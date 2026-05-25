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
keymap.set("n", "<leader>fS", "<cmd>luafile %<cr>", { desc = "Source this file" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
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
			{ "<leader>x", group = "Trouble" },
			{ "<leader>w", proxy = "<c-w>", group = "Windows" }, -- proxy to window mappings
			{ "<leader>q", group = "Quit" },
			{ "<leader>o", group = "Obsidian", icon = { icon = "", color = "orange" } },
		},
	})
end
-- smooth resize
-- ipo C-w
vim.pack.add({
	"https://github.com/aronjohanns/smooth-resize.nvim",
})
require("smooth-resize").setup()

keymap.set("n", "<leader>sm", function()
	local messages = vim.api.nvim_exec2("messages", { output = true })
	local lines = vim.split(messages.output, "\n", { plain = true })

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Neovim Messages",
			finder = require("telescope.finders").new_table({
				results = lines,
				entry_maker = function(line)
					return {
						value = line,
						display = line,
						ordinal = line,
					}
				end,
			}),
			sorter = require("telescope.sorters").get_generic_fuzzy_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				-- Optional: Map <CR> to copy the selected message into your clipboard
				map("i", "<CR>", function()
					local selection = require("telescope.actions.state").get_selected_entry()
					if selection then
						vim.fn.setreg("+", selection.value)
						print("Copied message to clipboard!")
					end
				end)
				return true
			end,
		})
		:find()
end, { desc = "Fuzzy search :messages" })
