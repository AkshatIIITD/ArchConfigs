-- lua/plugins/indent-blankline.lua
--
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    scope = {
      enabled = false,
    },
  },
}
