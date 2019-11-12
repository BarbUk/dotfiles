local awful          = require("awful")
local beautiful      = require("beautiful")
local client_keys    = require('config.client.keys')
local client_buttons = require('config.client.buttons')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width      = beautiful.border_width,
      border_color      = beautiful.border_normal,
      focus             = awful.client.focus.filter,
      raise             = true,
      keys              = client_keys,
      buttons           = client_buttons,
      screen            = awful.screen.preferred,
      placement         = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor  = false
    },
    callback = function(c)
      c.maximized, c.maximized_vertical, c.maximized_horizontal = false, false, false
    end
  },
  -- Jetbrains
  {
      rule = {
          class = "jetbrains-.*",
      }, properties = { focus = true }
  },
  {
      rule = {
          class = "jetbrains-.*",
          name = "win.*"
      }, properties = { titlebars_enabled = false, focusable = false, focus = true, floating = true, placement = awful.placement.restore }
  },
  -- clients that should float centered
  {
    rule_any = {
      class = {
        "feh",
        "Lxappearance",
        "Lxsession-edit",
        "Lxsession-default-apps",
        "Pinentry",
        "Pavucontrol",
        "Paprefs",
        "center",
        "albert",
        "Peek",
        "Toggl Desktop",
        "Wine",
        "copyq",
        "Zoiper",
        "mpv",
        "MPlayer",
        "sun-awt-X11-XDialogPeer",
        "sun-awt-X11-XWindowPeer",
      },
      type = {
        "dialog"
      },
      name = {
        "Error",
        "Unlock Keyring",
      },
      role = {
        "GtkFileChooserDialog",
        "pop-up"
      },
    },
    properties = {
      floating = true,
      focus = yes,
      placement = awful.placement.centered,
    }
  },
  -- clients that should float ontop
  { rule = { name = "Slack Call Minipanel" }, properties = { floating = true, ontop = true},
    callback = function (c)
      awful.placement.bottom_right(c, { honor_workarea=true })
    end
  }
}
-- }}}

-- client.connect_signal("property::class",function(c)

--   if c.class == 'Spotify' then
--     local t = awful.tag.find_by_name(nil, '')
--     c:move_to_tag(t)
--     t:view_only()
--   end

-- end)
