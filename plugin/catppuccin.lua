vim.pack.add({
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},
})

require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	integrations = {
		treesitter = true,
		native_lsp = { enabled = true },
		custom_highlights = function(colors)
			return {
				Comment = { fg = colors.overlay2, style = { "italic" } },
				LineNr = { fg = colors.surface2 },
				CursorLineNr = { fg = colors.peach, style = { "bold" } },
				-- Aumentando o destaque de variáveis para evitar o efeito lavado
				["@variable"] = { fg = colors.text },
				["@lsp.type.variable"] = { link = "@variable" },
			}
		end,
	},
})

vim.cmd.colorscheme("catppuccin-nvim")
-- Exemplo de ajuste de prioridade para favorecer Treesitter
