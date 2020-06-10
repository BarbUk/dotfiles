local awful     = require("awful")
local wibox     = require("wibox")
local lain      = require("lain")
local helpers   = require("lain.helpers")
local beautiful = require("beautiful")

local apps       = require('config.apps')
local bat        = require('config.widgets.battery')
local volume     = require('config.widgets.volume')
local mpris_info = require('config.widgets.mpris')

-- {{{ Wibox
local markup = lain.util.markup
local white  = beautiful.fg_normal
local gray   = beautiful.fg_focus

-- Separators
local separator = {
  left = wibox.widget.textbox(markup(white, markup.bold('  '))),
  center = wibox.widget.textbox(markup(white, ' ')),
  right = wibox.widget.textbox(markup(white, markup.bold('  '))),
}

-- flags
local fr_flag     = wibox.widget.imagebox(beautiful.fr_flag, true)
local local_flag  = wibox.widget.imagebox(beautiful.local_flag, true)

fr_flag:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then
      awful.util.spawn_with_shell(apps.cmd.timezone.france, false)
    end
  end
)

local_flag:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then
      awful.util.spawn_with_shell(apps.cmd.timezone.mauritius, false)
    end
  end
)

-- Text
local clockfr = wibox.widget.textclock(markup(white, "%H:%M"), 30, "Europe/Paris")
local clock = wibox.widget.textclock(markup(white, "%H:%M "), 30, "Indian/Mauritius")

-- Calendar
local calendar = lain.widget.cal({
  attach_to = { clock, clockfr },
  three     = true,
  icons     = helpers.icons_dir .. "cal/" .. beautiful.iconcolor .. "/",
  followtag = true,
  notification_preset = {
    font = beautiful.notification_font,
    fg   = beautiful.notification_fg,
    bg   = beautiful.notification_bg
}})

-- MPD
local mpd = lain.widget.mpd({
  settings = function()
    if mpd_now.state ~= "N/A" then
      state = "  "
      if mpd_now.state == "play" then
        state = markup(beautiful.nord7, "  ")
      else
        state = markup(beautiful.nord7, "  ")
      end
        widget:set_markup(state .. markup(white, mpd_now.artist) .. " - " .. markup(white, mpd_now.title) .. " ")
    else
        widget:set_markup("")
    end
  end
})

mpd.widget:connect_signal("button::press", function(_, _, _, button)
    if (button == 4) then
      awful.util.spawn_with_shell(apps.cmd.mpd.next, false)
    elseif (button == 5) then
      awful.util.spawn_with_shell(apps.cmd.mpd.prev, false)
    elseif (button == 1) then
      awful.util.spawn_with_shell(apps.cmd.mpd.toggle, false)
    end
    mpd.update()
  end
)

-- mpris
local mpris = mpris_info({
  cmd = apps.dir.scripts .. "mprisctl",
  settings = function()
    if mpris_now[1] ~= "no player detected" then
      state = "  "
      if mpris_now[1] == "Playing" then
        state = markup(beautiful.nord7, "  ")
      elseif mpris_now[1] == "Paused" then
        state = markup(beautiful.nord7, "  ")
      end
      widget:set_markup(state .. markup(white, mpris_now[2]) .. " - " .. markup(white, mpris_now[3]) .. " ")
    else
      widget:set_markup("")
    end
  end
})

mpris.widget:connect_signal("button::press", function(_, _, _, button)
    if (button == 4) then
      awful.util.spawn_with_shell(apps.cmd.player.next, false)
    elseif (button == 5) then
      awful.util.spawn_with_shell(apps.cmd.player.prev, false)
    elseif (button == 1) then
      awful.util.spawn_with_shell(apps.cmd.player.toggle, false)
    end
    mpris.update()
  end
)

-- /home fs
local fsroot = lain.widget.fs({
  notification_preset = { fg = white, bg = beautiful.bg_normal },
  settings  = function()
    hdd = ""
    p   = ""

    if fs_now["/"].percentage >= 85 then
      hdd = markup(white, markup.bold('  ')) .. markup(beautiful.nord7,"  ")
      p   = fs_now["/"].percentage .. "%"
    end

    widget:set_markup(hdd .. markup(white, p))
  end
})

-- Weather
local weather = lain.widget.weather({
  city_id = 934131,
  current_call  = "curl --connect-timeout 3 --max-time 5 -s 'http://api.openweathermap.org/data/2.5/weather?id=%s&units=%s&lang=%s&APPID=%s'",
  forecast_call = "curl --connect-timeout 3 --max-time 5 -s 'http://api.openweathermap.org/data/2.5/forecast/daily?id=%s&units=%s&lang=%s&cnt=%s&APPID=%s'",
  settings = function()
    descr = weather_now["weather"][1]["description"]
    units = math.floor(weather_now["main"]["temp"])
    widget:set_markup(" " .. units .. "°C")
  end
})

-- Net
local net = lain.widget.net({
  settings = function()
  if iface ~= "network off" and
    string.match(weather.widget.text, "N/A")
  then
    weather.update()
  end

  widget:set_markup(markup(beautiful.nord14, markup.bold("↓ ")) .. net_now.received .. " " .. markup(beautiful.nord11, markup.bold("↑ ")) .. net_now.sent)
  end
})

-- CPU
local cpuicon = wibox.widget.textbox(markup(beautiful.nord14, " "))
local cpu = lain.widget.sysload({
  settings = function()
    widget:set_markup(load_1 .. " " .. load_5)
  end
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
    mpd.widget,
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
    fr_flag,clockfr,
    separator.left,
    local_flag,clock
  }

  local time = {
    layout = wibox.layout.fixed.horizontal,
    weather.icon,
    weather.widget,
    separator.left,
    fr_flag,clockfr,
    separator.left,
    local_flag,clock
  }

  if s.index == 1 then
    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      left,
      s.mytasklist, -- Middle widget
      right
  }
  elseif s.index == 2 then
    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      left,
      s.mytasklist, -- Middle widget,
      time
    }
  end
end)

return {
  mpd      = mpd,
  mpris    = mpris,
  volume   = volume.helper,
  calendar = calendar,
  fsroot   = fsroot,
}
