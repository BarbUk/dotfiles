require("config.widgets.bar")

return {
   mpris = require("config.widgets.mpris_widget"),
   volume = require("config.widgets.volume").helper,
   calendar = require("config.widgets.clock").calendar,
   fsroot = require("config.widgets.fsroot"),
}
