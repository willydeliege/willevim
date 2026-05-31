vim.pack.add({
	"https://github.com/gbprod/yanky.nvim",
	"https://github.com/kawre/neotab.nvim",
	"https://github.com/monaqa/dial.nvim",
	"https://github.com/AckslD/messages.nvim",
})
require("messages").setup()
-- Load built-in undotree
vim.cmd("packadd nvim.undotree")

local map = vim.keymap
map.set("n", "<leader>N", "<cmd>Messages<cr>", { desc = "Messages" })
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

-- yanky
require("yanky").setup({})
map.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
map.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
map.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
map.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

map.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
map.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
map.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
map.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

map.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
map.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")
map.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

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
