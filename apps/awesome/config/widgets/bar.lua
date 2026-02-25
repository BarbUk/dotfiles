local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup

-- Widgets
local mpris = require("config.widgets.mpris_widget")
local bat = require("config.widgets.battery")
local volume = require("config.widgets.volume")
local weather = require("config.widgets.weather")
local net = require("config.widgets.net")
local cpu = require("config.widgets.cpu")
local ram = require("config.widgets.ram")
local temp = require("config.widgets.temp")
local fsroot = require("config.widgets.fsroot")
local clk = require("config.widgets.clock")

local white = beautiful.fg_normal

-- Separators
local separator = {
   left = wibox.widget.textbox(markup(white, markup.bold("  "))),
   center = wibox.widget.textbox(markup(white, " ")),
   right = wibox.widget.textbox(markup(white, markup.bold("  "))),
}

-- Setup Wibar for each screen
awful.screen.connect_for_each_screen(function(s)
   -- Create the wibox
   s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height })
   s.mypromptbox = awful.widget.prompt()

   local left = { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      separator.right,
      s.mytxtlayoutbox,
      separator.right,
      s.mypromptbox,
   }

   local right = { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mpris.widget,
      separator.center,
      wibox.widget.systray(),
      separator.left,
      net.widget,
      separator.left,
      cpu.widget,
      separator.left,
      ram.widget,
      fsroot.widget,
      separator.left,
      temp.widget,
      separator.left,
      bat.widget,
      separator.left,
      volume.widget,
      separator.left,
      weather.icon,
      weather.widget,
      separator.left,
      clk.flag.canada,
      separator.center,
      clk.clock.canada,
      separator.left,
      clk.flag.france,
      separator.center,
      clk.clock.france,
      separator.left,
      clk.flag.mauritius,
      separator.center,
      clk.clock.mauritius,
      separator.center,
   }

   local general_info = {
      layout = wibox.layout.fixed.horizontal,
      mpris.widget,
      separator.center,
      weather.icon,
      weather.widget,
      separator.left,
      clk.flag.canada,
      separator.center,
      clk.clock.canada,
      separator.left,
      clk.flag.france,
      separator.center,
      clk.clock.france,
      separator.left,
      clk.flag.mauritius,
      separator.center,
      clk.clock.mauritius,
      separator.center,
   }

   if s.index == 1 then
      s.mywibox:setup({
         layout = wibox.layout.align.horizontal,
         left,
         s.mytasklist,
         right,
      })
   else
      s.mywibox:setup({
         layout = wibox.layout.align.horizontal,
         left,
         s.mytasklist,
         general_info,
      })
   end
end)
