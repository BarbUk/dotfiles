local lain = require("lain")
local secrets = require("config.secrets")
local apps = require("config.apps")

local weather = lain.widget.weather({
   lat = secrets.weather.lat,
   lon = secrets.weather.lon,
   APPID = secrets.weather.appid,
   cnt = 40,
   units = "metric",
   lang = "fr",
   settings = function()
      local descr = weather_now["weather"][1]["description"]
      local units = math.floor(weather_now["main"]["temp"])
      widget:set_markup(" " .. units .. "°C")
   end,
   notification_text_fun = function(wn)
      local day = os.date("%a	%H", wn["dt"])
      local temp = math.floor(wn["main"]["temp"])
      local humi = math.floor(wn["main"]["humidity"])
      local wind = math.floor(wn["wind"]["speed"])
      local desc = wn["weather"][1]["description"]
      local icon = "w" .. wn["weather"][1]["icon"]
      return string.format("<b>%s %sh</b>: %d°C %d%% %d %s", apps.weather[icon], day, temp, humi, wind, desc)
   end,
})

return weather
