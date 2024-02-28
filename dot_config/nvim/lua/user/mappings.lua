local astro_utils = require "astronvim.utils"
local buffer = astro_utils.buffer

local mappings = {
  n = {
    -- disable default bindings
    ["]b"] = false,
    ["[b"] = false,

    ["<S-l>"] = { function() buffer.nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
    ["<S-h>"] = { function() buffer.nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer" },
    ["<Tab>"] = {
      function()
        if #vim.t.bufs > 1 then
          require("telescope.builtin").buffers {
            sort_mru = true,
            ignore_current_buffer = true,
          }
        else
          astro_utils.notify "No other buffers open"
        end
      end,
      desc = "Switch Buffers",
    },
  },
}

return mappings
