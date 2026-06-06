vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mfussenegger/nvim-lint",
})

require("mason").setup()
--Mason install lsp servers, formatters, linters , ...
-- Enable language server
require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
	integrations = { lspconfig = true },
})
vim.lsp.enable("lua_ls")
vim.keymap.set("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
vim.diagnostic.config({
	virtual_text = true,
})
vim.keymap.set("n", "<leader>uv", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({
		virtual_text = not current,
	})
end, { desc = "Toggle virtual text" })
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("x-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>uh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "Toggle Inlay [H]ints")
		end
		if client and client:supports_method("textDocument/codeLens", event.buf) then
			-- Map <leader>cl to run the codelens at the current cursor position
			vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = event.buf, desc = "Run CodeLens" })
		end
	end,
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettier" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})
-- Completion
-- ── 1. mini.snippets ────────────────────────────────────────────────
local snippets = require("mini.snippets")

snippets.setup({
	snippets = {
		-- Load snippets bundled with mini.nvim for the current filetype
		snippets.gen_loader.from_lang(),

		-- Load your own snippets from ~/.config/nvim/snippets/
		snippets.gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),

		-- Optional: load friendly-snippets (install with your plugin manager)
		snippets.gen_loader.from_runtime("snippets", { lang = false }),
		function(context)
			if context.lang == "markdown_inline" then
				-- Redirige vers les snippets markdown normaux
				return snippets.gen_loader.from_lang()({ lang = "markdown", filetype = "markdown" })
			end
		end,
	},
	expand = {
		-- Called when multiple snippets match; lets you pick one
		select = snippets.default_select,
	},
})

-- Expose loaded snippets to mini.completion (and any LSP-capable engine)
-- Call AFTER setup(); match=false lets the completion engine filter
snippets.start_lsp_server({ match = false })

-- ── 2. mini.completion ──────────────────────────────────────────────
require("mini.completion").setup({
	delay = { completion = 100, info = 100, signature = 50 },

	window = {
		info = { height = 25, width = 80, border = "single" },
		signature = { height = 25, width = 80, border = "single" },
	},

	lsp_completion = {
		source_func = "completefunc", -- or "omnifunc"
		auto_setup = true,
		-- Optionally add icons via MiniIcons:
		-- process_items = function(items, base)
		--   items = MiniCompletion.default_process_items(items, base)
		--   MiniIcons.tweak_lsp_kind()
		--   return items
		-- end,
	},

	-- mini.snippets is detected automatically; no extra config needed here
})

-- ── 3. mini.keymap — smart Tab / S-Tab / CR / BS ────────────────────
local keymap = require("mini.keymap")

-- <Tab>: next popup item → expand/jump snippet → indent
keymap.map_multistep("i", "<Tab>", {
	"pmenu_next", -- select next completion item
	"minisnippets_next", -- jump to next snippet tabstop (or expand)
	"increase_indent", -- fall back to indenting
})

-- <S-Tab>: prev popup item → prev snippet tabstop → de-indent
keymap.map_multistep("i", "<S-Tab>", {
	"pmenu_prev",
	"minisnippets_prev",
	"decrease_indent",
})

-- <CR>: accept selected item (pairs-aware if mini.pairs is loaded)
keymap.map_multistep("i", "<CR>", {
	"pmenu_accept",
	"minipairs_cr", -- remove if you don't use mini.pairs
})

-- <BS>: pairs-aware backspace (remove if you don't use mini.pairs)
keymap.map_multistep("i", "<BS>", {
	"minipairs_bs",
})

-- Snippet tabstop navigation also in select mode
keymap.map_multistep("s", "<Tab>", { "minisnippets_next" })
keymap.map_multistep("s", "<S-Tab>", { "minisnippets_prev" })
-- Treesitter
require("tree-sitter-manager").setup({
	-- Default Options
	ensure_installed = { "lua", "markdown" }, -- list of parsers to install at the start of a neovim session
	border = "rounded", -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
	auto_install = true, -- if enabled, install missing parsers when editing a new file
	-- highlight = true, -- treesitter highlighting is enabled by default
	-- languages = {}, -- override or add new parser sources
})

require("lint").linters_by_ft = { markdown = { "markdownlint-cli2" }, lua = { "luacheck" } }
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		-- require("lint").try_lint("cspell")
	end,
})
