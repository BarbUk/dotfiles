local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup

local cpu = lain.widget.sysload({
   settings = function()
      widget:set_markup(markup(beautiful.nord9, " ") .. load_1 .. " " .. load_5)
   end,
})

return cpu
