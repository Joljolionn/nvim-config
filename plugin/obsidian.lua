vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/epwalsh/obsidian.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/iamcco/markdown-preview.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim", version = vim.version.range("1.*") }
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "markdown-preview.nvim" then
      vim.fn["mkdp#util#install"]()
    end
  end,
})

local workspaces_file = vim.fn.stdpath("data").. "/obsidian_workspaces.json"
local function load_extra_workspaces()
  local f = io.open(workspaces_file, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.fn.json_decode, content)
  return ok and data or {}
end

local my_workspaces = {
  { name = "Brain", path = "~/Documents/obsidian/Brain" },
}

local extras = load_extra_workspaces()
for _, ws in ipairs(extras) do
  table.insert(my_workspaces, ws)
end

require("obsidian").setup({
  workspaces = my_workspaces,
  disable_frontmatter = true,
  ui = { enable = false },
  completion = { nvim_cmp = true },
  note_id_func = function(title)
    return title ~= nil and title or tostring(os.time())
  end,
  mappings = {
    ["<leader>on"] = {
      action = function() vim.cmd("ObsidianNew") end,
      opts = { buffer = true, desc = "Nova Nota" }
    },
    ["<cr>"] = {
      action = function() return require("obsidian").util.smart_action() end,
      opts = { buffer = true, expr = true }
    },
  }
})


vim.keymap.set("n", "<leader>oa", function()
	local obsidian = require("obsidian")
	local client = obsidian.get_client()
	if not client then
		return
	end

	local pwd = vim.fn.getcwd()
	local name = vim.fn.input("Nome do Workspace: ", vim.fn.fnamemodify(pwd, ":t"))
	if name == "" then
		return
	end

	local path = vim.fn.input("Confirmar Path: ", pwd)
	if path == "" then
		return
	end

	-- Adiciona na memória
	table.insert(client.opts.workspaces, { name = name, path = path })
	obsidian.setup(client.opts)

	local workspaces_file = vim.fn.stdpath("data") .. "/obsidian_workspaces.json"
	local function load_extra_workspaces()
		local f = io.open(workspaces_file, "r")
		if not f then
			return {}
		end
		local content = f:read("*a")
		f:close()
		local ok, data = pcall(vim.fn.json_decode, content)
		return ok and data or {}
	end

	-- Salva no arquivo para persistência
	local current_extras = load_extra_workspaces()
	table.insert(current_extras, { name = name, path = path })
	local wf = io.open(workspaces_file, "w")
	if wf then
		wf:write(vim.fn.json_encode(current_extras))
		wf:close()
	end

	vim.cmd("edit!")
	print("\n[Obsidian] Workspace '" .. name .. "' salvo no caderno!")
end, { desc = "Obsidian: Add Permanent Workspace" })

vim.keymap.set("n", "<leader>ow", function()
	local client = require("obsidian").get_client()
	local workspaces = client.opts.workspaces
	local names = {}
	for _, ws in ipairs(workspaces) do
		table.insert(names, ws.name)
	end

	vim.ui.select(names, { prompt = "Selecionar Workspace: " }, function(choice)
		if not choice then
			return
		end

		-- Acha o path do workspace escolhido
		local target_path = ""
		for _, ws in ipairs(workspaces) do
			if ws.name == choice then
				target_path = ws.path
				break
			end
		end

		-- Muda o Workspace no Plugin
		vim.cmd("ObsidianWorkspace " .. choice)
		-- Muda o PWD do Neovim
		vim.api.nvim_set_current_dir(vim.fn.expand(target_path))
		-- Abre o Oil no novo dir
		require("oil").open(target_path)
	end)
end, { desc = "Switch Obsidian Workspace + CD" })


require('render-markdown').setup({
  render_modes = { "n", "c", "i" },
  latex = { enabled = false },
  anti_conceal = { enabled = true },
})

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1

require("typst-preview").setup({})
