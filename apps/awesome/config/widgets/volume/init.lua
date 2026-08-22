local beautiful = require("beautiful")
local awful = require("awful")
local lain = require("lain")
local helpers = require("lain.helpers")
local gears = require("gears")
local apps = require("config.apps")
local markup = lain.util.markup

local volumeicon = markup(beautiful.nord9, " ")
local internal_soundcard = "alsa_output.pci"
local easyeffect_output_preset
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
   timeout = 30,
   settings = function()
      helpers.async_with_shell(
         "pactl list short sinks | awk '$NF ~ /RUNNING/ && $2 !~ /easyeffects_sink/ {print $2}'",
         function(soundcard)
            if soundcard:sub(1, #internal_soundcard) == internal_soundcard then
               volumeicon = markup(beautiful.nord9, " ")
            else
               volumeicon = markup(beautiful.nord9, "🎧 ")
            end
         end
      )
      helpers.async_with_shell(
         "env -u SESSION_MANAGER easyeffects --last-loaded-presets | awk -F: '/^output/ {print $2}'",
         function(out)
            easyeffect_output_preset = out
         end
      )
      if volume_now.muted == "yes" then
         widget:set_markup(markup(beautiful.nord9, " ") .. "Mute -" .. easyeffect_output_preset)
      else
         widget:set_markup(volumeicon .. volume_now.right .. "% -" .. easyeffect_output_preset)
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
   helper = volume,
}
