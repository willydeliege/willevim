vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/neogitorg/neogit",
})

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			vim.schedule(function()
				gitsigns.nav_hunk("next")
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Next Git Hunk" })

		map("n", "[h", function()
			vim.schedule(function()
				gitsigns.nav_hunk("prev")
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Previous Git Hunk" })

		-- Actions
		map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage Git Hunk" })
		map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset Git Hunk" })
		map("v", "<leader>ghs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage Hunk" })
		map("v", "<leader>ghr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset Hunk" })
		map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset Entire Buffer" })
		map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview Git Hunk" })

		map("n", "<leader>ghb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame Line" })
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })
		map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git Diff This File" })
		map("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end, { desc = "Git Diff vs Last Commit" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Git Hunk" })
	end,
})
require("neogit").setup({})

-- Keymaps
local wk = require("which-key")
wk.add({
	{ "<leader>gh", group = "Hunk" },
	{ "<leader>gg", "<cmd>Neogit<cr>", { desc = "Magit" } },
})
