local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local noti = require("config.notifications")
local helpers = require("config.helpers")

local POPUP_WIDTH = 720
local ICON_SIZE = 32
local CARD_PADDING = 10
local CARD_SPACING = 8
local CARD_BORDER_WIDTH = 1
local POPUP_BORDER_WIDTH = 2
local POPUP_MARGIN = 12
local MAX_VISIBLE_ITEMS = 6
local BUTTON_LEFT = 1
local BUTTON_RIGHT = 3
local WHEEL_UP = 4
local WHEEL_DOWN = 5

local center = {
   popup = nil,
   scroll_offset = 1,
   hovered_dismiss_slot = nil,
}

-- Clamp scroll offset so visible window stays within unread list bounds
local function clamp_offset(total)
   local max_offset = math.max(1, total - MAX_VISIBLE_ITEMS + 1)
   if center.scroll_offset > max_offset then
      center.scroll_offset = max_offset
   end
   if center.scroll_offset < 1 then
      center.scroll_offset = 1
   end
end

-- Build a single unread notification card widget
local function build_card(entry, slot_idx)
   local time_str = os.date("%H:%M", entry.timestamp)
   local title_escaped = gstring.xml_escape(entry.title ~= "" and entry.title or "Notification")
   local border_color = entry.urgency == "critical" and (beautiful.nord11 or "#BF616A")
      or (beautiful.nord3 or "#4C566A")

   local dismiss_fg = beautiful.nord11 or "#BF616A"
   local dismiss_hover_fg = beautiful.bg_normal or "#2E3440"
   local is_dismiss_hovered = (center.hovered_dismiss_slot == slot_idx)
   local dismiss_btn = wibox.widget({
      {
         text = " ✕ ",
         font = beautiful.font,
         align = "center",
         valign = "center",
         widget = wibox.widget.textbox,
      },
      fg = is_dismiss_hovered and dismiss_hover_fg or dismiss_fg,
      bg = is_dismiss_hovered and dismiss_fg or beautiful.bg_normal,
      shape = helpers.rrect(dpi(4)),
      widget = wibox.container.background,
   })

   local function set_dismiss_hover(hovered)
      is_dismiss_hovered = hovered
      if hovered then
         center.hovered_dismiss_slot = slot_idx
         dismiss_btn.bg = dismiss_fg
         dismiss_btn.fg = dismiss_hover_fg
      else
         if center.hovered_dismiss_slot == slot_idx then
            center.hovered_dismiss_slot = nil
         end
         dismiss_btn.bg = beautiful.bg_normal
         dismiss_btn.fg = dismiss_fg
      end
   end

   dismiss_btn:connect_signal("mouse::enter", function()
      set_dismiss_hover(true)
   end)

   dismiss_btn:connect_signal("mouse::leave", function()
      set_dismiss_hover(false)
   end)

   dismiss_btn:buttons(gears.table.join(awful.button({}, BUTTON_LEFT, function()
      center.hovered_dismiss_slot = slot_idx
      is_dismiss_hovered = true
      noti:remove_unread(entry.id)
   end)))

   local header_row = wibox.widget({
      {
         markup = "<b>" .. title_escaped .. "</b>",
         font = beautiful.notification_font or beautiful.font,
         ellipsize = "end",
         widget = wibox.widget.textbox,
      },
      nil,
      {
         {
            markup = helpers.colorize_text(time_str, beautiful.nord9 or beautiful.fg_normal),
            font = beautiful.font,
            widget = wibox.widget.textbox,
         },
         dismiss_btn,
         spacing = dpi(6),
         layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal,
   })

   local body_box = wibox.widget({
      markup = entry.message ~= "" and entry.message or "",
      font = beautiful.font,
      widget = wibox.widget.textbox,
   })

   body_box:connect_signal("mouse::enter", function()
      if is_dismiss_hovered then
         set_dismiss_hover(false)
      end
   end)

   local content_col = wibox.widget({
      header_row,
      body_box,
      spacing = dpi(4),
      layout = wibox.layout.fixed.vertical,
   })

   local row_children = {
      spacing = dpi(10),
      layout = wibox.layout.fixed.horizontal,
   }

   if entry.icon then
      table.insert(
         row_children,
         wibox.widget({
            image = entry.icon,
            resize = true,
            forced_width = ICON_SIZE,
            forced_height = ICON_SIZE,
            widget = wibox.widget.imagebox,
         })
      )
   end

   table.insert(
      row_children,
      wibox.widget({
         content_col,
         width = POPUP_WIDTH - (entry.icon and (ICON_SIZE + dpi(56)) or dpi(44)),
         strategy = "exact",
         widget = wibox.container.constraint,
      })
   )

   local card = wibox.widget({
      {
         row_children,
         margins = CARD_PADDING,
         widget = wibox.container.margin,
      },
      bg = beautiful.bg_normal,
      fg = beautiful.fg_normal,
      shape = helpers.rrect(beautiful.border_radius or dpi(6)),
      border_width = CARD_BORDER_WIDTH,
      border_color = is_dismiss_hovered and (beautiful.border_focus or beautiful.nord8) or border_color,
      widget = wibox.container.background,
   })

   card:connect_signal("mouse::enter", function()
      card.border_color = beautiful.border_focus or beautiful.nord8
   end)

   card:connect_signal("mouse::leave", function()
      card.border_color = border_color
      if is_dismiss_hovered then
         set_dismiss_hover(false)
      end
   end)

   card:buttons(gears.table.join(
      awful.button({}, BUTTON_LEFT, function()
         if is_dismiss_hovered then
            return
         end
         noti:activate_unread(entry.id)
         center.hide()
      end),
      awful.button({}, BUTTON_RIGHT, function()
         noti:remove_unread(entry.id)
      end),
      awful.button({}, WHEEL_UP, function()
         center.scroll(-1)
      end),
      awful.button({}, WHEEL_DOWN, function()
         center.scroll(1)
      end)
   ))

   return card
end

-- Build the full Notification Center widget tree for current unread state
local function build_popup_widget()
   local unread = noti.unread
   local total = #unread
   clamp_offset(total)

   local clear_btn = wibox.widget({
      markup = total > 0 and helpers.colorize_text("Clear all", beautiful.nord8 or beautiful.fg_focus) or "",
      font = beautiful.font,
      widget = wibox.widget.textbox,
   })

   if total > 0 then
      clear_btn:buttons(gears.table.join(awful.button({}, BUTTON_LEFT, function()
         noti:clear_unread()
      end)))
   end

   local range_label = ""
   if total > MAX_VISIBLE_ITEMS then
      local last_idx = math.min(total, center.scroll_offset + MAX_VISIBLE_ITEMS - 1)
      range_label = string.format(" (%d-%d/%d)", center.scroll_offset, last_idx, total)
   elseif total > 0 then
      range_label = string.format(" (%d)", total)
   end

   local header = wibox.widget({
      {
         markup = "<b>Notifications" .. range_label .. "</b>",
         font = beautiful.notification_font or beautiful.font,
         widget = wibox.widget.textbox,
      },
      nil,
      clear_btn,
      layout = wibox.layout.align.horizontal,
   })

   local list_layout = wibox.widget({
      spacing = dpi(CARD_SPACING),
      layout = wibox.layout.fixed.vertical,
   })

   if total == 0 then
      list_layout:add(wibox.widget({
         {
            markup = helpers.colorize_text("No unread notifications", beautiful.nord9 or beautiful.fg_normal),
            align = "center",
            valign = "center",
            font = beautiful.font,
            widget = wibox.widget.textbox,
         },
         margins = dpi(20),
         widget = wibox.container.margin,
      }))
   else
      local last_idx = math.min(total, center.scroll_offset + MAX_VISIBLE_ITEMS - 1)
      local slot_idx = 1
      for i = center.scroll_offset, last_idx do
         list_layout:add(build_card(unread[i], slot_idx))
         slot_idx = slot_idx + 1
      end
   end

   local root_box = wibox.widget({
      {
         header,
         list_layout,
         spacing = dpi(10),
         layout = wibox.layout.fixed.vertical,
      },
      margins = dpi(POPUP_MARGIN),
      forced_width = dpi(POPUP_WIDTH),
      widget = wibox.container.margin,
   })

   root_box:buttons(gears.table.join(
      awful.button({}, WHEEL_UP, function()
         center.scroll(-1)
      end),
      awful.button({}, WHEEL_DOWN, function()
         center.scroll(1)
      end)
   ))

   return root_box
end

-- Re-sync AwesomeWM drawable hover state after widget tree rebuild under stationary cursor
local function sync_drawable_mouse()
   if not gears.timer or type(gears.timer.delayed_call) ~= "function" then
      return
   end

   gears.timer.delayed_call(function()
      if not center.popup or not center.popup.visible or not mouse then
         return
      end

      local d = center.popup._drawable and center.popup._drawable.drawable
      if not d or type(center.popup.geometry) ~= "function" then
         return
      end

      local geo = center.popup:geometry()
      local m = mouse.coords()
      if geo and m then
         d:emit_signal("mouse::move", m.x - geo.x, m.y - geo.y)
      end
   end)
end

function center.refresh()
   if not center.popup or not center.popup.visible then
      return
   end
   center.popup.widget = build_popup_widget()
   sync_drawable_mouse()
end

function center.scroll(delta)
   local total = #noti.unread
   if total <= MAX_VISIBLE_ITEMS then
      return
   end

   center.scroll_offset = center.scroll_offset + delta
   clamp_offset(total)
   center.refresh()
end

function center.show(s)
   local target_screen = s or awful.screen.focused()
   center.hovered_dismiss_slot = nil
   if not center.popup then
      center.popup = awful.popup({
         ontop = true,
         visible = false,
         bg = beautiful.bg_normal,
         fg = beautiful.fg_normal,
         border_width = POPUP_BORDER_WIDTH,
         border_color = beautiful.border_focus or beautiful.nord8,
         shape = helpers.rrect(beautiful.border_radius or dpi(6)),
         widget = build_popup_widget(),
      })
   end

   center.scroll_offset = 1
   center.popup.screen = target_screen
   center.popup.widget = build_popup_widget()
   awful.placement.top_right(center.popup, {
      honor_workarea = true,
      margins = beautiful.screen_margin or dpi(5),
   })
   center.popup.visible = true
end

function center.hide()
   center.hovered_dismiss_slot = nil
   if center.popup then
      center.popup.visible = false
   end
end

function center.toggle(s)
   if center.popup and center.popup.visible then
      center.hide()
   else
      center.show(s)
   end
end

noti:subscribe(function()
   center.refresh()
end)

return center
