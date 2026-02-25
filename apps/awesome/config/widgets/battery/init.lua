local beautiful = require("beautiful")
local lain = require("lain")
local wibox = require("wibox")
local markup = lain.util.markup
local fs = require("gears.filesystem")
local awful = require("awful")
local naughty = require("naughty")
local noti = require("config.notifications")
local dpi = beautiful.xresources.apply_dpi

local bat
local icon

local notification
local function show_battery_status()
   awful.spawn.easy_async([[bash -c 'acpi']], function(stdout, _, _, _)
      naughty.destroy(notification)

      notification = naughty.notification({
         preset = naughty.config.presets.low,
         title = "Battery information",
         message = tostring(stdout),
      })
   end)
end

local function set_bat_value(status, percentage)
   local content

   if status:lower() == "discharging" then
      if percentage and tonumber(percentage) <= 10 then
         icon = markup(beautiful.nord11, "")
         noti:notify("Battery is low", naughty.config.presets.critical)
      elseif percentage and tonumber(percentage) <= 15 then
         icon = markup(beautiful.nord12, "")
      elseif percentage and tonumber(percentage) <= 25 then
         icon = markup(beautiful.nord13, "")
      elseif percentage and tonumber(percentage) <= 55 then
         icon = markup(beautiful.nord14, "")
      elseif percentage and tonumber(percentage) <= 75 then
         icon = markup(beautiful.nord14, "")
      else
         icon = markup(beautiful.nord15, "")
      end
   else
      icon = markup(beautiful.nord15, "")
   end

   content = icon .. " " .. percentage .. "%"
   return content
end

if fs.is_dir("/sys/devices/platform/smapi") then
   local tp_smapi = lain.widget.contrib.tp_smapi("/sys/devices/platform/smapi")
   bat = tp_smapi.create_widget({
      battery = "BAT0",
      settings = function()
         local content = set_bat_value(tpbat_now.n_status[1], tpbat_now.n_perc[1])
         widget:set_markup(content)
      end,
   })

   bat.widget:connect_signal("mouse::enter", function()
      tp_smapi.show("BAT0")
   end)
   bat.widget:connect_signal("mouse::leave", function()
      tp_smapi.hide()
   end)
else
   bat = lain.widget.bat({
      settings = function()
         local content = set_bat_value(bat_now.status, bat_now.perc)
         widget:set_markup(content)
      end,
   })
   bat.widget:connect_signal("mouse::enter", function()
      show_battery_status()
   end)
   bat.widget:connect_signal("mouse::leave", function()
      naughty.destroy(notification)
   end)
end

return {
   widget = bat.widget,
}
