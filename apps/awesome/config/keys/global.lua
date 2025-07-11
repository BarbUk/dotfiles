local gears         = require('gears')
local awful         = require('awful')
local naughty       = require('naughty')
local beautiful     = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local lain          = require('lain')

local modkey   = require('config.keys.mod').modkey
local altkey   = require('config.keys.mod').altkey
local apps     = require('config.apps')
local mpris    = require('config.widgets').mpris
local volume   = require('config.widgets').volume
local calendar = require('config.widgets').calendar
local fsroot   = require('config.widgets').fsroot

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- }}}

awful.util.terminal = apps.default.terminal
hotkeys_popup.default_widget.labels = beautiful.hotkeys_popup_labels

local widget_refresh = function()
  mpris.update()
end

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey, "Shift" }, "h", hotkeys_popup.show_help, { description="show help", group="awesome" }),

  -- Take a screenshot
  awful.key({ "Shift" }, "Print", function ()
    awful.util.spawn_with_shell([[
      maim --select --hidecursor --highlight --color=0.3,0.4,0.6,0.3 --bordersize=3 --format=png --quality=10 |
      convert - \( +clone -background black -shadow 25x5+10+10 \) +swap -background none -layers merge +repage ~/screenshots/$(date +%F-%T).png
    ]])
  end, { description="take a screenshot and save it", group="awesome" }),

  awful.key({ "Control" }, "Print", function ()
    awful.util.spawn("flameshot gui")
  end, { description="take a screenshot with flashshot", group="awesome" }),

  awful.key({ }, "Print", function ()
    awful.util.spawn_with_shell([[
      maim --select --hidecursor --highlight --color=0.3,0.4,0.6,0.3 --bordersize=3 --format=png --quality=10 |
      xclip -selection clipboard -t image/png
    ]])
  end, { description="take a screenshot accessible from clipboard", group="awesome" }),

  -- Take a video
  awful.key({ altkey }, "Print", function ()
    awful.util.spawn_with_shell([[
      giph --select --delay 3 --timer 10 --notify --color 0.3,0.4,0.6,0.3 --bordersize 3 --highlight ~/screenshots/$(date +%F-%T).mp4
    ]])
  end, { description="take a screenshot and save it", group="awesome" }),

  -- OCR !
  awful.key({ modkey, "Control" }, "Print", function ()
    awful.util.spawn_with_shell('ocr')
  end, { description="Select a zone to OCR", group="awesome" }),

  awful.key({ modkey,           }, "p", function ()
    sloppyfocus_last.focus = false
    awful.spawn("rofi -theme-str 'element-icon { size: 2.5ch;}' -combi-modi 'clipboard:greenclip print,chrome:" .. apps.dir.scripts .. "chrome_history,window,drun' -show combi -modi combi")
  end, { description="Rofi launcher", group="awesome" }),

  awful.key({ modkey, altkey    }, "p", function ()
    sloppyfocus_last.focus = false
    awful.spawn("rofi-rbw-filter-current-tab-domain")
  end, { description="Rofi password", group="awesome" }),

  awful.key({ modkey,           }, "=", function ()
    sloppyfocus_last.focus = false
    awful.spawn("=")
  end, { description="calculator", group="awesome" }),

  awful.key({ modkey,           }, "-", function ()
    sloppyfocus_last.focus = false
    awful.spawn("/usr/local/bin/splatmoji/splatmoji type")
  end, { description="emoji", group="awesome" }),

  -- Tag browsing
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  -- Default client focus
  awful.key({ altkey,           }, "j",
    function ()
      awful.client.focus.byidx(1)
    end,
    {description = "focus next by index", group = "client"}
  ),
  awful.key({ altkey,           }, "k",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),

  -- By direction client focus
  awful.key({ modkey }, "j", function()
    awful.client.focus.global_bydirection("down")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "k", function()
    awful.client.focus.global_bydirection("up")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "h", function()
    awful.client.focus.global_bydirection("left")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "l", function()
    awful.client.focus.global_bydirection("right")
    if client.focus then client.focus:raise() end
  end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function ()
    awful.screen.focus_relative( 1)
  end,
    {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function ()
    awful.screen.focus_relative(-1)
  end,
    {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
  awful.key({ altkey,           }, "Tab", function ()
    awful.client.focus.byidx(1)
    if client.focus then
      client.focus:raise()
    end
  end, {description = "go back", group = "client"}),
  awful.key({ altkey, "Shift"      }, "Tab", function ()
    awful.client.focus.byidx(-1)
    if client.focus then
      client.focus:raise()
    end
  end, {description = "go front", group = "client"}),

  -- Show/Hide Wibox
  awful.key({ modkey }, "b", function ()
    for s in screen do
      s.mywibox.visible = not s.mywibox.visible
    end
  end, {description = "toggle wibox", group = "launcher"}),

  -- On the fly useless gaps change
  awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end, {description = "resize +", group = "client"}),
  awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end, {description = "resize -", group = "client"}),

  -- Dynamic tagging
  awful.key({ modkey, "Shift" }, "n", function () awful.tag.add("💻", { screen = awful.screen.focused(), layout = awful.layout.suit.tile }):view_only() end, { description = "add_tag", group = "client"}),
  awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end, { description = "rename_tag", group = "client"}),
  awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end, { description = "move_tag", group = "client"}),  -- move to previous tag
  awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end, { description = "move_tag", group = "client"}),  -- move to next tag
  awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end, { description = "delete_tag", group = "client"}),

  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

  awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
  --   {description = "increase the number of master clients", group = "layout"}),
  -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
  --   {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),
  -- Destroy all notifications
  awful.key({ modkey, "Control" }, "space", function() naughty.destroy_all_notifications() end,
    {description = "destroy all notifications", group = "hotkeys"}),

  awful.key({ modkey, "Control" }, "n",
      function ()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
          end
      end,
      {description = "restore minimized", group = "client"}),

  -- Widgets popups
  awful.key({ altkey, }, "c", function () calendar.show(7) end, {description = "show calendar", group = "widget"}),
  awful.key({ altkey, }, "h", function () fsroot.show(7, awful.screen.focused()) end, {description = "show fs widget", group = "widget"}),

  -- Volume control
  awful.key({ }, "XF86AudioRaiseVolume", function ()
    apps.osd.volume.up()
    volume.update()
  end, {description = "volume up", group = "sound"} ),
  awful.key({ }, "XF86AudioLowerVolume", function ()
    apps.osd.volume.down()
    volume.update()
  end, {description = "volume down", group = "sound"}),
  awful.key({ }, "XF86AudioMute", function ()
    apps.osd.volume.mute()
    volume.update()
  end, {description = "volume mute", group = "sound"}),

  -- Theme control
  awful.key({ }, "XF86Launch1", function ()
    awful.spawn("change_theme")
  end, {description = "change theme", group = "theme"}),
  awful.key({ }, "XF86LaunchA", function ()
    awful.spawn("change_theme")
  end, {description = "change theme", group = "theme"}),

  -- Music control
  awful.key({ }, "XF86AudioStop", function ()
    apps.osd.player.stop()
    widget_refresh()
  end, {description = "music stop", group = "sound"}),
  awful.key({ }, "XF86AudioPlay", function ()
    apps.osd.player.toggle()
    widget_refresh()
  end, {description = "music toggle", group = "sound"}),
  awful.key({ altkey }, "XF86AudioPlay", function ()
    awful.util.spawn(apps.cmd.volume.toggle, false)
    widget_refresh()
  end, {description = "Toggle soundcard", group = "sound"}),
  awful.key({ "Control" }, "XF86AudioPlay", function ()
    awful.util.spawn(apps.cmd.volume.toggle .. " media music", false)
    widget_refresh()
  end, {description = "music toggle", group = "sound"}),
  awful.key({ modkey, "Control" }, "Down", function ()
    apps.osd.player.toggle()
    widget_refresh()
  end, {description = "music toggle", group = "sound"}),
  awful.key({ }, "Pause", function ()
    apps.osd.player.toggle()
    widget_refresh()
  end, {description = "music toggle", group = "sound"}),
  awful.key({ }, "XF86AudioPrev", function ()
    apps.osd.player.prev()
    widget_refresh()
  end, {description = "music previous", group = "sound"}),
  awful.key({ modkey, "Control" }, "Left", function ()
    apps.osd.player.prev()
    widget_refresh()
  end, {description = "music previous", group = "sound"}),
  awful.key({ }, "XF86AudioNext", function ()
    apps.osd.player.next()
    widget_refresh()
  end, {description = "music next", group = "sound"}),
  awful.key({ modkey, "Control" }, "Right", function ()
    apps.osd.player.next()
    widget_refresh()
  end, {description = "music next", group = "sound"}),

  -- Backlight control
  awful.key({ }, "XF86MonBrightnessUp", function ()
      apps.osd.brightness.up()
  end, {description = "brightness up", group = "screen"}),
  awful.key({ }, "XF86MonBrightnessDown", function ()
      apps.osd.brightness.down()
  end, {description = "brightness down", group = "screen"}),

  awful.key({ modkey }, "F12", function ()
      apps.osd.brightness.up()
  end, {description = "brightness up", group = "screen"}),
  awful.key({ modkey }, "F11", function ()
      apps.osd.brightness.down()
  end, {description = "brightness down", group = "screen"}),

  awful.key({ modkey }, "l", function ()
      awful.spawn(apps.default.lock, false )
  end, {description = "lock", group = "screen"}),

  awful.key({ }, "XF86ScreenSaver", function ()
      awful.spawn(apps.default.lock, false )
  end, {description = "lock", group = "screen"}),

  awful.key({ }, "XF86Display", function ()
      awful.util.spawn("autorandr -c")
  end, {description = "detect display", group = "screen"}),

  awful.key({ }, "XF86TouchpadToggle", function ()
      awful.spawn(apps.cmd.picom.toggle, false)
  end, {description = "Toggle picom", group = "screen"}),

  awful.key({ }, "XF86Explorer", function ()
      awful.spawn(apps.cmd.picom.toggle, false)
  end, {description = "Toggle picom", group = "screen"}),

  -- Copy primary to clipboard (terminals to gtk)
  awful.key({ modkey }, "c", function () awful.util.spawn_with_shell("xsel | xsel -i -b") end, {description = "copy", group = "clipboard"}),
  -- Copy clipboard to primary (gtk to terminals)
  awful.key({ modkey }, "v", function () awful.spawn.easy_async("paste", function(stdout)
        noti:notify(stdout)
  end) end, {description = "paste", group = "clipboard"}),

  -- User programs
  awful.key({ modkey,           }, "Return", function () awful.spawn(apps.default.terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(apps.alt.terminal) end,
    {description = "open a alt terminal", group = "launcher"}),
  awful.key({ modkey }, "s", function () awful.spawn(apps.default.editor) end,
    {description = "open " .. apps.default.editor, group = "launcher"}),
  awful.key({ modkey, "Shift" }, "s", function () awful.spawn(apps.alt.editor) end,
    {description = "open " .. apps.default.editor, group = "launcher"}),
  awful.key({ modkey }, "g", function () awful.spawn(apps.default.graphics) end,
    {description = "open " .. apps.default.graphics, group = "launcher"}),
  awful.key({ modkey }, "d", function () awful.spawn(apps.default.filemanager) end,
    {description = "open " .. apps.default.filemanager, group = "launcher"}),
  awful.key({ modkey, "Shift" }, "d", function () awful.spawn("open_sftp") end,
    {description = "open " .. apps.default.filemanager, group = "launcher"}),

  -- awful.key({ modkey, "Shift"   }, "Return", function ()
  --   awful.spawn("dmenu_ssh")
  -- end, {description = "launch ssh session", group = "launcher"}),
  awful.key({ modkey, "Control" }, "Return", function ()
    awful.spawn("dmenu_raise")
  end, {description = "launch window selection", group = "launcher"}),
  awful.key({ modkey, altkey    }, "Return", function ()
    awful.spawn("dmenu_edit")
  end, {description = "launch edit menu", group = "launcher"}),
  awful.key({ modkey, altkey, "Control" }, "Return", function ()
    awful.spawn("dmenu_monitoring")
  end, {description = "launch monitoring menu", group = "launcher"}),
  awful.key({ modkey, "Shift"   }, "p", function ()
    sloppyfocus_last.focus = false
    awful.util.spawn_with_shell("snippy")
  end, {description = "snippets", group = "launcher"}),
  awful.key({ modkey, "Shift"   }, "m", function ()
    awful.util.spawn_with_shell("termite --class='center' --geometry='700x400' --exec=ncmpcpp &")
  end, {description = "terminal centered", group = "launcher"}),
  awful.key({ modkey }, "0", function ()
    awful.spawn( "qrcodize", false )
  end, {description = "qrcodize your clipboard ", group = "launcher"}),
  awful.key({ modkey }, "t", function ()
    awful.spawn( apps.default.browser .. " --profile-directory='Default' https://mail.google.com/mail/u/0/#inbox", false )
  end, {description = "launch perso browser", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "t", function ()
    awful.spawn( apps.default.browser .. " --profile-directory='Default' --app=https://calendar.google.com", false )
  end, {description = "launch perso calendar", group = "launcher"}),
  awful.key({ modkey }, "y", function ()
    awful.spawn( apps.default.browser .. " --profile-directory='Profile 3' https://mail.missiveapp.com", false )
  end, {description = "launch work browser", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "y", function ()
    awful.spawn( apps.default.browser .. " --profile-directory='Profile 3' --app=https://calendar.google.com", false )
  end, {description = "launch work calendar", group = "launcher"}),
  awful.key({ modkey }, "u", function ()
    spawn_and_move("mattermost-desktop", "Mattermost", 1)
    spawn_and_move("slack", "Slack", 2)
    spawn_and_move(apps.default.browser .. " --profile-directory='Profile 3' https://mail.missiveapp.com", "Google-chrome", 3)
    spawn_and_move("subl", "Subl", 4)
  end, {description = "launch work apps on their tag", group = "launcher"}),

  -- Default
  -- Prompt
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#" .. i + 9,
    function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end,
    {description = "view tag #"..i, group = "tag"}),
  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
    {description = "toggle tag #" .. i, group = "tag"}),
  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
    {description = "move focused client to tag #"..i, group = "tag"}),
  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
