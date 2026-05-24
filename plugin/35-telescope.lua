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
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- telescope setup
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
local builtin = require("telescope.builtin")
local function toggle_hidden_files()
	-- local actions = require("telescope.actions")
	-- local action_state = require("telescope.actions.state")

	-- Initialisation de l'état (persiste entre les ouvertures)
	if vim.g.telescope_show_hidden == nil then
		vim.g.telescope_show_hidden = false
	end

	local opts = {
		hidden = vim.g.telescope_show_hidden,
		prompt_title = vim.g.telescope_show_hidden and "Find Files (Hidden Included)" or "Find Files",

		-- Mappage pour basculer en direct à l'intérieur de la fenêtre Telescope
		attach_mappings = function(prompt_bufnr, map)
			map({ "i", "n" }, "<C-h>", function()
				-- Récupère le texte actuellement tapé pour ne pas perdre la recherche en cours
				local current_picker = action_state.get_current_picker(prompt_bufnr)
				local current_text = current_picker:_get_prompt()

				actions.close(prompt_bufnr)
				vim.g.telescope_show_hidden = not vim.g.telescope_show_hidden

				-- Relance instantanément avec le nouvel état et le même texte
				toggle_hidden_files()
				vim.schedule(function()
					local new_picker = action_state.get_current_picker(vim.api.nvim_get_current_buf())
					if new_picker then
						new_picker:set_prompt(current_text)
					end
				end)
			end)
			return true
		end,
	}

	builtin.find_files(opts)
end

-- Associer la fonction à votre touche préférée (ex: <leader>ff)
vim.keymap.set("n", "<leader>ff", toggle_hidden_files, { desc = "Telescope Find Files (Toggle hidden with <C-h>)" })
-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Telescope config files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search current buffer" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
