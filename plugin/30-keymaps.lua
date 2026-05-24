--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Vim helper keys
vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>qq", "<cmd>qall<cr>", { desc = "Quit willevim" })
vim.keymap.set("n", "<leader>fS", "<cmd>:source %<cr>", { desc = "Source this file" })

-- Remap j and k to act as gj and gk when navigating wrapped lines
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- Alt + jk to move line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set(
	"i",
	"<A-j>",
	"<Esc>:m .+1<cr>==gi",
	{ noremap = true, silent = true, desc = "Move line down (insert mode)" }
)
vim.keymap.set(
	"i",
	"<A-k>",
	"<Esc>:m .-2<cr>==gi",
	{ noremap = true, silent = true, desc = "Move line up (insert mode)" }
)
vim.keymap.set("x", "<A-j>", ":m '>+1<cr>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "<A-k>", ":m '<-2<cr>gv=gv", { noremap = true, silent = true, desc = "Move block up" })
-- Center screen and unfold when jumping to the next/previous search result
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

vim.pack.add({ "https://github.com/folke/which-key.nvim" })
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
