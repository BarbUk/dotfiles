local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local lain = require("lain")
local markup = lain.util.markup
local gstring = require("gears.string")
local cst = require("naughty.constants")

local URGENCY_CRITICAL = "critical"
local URGENT_WATCHDOG_SECONDS = 10
local SUPPRESSED_TIMEOUT_SECONDS = 0.0001

-- Resolve application icon path from freedesktop hints or app_name
local function resolve_icon_path(args)
   if args.icon ~= nil then
      return args.icon
   end

   local hints = args.freedesktop_hints
   if hints and hints["desktop-entry"] and hints["image-path"] == nil and hints["image-data"] == nil then
      local entry = hints["desktop-entry"]
      return menubar.utils.lookup_icon(entry) or menubar.utils.lookup_icon(entry:lower())
   end

   if hints and hints["image-path"] then
      local img_path = hints["image-path"]
      return menubar.utils.lookup_icon(img_path) or menubar.utils.lookup_icon(img_path:lower())
   end

   if args.app_name then
      return menubar.utils.lookup_icon(args.app_name) or menubar.utils.lookup_icon(args.app_name:lower())
   end

   return nil
end

-- Apply Pango markup highlights to notification message body
local function format_message(message)
   local escaped = gstring.xml_escape(message)
   escaped = escaped:gsub("PROBLEM", markup.bold(markup(beautiful.nord11, "PROBLEM")))
   escaped = escaped:gsub("RECOVERY", markup.bold(markup(beautiful.nord9, "RECOVERY")))
   escaped =
      escaped:gsub("([%a://]*[%w(%-)@]+%.[%w%-%.]+[:%d]*[/%w_%.(%%20)(%-)]*)", markup.bold(markup.underline("%1")))
   escaped =
      escaped:gsub("```(.+)```", "\n\n" .. markup.color(beautiful.background, beautiful.nord4, markup.bold("%1")))
   return escaped
end

-- Defaults
naughty.config.defaults.shape = function(cr, w, h)
   gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
end

naughty.config.notify_callback = function(args)
   local noti = require("config.notifications")
   local path = resolve_icon_path(args)
   if path then
      args.icon = path
   end

   local clean_title = args.title
   if args.app_name and args.message then
      args.message = format_message(args.message)
   end

   if noti.suspended then
      local is_critical = args.urgency == URGENCY_CRITICAL
         or (args.preset and args.preset.urgency == URGENCY_CRITICAL)
         or (args.preset == naughty.config.presets.critical)

      if not (is_critical or args.ignore_suspend) then
         noti:add_unread({
            title = clean_title or args.app_name or "Notification",
            message = args.message or args.text or "",
            app_name = args.app_name or "",
            icon = args.icon,
            urgency = args.urgency or "normal",
            actions = args.actions or {},
            run = args.run,
         })
         return {
            timeout = SUPPRESSED_TIMEOUT_SECONDS,
            ignore_suspend = true,
         }
      end
   end

   if args.title then
      args.title = args.title .. "\n"
   end

   return args
end

-- Icon size
naughty.config.defaults.icon_size = beautiful.notification_icon_size

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
naughty.config.defaults.ontop = true
naughty.config.icon_formats = { "png", "svg", "jpg" }
naughty.persistence_enabled = true

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
   urgency = URGENCY_CRITICAL,
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

naughty.connect_signal("request::action_icon", function(a, _, hints)
   a.icon = menubar.utils.lookup_icon(hints.id)
end)

-- Track hover state on live notification popup boxes to distinguish hover-read from timeout-unread
naughty.connect_signal("request::fallback", function(n)
   local clients = n.clients or {}
   local client_names = {}
   for _, c in ipairs(clients) do
      if c.name then
         table.insert(client_names, c.name)
      end
   end
   n._cached_clients = clients
   n._cached_client_names = client_names

   if n.box then
      n.box:connect_signal("mouse::enter", function()
         n.read_by_hover = true
      end)
   end
end)

naughty.connect_signal("destroyed", function(n, reason)
   local clients = n._cached_clients or n.clients or {}
   local client_names = n._cached_client_names or {}
   if #client_names == 0 then
      for _, c in ipairs(clients) do
         if c.name then
            table.insert(client_names, c.name)
         end
      end
   end

   -- Untouched timeout expiration -> store as unread in Notification Center
   if reason == cst.notification_closed_reason.expired then
      if n.read_by_hover or n.ignore_suspend then
         return
      end

      local noti = require("config.notifications")
      local clean_title = (n.title or ""):gsub("\n$", "")
      if clean_title == "" then
         clean_title = n.app_name or "Notification"
      end

      noti:add_unread({
         title = clean_title,
         message = n.message or "",
         app_name = n.app_name or "",
         icon = n.icon,
         urgency = n.urgency or "normal",
         clients = clients,
         client_names = client_names,
         actions = n.actions or {},
         run = n.run,
      })
      return
   end

   if #client_names == 0 then
      return
   end

   -- Dismissed by user click -> jump to urgent client when it requests attention
   if reason == cst.notification_closed_reason.dismissed_by_user then
      local on_urgent
      local timer

      on_urgent = function(c)
         for _, name in ipairs(client_names) do
            if c.name == name then
               c:jump_to()
               client.disconnect_signal("property::urgent", on_urgent)
               if timer and timer.started then
                  timer:stop()
               end
               return
            end
         end
      end

      client.connect_signal("property::urgent", on_urgent)

      timer = gears.timer.start_new(URGENT_WATCHDOG_SECONDS, function()
         client.disconnect_signal("property::urgent", on_urgent)
         return false
      end)
   end
end)
