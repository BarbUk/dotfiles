local beautiful = require('beautiful')
local lain      = require('lain')
local helpers   = require("lain.helpers")
local wibox     = require('wibox')
local markup    = lain.util.markup

local volumeicon = markup(beautiful.nord9, " ")
local volicon = wibox.widget.textbox(volumeicon)
local internal_soundcard = 'alsa_output.pci'
local volume = lain.widget.pulse({
  settings = function()
    helpers.async_with_shell("pacmd stat | awk -F': ' '/^Default sink name: /{print $2}'",
    function(soundcard)
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
  end
})

volume.widget:connect_signal("button::press", function(_, _, _, button)
    if (button == 4) then
      awful.util.spawn_with_shell(volume_up_cmd, false)
    elseif (button == 5) then
      awful.util.spawn_with_shell(volume_down_cmd, false)
    elseif (button == 1) then
      awful.util.spawn_with_shell(volume_mute_cmd, false)
    elseif (button == 3) then
      awful.util.spawn('pavucontrol', false)
    end

    volume.update()
  end
)

return {
  widget = volume.widget,
  icon = volicon,
  helper = volume,
}
