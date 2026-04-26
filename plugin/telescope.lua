vim.pack.add({
  {src = "https://github.com/nvim-tree/nvim-web-devicons"},
  {src = "https://github.com/MunifTanjim/nui.nvim"},
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" }
})

local telescope = require("telescope")

telescope.setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
      })
    }
  }
})

telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })

vim.keymap.set("n", "<leader>fd", function()
  local search_string = vim.fn.input("Grep > ")
  if search_string ~= "" then
    builtin.grep_string({ search = search_string })
  end
end, { desc = "Telescope grep string" })
