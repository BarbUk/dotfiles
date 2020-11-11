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
        os.execute(music_player_client .. " stop || " .. mpris_player_client .. " stop", false)
      end,
      toggle = function()
        os.execute(music_player_client .. " toggle || " .. mpris_player_client .. " play-pause", false)
      end,
      prev = function()
        os.execute(music_player_client .. " prev || " .. mpris_player_client .. " previous", false)
      end,
      next = function()
        os.execute(music_player_client .. " next || " .. mpris_player_client .. " next", false)
      end,
    }
  }
}
