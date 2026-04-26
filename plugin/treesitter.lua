vim.pack.add({{
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	branch = "main",

}})


require("nvim-treesitter").setup({
	ensure_installed = { "yaml", "dockerfile", "markdown", "markdown_inline", "html", "jsonc" },
	auto_install = {enable=  true},


	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
})
