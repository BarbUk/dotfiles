local suspicious = {
   { "curl[%s]+[^%s]-|[%s]*[sb]h", "pipe from curl into shell" },
   { "wget[%s]+[^%s]-|[%s]*[sb]h", "pipe from wget into shell" },
   { "base64[%s]+-%-decode", "base64 decode" },
   { "base64[%s]+-d", "base64 decode" },
   { "eval[%s]*%$[%s]*%(", "eval on command substitution" },
   { "chmod[%s]+%+s", "setuid bit" },
   { "chmod[%s]+4", "setuid bit" },
   { "/etc/shadow", "access to /etc/shadow" },
   { "/etc/passwd", "access to /etc/passwd" },
   { "python[%d]*%s+%-c%s*['\"]import", "inline python execution" },
   { "\\x%x%x[^%c]-\\x%x%x", "hex-encoded strings" },
   { "nc[%s]+-[elp]", "netcat listener/exec" },
   { "/dev/tcp/", "bash reverse shell" },
   { "mkfifo", "named pipe (potential reverse shell)" },
}

yay.create_autocmd("AURPreInstall", {
   desc = "flag potentially compromised PKGBUILDs",
   callback = function(event)
      local pkgbuild = event.data.pkgbuild
      local name = event.match
      local warnings = {}

      for _, check in ipairs(suspicious) do
         if pkgbuild:match(check[1]) then
            table.insert(warnings, check[2])
         end
      end

      if #warnings > 0 then
         yay.log.warn(name .. ": PKGBUILD contains suspicious patterns:")
         for _, w in ipairs(warnings) do
            yay.log.warn("  ⚠ " .. w)
         end
         yay.log.warn("Review the PKGBUILD carefully before proceeding.")
      end
   end,
})
