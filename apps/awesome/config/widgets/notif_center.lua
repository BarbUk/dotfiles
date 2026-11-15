local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local markup = require("lain.util.markup")
local noti = require("config.notifications")
local center = require("config.notifications.center")

local ICON_BELL = ""
local ICON_DND = ""
local BUTTON_LEFT = 1
local BUTTON_RIGHT = 3

local notif_center = {
   widget = wibox.widget.textbox(),
   toggle = center.toggle,
   show = center.show,
   hide = center.hide,
}

function notif_center.update()
   local count = #noti.unread
   local icon = noti.suspended and ICON_DND or ICON_BELL
   local icon_color = noti.suspended and (beautiful.nord11 or "#BF616A")
      or (count > 0 and (beautiful.nord13 or "#EBCB8B") or (beautiful.nord9 or "#81A1C1"))

   if count > 0 then
      notif_center.widget:set_markup(
         markup(icon_color, icon) .. " " .. markup(beautiful.fg_normal or "#D8DEE9", tostring(count))
      )
      return
   end

   notif_center.widget:set_markup(markup(icon_color, icon))
end

notif_center.widget:buttons(gears.table.join(
   awful.button({}, BUTTON_LEFT, function()
      center.toggle()
   end),
   awful.button({}, BUTTON_RIGHT, function()
      noti:toggle()
   end)
))

noti:subscribe(function()
   notif_center.update()
end)

notif_center.update()

return notif_center
