local lain = require("lain")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local markup = lain.util.markup

local cpu = lain.widget.sysload({
   settings = function()
      widget:set_markup(markup(beautiful.nord9, " ") .. load_1 .. " " .. load_5)
   end,
})

local cpu_notification
cpu.widget:connect_signal("mouse::enter", function()
   local cmd = [[bash -c "ps -Ao pcpu,comm --sort=-pcpu --no-headers | head -n 5 | awk '{print $1\"% \" $2}'"]]
   awful.spawn.easy_async(cmd, function(stdout)
      cpu_notification = naughty.notification({
         title = "Top CPU process",
         message = stdout,
         timeout = 0,
         hover_timeout = 0.5,
      })
   end)
end)

cpu.widget:connect_signal("mouse::leave", function()
   if cpu_notification then
      naughty.destroy(cpu_notification)
      cpu_notification = nil
   end
end)

return cpu
