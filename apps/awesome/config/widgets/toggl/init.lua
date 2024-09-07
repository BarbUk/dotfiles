--[[

     Licensed under GNU General Public License v2
      * (c) 2017, Julien Virey

--]]

local helpers = require("lain.helpers")
local wibox   = require("wibox")
local shell   = require("awful.util").shell
local gstring = require("gears.string")
local naughty = require("naughty")
local setmetatable = setmetatable

local toggl = {}

local function worker(args)
    args = args or {}
    local timeout       = args.timeout or 30
    local settings      = args.settings or function() end

    toggl.cmd      = args.cmd or "toggl"
    toggl.widget   = wibox.widget.textbox()

    function toggl.update()
        helpers.async({shell, "-c", toggl.cmd}, function(output)
            widget = toggl.widget
            toggl.now = output
            settings()
        end)
    end

    helpers.newtimer("toggl", timeout, toggl.update)
    return toggl
end


return setmetatable(toggl, { __call = function(_, ...) return worker(...) end })
