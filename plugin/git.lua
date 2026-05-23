vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/neogitorg/neogit",
})

require("gitsigns").setup({})
require("neogit").setup({})

-- Keymaps
local wk = require("which-key")
wk.add({
	{ "<leader>g", group = "Git" },
	{ "<leader>gg", "<cmd>NeoGit<cr>", { desc = "Magit" } },
})
