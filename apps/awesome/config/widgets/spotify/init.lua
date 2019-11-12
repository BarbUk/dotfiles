--[[

     Licensed under GNU General Public License v2
      * (c) 2017, Julien Virey

--]]

local helpers      = require("lain.helpers")
local wibox        = require("wibox")
local shell        = require("awful.util").shell
local setmetatable = setmetatable

-- Spotify
-- lain.widgets.contrib.spotify
local spotify = {}

local function worker(args)
    local args       = args or {}
    local timeout    = args.timeout or 5
    local settings   = args.settings or function() end

    spotify.cmd      = args.cmd or "sp metadata"

    spotify.widget   = wibox.widget.textbox()

    function spotify.update()

        helpers.async({shell, "-c", spotify.cmd}, function(output)
            spotify_now = {
                artist = string.match(output, "artist|(.-)[\n]") or "not_running",
                title  = string.match(output, "title|(.-)[\n]") or "not_running",
                state  = string.match(output, "state|(.-)[\n]") or "not_running"
            }

            widget = spotify.widget
            settings()
        end)
    end

    helpers.newtimer("spotify", timeout, spotify.update)

    return spotify
end

return setmetatable(spotify, { __call = function(_, ...) return worker(...) end })
