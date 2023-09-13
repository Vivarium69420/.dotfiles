local home = os.getenv "HOME"
local jdtls = require "jdtls"
local jdtls_dir = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
local config_dir = jdtls_dir .. "/config_linux"
local plugins_dir = jdtls_dir .. "/plugins/"
local path_to_jar = plugins_dir .. "org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
local path_to_lombok = jdtls_dir .. "/lombok.jar"

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = {
  "gradlew",
  "mvnw",
  ".git",
  "pom.xml",
  "build.gradle",
  "settings.gradle",
  "build.xml",
  "src",
  "app.src",
  "gradle",
  "build",
}
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == nil then
  print "Couldn't find root directory"
  return
end

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Helper function for creating keymaps
function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Regular Neovim LSP client keymappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap("gD", vim.lsp.buf.declaration, bufopts, "Go to declaration")
  nnoremap("gd", vim.lsp.buf.definition, bufopts, "Go to definition")
  nnoremap("gi", vim.lsp.buf.implementation, bufopts, "Go to implementation")
  nnoremap("K", vim.lsp.buf.hover, bufopts, "Hover text")
  nnoremap("<space>ls", vim.lsp.buf.signature_help, bufopts, "Show signature")
  nnoremap("<space>wa", vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
  nnoremap("<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
  nnoremap("<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, "List workspace folders")
  nnoremap("<space>D", vim.lsp.buf.type_definition, bufopts, "Go to type definition")
  nnoremap("<space>ra", vim.lsp.buf.rename, bufopts, "Rename")
  nnoremap("<space>ca", vim.lsp.buf.code_action, bufopts, "Code actions")
  nnoremap("gr", vim.lsp.buf.references, bufopts, "Go to references")
  nnoremap("<space>lm", vim.diagnostic.open_float { border = "rounded" }, bufopts, "Floating diagnostics")
  nnoremap("[d", vim.diagnostic.goto_prev { float = { border = "rounded" } }, bufopts, "Previous diagnostic")
  nnoremap("]d", vim.diagnostic.goto_next { float = { border = "rounded" } }, bufopts, "Next diagnostic")
  nnoremap("<space>q", vim.diagnostic.set_loclist, bufopts, "Set location list")
  vim.keymap.set(
    "v",
    "<space>ca",
    "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    { noremap = true, silent = true, buffer = bufnr, desc = "Code actions" }
  )
  nnoremap("<space>fm", function()
    vim.lsp.buf.format { async = true }
  end, bufopts, "Format file")

  -- Java extensions provided by jdtls
  nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set(
    "v",
    "<space>em",
    [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" }
  )
end

local config = {
  flags = {
    debounce_text_changes = 80,
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {},
  },
  on_attach = on_attach,
  root_dir = root_dir,
  settings = {
    java = {
      format = {
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          -- and place it in the ~/.local/share/eclipse directory
          url = "~/.local/share/eclipse/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "^java.awt.*",
          "^javax.swing.*",
          "^com.sun.*",
          "^sun.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      -- configuration = {
      --   runtimes = {
      --     {
      --       name = "JavaSE_17",
      --       path = "/usr/lib/jvm/java-17-openjdk/bin/java",
      --     },
      --   }
      -- }
    },
  },
  capabilities = {
    workspace = {
      configuration = true,
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
  cmd = {
    "/usr/lib/jvm/java-17-openjdk/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-Xmx2G",
    "-javaagent:" .. path_to_lombok,
    "-jar",
    path_to_jar,
    "-configuration",
    config_dir,
    "-data",
    workspace_folder,
    "--add-modules=ALL-SYSTEM",
    "--add-opens java.base/java.util=ALL-UNNAMED",
    "--add-opens java.base/java.lang=ALL-UNNAMED",
  },
}

jdtls.start_or_attach(config)
