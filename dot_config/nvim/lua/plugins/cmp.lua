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

    local format = opts.formatting.format
    opts.formatting.format = function(entry, vim_item)
      vim_item = format(entry, vim_item)

      -- truncate label
      local max_width = math.floor(0.25 * vim.o.columns)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, max_width)
      if truncated_label ~= label then vim_item.abbr = truncated_label .. "…" end

      return vim_item
    end

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
