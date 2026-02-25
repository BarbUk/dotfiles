-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Garbage collection tuning
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- beautiful init
local chosen_theme = "barbuk"
local theme_path = string.format("%s/themes/%s/base.lua", gears.filesystem.get_configuration_dir(), chosen_theme)
local success, _ = pcall(beautiful.init, theme_path)
if not success then
   beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
end

require("config.notifications")
require("config.client")
require("config.tags")
require("config.tasks")
require("config.utils")
require("config.keys")
require("config.focus")
