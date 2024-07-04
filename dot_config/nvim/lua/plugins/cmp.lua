---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "kdheepak/cmp-latex-symbols",
  },
  opts = function(_, opts)
    opts.sources = {
      {
        name = "nvim_lsp",
        priority = 1000,
        option = { markdown_oxide = { keyword_pattern = [[\(\k\| \|\/\|#\)\+]] } },
      },
      { name = "luasnip", priority = 750 },
      { name = "latex_symbols", priority = 700 },
      { name = "path", priority = 500 },
      { name = "buffer", priority = 250, group_index = 2 },
    }

    if not opts.sorting then opts.sorting = {} end
    local compare = require "cmp.config.compare"
    opts.sorting.comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    }
  end,
}
