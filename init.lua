vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- 1. Configuration de Catppuccin avant le chargement
vim.pack.add({
	"https://github.com/catppuccin/nvim",
})

require("catppuccin").setup({
	flavour = "mocha", -- Utilise la variante la plus sombre par défaut
	color_overrides = {
		mocha = {
			base = "#000000", -- Fond noir absolu pour un contraste maximal
			mantle = "#0b0b0b", -- Fond des fenêtres secondaires très sombre
			crust = "#111111", -- Bordures et statuts sombres
			text = "#ffffff", -- Texte principal blanc pur (au lieu de gris clair)
		},
	},
	custom_highlights = function(colors)
		return {
			-- #8087a2 est un gris moyen très lisible (au lieu du gris très sombre par défaut)
			LineNr = { fg = "#8087a2" },

			-- Optionnel : applique une couleur éclatante (ex: jaune) à la ligne active
			CursorLineNr = { fg = colors.yellow, style = { "bold" } },
		}
	end,
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = false,
		notify = true,
		mini = {
			enabled = true,
			indentscope_color = "",
		},
		treesitter = true,
	},
})

-- 2. Activation du thème
vim.cmd.colorscheme("catppuccin")
