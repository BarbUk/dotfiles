local awful = require("awful")
local buttons = require("config.tasks.buttons")

awful.screen.connect_for_each_screen(function(s)
   -- Create a tasklist widget
   s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, buttons)
end)
