local gears         = require("gears")

local helpers = {}

helpers.file_exists = function (name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

 -- Create rounded rectangle shape
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function helpers.colorize_text(txt, fg)
    return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

return helpers
