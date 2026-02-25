local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup
local white = beautiful.fg_normal

local fsroot = lain.widget.fs({
   notification_preset = { fg = white, bg = beautiful.bg_normal },
   settings = function()
      local hdd = ""
      local p = ""

      if fs_now["/"].percentage >= 85 then
         hdd = markup(white, markup.bold("  ")) .. markup(beautiful.nord7, "  ")
         p = fs_now["/"].percentage .. "%"
      end

      widget:set_markup(hdd .. markup(white, p))
   end,
})

return fsroot
