local gears = require("gears")
local awful = require("awful")

local navigation = require("config.keys.navigation")
local system = require("config.keys.system")
local launcher = require("config.keys.launcher")

local globalkeys = gears.table.join(navigation, system, launcher)

-- Set keys
root.keys(globalkeys)

-- Set Mouse bindings
root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))

return {
   mod = require("config.keys.mod"),
   global = globalkeys,
}
