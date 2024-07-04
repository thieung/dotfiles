local prefix = "<Leader>s"
---@type LazySpec
return {
  "nvim-pack/nvim-spectre",
  cmd = "Spectre",
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          [prefix] = { desc = "󰛔 Search/Replace" },
          [prefix .. "s"] = { function() require("spectre").toggle() end, desc = "Toggle Spectre" },
          [prefix .. "f"] = { function() require("spectre").open_file_search() end, desc = "Spectre (current file)" },
          [prefix .. "w"] = {
            function() require("spectre").open_visual { select_word = true } end,
            desc = "Spectre (current word)",
          },
        },
        v = {
          [prefix] = { function() require("spectre").open_visual() end, desc = "Spectre" },
        },
      },
    },
  },
  opts = {
    open_cmd = "new",
    mapping = {
      send_to_qf = { map = "<Leader>sq" },
      replace_cmd = { map = "<Leader>sc" },
      show_option_menu = { map = "<Leader>so" },
      run_current_replace = { map = "<Leader>sC" },
      run_replace = { map = "<Leader>sR" },
      change_view_mode = { map = "<Leader>sv" },
      resume_last_search = { map = "<Leader>sl" },
    },
  },
}
