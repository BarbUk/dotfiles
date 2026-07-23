local naughty = require("naughty")
require(... .. ".default")
require(... .. ".errors")

local noti = {}
noti.notification = nil
noti.suspended = false
noti.queue = {}
noti.queue_notification = nil

function noti:notify(message, preset)
   if self.notification and not self.notification.is_expired then
      self.notification.message = tostring(message)
   else
      if not preset then
         preset = naughty.config.presets.low
      end
      self.notification = naughty.notification({
         preset = preset,
         message = tostring(message),
         ignore_suspend = true,
      })
   end
end

function noti:update_queue_notification()
   local count = #self.queue
   if count == 0 then
      if self.queue_notification then
         naughty.destroy(self.queue_notification)
         self.queue_notification = nil
      end
      return
   end

   local message = string.format("Suspended • %d in queue", count)
   if self.queue_notification then
      self.queue_notification.message = message
   else
      self.queue_notification = naughty.notification({
         preset = naughty.config.presets.low,
         title = "Do Not Disturb",
         message = message,
         ignore_suspend = true,
         timeout = 0,
      })
   end
end

function noti:toggle()
   self.suspended = not self.suspended
   if self.suspended then
      self.queue = {}
      self:notify("Notifications suspended")
   else
      if self.queue_notification then
         naughty.destroy(self.queue_notification)
         self.queue_notification = nil
      end
      self:notify("Notifications resumed")
      -- Resend all queued notifications
      for _, item in ipairs(self.queue) do
         naughty.notification(item)
      end
      self.queue = {}
   end
end

return noti
