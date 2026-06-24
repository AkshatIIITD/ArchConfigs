-- after/lsp/lua_ls.lua
--
-- Loaded AFTER nvim-lspconfig's lsp/lua_ls.lua.
-- Your settings here take precedence over lspconfig's defaults.
--
-- workspace.library is NOT set here intentionally.
-- lazydev.nvim manages it dynamically and does it better.

---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime   = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" },
      },
      completion = { callSnippet = "Replace" },
      hint = {
        enable     = true,
        arrayIndex = "Disable",
        paramName  = "All",
        paramType  = true,
        semicolon  = "Disable",
        setType    = true,
      },
      telemetry = { enable = false },
    },
  },
}

