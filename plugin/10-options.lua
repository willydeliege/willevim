require("mini.basics").setup({
	-- Options. Set field to `false` to disable.
	options = {
		-- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
		extra_ui = true,

		-- Presets for window borders ('single', 'double', ...)
		-- Default 'auto' infers from 'winborder' option
		win_borders = "rounded",
	},
})
local o = vim.opt
o.tabstop = 2
o.shiftwidth = 0
o.clipboard = "unnamedplus"
o.pumborder = "rounded"
o.relativenumber = true
