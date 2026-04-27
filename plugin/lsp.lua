-- 1. Instalação dos Plugins (Ordem importa no vim.pack)
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/dressing.nvim" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/folke/neoconf.nvim" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

require("neoconf").setup({ local_config = ".neoconf.json" })
require("mason").setup()

local caps = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"clangd",
		"rust_analyzer",
		"ts_ls",
		"pyright",
		"intelephense",
		"cssls",
		"eslint",
	},
	automatic_enable = {
		exclude = { "jdtls" },
	},
})

vim.lsp.config("ts_ls", {
	capabilities = caps,
	on_attach = function(client, _)
		-- Desativando formatação nativa para usar null-ls/prettier
		client.server_capabilities.documentFormattingProvider = false
	end,
})

vim.lsp.config("pyright", {
	capabilities = caps,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoImportCompletions = true,
			},
		},
	},
})

-- Configuração padrão para Docker
vim.lsp.config("dockerls", {
	capabilities = caps,
	settings = {
		docker = {
			languageserver = {
				formatter = "prettier",
			},
		},
	},
})

vim.lsp.config("yamlls", {
	capabilities = caps,
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		yaml = {
			format = {
				enable = false,
			},
		},
	},
})

require("flutter-tools").setup({
	lsp = {
		capabilities = caps,
		settings = {
			showTodos = true,
			completeFunctionCalls = true,
		},
		on_attach = function(client, bufnr)
			local au_group = vim.api.nvim_create_augroup("FlutterHotReload", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = au_group,
				buffer = bufnr,
				callback = function()
					vim.cmd("FlutterReload")
				end,
			})
		end,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>del", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
		vim.keymap.set("n", "<leader>deg", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
	end,
})

vim.diagnostic.config({
	virtual_text = { prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = true,
})
