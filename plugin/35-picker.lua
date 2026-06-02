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

wk.add({
	-- Groups
	{ "<leader>f", group = "Files" },
	{ "<leader>s", group = "Search" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>g", group = "Git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>d", group = "Diagnostics" },
	{ "<leader>t", group = "Treesitter/Tags" },
	{ "<leader>j", group = "Jumps" },
	{ "<leader>h", group = "Help" },
	{ "<leader>r", group = "Resume/History" },
	{ "<leader>q", group = "Quickfix" },
	{ "<leader>u", group = "UI" },

	----------------------------------------------------------------------------
	-- FILES
	----------------------------------------------------------------------------
	{
		"<leader>ff",
		function()
			fzf.files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>fg",
		function()
			fzf.git_files()
		end,
		desc = "Git Files",
	},
	{
		"<leader>fr",
		function()
			fzf.oldfiles()
		end,
		desc = "Recent Files",
	},
	-- {
	-- 	"<leader>fb",
	-- 	function()
	-- 		fzf.file_browser()
	-- 	end,
	-- 	desc = "File Browser",
	-- },

	----------------------------------------------------------------------------
	-- SEARCH
	---------------------------------------------------------------------------
	{
		"<leader>sg",
		function()
			fzf.live_grep()
		end,
		desc = "Live Grep",
	},
	{
		"<leader>sw",
		function()
			fzf.grep_cword()
		end,
		desc = "Word Under Cursor",
	},
	{
		"<leader>sW",
		function()
			fzf.grep_cWORD()
		end,
		desc = "WORD Under Cursor",
	},
	{
		"<leader>sb",
		function()
			fzf.blines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sL",
		function()
			fzf.lines()
		end,
		desc = "All Buffer Lines",
	},
	{
		"<leader>sr",
		function()
			fzf.resume()
		end,
		desc = "Resume Search",
	},

	----------------------------------------------------------------------------
	-- BUFFERS
	----------------------------------------------------------------------------
	{
		"<leader>bb",
		function()
			fzf.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>bm",
		function()
			fzf.marks()
		end,
		desc = "Marks",
	},

	----------------------------------------------------------------------------
	-- GIT
	----------------------------------------------------------------------------
	{
		"<leader>gs",
		function()
			fzf.git_status()
		end,
		desc = "Status",
	},
	{
		"<leader>gb",
		function()
			fzf.git_branches()
		end,
		desc = "Branches",
	},
	{
		"<leader>gc",
		function()
			fzf.git_commits()
		end,
		desc = "Commits",
	},
	{
		"<leader>gC",
		function()
			fzf.git_bcommits()
		end,
		desc = "Buffer Commits",
	},
	{
		"<leader>gt",
		function()
			fzf.git_stash()
		end,
		desc = "Stash",
	},

	----------------------------------------------------------------------------
	-- LSP
	----------------------------------------------------------------------------
	{
		"<leader>ld",
		function()
			fzf.lsp_definitions()
		end,
		desc = "Definitions",
	},
	{
		"<leader>lD",
		function()
			fzf.lsp_declarations()
		end,
		desc = "Declarations",
	},
	{
		"<leader>lr",
		function()
			fzf.lsp_references()
		end,
		desc = "References",
	},
	{
		"<leader>li",
		function()
			fzf.lsp_implementations()
		end,
		desc = "Implementations",
	},
	{
		"<leader>lt",
		function()
			fzf.lsp_typedefs()
		end,
		desc = "Type Definitions",
	},
	{
		"<leader>ls",
		function()
			fzf.lsp_document_symbols()
		end,
		desc = "Document Symbols",
	},
	{
		"<leader>lS",
		function()
			fzf.lsp_workspace_symbols()
		end,
		desc = "Workspace Symbols",
	},
	{
		"<leader>la",
		function()
			vim.lsp.buf.code_action()
		end,
		desc = "Code Actions",
	},
	{
		"<leader>ln",
		function()
			vim.lsp.buf.rename()
		end,
		desc = "Rename",
	},
	{
		"<leader>lc",
		function()
			fzf.lsp_incoming_calls()
		end,
		desc = "Incoming Calls",
	},
	{
		"<leader>lC",
		function()
			fzf.lsp_outgoing_calls()
		end,
		desc = "Outgoing Calls",
	},

	----------------------------------------------------------------------------
	-- DIAGNOSTICS
	----------------------------------------------------------------------------
	{
		"<leader>dd",
		function()
			fzf.diagnostics_document()
		end,
		desc = "Document Diagnostics",
	},
	{
		"<leader>dw",
		function()
			fzf.diagnostics_workspace()
		end,
		desc = "Workspace Diagnostics",
	},

	----------------------------------------------------------------------------
	-- TREESITTER / TAGS
	----------------------------------------------------------------------------
	{
		"<leader>ts",
		function()
			fzf.treesitter()
		end,
		desc = "Treesitter Symbols",
	},
	{
		"<leader>tt",
		function()
			fzf.tags()
		end,
		desc = "Project Tags",
	},
	{
		"<leader>tb",
		function()
			fzf.btags()
		end,
		desc = "Buffer Tags",
	},

	----------------------------------------------------------------------------
	-- JUMPS
	----------------------------------------------------------------------------
	{
		"<leader>jj",
		function()
			fzf.jumps()
		end,
		desc = "Jumps",
	},
	{
		"<leader>jc",
		function()
			fzf.changes()
		end,
		desc = "Changes",
	},

	----------------------------------------------------------------------------
	-- HELP
	----------------------------------------------------------------------------
	{
		"<leader>hh",
		function()
			fzf.help_tags()
		end,
		desc = "Help Tags",
	},
	{
		"<leader>hk",
		function()
			fzf.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>hc",
		function()
			fzf.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>ha",
		function()
			fzf.autocmds()
		end,
		desc = "Autocommands",
	},
	{
		"<leader>hl",
		function()
			fzf.highlights()
		end,
		desc = "Highlights",
	},

	----------------------------------------------------------------------------
	-- HISTORY / RESUME
	----------------------------------------------------------------------------
	{
		"<leader>rr",
		function()
			fzf.resume()
		end,
		desc = "Resume",
	},
	{
		"<leader>rg",
		function()
			fzf.registers()
		end,
		desc = "Registers",
	},
	{
		"<leader>rc",
		function()
			fzf.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>rs",
		function()
			fzf.search_history()
		end,
		desc = "Search History",
	},

	----------------------------------------------------------------------------
	-- QUICKFIX
	----------------------------------------------------------------------------
	{
		"<leader>sq",
		function()
			fzf.quickfix()
		end,
		desc = "Quickfix",
	},
	{
		"<leader>sl",
		function()
			fzf.loclist()
		end,
		desc = "Location List",
	},

	----------------------------------------------------------------------------
	-- UI
	----------------------------------------------------------------------------
	{
		"<leader>uc",
		function()
			fzf.colorschemes()
		end,
		desc = "Colorschemes",
	},
	{
		"<leader>uz",
		function()
			fzf.spell_suggest()
		end,
		desc = "Spell Suggestions",
		{
			"<leader>/",
			function()
				fzf.live_grep()
			end,
			desc = "Grep Project",
		},
		{
			"<leader><leader>",
			function()
				fzf.files()
			end,
			desc = "Find Files",
		},
		{
			"gd",
			function()
				fzf.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gr",
			function()
				fzf.lsp_references()
			end,
			desc = "Goto References",
		},
		{
			"gi",
			function()
				fzf.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
	},
})
