local disabled = {
  "goolord/alpha-nvim",
  "jay-babu/mason-null-ls.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "max397574/better-escape.nvim",
  "nvimtools/none-ls.nvim",
}
if vim.fn.has "nvim-0.10" == 1 then table.insert(disabled, "numToStr/Comment.nvim") end

return vim.tbl_map(function(plugin) return { plugin, enabled = false } end, disabled)
