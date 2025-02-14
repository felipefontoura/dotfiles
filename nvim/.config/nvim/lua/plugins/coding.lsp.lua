return {
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- CSS
      lspconfig.css_variables.setup({
        capabilities = capabilities,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- JavaScript / TypeScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- Python
      lspconfig.pylsp.setup({
        capabilities = capabilities,
      })

      -- Ruby and RoR
      lspconfig.rubocop.setup({
        capabilities = capabilities,
      })
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
      })
      lspconfig.stimulus_ls.setup({
        capabilities = capabilities,
      })

      -- Spellchecker
      lspconfig.harper_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "html",
          "markdown",
          "text",
        },
      })

      -- Yaml
      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })
    end,
  },
}
