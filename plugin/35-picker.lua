vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	{ src = "https://github.com/willydeliege/project.nvim/", name = "project" },
	"https://github.com/ibhagwan/fzf-lua",
})

require("project").setup({
	enable_autochdir = false,
	logging = {
		enabled = false,
	},
	fzf_lua = {
		enabled = true,
		show = "names", ---@type 'paths'|'names'
		sort = "newest", ---@type 'newest'|'oldest'
	},
})
vim.keymap.set("n", "<leader>fp", "<cmd>Project fzf-lua<cr>", { desc = "Switch project" })

require("mini.notify").setup({
	content = {
		-- Use notification message as is for LSP progress
		format = function(notif)
			if notif.data.source == "lsp_progress" then
				return notif.msg
			end
			return MiniNotify.default_format(notif)
		end,

		-- Show more recent notifications first
		sort = function(notif_arr)
			table.sort(notif_arr, function(a, b)
				return a.ts_update > b.ts_update
			end)
			return notif_arr
		end,
	},
})
require("mini.ai").setup({
	-- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
	mappings = {
		around_next = "aa",
		inside_next = "ii",
	},
	n_lines = 500,
})
require("mini.splitjoin").setup()
-- require('mini.cmdline').setup()
require("mini.icons").setup()
require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`
	},
})
require("mini.jump2d").setup()
require("mini.pairs").setup({
	-- In which modes mappings from this `config` should be created
	modes = { insert = true, command = true, terminal = false },

	-- Global mappings. Each right hand side should be a pair information, a
	-- table with at least these fields (see more in |MiniPairs.map|):
	-- - <action> - one of 'open', 'close', 'closeopen'.
	-- - <pair> - two character string for pair to be used.
	-- By default pair is not inserted after `\`, quotes are not recognized by
	-- <CR>, `'` does not insert the pair after a letter.
	-- Only parts of tables can be tweaked (others will use these defaults).
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "^[^\\]" },
		["["] = { action = "open", pair = "[]", neigh_pattern = "^[^\\]" },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "^[^\\]" },
		["<"] = { action = "open", pair = "<>", neigh_pattern = "^[^\\]" },

		[")"] = { action = "close", pair = "()", neigh_pattern = "^[^\\]" },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "^[^\\]" },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "^[^\\]" },
		[">"] = { action = "close", pair = "<>", neigh_pattern = "^[^\\]" },

		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "^[^\\]", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "^[^%a\\]", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "^[^\\]", register = { cr = false } },
	},
})
require("fzf-lua").setup()
local fzf = require("fzf-lua")
fzf.register_ui_select()
local wk = require("which-key")
-- builtin lsp functions
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "grx")
wk.add({
	-- Groups
	{ "<leader>f", group = "Files" },
	{ "<leader>s", group = "Search" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>g", group = "Git" },
	{ "<leader>c", group = "Code" },
	{ "<leader>d", group = "Diagnostics" },
	{ "<leader>T", group = "Treesitter/Tags" },
	{ "<leader>j", group = "Jumps" },
	{ "<leader>h", group = "Help" },
	{ "<leader>r", group = "Resume/History" },
	{ "<leader>u", group = "UI/Toggle" },

	----------------------------------------------------------------------------
	-- FILES
	----------------------------------------------------------------------------
	{
		"<leader>fb",
		function()
			fzf.buffers({ sort_lastused = true, tgnore_current_buffer = true })
		end,
		desc = "Find buffers",
	},
	{ "<leader>ff", fzf.files, desc = "Find Files" },
	{ "<leader>fg", fzf.git_files, desc = "Git Files" },
	{ "<leader>fr", fzf.oldfiles, desc = "Recent Files" },

	----------------------------------------------------------------------------
	-- SEARCH
	---------------------------------------------------------------------------
	{ "<leader>sg", fzf.live_grep, desc = "Live Grep" },
	{ "<leader>sw", fzf.grep_cword, desc = "Word Under Cursor" },
	{ "<leader>sW", fzf.grep_cWORD, desc = "WORD Under Cursor" },
	{
		"<leader>sb",
		function()
			require("fzf-lua").lines({
				profile = "ivy",
			})
		end,
		desc = "Buffer Lines",
	},
	{ "<leader>sL", fzf.lines, desc = "All Buffer Lines" },
	{ "<leader>sr", fzf.resume, desc = "Resume Search" },

	----------------------------------------------------------------------------
	-- BUFFERS
	----------------------------------------------------------------------------
	{ "<leader>bm", fzf.marks, desc = "Marks" },

	----------------------------------------------------------------------------
	-- GIT
	----------------------------------------------------------------------------
	{ "<leader>gs", fzf.git_status, desc = "Status" },
	{ "<leader>gb", fzf.git_branches, desc = "Branches" },
	{ "<leader>gc", fzf.git_commits, desc = "Commits" },
	{ "<leader>gC", fzf.git_bcommits, desc = "Buffer Commits" },
	{ "<leader>gt", fzf.git_stash, desc = "Stash" },

	----------------------------------------------------------------------------
	-- CODE (LSP)
	----------------------------------------------------------------------------
	{ "<leader>cd", fzf.lsp_definitions, desc = "Definitions" },
	{ "<leader>cD", fzf.lsp_declarations, desc = "Declarations" },
	{ "<leader>cr", fzf.lsp_references, desc = "References" },
	{ "<leader>ci", fzf.lsp_implementations, desc = "Implementations" },
	{ "<leader>ct", fzf.lsp_typedefs, desc = "Type Definitions" },
	{ "<leader>cs", fzf.lsp_document_symbols, desc = "Document Symbols" },
	{ "<leader>cS", fzf.lsp_workspace_symbols, desc = "Workspace Symbols" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
	{ "<leader>cn", vim.lsp.buf.rename, desc = "Rename" },
	{ "<leader>cc", fzf.lsp_incoming_calls, desc = "Incoming Calls" },
	{ "<leader>cC", fzf.lsp_outgoing_calls, desc = "Outgoing Calls" },

	----------------------------------------------------------------------------
	-- DIAGNOSTICS
	----------------------------------------------------------------------------
	{ "<leader>dd", fzf.diagnostics_document, desc = "Document Diagnostics" },
	{ "<leader>dw", fzf.diagnostics_workspace, desc = "Workspace Diagnostics" },

	----------------------------------------------------------------------------
	-- TREESITTER / TAGS
	----------------------------------------------------------------------------
	{ "<leader>Ts", fzf.treesitter, desc = "Treesitter Symbols" },
	{ "<leader>Tt", fzf.tags, desc = "Project Tags" },
	{ "<leader>Tb", fzf.btags, desc = "Buffer Tags" },

	----------------------------------------------------------------------------
	-- JUMPS
	----------------------------------------------------------------------------
	{ "<leader>jj", fzf.jumps, desc = "Jumps" },
	{ "<leader>jc", fzf.changes, desc = "Changes" },

	----------------------------------------------------------------------------
	-- HELP
	----------------------------------------------------------------------------
	{ "<leader>hh", fzf.help_tags, desc = "Help Tags" },
	{ "<leader>hk", fzf.keymaps, desc = "Keymaps" },
	{ "<leader>hc", fzf.commands, desc = "Commands" },
	{ "<leader>ha", fzf.autocmds, desc = "Autocommands" },
	{ "<leader>ho", fzf.nvim_options, desc = "Options" },
	{ "<leader>hm", fzf.manpages, desc = "Man pages" },
	{ "<leader>hl", fzf.highlights, desc = "Highlights" },

	----------------------------------------------------------------------------
	-- HISTORY / RESUME
	----------------------------------------------------------------------------
	{ "<leader>rr", fzf.resume, desc = "Resume" },
	{ "<leader>rg", fzf.registers, desc = "Registers" },
	{ "<leader>rc", fzf.command_history, desc = "Command History" },
	{ "<leader>rs", fzf.search_history, desc = "Search History" },

	----------------------------------------------------------------------------
	-- QUICKFIX
	----------------------------------------------------------------------------
	{ "<leader>sq", fzf.quickfix, desc = "Quickfix" },
	{ "<leader>sl", fzf.loclist, desc = "Location List" },

	----------------------------------------------------------------------------
	-- UI/Toggle
	----------------------------------------------------------------------------
	{ "<leader>uc", fzf.colorschemes, desc = "Colorschemes" },
	{ "<leader>uz", fzf.spell_suggest, desc = "Spell Suggestions" },

	----------------------------------------------------------------------------
	-- GENERAL
	----------------------------------------------------------------------------
	{ "<leader>/", fzf.live_grep, desc = "Grep Project" },
	{
		"<leader><leader>",
		function()
			require("fzf-lua").combine({
				pickers = "oldfiles;git_files",
				winopts = { title = "Recent and git files" },
			})
		end,
		desc = "Find Files",
	},
	{ "gd", fzf.lsp_definitions, desc = "Goto Definition" },
	{ "gr", fzf.lsp_references, desc = "Goto References" },
	{ "gi", fzf.lsp_implementations, desc = "Goto Implementation" },
})
