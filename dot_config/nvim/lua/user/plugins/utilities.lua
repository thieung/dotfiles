return {
  -- {
  --   "gen740/SmoothCursor.nvim",
  --   cond = vim.g.neovide == nil,
  --   lazy = false,
  --   opts = {
  --     autostart = true,
  --     fancy = { enable = true },
  --   },
  -- },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = { "q", "<esc>" },
        cancel = "<c-e>",
      },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    event = "User AstroFile",
    cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
    opts = {},
  },
}
