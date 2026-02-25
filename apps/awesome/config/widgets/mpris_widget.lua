local mpris_info = require("config.widgets.mpris")
local lain = require("lain")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local apps = require("config.apps")
local markup = lain.util.markup
local white = beautiful.fg_normal

local mpris = mpris_info({
   cmd = "mprisctl",
   cover_size = dpi(150),
   notification_preset = {
      font = "PragmataPro Mono Liga " .. dpi(12),
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg,
   },
   settings = function()
      if mpris_now.status ~= "no player detected" then
         local state = "  "
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

return mpris
