vim.pack.add({
	"https://github.com/gbprod/yanky.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/kawre/neotab.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/monaqa/dial.nvim",
})
-- Load built-in undotree
vim.cmd("packadd nvim.undotree")

-- Create a custom function to open it on the right
local function open_undotree_right()
	local undotree = require("undotree")
	undotree.open({
		title = "Undotree",
		command = "botright 30vnew", -- Opens a 30-column vertical split on the far right
	})
end

-- Map this to <leader>U
vim.keymap.set("n", "<leader>U", open_undotree_right, { desc = "Open Undotree on the right" })

-- yanky
require("yanky").setup({})
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`
	},
})
require("mini.pairs").setup()

require("neotab").setup({
	-- Désactive <Tab> et <S-Tab> si vous souhaitez "les" binder manuellement
	-- tabkey = "",
})

--jump 2d
require("which-key").add({
	{
		"s",
		mode = { "n", "x", "o" },
		function()
			require("flash").jump()
		end,
		desc = "Flash",
	},
	{
		"S",
		mode = { "n", "x", "o" },
		function()
			require("flash").treesitter()
		end,
		desc = "Flash Treesitter",
	},
	{
		"r",
		mode = "o",
		function()
			require("flash").remote()
		end,
		desc = "Remote Flash",
	},
	{
		"R",
		mode = { "o", "x" },
		function()
			require("flash").treesitter_search()
		end,
		desc = "Treesitter Search",
	},
	{
		"<c-s>",
		mode = { "c" },
		function()
			require("flash").toggle()
		end,
		desc = "Toggle Flash Search",
	},
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

vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)

vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)

vim.keymap.set("v", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)

vim.keymap.set("v", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
