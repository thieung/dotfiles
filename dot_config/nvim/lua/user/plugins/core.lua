local get_icon = require("astronvim.utils").get_icon

return {
  -- disable default AstroNvim plugins
  { "goolord/alpha-nvim", enabled = false },
  { "max397574/better-escape.nvim", enabled = false },

  -- custom default AstroNvim plugins
  {
    "astrotheme",
    opts = { highlights = { global = { modify_hl_groups = function(hl) hl.Comment.italic = true end } } },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "miversen33/netman.nvim" },
    opts = {
      sources = {
        "filesystem",
        "netman.ui.neo-tree",
        "git_status",
      },
      source_selector = {
        sources = {
          { source = "filesystem", display_name = get_icon "FolderClosed" .. " File" },
          { source = "remote", display_name = "󰒍 Remote" },
          { source = "git_status", display_name = get_icon "Git" .. " Git" },
        },
      },
      filesystem = {
        filtered_items = {
          always_show = { ".github", ".gitignore" },
        },
      },
    },
  },

  {
    "mrjones2014/smart-splits.nvim",
    build = "./kitty/install-kittens.bash",
    opts = function(_, opts) opts.at_edge = require("smart-splits.types").AtEdgeBehavior.stop end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = false,
      numhl = true,
      current_line_blame = true,
      current_line_blame_opts = { ignore_whitespace = true },
    },
  },

  {
    "toggleterm.nvim",
    keys = {
      { "<C-BS>", mode = { "t" }, "<C-\\><C-n>", desc = "Terminal normal mode" },
      { "<esc><esc>", mode = { "t" }, "<C-\\><C-n>:q<cr>", desc = "Terminal quit" },
    },
    opts = { terminal_mappings = false },
  },

  { "williamboman/mason.nvim", opts = { PATH = "append" } }, -- Mason binaries will have the lowest priority
}
