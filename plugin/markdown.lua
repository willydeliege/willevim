---@diagnostic disable: missing-fields
-- Charge le paquet depuis pack/*/opt/
vim.pack.add({ "https://github.com/obsidian-nvim/obsidian.nvim" })

-- Initialise le plugin
require("obsidian").setup({
	legacy_commands = false, -- this will be removed in 4.0.0
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/MyPkm/",
		},
	},
	ui = {},
	picker = {
		name = "fzf-lua",
	},
	note_id_func = require("obsidian.builtin").title_id,
	checkbox = {
		enabled = true,
		create_new = false,
		order = { " ", "x" },
	},
	daily_notes = {
		folder = "Daily",
	},
})
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian find file" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Obsidian new file" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Obsidian open today" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinkr<cr>", { desc = "Obsidian backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Obsidian links" })
vim.pack.add({
	"https://github.com/OXY2DEV/markview.nvim",
})
require("markview").setup({
	markdown = {
		enable = true,
		list_items = {
			marker_minus = {
				add_padding = false,
			},
		},
	},
})
