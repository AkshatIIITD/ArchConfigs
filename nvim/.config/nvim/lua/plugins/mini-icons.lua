-- lua/plugins/mini-icons.lua
return {
  "nvim-mini/mini.icons",
  opts = {},
  config = function(_, opts)
    require("mini.icons").setup(opts)
    require("mini.icons").mock_nvim_web_devicons() -- mock api for nvim-web-devicons
  end,
}
