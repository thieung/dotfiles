---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>ff"][1] = function()
          require("telescope.builtin").find_files {
            -- search all files if in git root
            hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
          }
        end
      end,
    },
  },
  opts = {
    defaults = {
      results_title = "",
      selection_caret = "  ",
      layout_config = {
        width = 0.90,
        height = 0.85,
        preview_cutoff = 120,
        horizontal = {
          preview_width = 0.6,
        },
        vertical = {
          width = 0.9,
          height = 0.95,
          preview_height = 0.5,
        },
        flex = {
          horizontal = {
            preview_width = 0.9,
          },
        },
      },
    },
    pickers = {
      buffers = {
        path_display = { "smart" },
        mappings = {
          i = { ["<C-D>"] = function(...) return require("telescope.actions").delete_buffer(...) end },
          n = { ["d"] = function(...) return require("telescope.actions").delete_buffer(...) end },
        },
      },
    },
  },
}
