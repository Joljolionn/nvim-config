vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/jiaoshijie/undotree" },
})

require("undotree").setup({

	config = true,
})
vim.keymap.set("n", "<leader>u", function() require('undotree').toggle() end, {desc = "Toggle undotree"})
