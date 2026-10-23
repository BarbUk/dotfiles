local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup
local helpers = require("lain.helpers")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local noti = require("config.notifications")
local apps = require("config.apps")
local white = beautiful.fg_normal

local flag = {}
local clock = {}

for k, _ in pairs(beautiful.flag) do
   flag[k] = wibox.widget.imagebox(beautiful.flag[k], true)
   flag[k]:buttons(gears.table.join(awful.button({}, 1, function()
      awful.spawn(apps.cmd.timezone[k], false)
      awful.spawn.easy_async(apps.cmd.timezone[k], function(_, stderr, _, exit_code)
         if exit_code == 0 then
            noti:notify("Timezone changed to: " .. k)
         else
            -- Failure Notification
            naughty.notify({
               title = "Timezone change Failed",
               text = "Exit Code: " .. tostring(exit_code) .. "\nError: " .. stderr,
               urgency = "critical",
               preset = naughty.config.presets.critical,
            })
         end
      end)
   end)))
   clock[k] = wibox.widget.textclock(markup(white, "%H:%M"), 30, apps.timezone[k])
end

local calendar = lain.widget.cal({
   attach_to = { clock.france, clock.canada, clock.mauritius, clock.cambodia },
   three = true,
   week_number = "left",
   icons = helpers.icons_dir .. "cal/" .. beautiful.iconcolor .. "/",
   followtag = true,
   notification_preset = {
      font = beautiful.notification_font,
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg,
      ignore_suspend = true,
   },
})

return {
   flag = flag,
   clock = clock,
   calendar = calendar,
}
