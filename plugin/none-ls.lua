vim.pack.add({
	{ src = "https://github.com/nvimtools/none-ls-extras.nvim" },
	{ src = "https://github.com/jay-babu/mason-null-ls.nvim" },
	{
		src = "https://github.com/nvimtools/none-ls.nvim",
	},
})

require("mason-null-ls").setup({
	ensure_installed = { "prettier", "stylua", "black" },
	automatic_installation = true,
})

local null_ls = require("null-ls")
require("null-ls").setup({
	update_in_insert = true,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.djlint.with({
			filetypes = { "htmldjango" },
			extra_args = { "--reformat", "--indent", "4", "--profile", "django" },
		}),
		null_ls.builtins.diagnostics.djlint.with({
			filetypes = { "htmldjango" },
			extra_args = { "--profile", "django" },
		}),

		null_ls.builtins.formatting.prettier.with({
			command = "prettier",
			extra_args = { "--tab-width", "4" },
		}),
		require("none-ls.formatting.ruff"),
		require("none-ls.diagnostics.ruff"),

		require("none-ls.diagnostics.eslint_d").with({
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc",
					".eslintrc.js",
					".eslintrc.json",
				})
			end,
		}),
	},
})

vim.treesitter.language.register("django", "htmldjango")

vim.keymap.set("n", "<leader>fa", function()
	vim.lsp.buf.format({ async = true })
end, {})
