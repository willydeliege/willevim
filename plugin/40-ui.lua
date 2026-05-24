vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/j-hui/fidget.nvim",
})

-- telescope setup
require("telescope").setup({
	defaults = {
		layout_strategy = "center",
		layout_config = {
			width = 0.6, -- change this
			height = 15, -- fixed row count, or use 0.4 for %
			preview_cutoff = 1,
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})
-- Enable Telescope extensions if they are installed
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
-- Telscope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Telescope config files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search current buffer" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })

-- Oil setup
require("oil").setup({
	-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
	default_file_explorer = true,
	float = {
		-- Padding around the floating window
		padding = 2,
		-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		max_width = 0.8,
		max_height = 0.8,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
	},
})
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- icons
require("nvim-web-devicons").setup({
	-- your personal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "65",
			name = "Zsh",
		},
	},
	override_by_filename = {
		[".gitignore"] = {
			icon = "",
			color = "#f1502f",
			name = "Gitignore",
		},
	},
	-- same as `override` but specifically for overrides by extension
	-- takes effect when `strict` is true
	override_by_extension = {
		["log"] = {
			icon = "",
			color = "#81e043",
			name = "Log",
		},
	},
	-- same as `override` but specifically for operating system
	-- takes effect when `strict` is true
	override_by_operating_system = {
		["apple"] = {
			icon = "",
			color = "#A2AAAD",
			cterm_color = "248",
			name = "Apple",
		},
	},
})
-- Lualine setup
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- which-key
require("which-key").setup({
	preset = "helix",
	-- Delay between pressing a key and opening which-key (milliseconds)
	delay = 0,
	icons = { mappings = vim.g.have_nerd_font },
	-- Document existing key chains
	spec = {
		{ "<leader>f", group = "Find/files", mode = { "n", "v" } },
		{ "<leader>s", group = "Search", mode = { "n", "v" } },
		{ "<leader>t", group = "tasks" },
		{ "<leader>q", group = "Quit" },
		{ "<leader>o", group = "obsidian", icon = { icon = "", color = "orange" } },
	},
})

require("fidget").setup({})
