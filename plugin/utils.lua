vim.pack.add({
	"https://github.com/kawre/neotab.nvim",
	"https://github.com/monaqa/dial.nvim",
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

-- dial.nvim

local augend = require("dial.augend")
local config = require("dial.config")

config.augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.constant.alias.bool,
		augend.constant.new({
			elements = { "and", "or" },
			word = true,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "oui", "non" },
			word = true,
			cyclic = true,
		}),
	},
})

map.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)

map.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)

map.set("v", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)

map.set("v", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
