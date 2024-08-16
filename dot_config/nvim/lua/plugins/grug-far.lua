local prefix = "<Leader>s"
---@type LazySpec
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {
    windowCreationCommand = "split",
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            [prefix] = { desc = "󰛔 Search/Replace" },
            [prefix .. "s"] = {
              function() require("grug-far").grug_far { transient = true } end,
              desc = "Search/Replace workspace",
            },
            [prefix .. "e"] = {
              function()
                local ext = require("astrocore.buffer").is_valid() and vim.fn.expand "%:e" or ""
                require("grug-far").grug_far {
                  transient = true,
                  prefills = { filesFilter = ext ~= "" and "*." .. ext or nil },
                }
              end,
              desc = "Search/Replace filetype",
            },
            [prefix .. "f"] = {
              function()
                local filter = require("astrocore.buffer").is_valid() and vim.fn.expand "%" or nil
                require("grug-far").grug_far { transient = true, prefills = { paths = filter } }
              end,
              desc = "Search/Replace file",
            },
            [prefix .. "w"] = {
              function()
                local current_word = vim.fn.expand "<cword>"
                if current_word ~= "" then
                  require("grug-far").grug_far {
                    transient = true,
                    startCursorRow = 4,
                    prefills = { search = vim.fn.expand "<cword>" },
                  }
                else
                  vim.notify("No word under cursor", vim.log.levels.WARN, { title = "Grug-far" })
                end
              end,
              desc = "Replace current word",
            },
          },
          v = {
            [prefix] = {
              function() require("grug-far").grug_far { transient = true, startCursorRow = 4 } end,
              desc = "Replace selection",
            },
          },
        },
      },
    },
  },
}
