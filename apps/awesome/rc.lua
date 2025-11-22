-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Required libraries
local gears = require("gears")
local beautiful = require("beautiful")

-- beautiful init
local chosen_theme = "barbuk"
local theme_path = string.format("%s/themes/%s/base.lua", gears.filesystem.get_configuration_dir(), chosen_theme)
beautiful.init(theme_path)

sloppyfocus_last = { c = nil, x = nil, y = nil, focus = true }

require("config.notifications")
require("config.client")
require("config.tags")
require("config.tasks")
require("config.utils")
require("config.keys")

-- Enable sloppy focus, so that focus follows mouse.
function sloppy_focus(c)
   -- Skip focusing the client if the mouse wasn't moved.
   local mcoords = mouse.coords()
   if sloppyfocus_last.focus then
      if c ~= sloppyfocus_last.c and (mcoords.x ~= sloppyfocus_last.x or mcoords.y ~= sloppyfocus_last.y) then
         c:activate({ context = "mouse_enter", raise = false })
         sloppyfocus_last = { c = c, x = mcoords.x, mcoords.y }
      end
   end
   sloppyfocus_last.focus = true
end
client.connect_signal("mouse::enter", sloppy_focus)
