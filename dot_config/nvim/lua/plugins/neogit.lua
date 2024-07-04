---@type LazySpec
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>gG"] = { function() require("neogit").open() end, desc = "Neogit" },
          },
        },
      },
    },
    opts = function()
      local get_icon = require("astroui").get_icon
      local fold_signs = { get_icon "FoldClosed", get_icon "FoldOpened" }
      return {
        disable_builtin_notifications = true,
        signs = { section = fold_signs, item = fold_signs },
      }
    end,
  },
}
