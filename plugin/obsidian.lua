---@diagnostic disable: missing-fields
vim.pack.add({
	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/iamcco/markdown-preview.nvim",
	"https://github.com/bngarren/checkmate.nvim",
})

require("obsidian").setup({
	legacy_commands = false, -- this will be removed in 4.0.0
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/MyPkm/",
		},
	},
	ui = {
		enable = false,
		enabled = false,
	},
	picker = {
		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
		name = "telescope.nvim",
	},
	note_id_func = require("obsidian.builtin").title_id,
	checkbox = {
		enabled = false,
	},
	daily_notes = {
		folder = "Daily",
	},
})
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian find file" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Obsidian new file" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Obsidian open today" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinkr<cr>", { desc = "Obsidian backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Obsidian links" })
require("render-markdown").setup({
	bullet = {
		enabled = true,
		render_modes = true,
		icons = { "●", "○", "◆", "◇" },
		ordered_icons = function(ctx)
			local value = vim.trim(ctx.value)
			local index = tonumber(value:sub(1, #value - 1))
			return ("%d."):format(index > 1 and index or ctx.index)
		end,
		left_pad = 0,
		right_pad = 1,
		highlight = "RenderMarkdownBullet",
		scope_highlight = {},
		scope_priority = nil,
	},
	checkbox = {
		enabled = false,
	},
})
require("checkmate").setup({
	files = { "*.md" }, -- any .md file (instead of defaults)
	ui = {
		picker = "telescope", -- or "mini", "telescope", or "native"
	},
	keys = {
		["<leader>tt"] = {
			rhs = "<cmd>Checkmate toggle<CR>",
			desc = "Toggle todo item",
			modes = { "n", "v" },
		},
		["<leader>tc"] = {
			rhs = "<cmd>Checkmate check<CR>",
			desc = "Set todo item as checked (done)",
			modes = { "n", "v" },
		},
		["<leader>tu"] = {
			rhs = "<cmd>Checkmate uncheck<CR>",
			desc = "Set todo item as unchecked (not done)",
			modes = { "n", "v" },
		},
		["<leader>t="] = {
			rhs = "<cmd>Checkmate cycle_next<CR>",
			desc = "Cycle todo item(s) to the next state",
			modes = { "n", "v" },
		},
		["<leader>t-"] = {
			rhs = "<cmd>Checkmate cycle_previous<CR>",
			desc = "Cycle todo item(s) to the previous state",
			modes = { "n", "v" },
		},
		["<leader>tn"] = {
			rhs = "<cmd>Checkmate create<CR>",
			desc = "Create todo item",
			modes = { "n", "v" },
		},
		["<leader>tr"] = {
			rhs = "<cmd>Checkmate remove<CR>",
			desc = "Remove todo marker (convert to text)",
			modes = { "n", "v" },
		},
		["<leader>tR"] = {
			rhs = "<cmd>Checkmate remove_all_metadata<CR>",
			desc = "Remove all metadata from a todo item",
			modes = { "n", "v" },
		},
		["<leader>ta"] = {
			rhs = "<cmd>Checkmate archive<CR>",
			desc = "Archive checked/completed todo items (move to bottom section)",
			modes = { "n" },
		},
		["<leader>tF"] = {
			rhs = "<cmd>Checkmate select_todo<CR>",
			desc = "Open a picker to select a todo from the current buffer",
			modes = { "n" },
		},
		["<leader>tv"] = {
			rhs = "<cmd>Checkmate metadata select_value<CR>",
			desc = "Update the value of a metadata tag under the cursor",
			modes = { "n" },
		},
		["<leader>t]"] = {
			rhs = "<cmd>Checkmate metadata jump_next<CR>",
			desc = "Move cursor to next metadata tag",
			modes = { "n" },
		},
		["<leader>t["] = {
			rhs = "<cmd>Checkmate metadata jump_previous<CR>",
			desc = "Move cursor to previous metadata tag",
			modes = { "n" },
		},
	},
})
