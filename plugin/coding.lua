vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.*") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
	"https://github.com/mason-org/mason.nvim",
	-- "https://github.com/saghen/blink.lib",
})
-- require("blink.lib.lazy_require")
-- require("blink.cmp").build():wait(60000)
-- require("blink.cmp").download({ force = true, tags = "*" }):wait(60000)

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

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettier" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- Completion
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	keymap = {
		-- i'default' (recommended) for mappings similar to built-in completions
		-- See `:help blink-cmp-config-keymap` for defining your own keymap
		preset = "enter",

		-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
		--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		-- By default, you may press `<c-space>` to show the documentation.
		-- Optionally, set `auto_show = true` to show the documentation after a delay.
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},

	sources = {
		default = { "lsp", "path", "snippets" },
		per_filetype = {
			lua = { inherit_defaults = true, "lazydev" },
		},
		providers = {
			lazydev = {
				enabled = true,
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
			snippets = {
				name = "snippets",
				module = "blink.cmp.sources.snippets",
			},
		},
	},
	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},

	snippets = { preset = "luasnip" },

	-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
	-- which automatically downloads a prebuilt binary when enabled.
	--
	-- By default, we use the Lua implementation instead, but you may enable
	-- the rust implementation via `'prefer_rust_with_warning'`
	--
	-- See `:help blink-cmp-config-fuzzy` for more information
	fuzzy = { implementation = "rust" },

	-- Shows a signature help window while you type arguments for a function
	signature = { enabled = true },
})

-- Treesitter
require("tree-sitter-manager").setup({
	-- Default Options
	ensure_installed = { "lua", "markdown" }, -- list of parsers to install at the start of a neovim session
	border = "rounded", -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
	auto_install = true, -- if enabled, install missing parsers when editing a new file
	-- highlight = true, -- treesitter highlighting is enabled by default
	-- languages = {}, -- override or add new parser sources
})
