local awful = require("awful")
local state = require("config.state")

-- Enable sloppy focus, so that focus follows mouse.
local function sloppy_focus(c)
   -- Skip focusing the client if the mouse wasn't moved.
   local mcoords = mouse.coords()
   if state.sloppyfocus_last.focus then
      if
         c ~= state.sloppyfocus_last.c
         and (mcoords.x ~= state.sloppyfocus_last.x or mcoords.y ~= state.sloppyfocus_last.y)
      then
         c:activate({ context = "mouse_enter", raise = false })
         state.sloppyfocus_last = { c = c, x = mcoords.x, y = mcoords.y }
      end
   end
   state.sloppyfocus_last.focus = true
end

client.connect_signal("mouse::enter", sloppy_focus)

-- switch to parent after closing child window
local function backham()
   local s = awful.screen.focused()
   local c = awful.client.focus.history.get(s, 0)
   if c then
      client.focus = c
      c:raise()
   end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)
