local beautiful = require('beautiful')
local lain = require('lain')
local wibox = require('wibox')
local markup = lain.util.markup

-- Battery
local icon = wibox.widget.textbox("")
local tp_smapi = lain.widget.contrib.tp_smapi('/sys/devices/platform/smapi')
local bat = tp_smapi.create_widget({
  battery = "BAT0",
  settings = function()
    if tpbat_now.n_status[1] == "discharging" then
      if tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 10 then
        icon:set_markup_silently(markup(beautiful.nord11, ""))
        noti:notify("Battery is low", naughty.config.presets.critical)
      elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 25 then
        icon:set_markup_silently(markup(beautiful.nord12, ""))
      elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 55 then
        icon:set_markup_silently(markup(beautiful.nord13, ""))
      elseif tpbat_now.n_perc[1] and tonumber(tpbat_now.n_perc[1]) <= 75 then
        icon:set_markup_silently(markup(beautiful.nord14, ""))
      else
        icon:set_markup_silently(markup(beautiful.nord15, ""))
      end
    else
      icon:set_markup_silently(markup(beautiful.nord15, ""))
    end
  widget:set_markup(" " .. tpbat_now.n_perc[1] .. "%")
  end
})

bat.widget:connect_signal('mouse::enter', function () tp_smapi.show('BAT0') end)
bat.widget:connect_signal('mouse::leave', function () tp_smapi.hide() end)

return {
  widget = bat.widget,
  icon = icon
}
