local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup

local temp = lain.widget.temp({
   settings = function()
      widget:set_markup(markup(beautiful.nord15, "") .. coretemp_now .. "°C")
   end,
})

return temp
