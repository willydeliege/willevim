vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
})
do -- noice
	-- nvim-notify (optionnel, avant noice)
	require("notify").setup({
		background_colour = "#000000",
		timeout = 3000,
		render = "compact",
	})

	-- Configuration de noice.nvim
	require("noice").setup({
		-- Rediriger les messages de la cmdline vers le popup
		cmdline = {
			enabled = true,
			view = "cmdline_popup", -- "cmdline" pour comportement classique en bas
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
			},
		},

		messages = {
			enabled = true,
			view = "notify", -- utilise nvim-notify si installé
			view_error = "notify",
			view_warn = "notify",
			view_history = "messages",
			view_search = "virtualtext",
		},

		lsp = {
			-- Barre de progression LSP
			progress = {
				enabled = true,
				format = "lsp_progress",
				format_done = "lsp_progress_done",
				throttle = 1000 / 30,
				view = "mini",
			},
			-- Remplace vim.lsp.buf.hover / signature_help
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- si nvim-cmp est utilisé
			},
			hover = { enabled = true },
			signature = { enabled = true },
			message = { enabled = true },
		},

		presets = {
			bottom_search = true, -- true = barre de recherche classique en bas
			command_palette = true, -- cmdline + popupmenu ensemble
			long_message_to_split = true,
			inc_rename = false, -- mettre true si inc-rename.nvim est installé
			lsp_doc_border = true, -- bordure sur hover/signature
		},

		-- Vue "mini" discrète en bas à droite
		views = {
			mini = {
				win_options = { winblend = 0 },
				position = { row = -2, col = "100%" },
			},
		},
	})

	-- Raccourcis utiles
	local map = vim.keymap.set

	-- Historique des messages noice
	map("n", "<leader>nl", function()
		require("noice").cmd("last")
	end, { desc = "Noice: dernier message" })
	map("n", "<leader>nh", function()
		require("noice").cmd("history")
	end, { desc = "Noice: historique" })
	map("n", "<leader>nd", function()
		require("noice").cmd("dismiss")
	end, { desc = "Noice: effacer" })
	map("n", "<leader>nt", function()
		require("noice").cmd("fzf")
	end, { desc = "Noice: fzf" })

	-- Scroll dans les popups hover/signature
	map({ "n", "i", "s" }, "<c-f>", function()
		if not require("noice.lsp").scroll(4) then
			return "<c-f>"
		end
	end, { silent = true, expr = true })

	map({ "n", "i", "s" }, "<c-b>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<c-b>"
		end
	end, { silent = true, expr = true })
end

do -- Oil setup
	require("oil").setup({
		-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
		-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
		default_file_explorer = true,
		float = {
			-- Padding around the floating window
			padding = 2,
			-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			max_width = 0.8,
			max_height = 0.8,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
	})
	vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
end

do -- Lualine setup
	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
				refresh_time = 16, -- ~60fps
				events = {
					"WinEnter",
					"BufEnter",
					"BufWritePost",
					"SessionLoadPost",
					"FileChangedShellPost",
					"VimResized",
					"Filetype",
					"CursorMoved",
					"CursorMovedI",
					"ModeChanged",
				},
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "project", "branch" },
			lualine_c = { "filename" },
			lualine_x = {
				{ "diff" },
				{ "diagnostics", icons_enabled = true },
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "datetime" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

do --indent-blank-line setup
	local highlight = {
		"RainbowRed",
		"RainbowYellow",
		"RainbowBlue",
		"RainbowOrange",
		"RainbowGreen",
		"RainbowViolet",
		"RainbowCyan",
	}

	local hooks = require("ibl.hooks")
	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	end)

	require("ibl").setup({
		indent = {
			char = "│", -- Character used for indent guides
			tab_char = "│", -- Character for tab indents
			-- highlight = highlight,
			smart_indent_cap = true,
		},
		whitespace = {
			highlight = "IblWhitespace",
			remove_blankline_trail = true,
		},
		scope = {
			enabled = true,
			char = "┃", -- Thicker char for current scope
			highlight = highlight,
			show_start = false,
			show_end = false,
			injected_languages = true,
			include = {
				node_type = {
					["*"] = { "*" }, -- Highlight scope for all node types
				},
			},
		},
		exclude = {
			filetypes = {
				"help",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
			},
			buftypes = { "terminal", "nofile" },
		},
	})
end
