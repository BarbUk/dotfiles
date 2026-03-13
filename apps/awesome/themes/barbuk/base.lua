--[[

   BarbUk Awesome WM config dark

--]]
local helpers = require("config.helpers")
local home = os.getenv("HOME")
local light_file = home .. "/.config/themelight"
local color = "dark"

if helpers.file_exists(light_file) then
   color = "light"
end

local theme = require("themes/barbuk/" .. color)
local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Do not scale with dpi
theme.wibar_height = dpi(15)
theme.notification_max_width = dpi(720)
theme.notification_icon_size = dpi(64)

awful.screen.connect_for_each_screen(function(s)
   -- 2k screen should have a normal dpi
   -- 2560x1440
   -- 4k screen should have a double dpi
   -- 3840x2160
   if s.geometry.width > 2600 then
      xresources.set_dpi(192, s)
      dpi = xresources.apply_dpi
      theme.wibar_height = dpi(30)
      theme.notification_max_width = dpi(1440)
      theme.notification_icon_size = dpi(128)
   end
end)

awful.screen.set_auto_dpi_enabled(true)

theme.dir = gears.filesystem.get_configuration_dir() .. "themes/barbuk"
theme.wallpaper = theme.dir .. "/archlinux.png"

theme.font = "PragmataPro Nerd Font " .. dpi(8)

theme.fg_normal = theme.foreground
theme.fg_focus = theme.focus
theme.bg_normal = theme.background
theme.bg_focus = theme.background
theme.fg_urgent = theme.background
theme.bg_urgent = theme.nord11
theme.border_width = dpi(1)
theme.border_normal = theme.nord3
theme.border_focus = theme.nord8
theme.taglist_fg_focus = theme.foreground
theme.taglist_bg_focus = theme.nord9
theme.taglist_fg_occupied = theme.nord9
theme.menu_height = dpi(12)
theme.menu_width = dpi(140)
theme.menu_border_width = dpi(0)
theme.useless_gap = dpi(0.33)

-- Rounded corners
theme.border_radius = dpi(6)
theme.screen_margin = dpi(5)

theme.notification_position = "top_right"
theme.notification_border_width = dpi(2)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = theme.nord14
theme.notification_bg = theme.background
theme.notification_fg = theme.foreground
theme.notification_crit_bg = theme.bg_urgent
theme.notification_crit_fg = theme.fg_urgent
theme.notification_margin = dpi(12)
theme.notification_font = "PragmataPro Nerd Font " .. dpi(12)
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 2
theme.notification_shape = helpers.rrect(theme.notification_border_radius)

theme.ocol = "<span color='" .. theme.nord8 .. "'>"
theme.ccol = "</span>"
theme.tasklist_ontop = theme.ocol .. " " .. theme.ccol
theme.tasklist_floating = theme.ocol .. " " .. theme.ccol
theme.tasklist_maximized_horizontal = theme.ocol .. " " .. theme.ccol
theme.tasklist_maximized_vertical = theme.ocol .. " " .. theme.ccol
theme.tasklist_maximized = theme.ocol .. " " .. theme.ccol
theme.layout_txt_tile = ""
theme.layout_txt_tiletop = ""
theme.layout_txt_fairv = ""
theme.layout_txt_dwindle = ""
theme.layout_txt_fullscreen = ""
theme.layout_txt_floating = ""
theme.tasklist_disable_icon = false
theme.icon_theme = "Papirus"
theme.flag = {
   france = theme.dir .. "/icons/fr.png",
   mauritius = theme.dir .. "/icons/mu.png",
   canada = theme.dir .. "/icons/ca.png",
   cambodia = theme.dir .. "/icons/kh.png",
}

-- lain related
theme.layout_txt_termfair = "[termfair]"
theme.layout_txt_centerfair = "[centerfair]"
theme.taglist_squares_sel = gears.surface.load_from_shape(dpi(3), dpi(3), gears.shape.rectangle, theme.fg_focus)
theme.taglist_squares_unsel = gears.surface.load_from_shape(dpi(3), dpi(3), gears.shape.rectangle, theme.focus)

theme.hotkeys_font = "PragmataPro Bold " .. dpi(13)
theme.hotkeys_description_font = "PragmataPro " .. dpi(10)
-- Use pretty Unicode characters to represent special keys in hotkey hinter
theme.hotkeys_popup_labels = {
   Mod4 = " ⌥ ",
   Mod1 = " ⎇ ",
   Shift = " ⇧ ",
   Control = " Ctrl ",
   Left = " ← ",
   Up = " ↑ ",
   Right = " → ",
   Down = " ↓ ",
   Page_Down = " ↧ ",
   Page_Up = " ↥ ",
   Escape = " ⎋ ",
   Return = " ↵ ",
   Backspace = " ⌫ ",
   Delete = " ⌦ ",
   Insert = " ⎀ ",
   space = " ⍽ ",
   Tab = " ⇆ ",
   ["#108"] = " ⌨ ",
   F1 = " F1",
   F2 = " F2",
   F3 = " F3",
   F4 = " F4",
   F5 = " F5",
   F6 = " F6",
   F7 = " F7",
   F8 = " F8",
   F9 = " F9",
   F10 = " F10",
   F11 = " F11",
   F12 = " F12",
   ["#10"] = " 1",
   ["#11"] = " 2",
   ["#12"] = " 3",
   ["#13"] = " 4",
   ["#14"] = " 5",
   ["#15"] = " 6",
   ["#16"] = " 7",
   ["#17"] = " 8",
   ["#18"] = " 9",
   ["#19"] = " 0",
   ["#21"] = " = ",
   ["+"] = " + ",
   ["-"] = " - ",
   ["XF86AudioRaiseVolume"] = "🔊",
   ["XF86AudioLowerVolume"] = "🔉",
   ["XF86AudioMute"] = "🔇",
   ["XF86Launch1"] = "🚀",
   ["XF86AudioStop"] = "■",
   ["XF86AudioPlay"] = "▶",
   ["XF86AudioPrev"] = "⏪",
   ["XF86AudioNext"] = "⏩",
   ["XF86MonBrightnessUp"] = "🔆",
   ["XF86MonBrightnessDown"] = "🔅",
   ["XF86ScreenSaver"] = "🔒",
   ["XF86Display"] = "🔅",
   ["Print"] = " 🖶 ",
}

return theme
