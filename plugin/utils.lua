vim.pack.add({
	"https://github.com/kawre/neotab.nvim",
})
-- Load built-in undotree
vim.cmd("packadd nvim.undotree")

local map = vim.keymap
-- Create a custom function to open it on the right
local function open_undotree_right()
	local undotree = require("undotree")
	undotree.open({
		title = "Undotree",
		command = "botright 30vnew", -- Opens a 30-column vertical split on the far right
	})
end

-- Map this to <leader>U
map.set("n", "<leader>U", open_undotree_right, { desc = "Open Undotree on the right" })

require("neotab").setup({
	-- Désactive <Tab> et <S-Tab> si vous souhaitez "les" binder manuellement
	-- tabkey = "",
})

-- Liste des mots à cycles
local toggles = {
	["true"] = "false",
	["false"] = "true",
	["yes"] = "no",
	["no"] = "yes",
	["on"] = "off",
	["off"] = "on",
}

-- Fonction de bascule locale
local function toggle_word()
	local word = vim.fn.expand("<cword>")
	if toggles[word] then
		vim.cmd('normal! "_ciw' .. toggles[word])
	end
end

-- Création du raccourci (Ex: <leader>t)
vim.keymap.set("n", "<leader>us", toggle_word, { desc = "Swap word" })
