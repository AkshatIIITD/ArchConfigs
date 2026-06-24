return {
  "romus204/tree-sitter-manager.nvim",
  dependencies = {}, -- tree-sitter CLI must be installed system-wide
  config = function()
    require("tree-sitter-manager").setup({
      -- Default Options
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query", -- for editing treesitter queries
        "bash",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "latex",
        "css",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "go",
        "rust",
        "c",
        "cpp",
        "java",
        "regex",
        "gitignore",
        "gitcommit",
        "diff",
      }, -- list of parsers to install at the start of a neovim session
      -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
      auto_install = true, -- if enabled, install missing parsers when editing a new file
      -- highlight = true, -- treesitter highlighting is enabled by default
      -- languages = {}, -- override or add new parser sources
      -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
      -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
    })
  end,
}
