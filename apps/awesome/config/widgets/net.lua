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

      if received > 1024 then
         received = string.format("%.2f", received / 1024) .. "M/s"
      end

      if sent > 1024 then
         sent = string.format("%.2f", sent / 1024) .. "M/s"
      end

      widget:set_markup(
         markup(beautiful.nord10, markup.bold(" "))
            .. received
            .. " "
            .. markup(beautiful.nord11, markup.bold(" "))
            .. sent
      )
   end,
})

return net
