local randomhead = function()
  math.randomseed(os.time())
  local headers = {
    {
      [[  /\ \▔\___  ___/\   /(●)_ __ ___  ]],
      [[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
      [[/ /\  /  __/ (_) \ V /| | | | | | |]],
      [[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
      [[───────────────────────────────────]],
    },
    {
      [[ _______             ____   ____.__         ]],
      [[ \      \   ____  ___\   \ /   /|__| _____  ]],
      [[ /   |   \_/ __ \/  _ \   Y   / |  |/     \ ]],
      [[/    |    \  ___(  <_> )     /  |  |  Y Y  \]],
      [[\____|__  /\___  >____/ \___/   |__|__|_|  /]],
      [[        \/     \/                        \/ ]],
    },
    {
      [[                               __                ]],
      [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    },
  }
  return table.concat(headers[math.random(1, #headers)], "\n")
end

return {
  -- disable alpha
  { "goolord/alpha-nvim", enabled = false },

  -- enable mini.starter
  {
    "echasnovski/mini.starter",
    version = false,
    event = "VimEnter",
    opts = function()
      local new_section = function(name, action, section) return { name = name, action = action, section = section } end
      local starter = require "mini.starter"
      local config = {
        evaluate_single = true,
        header = randomhead(),
        items = {
          starter.sections.recent_files(5, true, false),
          new_section("Restore last session", "SessionManager! load_last_session", "Built-in"),
          new_section("Load sessions", "SessionManager! load_session", "Built-in"),
          new_section("New file", "ene | startinsert", "Built-in"),
          new_section("Old files", "Telescope oldfiles", "Telescope"),
          new_section("Find file", "Telescope find_files hidden=true path_display=smart<CR>", "Telescope"),
          new_section("Grep text", "Telescope live_grep path_display=smart<CR>", "Telescope"),
          new_section("Update plugins", "Lazy", "Config"),
          new_section("Quit", "qa", "Built-in"),
        },
        content_hooks = {
          function(content)
            local blank_content_line = { { type = "empty", string = "" } }
            local section_coords = starter.content_coords(content, "section")
            -- Insert backwards to not affect coordinates
            for i = #section_coords, 1, -1 do
              table.insert(content, section_coords[i].line + 1, blank_content_line)
            end
            return content
          end,
          starter.gen_hook.adding_bullet("» ", false),
          starter.gen_hook.aligning("center", "center"),
        },
      }
      return config
    end,
    config = function(_, config)
      -- close Lazy and re-open when starter is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniStarterOpened",
          callback = function() require("lazy").show() end,
        })
      end

      local starter = require "mini.starter"
      starter.setup(config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          starter.config.footer = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(starter.refresh)
        end,
      })
    end,
  },
}
