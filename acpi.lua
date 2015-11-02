function getCharge()
   local acpiString = io.popen('acpi'):read()
   if(acpiString == nil) then
      return nil
   else
      if(string.match(acpiString, "power_supply") == "power_supply") then
	 return nil
      end
      local pfull = string.match(acpiString, ', (%d+)%%')
      return pfull
   end
end

return getCharge
