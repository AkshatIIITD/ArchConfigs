-- ftplugin/java.lua

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- ── Paths ──────────────────────────────────────────────────────────────────
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

local launcher_list = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)
local launcher = launcher_list[1]
if not launcher then
  vim.notify(
    "jdtls launcher jar not found — is jdtls installed via Mason?",
    vim.log.levels.WARN,
    { title = "nvim-jdtls" }
  )
  return
end

local os_config = "linux"
if vim.fn.has("mac") == 1 then
  os_config = "mac"
elseif vim.fn.has("win32") == 1 then
  os_config = "win"
end
local config_dir = jdtls_path .. "/config_" .. os_config

local lombok_jar = jdtls_path .. "/lombok.jar"
local lombok_exists = vim.uv.fs_stat(lombok_jar) ~= nil

-- ── Root / workspace ───────────────────────────────────────────────────────
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t") .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

-- ── Capabilities ───────────────────────────────────────────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- ── Command ────────────────────────────────────────────────────────────────
local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.level=ERROR",
  "-Xms256m",
  "-Xmx4g",
  "-Djava.import.generatesMetadataFilesAtProjectRoot=false",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
}

if lombok_exists then
  table.insert(cmd, "-javaagent:" .. lombok_jar)
end

vim.list_extend(cmd, {
  "-jar",
  launcher,
  "-configuration",
  config_dir,
  "-data",
  workspace_dir,
})

-- ── Config ─────────────────────────────────────────────────────────────────
local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,

  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = {
        downloadSources = true,
        -- Uncomment for custom settings.xml (corporate Nexus/Artifactory):
        -- userSettings   = vim.fn.expand("~/.m2/settings.xml"),
        -- globalSettings = "/etc/maven/settings.xml",
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- Uncomment for multi-JDK corporate environments:
        -- runtimes = {
        --   { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
        --   { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
        -- },
      },
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
    },
  },

  init_options = { bundles = {} },
}

jdtls.start_or_attach(config)
