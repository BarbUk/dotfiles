local naughty = require("naughty")
local module_path = ...

local noti = {
   notification = nil,
   suspended = false,
   unread = {},
   listeners = {},
   next_id = 1,
}

package.loaded[module_path] = noti

function noti:subscribe(fn)
   table.insert(self.listeners, fn)
end

function noti:emit_changed()
   for _, fn in ipairs(self.listeners) do
      fn(self)
   end
end

function noti:notify(message, preset)
   if self.notification and not self.notification.is_expired then
      self.notification.message = tostring(message)
      return
   end

   self.notification = naughty.notification({
      preset = preset or naughty.config.presets.low,
      message = tostring(message),
      ignore_suspend = true,
   })
end

function noti:add_unread(item)
   local id = self.next_id
   self.next_id = id + 1

   local entry = {
      id = id,
      title = item.title or "",
      message = item.message or "",
      app_name = item.app_name or "",
      icon = item.icon,
      urgency = item.urgency or "normal",
      timestamp = item.timestamp or os.time(),
      clients = item.clients or {},
      client_names = item.client_names or {},
      actions = item.actions or {},
      run = item.run,
   }

   table.insert(self.unread, 1, entry)
   self:emit_changed()
   return id
end

function noti:remove_unread(id)
   for idx, entry in ipairs(self.unread) do
      if entry.id == id then
         table.remove(self.unread, idx)
         self:emit_changed()
         return entry
      end
   end
   return nil
end

function noti:clear_unread()
   if #self.unread == 0 then
      return
   end

   self.unread = {}
   self:emit_changed()
end

-- Focus the originating client window if still open
local function jump_to_entry_client(entry)
   for _, c in ipairs(entry.clients) do
      if c and c.valid ~= false and type(c.jump_to) == "function" then
         c:jump_to()
         return true
      end
   end

   if not client or type(client.get) ~= "function" then
      return false
   end

   local all_clients = client.get()
   for _, target_name in ipairs(entry.client_names) do
      for _, c in ipairs(all_clients) do
         if c.name == target_name and type(c.jump_to) == "function" then
            c:jump_to()
            return true
         end
      end
   end

   if entry.app_name ~= "" then
      local app_norm = entry.app_name:lower():gsub("[%s%-_]+", "")
      for _, c in ipairs(all_clients) do
         local class_norm = c.class and c.class:lower():gsub("[%s%-_]+", "") or ""
         if class_norm:find(app_norm, 1, true) and type(c.jump_to) == "function" then
            c:jump_to()
            return true
         end
      end
   end

   return false
end

function noti:activate_unread(id)
   local entry = self:remove_unread(id)
   if not entry then
      return false
   end

   if type(entry.run) == "function" then
      pcall(entry.run, entry)
   elseif entry.actions and entry.actions[1] and type(entry.actions[1].invoke) == "function" then
      pcall(function()
         entry.actions[1]:invoke()
      end)
   end

   jump_to_entry_client(entry)
   return true
end

function noti:toggle()
   self.suspended = not self.suspended
   if self.suspended then
      self:notify("Notifications suspended")
   else
      self:notify("Notifications resumed")
   end
   self:emit_changed()
end

require(module_path .. ".default")
require(module_path .. ".errors")

return noti
