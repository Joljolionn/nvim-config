vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" }
})

require("catppuccin").setup({
  flavour = "mocha", -- Opções: latte, frappe, macchiato, mocha
})

-- 3. Carrega o tema
vim.cmd.colorscheme("catppuccin")
