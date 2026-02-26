local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup
local weather = require("config.widgets.weather")

local net = lain.widget.net({
   settings = function()
      if iface ~= "network off" and string.match(weather.widget.text, "N/A") then
         weather.update()
      end

      local received = tonumber(net_now.received)
      local sent = tonumber(net_now.sent)
      local unit_received = "k/s"
      local unit_sent = "k/s"

      if received > 1024 then
         received = string.format("%.1f", received / 1024)
         unit_received = "M/s"
      end

      if sent > 1024 then
         sent = string.format("%.1f", sent / 1024)
         unit_sent = "M/s"
      end

      widget:set_markup(
         markup(beautiful.nord10, markup.bold(" "))
            .. received
            .. unit_received
            .. " "
            .. markup(beautiful.nord11, markup.bold(" "))
            .. sent
            .. unit_sent
      )
   end,
})

return net
