-- lua/plugins/ts-autotag.lua

return {
  "windwp/nvim-ts-autotag",
  -- do NOT lazy load — the README explicitly warns against it
  lazy = false,
  opts = {
    opts = {
      enable_close = true, -- auto close tags
      enable_rename = true, -- auto rename paired tag
      enable_close_on_slash = false, -- auto close on </
    },
    -- per-filetype overrides if needed
    per_filetype = {},
  },
}
