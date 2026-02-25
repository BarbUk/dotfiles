local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup
local weather = require("config.widgets.weather")

local net = lain.widget.net({
   settings = function()
      if iface ~= "network off" and string.match(weather.widget.text, "N/A") then
         weather.update()
      end

      widget:set_markup(
         markup(beautiful.nord10, markup.bold(" "))
            .. net_now.received
            .. " "
            .. markup(beautiful.nord11, markup.bold(" "))
            .. net_now.sent
      )
   end,
})

return net
