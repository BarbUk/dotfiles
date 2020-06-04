local awful       = require('awful')
local pulse_sink  = "@DEFAULT_SINK@"
local step        = 5
local scripts_dir = os.getenv("HOME") .. "/.dotfiles/bin/"

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
    scripts = scripts_dir,
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
  },

  osd = {
     volume = {
      up   = function()
        awful.spawn.easy_async(scripts_dir .. "vol_bar up", function(stdout)
          noti:notify(stdout)
        end)
      end,
      down   = function()
      awful.spawn.easy_async(scripts_dir .. "vol_bar down", function(stdout)
          noti:notify(stdout)
        end)
      end,
      mute   = function()
        awful.spawn.easy_async(scripts_dir .. "vol_bar mute", function(stdout)
          noti:notify(stdout)
        end)
      end
    },

    brightness = {
      up = 'light -A ' .. step,
      down = 'light -U ' .. step,
      get = 'light'
    }
  }
}
