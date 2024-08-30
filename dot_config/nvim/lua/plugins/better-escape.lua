return {
  "max397574/better-escape.nvim",
  opts = {
    mappings = {
      i = { j = { k = false, j = false } }, -- disable insert mode escape
      t = {
        ["<Esc>"] = { ["<Esc>"] = "<C-\\><C-n>:q<CR>" }, -- add double escape to close
      },
    },
  },
}
