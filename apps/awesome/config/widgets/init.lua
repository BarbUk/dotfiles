local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local helpers = require("lain.helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")

local apps = require("config.apps")
local bat = require("config.widgets.battery")
local volume = require("config.widgets.volume")
local mpris_info = require("config.widgets.mpris")

-- {{{ Wibox
local markup = lain.util.markup
local white = beautiful.fg_normal
local gray = beautiful.fg_focus

-- Separators
local separator = {
   left = wibox.widget.textbox(markup(white, markup.bold("  "))),
   center = wibox.widget.textbox(markup(white, " ")),
   right = wibox.widget.textbox(markup(white, markup.bold("  "))),
}

-- flags and timezone
local flag = {}
local clock = {}
for k, v in pairs(beautiful.flag) do
   flag[k] = wibox.widget.imagebox(beautiful.flag[k], true)
   flag[k]:buttons(gears.table.join(awful.button({}, 1, function()
      awful.spawn(apps.cmd.timezone[k], false)
   end)))
   clock[k] = wibox.widget.textclock(markup(white, "%H:%M"), 30, apps.timezone[k])
end

-- Calendar
local calendar = lain.widget.cal({
   attach_to = { clock.france, clock.canada, clock.mauritius, clock.cambodia },
   three = true,
   icons = helpers.icons_dir .. "cal/" .. beautiful.iconcolor .. "/",
   followtag = true,
   notification_preset = {
      font = beautiful.notification_font,
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg,
   },
})

-- mpris
local mpris = mpris_info({
   cmd = "mprisctl",
   cover_size = 80,
   notification_preset = {
      font = "PragmataPro Mono Liga " .. dpi(12),
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg,
   },
   settings = function()
      if mpris_now.status ~= "no player detected" then
         state = "  "
         if mpris_now.status == "Playing" then
            state = markup(beautiful.nord7, "  ")
         elseif mpris_now.status == "Paused" then
            state = markup(beautiful.nord7, "  ")
         end
         widget:set_markup(
            state .. markup(white, mpris_now.artist) .. " - " .. markup(white, mpris_now.title) .. " "
         )
      else
         widget:set_markup("")
      end
   end,
})

mpris.widget:buttons(gears.table.join(
   awful.button({}, 1, function()
      awful.spawn.easy_async(apps.cmd.player.toggle, function()
         mpris.update()
      end)
   end),
   awful.button({}, 4, function()
      awful.spawn.easy_async(apps.cmd.player.next, function()
         mpris.update()
      end)
   end),
   awful.button({}, 5, function()
      awful.spawn.easy_async(apps.cmd.player.prev, function()
         mpris.update()
      end)
   end)
))

-- /home fs
local fsroot = lain.widget.fs({
   notification_preset = { fg = white, bg = beautiful.bg_normal },
   settings = function()
      hdd = ""
      p = ""

      if fs_now["/"].percentage >= 85 then
         hdd = markup(white, markup.bold("  ")) .. markup(beautiful.nord7, "  ")
         p = fs_now["/"].percentage .. "%"
      end

      widget:set_markup(hdd .. markup(white, p))
   end,
})

-- Weather
local weather = lain.widget.weather({
   lat = -20.4172,
   lon = 57.5413,
   APPID = "869faf1aac21d680efcfd1a6ce1ece93",
   cnt = 5,
   units = "metric",
   lang = "fr",
   settings = function()
      descr = weather_now["weather"][1]["description"]
      units = math.floor(weather_now["main"]["temp"])
      widget:set_markup(" " .. units .. "°C")
   end,
   notification_text_fun = function(wn)
      local day = os.date("%a %d", wn["dt"])
      local temp = math.floor(wn["main"]["temp"])
      local humi = math.floor(wn["main"]["humidity"])
      local wind = math.floor(wn["wind"]["speed"])
      local desc = wn["weather"][1]["description"]
      local icon = "w" .. wn["weather"][1]["icon"]
      return string.format("<b>%s  %s</b>:%d°C%d%%%d %s", apps.weather[icon], day, temp, humi, wind, desc)
   end,
})

-- Net
local net = lain.widget.net({
   settings = function()
      if iface ~= "network off" and string.match(weather.widget.text, "N/A") then
         weather.update()
      end

      widget:set_markup(
         markup(beautiful.nord14, markup.bold("↓ "))
            .. net_now.received
            .. " "
            .. markup(beautiful.nord11, markup.bold("↑ "))
            .. net_now.sent
      )
   end,
})

-- CPU
local cpuicon = wibox.widget.textbox(markup(beautiful.nord14, " "))
local cpu = lain.widget.sysload({
   settings = function()
      widget:set_markup(load_1 .. " " .. load_5)
   end,
})

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
      cpuicon,
      cpu.widget,
      fsroot.widget,
      separator.left,
      bat.icon,
      bat.widget,
      separator.left,
      volume.icon,
      volume.widget,
      separator.left,
      weather.icon,
      weather.widget,
      separator.left,
      flag.canada,
      separator.center,
      clock.canada,
      separator.left,
      flag.france,
      separator.center,
      clock.france,
      separator.left,
      flag.mauritius,
      separator.center,
      clock.mauritius,
      separator.center,
      flag.cambodia,
      separator.center,
      clock.cambodia,
      separator.center,
   }

   local general_info = {
      layout = wibox.layout.fixed.horizontal,
      mpris.widget,
      separator.center,
      weather.icon,
      weather.widget,
      separator.left,
      flag.canada,
      separator.center,
      clock.canada,
      separator.left,
      flag.france,
      separator.center,
      clock.france,
      separator.left,
      flag.mauritius,
      separator.center,
      clock.mauritius,
      separator.left,
      flag.cambodia,
      separator.center,
      clock.cambodia,
      separator.center,
   }

   if s.index == 1 then
      -- Add widgets to the wibox
      s.mywibox:setup({
         layout = wibox.layout.align.horizontal,
         left,
         s.mytasklist, -- Middle widget
         right,
      })
   else
      -- Add widgets to the wibox
      s.mywibox:setup({
         layout = wibox.layout.align.horizontal,
         left,
         s.mytasklist, -- Middle widget,
         general_info,
      })
   end
end)

return {
   mpris = mpris,
   volume = volume.helper,
   calendar = calendar,
   fsroot = fsroot,
}
