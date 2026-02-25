local gears = require("gears")
local awful = require("awful")
local lain = require("lain")

local modkey = require("config.keys.mod").modkey
local altkey = require("config.keys.mod").altkey

local keys = gears.table.join(
   -- Tag browsing
   awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
   awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
   awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

   -- Default client focus
   awful.key({ altkey }, "j", function()
      awful.client.focus.byidx(1)
   end, { description = "focus next by index", group = "client" }),
   awful.key({ altkey }, "k", function()
      awful.client.focus.byidx(-1)
   end, { description = "focus previous by index", group = "client" }),

   -- By direction client focus
   awful.key({ modkey }, "j", function()
      awful.client.focus.global_bydirection("down")
      if client.focus then
         client.focus:raise()
      end
   end),
   awful.key({ modkey }, "k", function()
      awful.client.focus.global_bydirection("up")
      if client.focus then
         client.focus:raise()
      end
   end),
   awful.key({ modkey }, "h", function()
      awful.client.focus.global_bydirection("left")
      if client.focus then
         client.focus:raise()
      end
   end),
   awful.key({ modkey }, "l", function()
      awful.client.focus.global_bydirection("right")
      if client.focus then
         client.focus:raise()
      end
   end),

   -- Layout manipulation
   awful.key({ modkey, "Shift" }, "j", function()
      awful.client.swap.byidx(1)
   end, { description = "swap with next client by index", group = "client" }),
   awful.key({ modkey, "Shift" }, "k", function()
      awful.client.swap.byidx(-1)
   end, { description = "swap with previous client by index", group = "client" }),
   awful.key({ modkey, "Control" }, "j", function()
      awful.screen.focus_relative(1)
   end, { description = "focus the next screen", group = "screen" }),
   awful.key({ modkey, "Control" }, "k", function()
      awful.screen.focus_relative(-1)
   end, { description = "focus the previous screen", group = "screen" }),
   awful.key(
      { modkey, "Control" },
      "u",
      awful.client.urgent.jumpto,
      { description = "jump to urgent client", group = "client" }
   ),
   awful.key({ altkey }, "Tab", function()
      awful.client.focus.byidx(1)
      if client.focus then
         client.focus:raise()
      end
   end, { description = "go back", group = "client" }),
   awful.key({ altkey, "Shift" }, "Tab", function()
      awful.client.focus.byidx(-1)
      if client.focus then
         client.focus:raise()
      end
   end, { description = "go front", group = "client" }),

   -- On the fly useless gaps change
   awful.key({ altkey, "Control" }, "+", function()
      lain.util.useless_gaps_resize(1)
   end, { description = "resize +", group = "client" }),
   awful.key({ altkey, "Control" }, "-", function()
      lain.util.useless_gaps_resize(-1)
   end, { description = "resize -", group = "client" }),

   -- Dynamic tagging
   awful.key({ modkey, "Shift" }, "n", function()
      awful.tag.add("💻", { screen = awful.screen.focused(), layout = awful.layout.suit.tile }):view_only()
   end, { description = "add_tag", group = "client" }),
   awful.key({ modkey, "Shift" }, "r", function()
      lain.util.rename_tag()
   end, { description = "rename_tag", group = "client" }),
   awful.key({ modkey, "Shift" }, "Left", function()
      lain.util.move_tag(-1)
   end, { description = "move_tag", group = "client" }),
   awful.key({ modkey, "Shift" }, "Right", function()
      lain.util.move_tag(1)
   end, { description = "move_tag", group = "client" }),
   awful.key({ modkey, "Shift" }, "d", function()
      lain.util.delete_tag()
   end, { description = "delete_tag", group = "client" }),

   awful.key({ altkey, "Shift" }, "l", function()
      awful.tag.incmwfact(0.05)
   end, { description = "increase master width factor", group = "layout" }),
   awful.key({ altkey, "Shift" }, "h", function()
      awful.tag.incmwfact(-0.05)
   end, { description = "decrease master width factor", group = "layout" }),
   awful.key({ modkey, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
   end, { description = "increase the number of columns", group = "layout" }),
   awful.key({ modkey, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
   end, { description = "decrease the number of columns", group = "layout" }),
   awful.key({ modkey }, "space", function()
      awful.layout.inc(1)
   end, { description = "select next", group = "layout" }),
   awful.key({ modkey, "Shift" }, "space", function()
      awful.layout.inc(-1)
   end, { description = "select previous", group = "layout" }),

   awful.key({ modkey, "Control" }, "n", function()
      local c = awful.client.restore()
      if c then
         c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
   end, { description = "restore minimized", group = "client" })
)

for i = 1, 9 do
   keys = gears.table.join(
      keys,
      awful.key({ modkey }, "#" .. i + 9, function()
         local screen = awful.screen.focused()
         local tag = screen.tags[i]
         if tag then
            tag:view_only()
         end
      end, { description = "view tag #" .. i, group = "tag" }),
      awful.key({ modkey, "Control" }, "#" .. i + 9, function()
         local screen = awful.screen.focused()
         local tag = screen.tags[i]
         if tag then
            awful.tag.viewtoggle(tag)
         end
      end, { description = "toggle tag #" .. i, group = "tag" }),
      awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
         if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end, { description = "move focused client to tag #" .. i, group = "tag" }),
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
         if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
               client.focus:toggle_tag(tag)
            end
         end
      end, { description = "toggle focused client on tag #" .. i, group = "tag" })
   )
end

return keys
