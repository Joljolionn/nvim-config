vim.pack.add({{
	src = "https://github.com/tpope/vim-fugitive",
}})
vim.keymap.set("n", "<leader>fg", vim.cmd.Git)
