vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"


vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.tabstop = 2 -- Quantidade de espaços que um TAB exibe
vim.opt.shiftwidth = 2 -- Quantidade de espaços para indentação automática (>>, <<)
vim.opt.softtabstop = 2 -- Quantidade de espaços ao pressionar TAB no modo insert
vim.opt.expandtab = true -- Converte TAB em espaços (use `false` se quiser TABs literais)

vim.highlight.priorities.semantic_tokens = 95
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)



-- Mover linha para baixo com Alt+J
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Mover linha para cima com Alt+K
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Mover linha para baixo com Alt+Down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("x", "<A-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Mover linha para cima com Alt+Up
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("x", "<A-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><leader>", ":Oil<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><Left>", ":Neotree toggle filesystem reveal left<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader><Right>", ":Neotree toggle filesystem reveal right<CR>", { noremap = true, silent = true })






vim.keymap.set("n", "<leader>fm", function()
	require("telescope").extensions.media_files.media_files()
end, { desc = "📸 Telescope Media Files" })


local function run_kotlin_float()
	vim.cmd("write")

	local file = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")
	local jar_name = vim.fn.expand("%:t:r") .. ".jar"

	-- Montando o comando com feedback visual (verbose)
	-- Usamos o 'echo' para você saber exatamente em que etapa está
	local cmd = string.format(
		"echo '[1/3] Compilando %s...' && "
			.. "kotlinc %s -include-runtime -d %s && "
			.. "echo '[2/3] Compilação concluída.' && "
			.. "echo '------------------------------------------' && "
			.. "echo &&"
			.. "java -jar %s && "
			.. "echo &&"
			.. "echo '------------------------------------------' && "
			.. "echo '[3/3] Execução finalizada.' && "
			.. "rm %s",
		filename,
		file,
		jar_name,
		jar_name,
		jar_name
	)

	local width = math.ceil(vim.o.columns * 0.8)
	local height = math.ceil(vim.o.lines * 0.8)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = math.ceil((vim.o.lines - height) / 2),
		col = math.ceil((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	}

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Roda o comando verboso
	vim.fn.termopen(cmd)
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>rk", run_kotlin_float, { desc = "Run Kotlin Verbose" })

-- Restore the 'Lsp' command family
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {})

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd("edit " .. vim.lsp.get_log_path())
end, {})

vim.api.nvim_create_user_command("LspRestart", function()
	vim.lsp.stop_client(vim.lsp.get_clients())
	vim.cmd("edit")
	print("LSP Restarted")
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Isso desativa as cores do LSP e deixa o Treesitter brilhar sozinho
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang then
      pcall(vim.treesitter.start)
    end
  end,
})
