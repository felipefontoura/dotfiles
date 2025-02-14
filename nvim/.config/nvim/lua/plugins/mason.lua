return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      auto_update = true,
      -- ensure_installed = {
      --   "bash-language-server",
      -- },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = {
      auto_update = true,
      ensure_installed = {
        "bash-language-server",
        "black",
        "css-variables-language-server",
        "css-lsp",
        "erb-lint",
        "eslint_d",
        "harper-ls",
        "html-lsp",
        "isort",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "python-lsp-server",
        "rubocop",
        "ruby-lsp",
        "stimulus-language-server",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
}
