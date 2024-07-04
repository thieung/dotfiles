---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "andymass/vim-matchup",
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "WinBar", syntax_hl = 1 },
          },
        },
      },
    },
  },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    matchup = { enable = true },
  },
}
