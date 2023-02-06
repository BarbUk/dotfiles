local awful       = require('awful')
local pulse_sink  = "@DEFAULT_SINK@"
local step        = 5
local scripts_dir = os.getenv("HOME") .. "/.dotfiles/bin/"
local music_player_client = 'mpc'
local mpris_player_client = 'mprisctl'
local timezone = {
  france = 'Europe/Paris',
  mauritius = 'Indian/Mauritius',
  canada = 'America/Toronto',
}

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

  timezone = timezone,

  weather = {
    w01d = '滛',
    w01n = '望',
    w02d = '滛',
    w02n = '望',
    w03d = '杖',
    w03n = '杖',
    w04d = '摒',
    w04n = '摒',
    w09d = '殺',
    w09n = '殺',
    w10d = '歹',
    w10n = '歹',
    w11d = '朗',
    w11n = '朗',
    w13d = '流',
    w13n = '流',
    w50d = '',
    w50n = '',
  },

  alt = {
    terminal = 'wezterm',
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
      toggle = "pulseaudio_toggle_default_sink",
    },

    brightness = {
      up = 'light -A ' .. step,
      down = 'light -U ' .. step,
      get = 'light'
    },

    player = {
      next = mpris_player_client .. ' next',
      prev = mpris_player_client .. ' previous',
      toggle = mpris_player_client .. ' play-pause',
      stop = mpris_player_client .. ' stop'
    },

    mpd = {
      next = music_player_client .. ' next',
      prev = music_player_client .. ' previous',
      toggle = music_player_client .. ' toggle',
      stop = music_player_client .. ' stop',
    },

    picom = {
      toggle = 'toggle_picom',
    },

    timezone = {
      france = 'timedatectl set-timezone ' .. timezone.france,
      mauritius = 'timedatectl set-timezone ' .. timezone.mauritius,
      canada = 'timedatectl set-timezone ' .. timezone.canada,
    }

  },

  osd = {
     volume = {
      up = function()
        awful.spawn.easy_async("vol_bar up", function(stdout)
          noti:notify(stdout)
        end)
      end,
      down = function()
      awful.spawn.easy_async("vol_bar down", function(stdout)
          noti:notify(stdout)
        end)
      end,
      mute = function()
        awful.spawn.easy_async("vol_bar mute", function(stdout)
          noti:notify(stdout)
        end)
      end
    },

    brightness = {
      up = function()
        awful.spawn.easy_async("light_bar up", function(stdout)
          noti:notify(stdout)
        end)
      end,
      down = function()
        awful.spawn.easy_async("light_bar down", function(stdout)
          noti:notify(stdout)
        end)
      end,
    },

    player = {
      stop = function()
        os.execute(mpris_player_client .. " stop", false)
      end,
      toggle = function()
        os.execute(mpris_player_client .. " play-pause", false)
      end,
      prev = function()
        os.execute(mpris_player_client .. " previous", false)
      end,
      next = function()
        os.execute(mpris_player_client .. " next", false)
      end,
    }
  }
}
