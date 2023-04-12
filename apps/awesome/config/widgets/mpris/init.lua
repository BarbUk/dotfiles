--[[

     Licensed under GNU General Public License v2
      * (c) 2017, Julien Virey

--]]

local helpers      = require("lain.helpers")
local wibox        = require("wibox")
local shell        = require("awful.util").shell
local htmlEntities = require('htmlEntities')
local setmetatable = setmetatable

local mpris = {}

local function worker(args)
    local args       = args or {}
    local timeout    = args.timeout or 5
    local settings   = args.settings or function() end

    mpris.cmd      = args.cmd or "playerctl --format '{{status}}\n{{xesam:artist}}\n{{markup_escape(xesam:title)}}' metadata"
    mpris.widget   = wibox.widget.textbox()

    function mpris.update()

        mpris_now = {}
        local now = {}
        helpers.async({shell, "-c", mpris.cmd}, function(output)
            for s in output:gmatch("[^\n]+") do
                table.insert(now, s)
            end
            mpris_now = {
                status = now[1],
                artist = htmlEntities.encode(now[2]),
                title = htmlEntities.encode(now[3]),
            }
            widget = mpris.widget
            settings()
        end)
    end

    helpers.newtimer("mpris", timeout, mpris.update)

    return mpris
end

return setmetatable(mpris, { __call = function(_, ...) return worker(...) end })
