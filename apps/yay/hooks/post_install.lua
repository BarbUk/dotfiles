yay.create_autocmd("PostInstall", {
   desc = "post-install checks: orphans and pacnew files",
   callback = function()
      local handle

      handle = io.popen("pacman -Qtdq 2>/dev/null")
      if handle then
         local orphans = handle:read("*a")
         handle:close()
         if orphans and orphans ~= "" then
            local count = select(2, orphans:gsub("\n", "\n"))
            yay.log.warn(count .. " orphan(s) found, run: sudo pacman -Rns $(pacman -Qtdq)")
         end
      end

      handle = io.popen("find /etc -regextype posix-extended" .. " -regex '.*\\.pac(new|save|orig)$' 2>/dev/null")
      if handle then
         local pacfiles = handle:read("*a")
         handle:close()
         if pacfiles and pacfiles ~= "" then
            yay.log.warn("pacnew/pacsave files need attention:")
            for line in pacfiles:gmatch("[^\n]+") do
               yay.log.warn("  " .. line)
            end
         end
      end
   end,
})
