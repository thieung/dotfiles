---@type LazySpec
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = function()
    local get_icon = require("astroui").get_icon
    local lspkind_avail, lspkind = pcall(require, "lspkind")

    ---@type trouble.Config
    return {
      keys = {
        ["<Esc>"] = "close",
        ["<C-e>"] = "cancel",
      },
      icons = {
        indent = {
          fold_open = get_icon "FoldOpened",
          fold_closed = get_icon "FoldClosed",
        },
        folder_closed = get_icon "FolderClosed",
        folder_open = get_icon "FolderOpen",
        kinds = lspkind_avail and lspkind.symbol_map,
      },
    }
  end,
  specs = {
    { "lewis6991/gitsigns.nvim", opts = { trouble = true } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps, prefix = opts.mappings, "<Leader>x"
        maps.n[prefix .. "L"] = { "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" }
        maps.n[prefix .. "Q"] = { "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" }
        maps.n[prefix .. "x"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" }
        maps.n[prefix .. "X"] =
          { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" }

        if require("astrocore").is_available "todo-comments.nvim" then
          maps.n[prefix .. "t"] = { "<Cmd>Trouble todo<CR>", desc = "Todo (Trouble)" }
          maps.n[prefix .. "T"] =
            { "<Cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<CR>", desc = "Todo/Fix/Fixme (Trouble)" }
        end
      end,
    },
  },
}
