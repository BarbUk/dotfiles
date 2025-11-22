--[[

     Licensed under GNU General Public License v2
      * (c) 2017, Julien Virey

--]]

local helpers = require("lain.helpers")
local wibox = require("wibox")
local shell = require("awful.util").shell
local gstring = require("gears.string")
local naughty = require("naughty")
local setmetatable = setmetatable

local mpris = {}

local function worker(args)
   args = args or {}
   local timeout = args.timeout or 5
   local cover_size = args.cover_size or 100
   local default_art = args.default_art
   local notify = args.notify or "on"
   local followtag = args.followtag or false
   local settings = args.settings or function() end

   mpris.notification_preset = args.notification_preset
      or {
         font = "Monospace 10",
         fg = "#FFFFFF",
         bg = "#000000",
         title = "Now playing",
      }
   mpris.cmd = args.cmd
      or "playerctl --format '{{status}}\n{{xesam:artist}}\n{{markup_escape(xesam:title)}};{{mpris:artUrl}}' metadata"
   mpris.widget = wibox.widget.textbox()

   function mpris.update()
      mpris_now = {}
      local now = {}
      helpers.async({ shell, "-c", mpris.cmd }, function(output)
         for s in output:gmatch("[^\n]+") do
            table.insert(now, s)
         end
         mpris_now = {
            status = now[1],
            artist = gstring.xml_escape(now[2]),
            album = gstring.xml_escape(now[3]),
            title = gstring.xml_escape(now[4]),
            art = now[5],
         }
         widget = mpris.widget
         mpris.mpris_now = mpris_now
         settings()

         if mpris_now.status == "Playing" then
            if notify == "on" and mpris_now.title ~= helpers.get_map("current mpris track") then
               helpers.set_map("current mpris track", mpris_now.title)
               mpris.show(5)
            end
         elseif mpris_now.status ~= "Paused" then
            helpers.set_map("current mpris track", nil)
         end
      end)
   end

   function mpris.hide()
      if not mpris.notification then
         return
      end
      naughty.destroy(mpris.notification)
      mpris.notification = nil
   end

   function mpris.show(seconds)
      local text = string.format(
         "♫♪ %s ♪♬ • %s\n%s",
         mpris.mpris_now.title,
         mpris.mpris_now.artist,
         mpris.mpris_now.album
      )
      if mpris.notification then
         local title = mpris.notification_preset.title or nil
         naughty.replace_text(mpris.notification, title, text)
         return
      end

      if mpris.mpris_now.art and not string.match(mpris.mpris_now.art, "http.*://") then -- local art instead of http stream
         mpris.icon = mpris.mpris_now.art
      end

      mpris.notification = naughty.notify({
         preset = mpris.notification_preset,
         screen = mpris.followtag and awful.screen.focused() or scr or 1,
         icon = mpris.icon,
         icon_size = cover_size,
         timeout = type(seconds) == "number" and seconds or mpris.notification_preset.timeout or 5,
         text = text,
         replaces_id = mpris.id,
      })

      mpris.id = mpris.notification.id
   end

   function mpris.hover_on()
      mpris.show(0)
   end

   function mpris.attach(widget)
      widget:connect_signal("mouse::enter", mpris.hover_on)
      widget:connect_signal("mouse::leave", mpris.hide)
   end

   helpers.newtimer("mpris", timeout, mpris.update)
   mpris.attach(mpris.widget)
   return mpris
end

return setmetatable(mpris, {
   __call = function(_, ...)
      return worker(...)
   end,
})
