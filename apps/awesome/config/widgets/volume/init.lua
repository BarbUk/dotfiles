local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local apps = require("config.apps")
local markup = require("lain.util.markup")

local CMD_PULSE = [[
   pactl get-sink-mute @DEFAULT_SINK@;
   pactl get-sink-volume @DEFAULT_SINK@;
   echo "device: $(pactl get-default-sink)";
   echo "preset:$(env -u SESSION_MANAGER easyeffects --last-loaded-presets 2>/dev/null | awk -F: '/^output/ {print $2; exit}')"
]]
local TIMEOUT_SECONDS = 30
local ICON_HEADPHONES = "🎧 "
local ICON_SPEAKER = " "
local ICON_MUTED = " "
local internal_soundcard = "alsa_output.pci"

local volume = {
   widget = wibox.widget.textbox(),
}

-- Query default PulseAudio sink state and update widget text.
function volume.update()
   awful.spawn.easy_async_with_shell(CMD_PULSE, function(stdout)
      local muted = stdout:match("Mute:%s+(%S+)")
      if muted == "yes" then
         volume.widget:set_markup(markup(beautiful.nord9, ICON_MUTED) .. "Mute")
         return
      end

      local level = stdout:match("(%d+)%%") or "N/A"
      local device = stdout:match("device: (%S+)") or "N/A"
      local preset = stdout:match("preset: (%S+)") or "N/A"

      -- Select speaker icon for built-in PCI audio, headphones icon otherwise
      local icon = ICON_HEADPHONES
      if device:sub(1, #internal_soundcard) == internal_soundcard then
         icon = ICON_SPEAKER
      end

      volume.widget:set_markup(markup(beautiful.nord9, icon) .. level .. "% - " .. preset)
   end)
end

gears.timer({
   timeout = TIMEOUT_SECONDS,
   call_now = true,
   autostart = true,
   callback = volume.update,
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
