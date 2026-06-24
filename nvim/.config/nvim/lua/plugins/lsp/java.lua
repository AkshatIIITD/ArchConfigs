-- lua/plugins/lsp/java.lua
--
-- nvim-jdtls: dedicated plugin for Eclipse JDT Language Server.
-- Java is a special case — jdtls requires:
--   • A unique workspace/data directory per project root
--   • Specific JVM launch arguments (launcher jar, config dir, data dir)
--   • Per-attach startup via ftplugin, not vim.lsp.enable()
--
-- This plugin entry just ensures nvim-jdtls is installed.
-- The actual server start lives in ftplugin/java.lua.

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
