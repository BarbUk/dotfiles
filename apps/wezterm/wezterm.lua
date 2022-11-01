local wezterm = require 'wezterm'
local act = wezterm.action

return {
  font = wezterm.font 'PragmataProMonoLiga Nerd Font',
  font_size = 12,
  adjust_window_size_when_changing_font_size = false,
  color_scheme = "Solarized Light (base16)",
  colors = {
    -- The default text color
    foreground = '#34484E',
  },
  scrollback_lines = 35000,
  hide_tab_bar_if_only_one_tab = true,
  default_cursor_style = 'BlinkingBar',
  animation_fps = 1,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
   keys = {
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ''
        if has_selection then
          window:perform_action(
            act.CopyTo 'ClipboardAndPrimarySelection',
            pane
          )

          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(
            act.SendKey { key = 'c', mods = 'CTRL' },
            pane
          )
        end
      end),
    },
  },
  mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=act.CompleteSelection("PrimarySelection"),
    },

    -- and make CTRL-Click open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="CTRL",
      action=act.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.Nop,
    }
  },
   window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
