-- local colors = require("colors")
-- local settings = require("settings")
--
-- local front_app = sbar.add("item", "front_app", {
--   display = "active",
--   icon = { drawing = false },
--   label = {
--     font = {
--       style = settings.font.style_map["Black"],
--       size = 12.0,
--     },
--   },
--   updates = true,
-- })
--
-- front_app:subscribe("front_app_switched", function(env)
--   front_app:set({ label = { string = env.INFO } })
-- end)
--
-- front_app:subscribe("mouse.clicked", function(env)
--   sbar.trigger("swap_menus_and_spaces")
-- end)

local sbar = require "sketchybar"
local colors = require "colors"
local settings = require "settings"

-- Events that get pushed by hammerspoon
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  display = "active",
  icon = {
    background = {
      drawing = true,
      image = {
        border_width = 1,
        border_color = colors.bg1,
      },
    },
  },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
})

local function set_window_title(env)
  local window_title = env["title"]
  if #window_title > 50 then window_title = window_title:sub(1, 50) .. "..." end
  front_app:set { label = { string = window_title } }
end

-- Animate app icon back to 1.0
local function end_bounce_animation()
  sbar.animate(
    "tanh",
    15,
    function()
      front_app:set {
        icon = {
          background = {
            image = { scale = 1.0 },
          },
        },
      }
    end
  )
end

-- Make app icon slightly bigger before returning back to regular size
local function start_bounce_animation()
  sbar.animate(
    "tanh",
    15,
    function()
      front_app:set {
        icon = {
          background = {
            image = { scale = 1.2 },
          },
        },
      }
    end
  )
  -- Short delay so that full animation can occur
  sbar.exec("sleep 0.25 && echo 'finishing bounce'", end_bounce_animation)
end

front_app:subscribe("front_app_switched", function(env)
  front_app:set {
    icon = { background = { image = "app." .. env.INFO } },
    label = { string = env.INFO },
  }
  start_bounce_animation()
end)

front_app:subscribe("window_focus", function(env)
  set_window_title(env)
  start_bounce_animation()
end)

front_app:subscribe("title_change", function(env) set_window_title(env) end)

front_app:subscribe("mouse.clicked", function(env) sbar.trigger "swap_menus_and_spaces" end)
