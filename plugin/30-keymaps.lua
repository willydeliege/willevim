local keymap = vim.keymap
--  See `:help wincmd` for a list of all window commands
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Vim helper keys
keymap.set("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap.set("n", "<leader>qq", "<cmd>qall<cr>", { desc = "Quit willevim" })
keymap.set("n", "<leader>qr", "<cmd>restart<cr>", { desc = "Restart willevim" })
keymap.set("n", "<leader>fS", "<cmd>luafile %<cr>", { desc = "Source this file" })
keymap.set("n", "<leader>bw", "<cmd>bwipeout<cr>", { desc = "Forget buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch other buffe" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch other buffe" })

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
		sort = { "group", "alphanum" },
		-- Document existing key chains
		spec = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
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
vim.keymap.set("n", "<leader>uf", function()
	-- If global formatting is disabled, enable it
	if vim.g.disable_autoformat then
		vim.g.disable_autoformat = false
		vim.notify("Autoformat enabled")
	else
		-- Otherwise, disable it
		vim.g.disable_autoformat = true
		vim.notify("Autoformat disabled")
	end
end, { desc = "Toggle autoformat" })

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
	require("conform").format()
end, { desc = "Format buffer" })
vim.keymap.set("n", "<leade>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code actions" })
local function show_messages_floating()
	-- 1. Capturer la sortie de la commande :messages
	local messages = vim.fn.execute("messages")
	local lines = vim.split(messages, "\n", { trimempty = true })

	-- 2. Créer un scratch buffer (non listé, temporaire)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- 3. Configurer le buffer en lecture seule
	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

	-- 4. Calculer des dimensions dynamiques (80% de l'écran)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- 5. Définir les options de la fenêtre flottante
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded", -- Bordure élégante
		title = " Messages ",
		title_pos = "center",
	}

	-- 6. Ouvrir la fenêtre flottante
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- 7. Ajouter un raccourci local 'q' pour fermer rapidement cette fenêtre
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, silent = true, desc = "Fermer les messages" })
end

-- Créer une commande utilisateur Neovim
vim.api.nvim_create_user_command("MessagesFloat", show_messages_floating, {})

-- Associer à un raccourci clavier (ex: <leader>m)
vim.keymap.set("n", "<leader>m", show_messages_floating, { desc = "Messages" })
vim.keymap.set("n", "<leader>fp", function()
	vim.fn.system("tmux display-popup -E ~/.local/bin/tmux-sessionizer")
end, { desc = "Swaitch project" })
