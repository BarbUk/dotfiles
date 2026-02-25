local gears = require("gears")
local awful = require("awful")

local modkey = require("config.keys.mod").modkey
local altkey = require("config.keys.mod").altkey
local apps = require("config.apps")
local secrets = require("config.secrets")
local state = require("config.state")
local noti = require("config.notifications")
local helpers = require("config.helpers")

local keys = gears.table.join(
   -- Copy primary to clipboard (terminals to gtk)
   awful.key({ modkey }, "c", function()
      awful.spawn.with_shell("xsel | xsel -i -b")
   end, { description = "copy", group = "clipboard" }),
   -- Copy clipboard to primary (gtk to terminals)
   awful.key({ modkey }, "v", function()
      awful.spawn.easy_async("paste", function(stdout)
         noti:notify(stdout)
      end)
   end, { description = "paste", group = "clipboard" }),

   -- Take a screenshot
   awful.key({ "Shift" }, "Print", function()
      awful.spawn.with_shell(
         [[ maim --select --hidecursor --highlight --color=0.3,0.4,0.6,0.3 --bordersize=5 --format=png --quality=7 | satty --early-exit --filename - ]]
      )
   end, { description = "take a screenshot and edit it with satty", group = "awesome" }),
   awful.key({ "Control" }, "Print", function()
      awful.spawn("flameshot gui")
   end, { description = "take a screenshot with flashshot", group = "awesome" }),
   awful.key({}, "Print", function()
      awful.spawn.with_shell(
         [[ maim --select --hidecursor --highlight --color=0.3,0.4,0.6,0.3 --bordersize=5 --format=png --quality=10 | xclip -selection clipboard -t image/png ]]
      )
   end, { description = "take a screenshot accessible from clipboard", group = "awesome" }),

   -- Take a video
   awful.key({ altkey }, "Print", function()
      awful.spawn.with_shell(
         [[ giph --quiet --select --delay 1 --timer 5 --notify --color 0.3,0.4,0.6,0.3 --bordersize 3 --highlight ~/Downloads/$(date +%F-%T).mp4 ]]
      )
   end, { description = "take a screenshot and save it", group = "awesome" }),

   -- OCR
   awful.key({ modkey, "Control" }, "Print", function()
      awful.spawn.with_shell("ocr")
   end, { description = "Select a zone to OCR", group = "awesome" }),

   awful.key({ modkey }, "p", function()
      state.sloppyfocus_last.focus = false
      awful.spawn(
         "rofi -theme-str 'element-icon { size: 2.5ch;}' -combi-modi 'clipboard:greenclip print,chrome:"
            .. apps.dir.scripts
            .. "chrome_history,window,drun' -show combi -modi combi"
      )
   end, { description = "Rofi launcher", group = "awesome" }),
   awful.key({ modkey, altkey }, "p", function()
      state.sloppyfocus_last.focus = false
      awful.spawn("rofi-rbw-filter-current-tab-domain")
   end, { description = "Rofi password", group = "awesome" }),
   awful.key({ modkey }, "=", function()
      state.sloppyfocus_last.focus = false
      awful.spawn(
         [[ rofi -show calc -modi calc -no-show-match -no-sort -kb-accept-custom Return -kb-accept-entry Control+Return -calc-command "echo -n '{result}' | xclip -selection clipboard" ]]
      )
   end, { description = "calculator", group = "awesome" }),
   awful.key({ modkey }, "-", function()
      state.sloppyfocus_last.focus = false
      awful.spawn("splatmoji type")
   end, { description = "emoji", group = "awesome" }),

   -- User programs
   awful.key({ modkey }, "Return", function()
      awful.spawn(apps.default.terminal)
   end, { description = "open a terminal", group = "launcher" }),
   awful.key({ modkey, "Shift" }, "Return", function()
      awful.spawn(apps.alt.terminal)
   end, { description = "open a alt terminal", group = "launcher" }),
   awful.key({ modkey }, "s", function()
      awful.spawn(apps.default.editor)
   end, { description = "open " .. apps.default.editor, group = "launcher" }),
   awful.key({ modkey, "Shift" }, "s", function()
      awful.spawn(apps.alt.editor)
   end, { description = "open " .. apps.default.editor, group = "launcher" }),
   awful.key({ modkey }, "g", function()
      awful.spawn(apps.default.graphics)
   end, { description = "open " .. apps.default.graphics, group = "launcher" }),
   awful.key({ modkey }, "d", function()
      awful.spawn(apps.default.filemanager)
   end, { description = "open " .. apps.default.filemanager, group = "launcher" }),
   awful.key({ modkey, "Shift" }, "d", function()
      awful.spawn("open_sftp")
   end, { description = "open " .. apps.default.filemanager, group = "launcher" }),
   awful.key({ modkey, "Control" }, "Return", function()
      awful.spawn("dmenu_raise")
   end, { description = "launch window selection", group = "launcher" }),
   awful.key({ modkey, altkey }, "Return", function()
      awful.spawn("dmenu_edit")
   end, { description = "launch edit menu", group = "launcher" }),
   awful.key({ modkey, altkey, "Control" }, "Return", function()
      awful.spawn("dmenu_monitoring")
   end, { description = "launch monitoring menu", group = "launcher" }),
   awful.key({ modkey, "Shift" }, "p", function()
      state.sloppyfocus_last.focus = false
      awful.spawn.with_shell("snippy")
   end, { description = "snippets", group = "launcher" }),
   awful.key({ modkey, "Shift" }, "m", function()
      awful.spawn.with_shell("termite --class='center' --geometry='700x400' --exec=ncmpcpp &")
   end, { description = "terminal centered", group = "launcher" }),
   awful.key({ modkey }, "0", function()
      awful.spawn("qrcodize", false)
   end, { description = "qrcodize your clipboard ", group = "launcher" }),
   awful.key({ modkey }, "t", function()
      awful.spawn(
         apps.default.browser .. " --profile-directory='Default' https://mail.google.com/mail/u/0/#inbox",
         false
      )
   end, { description = "launch perso browser", group = "launcher" }),
   awful.key({ modkey, "Shift" }, "t", function()
      awful.spawn(apps.default.browser .. " --profile-directory='Default' --app=https://calendar.google.com", false)
   end, { description = "launch perso calendar", group = "launcher" }),
   awful.key({ modkey }, "y", function()
      awful.spawn(
         apps.default.browser
            .. " --profile-directory='"
            .. secrets.profile.pro
            .. "' "
            .. secrets.urls.pro.dashboard
            .. " "
            .. secrets.urls.pro.ticket,
         false
      )
   end, { description = "launch work browser", group = "launcher" }),
   awful.key({ modkey, "Shift" }, "y", function()
      awful.spawn(
         apps.default.browser
            .. " --profile-directory='"
            .. secrets.profile.pro
            .. "' --app=https://mail.zoho.com/zm/#mail/folder/inbox",
         false
      )
   end, { description = "launch pro mail", group = "launcher" }),
   awful.key({ altkey, "Shift" }, "y", function()
      awful.spawn(
         apps.default.browser .. " --profile-directory='" .. secrets.profile.pro .. "' --app=https://calendar.zoho.com/",
         false
      )
   end, { description = "launch pro calendar", group = "launcher" }),
   awful.key({ modkey }, "u", function()
      helpers.spawn_and_move("slack", "Slack", 1)
      helpers.spawn_and_move(
         apps.default.browser .. " --profile-directory='" .. secrets.profile.pro .. "' --app=https://mail.zoho.com",
         "mail.zoho.com__zm",
         2
      )
      helpers.spawn_and_move(
         apps.default.browser .. " --profile-directory='" .. secrets.profile.pro .. "' --app=https://calendar.zoho.com",
         "calendar.zoho.com",
         2
      )
      helpers.spawn_and_move("subl", "Subl", 4)
   end, { description = "launch work apps on their tag", group = "launcher" }),
   awful.key({ modkey }, "r", function()
      awful.screen.focused().mypromptbox:run()
   end, { description = "run prompt", group = "launcher" })
)

return keys
