local pulse_sink      = "@DEFAULT_SINK@"
local step      = 5

return {
  -- List of apps to start by default on some actions
  default = {
    terminal    = 'termite',
    editor      = 'subl',
    lock        = 'slock',
    filemanager = 'pcmanfm',
    browser     = 'google-chrome-stable',
    graphics    = "gimp",
  },

  alt = {
    terminal = 'alacritty',
    editor   = 'gvim',
    browser  = 'firefox',
  },

  dir = {
    scripts = os.getenv("HOME") .. "/.dotfiles/bin/",
  },

  cmd = {

    volume = {
      up   = "pamixer --increase " .. step .. " --sink " .. pulse_sink,
      down = "pamixer --decrease " .. step .. " --sink " .. pulse_sink,
      mute = "pamixer --toggle-mute --sink " .. pulse_sink,
    },

    brightness = {
      up = 'light -A ' .. step,
      down = 'light -U ' .. step,
      get = 'light',
      get = 'light'
    },

    player = {
      next = 'playerctl next',
      prev = 'playerctl previous',
      toggle = 'playerctl play-pause',
      stop = 'playerctl stop'
    },

    mpd = {
      next = 'mpd next',
      prev = 'mpd previous',
      toggle = 'mpc toggle',
      stop = 'mpc stop',
    }

  }
}
