vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})
require("oil").setup({
	default_file_explorer = true,
})
vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>fe", "<cmd>Oil --float<cr>", { desc = "File explorer" })

require("mini.statusline").setup({})
