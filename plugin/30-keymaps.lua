local keymap = vim.keymap
--  See `:help wincmd` for a list of all window commands
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Vim helper keys
keymap.set("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
keymap.set("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save file" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap.set("n", "<leader>qq", "<cmd>qall<cr>", { desc = "Quit willevim" })
keymap.set("n", "<leader>qr", "<cmd>restart<cr>", { desc = "Restart willevim" })
keymap.set("n", "<leader>qr", "<cmd>restart<cr>", { desc = "Restart willevim" })
keymap.set("n", "<leader>fS", "<cmd>luafile %<cr>", { desc = "Source this file" })
keymap.set("n", "<leader>bw", "<cmd>bwipeout<cr>", { desc = "Forget buffer" })

-- Remap j and k to act as gj and gk when navigating wrapped lines
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- Alt + jk to move line up/down
keymap.set("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })
keymap.set(
	"i",
	"<A-j>",
	"<Esc>:m .+1<cr>==gi",
	{ noremap = true, silent = true, desc = "Move line down (insert mode)" }
)
keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { noremap = true, silent = true, desc = "Move line up (insert mode)" })
keymap.set("x", "<A-j>", ":m '>+1<cr>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
keymap.set("x", "<A-k>", ":m '<-2<cr>gv=gv", { noremap = true, silent = true, desc = "Move block up" })
-- Center screen and unfold when jumping to the next/previous search result
keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev search result" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
do
	vim.pack.add({ "https://github.com/folke/which-key.nvim" })
	require("which-key").setup({
		preset = "helix",
		-- Delay between pressing a key and opening which-key (milliseconds)
		delay = 0,
		-- Document existing key chains
		spec = {
			{ "<leader>b", group = "Buffers", mode = { "n", "v" } },
			{ "<leader>f", group = "Find/files", mode = { "n", "v" } },
			{ "<leader>s", group = "Search", mode = { "n", "v" } },
			{ "<leader>t", group = "Tasks" },
			{ "<leader>u", group = "Toggle" },
			{ "<leader>x", group = "Trouble" },
			{
				"<leader>w",
				proxy = "<c-w>",
				group = "Windows",
				expand = function()
					return require("which-key.extras").expand.win()
				end,
			}, -- proxy to window mappings
			{ "<leader>q", group = "Quit" },
			{ "<leader>o", group = "Obsidian", icon = { icon = "", color = "orange" } },
		},
	})
end
-- smooth resize

vim.keymap.set("n", "<c-w><space>", function()
	require("which-key").show({
		keys = "<c-w>",
		loop = true,
	})
end)

-- treesiter

-- Select previous/next treesitter node
vim.keymap.set({ "x" }, "[n", function()
	require("vim.treesitter._select").select_prev(vim.v.count1)
end, { desc = "Select previous treesitter node" })

vim.keymap.set({ "x" }, "]n", function()
	require("vim.treesitter._select").select_next(vim.v.count1)
end, { desc = "Select next treesitter node" })

-- Select parent/child treesitter node or LSP selection
vim.keymap.set({ "x", "o" }, "an", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "x", "o" }, "in", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
