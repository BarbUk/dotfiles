local awful     = require('awful')
local gears     = require('gears')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local lain      = require('lain')
local buttons   = require('config.tags.buttons')

-- table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.fair,
  awful.layout.suit.tile,
  awful.layout.suit.tile.top,
}

awful.util.tagnames = {
  {
    names =  { "", "", "", "", "", "" },
  },
  {
    names =  { "", "", "", "", "", "" },
  },
}

-- lain
lain.layout.termfair.nmaster        = 3
lain.layout.termfair.ncol           = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol    = 1
-- }}}

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

awful.screen.connect_for_each_screen(function(s)
  screen_index = s.index
  awful.tag(awful.util.tagnames[screen_index].names, s, awful.layout.layouts[1])

    -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, buttons)

    -- Textual layoutbox
  s.mytxtlayoutbox = wibox.widget.textbox(beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
  awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
  awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
  s.mytxtlayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function () awful.layout.inc( 1) end),
    awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
    awful.button({}, 3, function () awful.layout.inc(-1) end),
    awful.button({}, 4, function () awful.layout.inc( 1) end),
    awful.button({}, 5, function () awful.layout.inc(-1) end)))
end)
