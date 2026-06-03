vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MagicDuck/grug-far.nvim",
})
require("yazi").setup({
	integrations = {
		--- What should be done when the user wants to grep in a directory
		grep_in_directory = "fzf-lua",
		grep_in_selected_files = "fzf-lua",
	},
})
vim.keymap.set("n", "-", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>fe", "<cmd>Yazi<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>fE", "<cmd>Yazi cwd<cr>", { desc = "File explorer (cwd)" })
do -- Lualine setup
	local function get_lsp_status()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if next(clients) == nil then
			return "No LSP"
		end

		local c_names = {}
		for _, client in pairs(clients) do
			table.insert(c_names, client.name)
		end
		return table.concat(c_names, ", ")
	end

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
			lualine_y = {
				{ "progress" },
				{ get_lsp_status, icon = "", color = { fg = "#a3be8c" } },
			},
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
