return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "debugloop/telescope-undo.nvim" },
    { "molecule-man/telescope-menufacture" },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.1.x",
      dependencies = { "kkharji/sqlite.lua" },
    },
  },
  keys = {
    -- telescope plugin mappings
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo" },
    { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File explorer" },
    { "<leader><leader>", "<Cmd>Telescope smart_open<CR>", desc = "Search files by name (smart)" },
  },
  opts = function(_, opts)
    local actions = require "telescope.actions"
    local fb_actions = require("telescope").extensions.file_browser.actions

    return require("astronvim.utils").extend_tbl(opts, {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        winblend = 0,
        layout_config = {
          width = 0.90,
          height = 0.85,
          preview_cutoff = 120,
          horizontal = {
            preview_width = function(_, cols, _) return math.floor(cols * 0.6) end,
          },
          vertical = {
            width = 0.9,
            height = 0.95,
            preview_height = 0.5,
          },
        },
      },
      live_grep = {
        file_ignore_patterns = {
          "vendor/*",
          "node_modules",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
          "%.csv",
          "%.lock",
          ".git/",
          "spell/*",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        undo = {
          mappings = {
            i = {
              ["<CR>"] = require("telescope-undo.actions").restore,
              ["<C-a>"] = require("telescope-undo.actions").yank_additions,
              ["<C-d>"] = require("telescope-undo.actions").yank_deletions,
            },
          },
        },
        file_browser = {
          theme = "ivy",
          mappings = {
            i = {
              ["<C-z>"] = fb_actions.toggle_hidden,
            },
            n = {
              z = fb_actions.toggle_hidden,
            },
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
              ["<Tab>"] = actions.select_default,
            },
            n = {
              ["d"] = actions.delete_buffer,
              ["<Tab>"] = actions.select_default,
            },
          },
        },
      },
    })
  end,
  config = function(...)
    require "plugins.configs.telescope"(...)
    local telescope = require "telescope"
    telescope.load_extension "undo"
    telescope.load_extension "fzf"
    telescope.load_extension "file_browser"
    telescope.load_extension "menufacture"
    telescope.load_extension "smart_open"
  end,
}
