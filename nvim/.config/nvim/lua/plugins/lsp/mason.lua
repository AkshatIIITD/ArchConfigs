-- lua/plugins/lsp/mason.lua
--
-- mason.nvim — binary installer for LSP servers, linters, and formatters.
-- Installs binaries to: ~/.local/share/nvim/mason/bin/
-- They are automatically added to PATH for all Mason-managed tools.
--
-- NOTE: mason.nvim v2.0 removed get_install_path() — do not use it.
-- Binaries are resolved via PATH automatically.

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
}
