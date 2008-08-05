-- $Id: main.lua 2491 2008-07-17 13:36:51Z det $


AllowUnsafeChanges("USE AT YOUR OWN PERIL")
--
--  Allows the use of the following call-outs when
--  not in the GameFrame() or GotChatMsg() call-ins:
--
--    CreateUnit()
--    DestroyUnit()
--    TransferUnit()
--    CreateFeature()
--    DestroyFeature()
--    TransferFeature()
--    GiveOrderToUnit()
--    GiveOrderToUnitMap()
--    GiveOrderToUnitArray()
--    GiveOrderArrayToUnitMap()
--    GiveOrderArrayToUnitArray()
--
--  *** The string argument must be an exact match ***


if (select == nil) then
  select = function(n,...) return arg[((n=='#') and 'n')or n] end
end


do  --  wrap print() in a closure
  local origPrint = print
  print = function(arg1,...)
    if (arg1) then
      arg1 = Script.GetName() .. ': ' .. tostring(arg1)
    end
    origPrint(arg1, ...)
  end
end


function tprint(t)
  for k,v in pairs(t) do
    Spring.Echo(k, tostring(v))
  end
end


local allModOptions = Spring.GetModOptions()
function Spring.GetModOption(s,bool,default)
  if (bool) then
    local modOption = allModOptions[s]
    if (modOption==nil) then modOption = (default and "1") end
    return (modOption=="1")
  else
    local modOption = allModOptions[s]
    if (modOption==nil) then modOption = default end
    return modOption
  end
end


if (Spring.GetModOption("gamemode")=="deploy")or
   (Spring.GetModOption("gamemode")=="tactics")
then

  -----------------------------
  -- DEPLOYMENT MODE
  -----------------------------
  if (not Spring.IsDevLuaEnabled()) then
    VFS.Include(Script.GetName() .. "/Deploy/main.lua", nil, VFS.ZIP_ONLY)
    Spring.Echo("LUARULES-DRAW  (DEPLOYMENT)")
  else
    VFS.Include(Script.GetName() .. "/Deploy/main.lua", nil, VFS.ZIP_ONLY)
    Spring.Echo("LUARULES-DRAW  (DEPLOYMENT)  --  DEVMODE")
  end

else

  -----------------------------
  -- NORMAL MODE
  -----------------------------
  if (not Spring.IsDevLuaEnabled()) then
    VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.ZIP_ONLY)
    Spring.Echo("LUARULES-DRAW  (GADGETS)")
  else
    VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.ZIP_ONLY)
    Spring.Echo("LUARULES-DRAW  (GADGETS)  --  DEVMODE")
  end

end
