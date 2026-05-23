vim.pack.add({
	{ src = "https://github.com/DrKJeff16/project.nvim/", name = "project" },
})

require("project").setup({
	enable_autochdir = true,
	logging = {
		enabled = false,
	},
})
require("telescope").load_extension("projects")
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Switch project" })
