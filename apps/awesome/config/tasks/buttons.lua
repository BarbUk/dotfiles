local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi

local instance = nil

return gears.table.join(
   awful.button({}, 1, function(c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal("request::activate", "tasklist", { raise = true })
      end
   end),
   awful.button({}, 3, function()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = dpi(1000), height = dpi(60) } })
      end
   end),
   awful.button({}, 4, function()
      awful.client.focus.byidx(1)
   end),
   awful.button({}, 5, function()
      awful.client.focus.byidx(-1)
   end)
)
