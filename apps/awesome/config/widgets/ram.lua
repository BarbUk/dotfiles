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

ram.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
   local cmd = [[bash -c "ps -Ao pmem,rss,comm --sort=-pmem --no-headers | ]]
      .. [[awk '{printf \"%s%% (%.1fMB) %s\\n\", $1, $2/1024, $3} NR==10 { zexit }'"]]
   awful.spawn.easy_async(cmd, function(stdout)
      naughty.destroy(ram_notification)
      ram_notification = naughty.notification({
         title = "Top RAM process",
         message = stdout,
         timeout = 10,
         hover_timeout = 0.5,
      })
   end)
end)))

return ram
