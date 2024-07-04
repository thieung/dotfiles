---@type LazySpec
return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps, prefix = opts.mappings, "<Leader>x"
        maps.n[prefix] = { desc = "󰒡 Trouble" }
        maps.n[prefix .. "l"] = { "<Cmd>Trouble lsp toggle win.position=right<CR>", desc = "LSP (Trouble)" }
        maps.n[prefix .. "L"] = { "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" }
        maps.n[prefix .. "q"] = { "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" }
        maps.n[prefix .. "s"] = { "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" }
        maps.n[prefix .. "x"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" }
        maps.n[prefix .. "X"] =
          { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" }

        if require("astrocore").is_available "todo-comments.nvim" then
          maps.n[prefix .. "T"] = { "<Cmd>Trouble todo<CR>", desc = "TODOs (Trouble)" }
        end
      end,
    },
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
  },
  { "lewis6991/gitsigns.nvim", opts = { trouble = true } },
}
