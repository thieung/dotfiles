---@type LazySpec
return {
  "rebelot/heirline.nvim",
  dependencies = {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      icons = {
        Clock = "", -- add icon for clock
      },
      status = {
        attributes = { mode = { bold = true } },
        separators = {
          left = { "", " " },
          right = { " ", "" },
        },
      },
    },
  },
  opts = function(_, opts)
    local status = require "astroui.status"
    -- add time to mode indicator
    opts.statusline[#opts.statusline] = status.component.builder {
      {
        provider = function()
          local time = os.date "%H:%M" -- show hour and minute in 24 hour format
          ---@cast time string
          return status.utils.stylize(time, {
            icon = { kind = "Clock", padding = { right = 1 } }, -- add icon
            padding = { right = 1 }, -- pad the right side
          })
        end,
      },
      update = { "ModeChanged", pattern = "*:*", callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end) },
      hl = status.hl.get_attributes "mode", -- highlight based on mode attributes
      surround = { separator = "right", color = status.hl.mode_bg, update = { "ModeChanged", pattern = "*:*" } }, -- background highlight based on mode
      init = status.init.update_events {
        { "User", pattern = "UpdateTime", callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end) },
      },
    }

    local uv = vim.uv or vim.loop
    uv.new_timer():start( -- timer for updating the time
      (60 - tonumber(os.date "%S")) * 1000, -- offset timer based on current seconds past the minute
      60000, -- update every 60 seconds
      vim.schedule_wrap(function() vim.api.nvim_exec_autocmds("User", { pattern = "UpdateTime", modeline = false }) end)
    )

    -- custom winbar
    local path_func = status.provider.filename { modify = ":.:h", fallback = "" }
    opts.winbar[1][1] = status.component.separated_path { path_func = path_func }
    opts.winbar[2] = {
      status.component.separated_path { path_func = path_func },
      status.component.file_info { -- add file_info to breadcrumbs
        file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
        file_read_only = false,
        file_modified = false,
        filename = {},
        filetype = false,
        hl = status.hl.get_attributes("winbar", true),
        surround = false,
        update = "BufEnter",
      },
      status.component.breadcrumbs {
        icon = { hl = true },
        hl = status.hl.get_attributes("winbar", true),
        prefix = true,
        padding = { left = 0 },
      },
    }
  end,
}
