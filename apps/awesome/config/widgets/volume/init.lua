local beautiful = require("beautiful")
local awful = require("awful")
local lain = require("lain")
local helpers = require("lain.helpers")
local wibox = require("wibox")
local gears = require("gears")
local apps = require("config.apps")
local markup = lain.util.markup

local volumeicon = markup(beautiful.nord9, " ")
local volicon = wibox.widget.textbox(volumeicon)
local internal_soundcard = "alsa_output.pci"
local volume = lain.widget.pulse({
   cmd = [[
      current_sink=$(pactl info | sed -En 's/Default Sink: (.*)/\1/p');
      pactl list sinks | sed -n -e '/'"$current_sink"'/,$!d' \
      -e '/Base Volume/d' \
      -e 's/Volume:/volume:/' \
      -e '/volume:/p' \
      -e 's/device.description/device.string/' \
      -e '/device.string/p' \
      -e 's/object.id/index/' \
      -e '/index/p' \
      -e 's/Mute:/muted:/' \
      -e '/muted:/p'
   ]],
   settings = function()
      helpers.async_with_shell("pactl list short sinks | awk '/RUNNING/ {print $2}'", function(soundcard)
         if soundcard:sub(1, #internal_soundcard) == internal_soundcard then
            volumeicon = markup(beautiful.nord9, " ")
         else
            volumeicon = markup(beautiful.nord9, " ")
         end
      end)
      if volume_now.muted == "yes" then
         widget:set_text("Mute")
         volicon:set_markup_silently(markup(beautiful.nord9, " "))
      else
         volicon:set_markup_silently(volumeicon)
         widget:set_markup(volume_now.right)
      end
   end,
})

volume.widget:buttons(gears.table.join(
   awful.button({}, 1, function()
      apps.osd.volume.mute()
      volume.update()
   end),
   awful.button({}, 2, function()
      awful.spawn.easy_async(apps.cmd.volume.toggle, function()
         volume.update()
      end)
   end),
   awful.button({}, 3, function()
      awful.spawn("pavucontrol", false)
   end),
   awful.button({}, 4, function()
      apps.osd.volume.up()
      volume.update()
   end),
   awful.button({}, 5, function()
      apps.osd.volume.down()
      volume.update()
   end)
))

return {
   widget = volume.widget,
   icon = volicon,
   helper = volume,
}
