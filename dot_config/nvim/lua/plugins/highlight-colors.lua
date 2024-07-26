return {
  "brenoprata10/nvim-highlight-colors",
  event = { "User AstroFile", "InsertEnter" },
  cmd = "HighlightColors",
  opts = { enable_named_colors = false, virtual_symbol = "" },
  specs = {
    { "NvChad/nvim-colorizer.lua", optional = true, enabled = false },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>uz"] = { function() vim.cmd.HighlightColors "Toggle" end, desc = "Toggle color highlight" }
      end,
    },
  },
}
