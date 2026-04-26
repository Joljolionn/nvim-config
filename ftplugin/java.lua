local home = os.getenv("HOME")
local jdtls_path = home.. "/.local/share/nvim/mason/packages/jdtls"
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

-- Se não achar root_dir (arquivo solto), usa o diretório atual
if root_dir == "" then root_dir = vim.fn.getcwd() end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_folder = home.. "/Development/jdtls-workspace/".. project_name

-- CORREÇÃO DO JAR: O Mason às vezes muda o nome. Vamos garantir que pegamos o certo.
local launcher_jar = vim.fn.glob(jdtls_path.. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]

if not launcher_jar then
    print("ERRO: Launcher JAR do JDTLS não encontrado no caminho do Mason!")
    return
end

local config = {
    cmd = {
        "/usr/lib/jvm/java-21-openjdk/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultstartlevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", jdtls_path.. "/config_linux",
        "-data", workspace_folder,
    },
    root_dir = root_dir,
    settings = {
        java = {
            format = {
                enabled = true,
                settings = {
                    url = home.. "/.config/nvim/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
        },
    },
    -- Adicione as capabilities para garantir que ele se comunique bem com o Neovim
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

-- Inicia o LSP
require("jdtls").start_or_attach(config)
