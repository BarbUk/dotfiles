local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local lain = require("lain")
local markup = lain.util.markup
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local wibox = require("wibox")
local helpers = require("config.helpers")
local cst = require("naughty.constants")

-- Defaults
naughty.config.defaults.shape = function(cr, w, h)
   gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
end

-- Apply theme variables
naughty.config.padding = dpi(6)
naughty.config.spacing = dpi(6)
naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.margin = dpi(20)

naughty.config.icon_formats = { "png", "svg", "jpg" }

-- Notification callback to style monitoring notification
naughty.config.notify_callback = function(args)
   if
      args.freedesktop_hints
      and args.freedesktop_hints["desktop-entry"]
      and args.icon == nil
      and args.freedesktop_hints["image_path"] == nil
      and args.freedesktop_hints["image-data"] == nil
   then
      local path = menubar.utils.lookup_icon(args.freedesktop_hints["desktop-entry"])
         or menubar.utils.lookup_icon(args.freedesktop_hints["desktop-entry"]:lower())
      if path then
         args.icon = path
      end
   end

   if args.title then
      args.title = args.title .. "\n"
   end

   if args.app_name and args.message then
      local message = gstring.xml_escape(args.message)
      message = message:gsub("PROBLEM", markup.bold(markup(beautiful.nord11, "PROBLEM")))
      message = message:gsub("RECOVERY", markup.bold(markup(beautiful.nord9, "RECOVERY")))
      message =
         message:gsub("([%a://]*[%w(%-)@]+%.[%w%-%.]+[:%d]*[/%w_%.(%%20)(%-)]*)", markup.bold(markup.underline("%1")))
      message =
         message:gsub("```(.+)```", "\n\n" .. markup.color(beautiful.background, beautiful.nord4, markup.bold("%1")))

      -- args.message = gstring.xml_unescape(message)
      -- args.message = markup.font("PragmataPro Liga " .. dpi(11.5), message)
      args.message = message
   end
   return args
end

-- Icon size
naughty.config.defaults["icon_size"] = beautiful.notification_icon_size

-- Timeouts
naughty.config.defaults.timeout = 35
naughty.config.defaults.hover_timeout = 2
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

-- Apply theme variables
naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width

naughty.config.presets.normal = {
   font = beautiful.notification_font,
   fg = beautiful.notification_fg,
   bg = beautiful.notification_bg,
   border_width = beautiful.notification_border_width,
   margin = beautiful.notification_margin,
   position = beautiful.notification_position,
}

naughty.config.presets.low = {
   font = beautiful.notification_font,
   fg = beautiful.notification_fg,
   bg = beautiful.notification_bg,
   border_width = beautiful.notification_border_width,
   margin = beautiful.notification_margin,
   position = beautiful.notification_position,
}

naughty.config.presets.critical = {
   font = beautiful.notification_font,
   fg = beautiful.notification_crit_fg,
   bg = beautiful.notification_crit_bg,
   border_width = beautiful.notification_border_width,
   margin = beautiful.notification_margin,
   position = beautiful.notification_position,
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.connect_signal("request::icon", function(n, context, hints)
   if context ~= "app_icon" then
      return
   end

   local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

   if path then
      n.icon = path
   end
end)

--- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
   a.icon = menubar.utils.lookup_icon(hints.id)
end)

naughty.connect_signal("destroyed", function(n, reason)
   -- If no client, we can guess the client to jump to
   if not n.clients or #n.clients == 0 then
      return
   end

   -- Capture client names early because 'n' will be invalid inside the signal handler
   local client_names = {}
   for _, c in ipairs(n.clients) do
      if c.name then
         table.insert(client_names, c.name)
      end
   end

   -- If we clicked on a notification, the reason is: dismissed_by_user
   if reason == cst.notification_closed_reason.dismissed_by_user then
      local on_urgent
      local timer

      on_urgent = function(c)
         for _, name in ipairs(client_names) do
            if c.name == name then
               c:jump_to()
               -- Clean up
               client.disconnect_signal("property::urgent", on_urgent)
               if timer and timer.started then
                  timer:stop()
               end
               return
            end
         end
      end

      -- If we clicked on a notification, we get a new urgent client to jump to
      client.connect_signal("property::urgent", on_urgent)

      -- Watchdog timer to prevent signal leaks if the expected client never becomes urgent
      timer = gears.timer.start_new(10, function()
         client.disconnect_signal("property::urgent", on_urgent)
         return false -- Stop the timer
      end)
   end
end)
