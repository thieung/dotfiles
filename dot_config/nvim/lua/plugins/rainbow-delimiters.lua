---@type LazySpec
return {
  "HiPhish/rainbow-delimiters.nvim",
  branch = "fix-highlighting",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "User AstroFile",
  main = "rainbow-delimiters.setup",
  opts = {},
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>u("] = {
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                require("rainbow-delimiters").toggle(bufnr)
                require("astrocore").notify(
                  string.format(
                    "Buffer rainbow delimeters %s",
                    require("rainbow-delimiters").is_enabled(bufnr) and "on" or "off"
                  )
                )
              end,
              desc = "Toggle rainbow delimeters (buffer)",
            },
          },
        },
      },
    },
  },
}
