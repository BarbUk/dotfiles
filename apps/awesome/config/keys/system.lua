local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

local modkey = require("config.keys.mod").modkey
local altkey = require("config.keys.mod").altkey
local apps = require("config.apps")
local mpris = require("config.widgets").mpris
local volume = require("config.widgets").volume
local calendar = require("config.widgets").calendar
local fsroot = require("config.widgets").fsroot

hotkeys_popup.default_widget.labels = beautiful.hotkeys_popup_labels

local widget_refresh = function()
   if mpris and mpris.update then
      mpris.update()
   end
end

local keys = gears.table.join(
   awful.key({ modkey, "Shift" }, "h", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

   -- Awesome controls
   awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
   awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

   -- Destroy all notifications
   awful.key({ modkey, altkey }, "space", function()
      naughty.destroy_all_notifications()
   end, { description = "destroy all notifications", group = "hotkeys" }),

   -- Show/Hide Wibox
   awful.key({ modkey }, "b", function()
      for s in screen do
         s.mywibox.visible = not s.mywibox.visible
      end
   end, { description = "toggle wibox", group = "launcher" }),

   -- Widgets popups
   awful.key({ altkey }, "c", function()
      if calendar then
         calendar.show(7)
      end
   end, { description = "show calendar", group = "widget" }),
   awful.key({ altkey }, "h", function()
      if fsroot then
         fsroot.show(7, awful.screen.focused())
      end
   end, { description = "show fs widget", group = "widget" }),

   -- Volume control
   awful.key({}, "XF86AudioRaiseVolume", function()
      apps.osd.volume.up()
      if volume and volume.update then
         volume.update()
      end
   end, { description = "volume up", group = "sound" }),
   awful.key({}, "XF86AudioLowerVolume", function()
      apps.osd.volume.down()
      if volume and volume.update then
         volume.update()
      end
   end, { description = "volume down", group = "sound" }),
   awful.key({}, "XF86AudioMute", function()
      apps.osd.volume.mute()
      if volume and volume.update then
         volume.update()
      end
   end, { description = "volume mute", group = "sound" }),

   -- Theme control
   awful.key({}, "XF86Launch1", function()
      awful.spawn("change_theme")
   end, { description = "change theme", group = "theme" }),
   awful.key({}, "XF86LaunchA", function()
      awful.spawn("change_theme")
   end, { description = "change theme", group = "theme" }),

   -- Music control
   awful.key({}, "XF86AudioStop", function()
      apps.osd.player.stop()
      widget_refresh()
   end, { description = "music stop", group = "sound" }),
   awful.key({}, "XF86AudioPlay", function()
      apps.osd.player.toggle()
      widget_refresh()
   end, { description = "music toggle", group = "sound" }),
   awful.key({ altkey }, "XF86AudioPlay", function()
      awful.spawn(apps.cmd.volume.toggle, false)
      widget_refresh()
   end, { description = "Toggle soundcard", group = "sound" }),
   awful.key({ "Control" }, "XF86AudioPlay", function()
      awful.spawn(apps.cmd.volume.toggle .. " media music", false)
      widget_refresh()
   end, { description = "music toggle", group = "sound" }),
   awful.key({ modkey, "Control" }, "Down", function()
      apps.osd.player.toggle()
      widget_refresh()
   end, { description = "music toggle", group = "sound" }),
   awful.key({}, "Pause", function()
      apps.osd.player.toggle()
      widget_refresh()
   end, { description = "music toggle", group = "sound" }),
   awful.key({}, "XF86AudioPrev", function()
      apps.osd.player.prev()
      widget_refresh()
   end, { description = "music previous", group = "sound" }),
   awful.key({ modkey, "Control" }, "Left", function()
      apps.osd.player.prev()
      widget_refresh()
   end, { description = "music previous", group = "sound" }),
   awful.key({}, "XF86AudioNext", function()
      apps.osd.player.next()
      widget_refresh()
   end, { description = "music next", group = "sound" }),
   awful.key({ modkey, "Control" }, "Right", function()
      apps.osd.player.next()
      widget_refresh()
   end, { description = "music next", group = "sound" }),

   -- Backlight control
   awful.key({}, "XF86MonBrightnessUp", function()
      apps.osd.brightness.up()
   end, { description = "brightness up", group = "screen" }),
   awful.key({}, "XF86MonBrightnessDown", function()
      apps.osd.brightness.down()
   end, { description = "brightness down", group = "screen" }),
   awful.key({ modkey }, "F12", function()
      apps.osd.brightness.up()
   end, { description = "brightness up", group = "screen" }),
   awful.key({ modkey }, "F11", function()
      apps.osd.brightness.down()
   end, { description = "brightness down", group = "screen" }),

   awful.key({ modkey }, "l", function()
      awful.spawn(apps.default.lock, false)
   end, { description = "lock", group = "screen" }),
   awful.key({}, "XF86ScreenSaver", function()
      awful.spawn(apps.default.lock, false)
   end, { description = "lock", group = "screen" }),
   awful.key({}, "XF86Display", function()
      awful.spawn("autorandr -c")
   end, { description = "detect display", group = "screen" }),
   awful.key({}, "XF86TouchpadToggle", function()
      awful.spawn(apps.cmd.picom.toggle, false)
   end, { description = "Toggle picom", group = "screen" }),
   awful.key({}, "XF86Explorer", function()
      awful.spawn(apps.cmd.picom.toggle, false)
   end, { description = "Toggle picom", group = "screen" })
)

return keys
