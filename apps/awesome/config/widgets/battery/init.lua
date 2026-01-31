local beautiful = require("beautiful")
local lain = require("lain")
local wibox = require("wibox")
local markup = lain.util.markup
local fs = require("gears.filesystem")
local awful = require("awful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local icon = wibox.widget.textbox("")
local bat

if fs.is_dir("/sys/devices/platform/smapi") then
   local tp_smapi = lain.widget.contrib.tp_smapi("/sys/devices/platform/smapi")
   bat = tp_smapi.create_widget({
      battery = "BAT0",
      settings = function()
         if tpbat_now.n_status[1] == "discharging" then
            if tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 10 then
               icon:set_markup_silently(markup(beautiful.nord11, ""))
               noti:notify("Battery is low", naughty.config.presets.critical)
            elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 25 then
               icon:set_markup_silently(markup(beautiful.nord12, ""))
            elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 55 then
               icon:set_markup_silently(markup(beautiful.nord13, ""))
            elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 75 then
               icon:set_markup_silently(markup(beautiful.nord14, ""))
            else
               icon:set_markup_silently(markup(beautiful.nord15, ""))
            end
         else
            icon:set_markup_silently(markup(beautiful.nord15, ""))
         end
         widget:set_markup(" " .. tpbat_now.n_perc[1] .. "%")
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
         if bat_now.status == "Discharging" then
            if bat_now.perc and tonumber(bat_now.perc) <= 10 then
               icon:set_markup_silently(markup(beautiful.nord11, ""))
               noti:notify("Battery is low", naughty.config.presets.critical)
            elseif bat_now.perc and tonumber(bat_now.perc) <= 25 then
               icon:set_markup_silently(markup(beautiful.nord12, ""))
            elseif bat_now.perc and tonumber(bat_now.perc) <= 55 then
               icon:set_markup_silently(markup(beautiful.nord13, ""))
            elseif bat_now.perc and tonumber(bat_now.perc) <= 75 then
               icon:set_markup_silently(markup(beautiful.nord14, ""))
            else
               icon:set_markup_silently(markup(beautiful.nord15, ""))
            end
         else
            icon:set_markup_silently(markup(beautiful.nord15, ""))
         end
         widget:set_markup(" " .. bat_now.perc .. "%")
      end,
   })
end

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

bat.widget:connect_signal("mouse::enter", function()
   show_battery_status()
end)
bat.widget:connect_signal("mouse::leave", function()
   naughty.destroy(notification)
end)

return {
   widget = bat.widget,
   icon = icon,
}
