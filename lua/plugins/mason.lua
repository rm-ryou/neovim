return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "rust_analyzer",
        -- "ruby_lsp",
        "ts_ls",
        "buf_ls",
        "html",
        "cssls",
        "tailwindcss",
        "eslint",
        "just",
        "docker_compose_language_service",
        "docker_language_server",
        "terraformls",
      },
    },
  },
}
