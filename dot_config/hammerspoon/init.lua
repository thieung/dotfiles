--------------------------------- RELOAD CONFIG --------------------------------
Hyper = { "cmd", "alt", "ctrl" }

local notify = function()
	hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()
end

-- Use 0 to reload the configuration
hs.hotkey.bind(Hyper, "0", function()
	notify()
	hs.reload()
end)

local function reload_config(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		notify()
		hs.reload()
	end
end

-- reload the config every time it changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reload_config):start()

------------------------------------ SKETCHYBAR --------------------------------
-- load sketchybar_lua
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
local sbar = require("sketchybar")

-- Create a window filter to monitor windows only on the external monitor
local wf = hs.window.filter.new(function(win)
	return win:isVisible() and not win:isFullScreen()
end)
wf:subscribe(hs.window.filter.windowTitleChanged, function(win)
	if win then
		sbar.trigger("title_change", {
			title = win:title(),
		})
	end
end)
wf:subscribe(hs.window.filter.windowFocused, function(win)
	if win then
		sbar.trigger("window_focus", {
			title = win:title(),
		})
	end
end)

------------------------------------ MODULES -----------------------------------
require("keymaps")
require("zoom-killer")
require("apple-music-spotify-redirect")
