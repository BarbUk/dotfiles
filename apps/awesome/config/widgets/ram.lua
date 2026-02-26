local lain = require("lain")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local markup = lain.util.markup

local ram = lain.widget.mem({
   settings = function()
      widget:set_markup(
         markup(beautiful.nord8, "󰍛") .. mem_now.perc .. "% " .. string.format("%.2f", mem_now.used / 1024) .. "G"
      )
   end,
})

local ram_notification
ram.widget:connect_signal("mouse::enter", function()
   local cmd = [[bash -c "ps -Ao pmem,rss,comm --sort=-pmem --no-headers | ]]
      .. [[head -n 5 | awk '{printf \"%s%% (%.1fMB) %s\\n\", $1, $2/1024, $3}'"]]
   awful.spawn.easy_async(cmd, function(stdout)
      ram_notification = naughty.notification({
         title = "Top RAM process",
         message = stdout,
         timeout = 0,
         hover_timeout = 0.5,
      })
   end)
end)

ram.widget:connect_signal("mouse::leave", function()
   if ram_notification then
      naughty.destroy(ram_notification)
      ram_notification = nil
   end
end)

return ram
