local gears = require("gears")
local wibox = require("wibox")

local awful = require("awful")

local helpers = {}

helpers.spawn_and_move = function(command, class, tag)
   local callback
   local screen_number = screen.count()
   callback = function(c)
      if c.class == class then
         awful.client.movetotag(screen[screen_number].tags[tag], c)
         client.disconnect_signal("manage", callback)
      end
   end
   client.connect_signal("manage", callback)
   awful.spawn(command)
end

helpers.file_exists = function(name)
   return gears.filesystem.file_readable(name)
end

helpers.app_exists = function(cmd)
   local success = os.execute(string.format("command -v %s >/dev/null 2>&1", cmd))
   return success == true or success == 0
end

-- Create rounded rectangle shape
helpers.rrect = function(radius)
   return function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, radius)
   end
end

function helpers.colorize_text(txt, fg)
   return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function helpers.vertical_pad(height)
   return wibox.widget({
      forced_height = height,
      layout = wibox.layout.fixed.vertical,
   })
end

return helpers
