local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup
local helpers = require("lain.helpers")
local gears = require("gears")
local awful = require("awful")
local apps = require("config.apps")
local white = beautiful.fg_normal

local flag = {}
local clock = {}

for k, v in pairs(beautiful.flag) do
   flag[k] = wibox.widget.imagebox(beautiful.flag[k], true)
   flag[k]:buttons(gears.table.join(awful.button({}, 1, function()
      awful.spawn(apps.cmd.timezone[k], false)
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
   },
})

return {
   flag = flag,
   clock = clock,
   calendar = calendar,
}
