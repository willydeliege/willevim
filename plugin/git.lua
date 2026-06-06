vim.pack.add({
	"https://github.com/kdheepak/lazygit.nvim",
})

require("mini.git").setup()
-- Initialisation de mini.diff
local diff = require("mini.diff")

diff.setup({
	-- Configuration visuelle de la colonne (signcolumn)
	view = {
		style = "sign",
		signs = {
			add = "▎", -- Ligne ajoutée (style gitsigns)
			change = "▎", -- Ligne modifiée
			delete = "", -- Ligne supprimée (nécessite une Nerd Font)
		},
	},

	-- Délai de mise à jour automatique pendant la frappe (en ms)
	delay = { text_change = 100 },
})

-- Initialisation optionnelle de mini.git (si installé)
require("mini.git").setup()

----------------------------------------------------------------
-- CONFIGURATION DES RACCOURCIS (KEYMAPS STYLE GITSIGNS)
----------------------------------------------------------------

-- Actions sur les Blocs
-- Appliquer/Stager le bloc sous le curseur
vim.keymap.set({ "n", "v" }, "<leader>ghs", function()
	diff.operator("apply")
end, { desc = "Stage hunk" })
-- Réinitialiser/Annuler le bloc sous le curseur
vim.keymap.set({ "n", "v" }, "<leader>ghr", function()
	diff.operator("reset")
end, { desc = "Reset hunk" })

-- L'alternative moderne de mini.diff à "Preview Hunk"
-- Au lieu d'une petite bulle flottante, cela affiche un calque (overlay) complet
-- et persistant des différences directement dans le code. Très puissant.
vim.keymap.set("n", "<leader>ghp", function()
	diff.toggle_overlay(0)
end, { desc = "Aperçu des modifications (Overlay)" })
-- -- Keymaps
local wk = require("which-key")
wk.add({
	{ "<leader>gh", group = "hunk" },
	{ "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Magit" } },
})
