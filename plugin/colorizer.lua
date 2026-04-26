vim.pack.add({ {
	src = "https://github.com/NvChad/nvim-colorizer.lua",
} })

require("colorizer").setup({
	event = "BufReadPre",
	filetypes = {
		"css",
		"scss",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	user_default_options = {
		RGB = true, -- #RGB
		RRGGBB = true, -- #RRGGBB
		names = false, -- <- desliga nomes como "red"
		RRGGBBAA = true, -- #RRGGBBAA
		rgb_fn = true, -- rgb(), rgba()
		hsl_fn = true, -- hsl(), hsla()
		css = true, -- parsing CSS
		css_fn = true, -- funções CSS
		mode = "background", -- só fundo
	},
})
