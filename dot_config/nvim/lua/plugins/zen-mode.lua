---@type LazySpec
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>z"] = { "<Cmd>ZenMode<CR>", desc = "Zen Mode" },
        },
      },
    },
  },
  opts = {
    window = {
      width = function() return math.min(120, vim.o.columns * 0.75) end,
      height = 0.9,
      options = {
        number = false,
        relativenumber = false,
        foldcolumn = "0",
        list = false,
        showbreak = "NONE",
        signcolumn = "no",
      },
    },
    plugins = {
      options = {
        cmdheight = 1,
        laststatus = 0,
      },
    },
    on_open = function() -- disable diagnostics, indent blankline, and winbar
      vim.g.diagnostics_mode_old = vim.g.diagnostics_mode
      vim.g.indent_blankline_enabled_old = vim.g.indent_blankline_enabled
      vim.g.miniindentscope_disable_old = vim.g.miniindentscope_disable
      vim.g.winbar_old = vim.wo.winbar
      vim.g.diagnostics_mode = 0
      vim.g.indent_blankline_enabled = false
      vim.g.miniindentscope_disable = true
      vim.wo.winbar = nil
      vim.diagnostic.config(require("astrocore").config.diagnostics[vim.g.diagnostics_mode])
    end,
    on_close = function() -- restore diagnostics, indent blankline, and winbar
      vim.g.diagnostics_mode = vim.g.diagnostics_mode_old
      vim.g.indent_blankline_enabled = vim.g.indent_blankline_enabled_old
      vim.g.miniindentscope_disable = vim.g.miniindentscope_disable_old
      vim.wo.winbar = vim.g.winbar_old
      pcall(vim.cmd.IndentBlanklineRefresh)
      vim.diagnostic.config(require("astrocore").config.diagnostics[vim.g.diagnostics_mode])
    end,
  },
}
