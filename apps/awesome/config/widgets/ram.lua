local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup

local ram = lain.widget.mem({
   settings = function()
      widget:set_markup(markup(beautiful.nord8, "󰍛") .. mem_now.perc .. "%")
   end,
})

return ram
