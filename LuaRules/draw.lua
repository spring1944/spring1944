
do  --  wrap print() in a closure
  local origPrint = print
  print = function(...)
    if (arg[1]) then
      arg[1] = '>> ' .. tostring(arg[1])
    end
    origPrint(unpack(arg))
  end
end


function tprint(t)
  for k,v in pairs(t) do
    Spring.Echo(k, tostring(v))
  end
end


if (not Spring.IsDevLuaEnabled()) then
  VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.ZIP_ONLY)
  Spring.Echo("LUARULES-DRAW  (GADGETS)")
else
  VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.RAW_ONLY)
  Spring.Echo("LUARULES-DRAW  (GADGETS)  --  DEVMODE")
end
