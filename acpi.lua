function getCharge()
   local acpiString = io.popen('acpi'):read()
   local pfull = string.match(acpiString, ', (%d+)%%')
   return pfull
end

return getCharge
