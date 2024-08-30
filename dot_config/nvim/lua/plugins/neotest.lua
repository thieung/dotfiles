local prefix = "<Leader>T"
---@type LazySpec
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "olimorris/neotest-rspec",
  },
  opts = function()
    return {
      adapters = {
        require "neotest-go",
        require "neotest-rspec" {
          rspec_cmd = function()
            return vim.tbl_flatten {
              "bundle",
              "exec",
              "rspec",
            }
          end,
        },
      },
      consumers = {
        overseer = require "neotest.consumers.overseer",
      },
      diagnostic = {
        enabled = false,
      },
      log_level = vim.log.levels.TRACE,
      icons = {
        expanded = "",
        child_prefix = "",
        child_indent = "",
        final_child_prefix = "",
        non_collapsible = "",
        collapsed = "",

        passed = "",
        running = "",
        failed = "",
        unknown = "",
        skipped = "",
      },
      floating = {
        border = "single",
        max_height = 0.8,
        max_width = 0.9,
      },
      summary = {
        mappings = {
          attach = "a",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          output = "o",
          run = "r",
          short = "O",
          stop = "u",
        },
      },
    }
  end,
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        end,
      },
    }, vim.api.nvim_create_namespace "neotest")
    require("neotest").setup(opts)
  end,
  specs = {
    "nvim-lua/plenary.nvim",
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            [prefix] = { desc = "󰗇 Tests" },
            [prefix .. "t"] = { function() require("neotest").run.run() end, desc = "Run test" },
            [prefix .. "d"] = { function() require("neotest").run.run { strategy = "dap" } end, desc = "Debug test" },
            [prefix .. "f"] = {
              function() require("neotest").run.run(vim.fn.expand "%") end,
              desc = "Run all tests in file",
            },
            [prefix .. "p"] = {
              function() require("neotest").run.run(vim.fn.getcwd()) end,
              desc = "Run all tests in project",
            },
            [prefix .. "<CR>"] = { function() require("neotest").summary.toggle() end, desc = "Test Summary" },
            [prefix .. "o"] = { function() require("neotest").output.open() end, desc = "Output hover" },
            [prefix .. "O"] = { function() require("neotest").output_panel.toggle() end, desc = "Output window" },
          },
        },
      },
    },
  },
}
