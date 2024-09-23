---@type LazySpec
return {
  "andymass/vim-matchup",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            matchup_matchparen_pumvisible = 0,
            matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "WinBar", syntax_hl = 1 },
          },
        },
      },
    },
  },
  specs = {
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = { "andymass/vim-matchup" },
      ---@type TSConfig
      ---@diagnostic disable-next-line: missing-fields
      opts = {
        matchup = { enable = true },
      },
    },
  },
}
