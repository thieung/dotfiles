return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local options, maps = opts.options, opts.mappings
        options.g.codeium_disable_bindings = 1
        options.g.codeium_manual = true
        options.g.codeium_filetypes_disabled_by_default = true
        options.g.codeium_filetypes = {
          typescript = true,
          ruby = true,
        }

        maps.n["<M-CR>"] = { function() return vim.fn["codeium#Chat"]() end, expr = true, silent = true }
        maps.i["<M-]>"] = { function() return vim.fn["codeium#CycleOrComplete"]() end, expr = true, silent = true }
        maps.i["<M-\\>"] = maps.i["<M-]>"]
        maps.i["<M-[>"] = { function() return vim.fn["codeium#CycleCompletions"](-1) end, expr = true, silent = true }
        maps.i["<M-CR>"] = { function() return vim.fn["codeium#Accept"]() end, expr = true, silent = true }
        maps.i["<M-BS>"] = { function() return vim.fn["codeium#Clear"]() end, expr = true, silent = true }
      end,
    },
  },
}
