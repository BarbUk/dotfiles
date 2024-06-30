local gears  = require('gears')
local awful  = require('awful')
local lain   = require('lain')
local modkey = require('config.keys.mod').modkey
local altkey = require('config.keys.mod').altkey

return gears.table.join(
  awful.key({ altkey, "Shift"   }, "m", lain.util.magnify_client ),
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ "Mod1"            }, "F4", function (c) c:kill() end,
    {description = "close", group = "client"}),
  awful.key({ modkey            }, "q", function (c) c:kill() end,
    {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o", function (c) c:move_to_screen(c.screen.index-1) end,
    {description = "move to screen + 1", group = "client"}),
  awful.key({ modkey, "Shift"   }, "o", function (c) c:move_to_screen() end,
    {description = "move to screen + 1", group = "client"}),
  awful.key({ modkey, "Control" }, "t", function (c) c.ontop = not c.ontop end,
    {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "m",
    function (c)
      if c.maximized_vertical and c.maximized_horizontal then
        c.maximized_vertical = not c.maximized_vertical
        c.maximized_horizontal = not c.maximized_horizontal
      else
        c.maximized = not c.maximized
      end
      c:raise()
    end ,
    {description = "maximize", group = "client"})
)
