---@type LazySpec
return {
  "onsails/lspkind.nvim",
  opts = function(_, opts)
    -- use codicons preset
    opts.preset = "codicons"
    -- set some missing symbol types
    opts.symbol_map = {
      Array = "",
      Boolean = "",
      Key = "",
      Namespace = "",
      Null = "",
      Number = "",
      Object = "",
      Package = "",
      String = "",
    }
    opts.before = function(_, vim_item)
      local max_width = math.floor(0.25 * vim.o.columns)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, max_width)
      if truncated_label ~= label then vim_item.abbr = truncated_label .. "…" end
      return vim_item
    end
  end,
}
