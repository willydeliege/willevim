vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	{ src = "https://github.com/DrKJeff16/project.nvim/", name = "project" },
})

require("project").setup({
	enable_autochdir = true,
	logging = {
		enabled = false,
	},
	telescope = {
		tilde = true,
	},
})
vim.keymap.set("n", "<leader>fp", function()
	require("telescope").extensions.projects.projects({
		attach_mappings = function(prompt_bufnr, map)
			map("n", "<C-g>", function()
				local project_actions = require("telescope._extensions.projects.actions")
				project_actions.change_working_directory(prompt_bufnr)
				require("neogit").open({ cwd = vim.fn.getcwd() })
			end)
			map("i", "<C-g>", function()
				local project_actions = require("telescope._extensions.projects.actions")
				project_actions.change_working_directory(prompt_bufnr)
				require("neogit").open({ cwd = vim.fn.getcwd() })
			end)
			return true -- garde les mappings par défaut
		end,
	})
end, { desc = "Switch project" })

local builtin = require("telescope.builtin")
local find_files_with_hidden = function()
	builtin.find_files({ hidden = true })
end
require("telescope").setup({
	defaults = {
		layout_strategy = "center",
		layout_config = {
			width = 0.6, -- change this
			height = 15, -- fixed row count, or use 0.4 for %
			preview_cutoff = 1,
		},
		sorting_strategy = "ascending",
	},
	pickers = {
		find_files = {
			mappings = {
				i = {
					["<C-h>"] = find_files_with_hidden,
				},
			},
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
		projects = {},
	},
	-- projects = ,
})
-- Enable Telescope extensions if they are installed
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("projects")
-- Telscope keymaps

-- Search file with hidder file toggleable
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Telescope config files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Project live grep" })
vim.keymap.set("n", "<leader>sg", builtin.current_buffer_fuzzy_find, { desc = "Search buffer lines" })
vim.keymap.set("n", "<leader>bb", function()
	builtin.buffers({ ignore_current_buffer = true })
end, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
