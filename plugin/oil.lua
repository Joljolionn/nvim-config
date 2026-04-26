vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/stevearc/oil.nvim" }
})

require("oil").setup({
  sync_with_cwd = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
   ["<CR>"]    = "actions.select",
    ["<C-p>"] = "actions.preview",
    ["<C-l>"] = "actions.refresh",
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      local ok, oil = pcall(require, "oil")
      if ok then
        require("oil.actions").cd.callback()
      end
    end)
  end,
})

vim.keymap.set("n", "<leader><leader>", ":Oil<CR>", { noremap = true, silent = true })
