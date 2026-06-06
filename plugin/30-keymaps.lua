vim.g.mapleader = " "
require("mini.keymap").setup()
require("mini.basics").setup({
	mappings = {
		basic = true,
		option_toggle_prefix = "<leader>u",
		windows = true,
		move_with_alt = true,
	},
})
local keymap = vim.keymap

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

-- -- Select previous/next treesitter node
-- vim.keymap.set({ "x" }, "[n", function()
-- 	require("vim.treesitter._select").select_prev(vim.v.count1)
-- end, { desc = "Select previous treesitter node" })
--
-- vim.keymap.set({ "x" }, "]n", function()
-- 	require("vim.treesitter._select").select_next(vim.v.count1)
-- end, { desc = "Select next treesitter node" })

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
