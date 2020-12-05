local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local menubar   = require("menubar")
local lain      = require('lain')
local markup    = lain.util.markup

-- Defaults
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.border_radius) end

-- Apply theme variables
naughty.config.padding = 5
naughty.config.spacing = 5
naughty.config.defaults.border_width = 0

-- Notification callback to style monitoring notification
naughty.config.notify_callback = function(args)
    if args.app_name and args.message then
        args.message = args.message:gsub('<(%w+%.%w+%.%w+)>', "%1")
        args.message = args.message:gsub("PROBLEM", markup(beautiful.nord11, "PROBLEM"))
        args.message = args.message:gsub("RECOVERY", markup(beautiful.nord9, "RECOVERY"))
        args.message = args.message:gsub("on host (%w+%.%w+%.%w+)", "on host " .. markup.bold("%1"))
        args.message = args.message:gsub("([%a://]*%w+%.[%w%.]+[:%d]*[/%w_%.(%%20)(%-)]*)", markup.underline("%1"))
        args.message = args.message:gsub("```(.+)```", "\n\n" .. markup.color(beautiful.background, beautiful.foreground, markup.bold("%1")))
    end
    return args
end

-- Icon size
naughty.config.defaults['icon_size']  = beautiful.notification_icon_size

-- Timeouts
naughty.config.defaults.timeout = 10
naughty.config.defaults.hover_timeout = 1
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

-- Apply theme variables
naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width

naughty.config.presets.normal = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.low = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.critical = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_crit_fg,
    bg           = beautiful.notification_crit_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or
        menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)
