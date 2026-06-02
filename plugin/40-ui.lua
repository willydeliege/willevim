vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MagicDuck/grug-far.nvim",
})
require("yazi").setup({
	integrations = {
		--- What should be done when the user wants to grep in a directory
		grep_in_directory = "snacks.picker",
		grep_in_selected_files = "snacks.picker",
	},
})
vim.keymap.set("n", "-", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>fe", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>fE", "<cmd>Yazi cwd<cr>", { desc = "File explorer (cwd)" })
do -- Lualine setup
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
			lualine_b = { "project", "branch" },
			lualine_c = { "filename" },
			lualine_x = {
				{ "diff" },
				{ "diagnostics", icons_enabled = true },
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "datetime" },
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
end
