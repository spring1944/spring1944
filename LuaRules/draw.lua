
--
-- 0.75b2 compatibilty
--
if (Spring.GetTeamColor == nil) then
  local getTeamInfo = Spring.GetTeamInfo
  Spring.GetTeamColor = function(teamID)
    local _,_,_,_,_,_,r,g,b,a = getTeamInfo(teamID)
    return r, g, b, a
  end
  Spring.GetTeamInfo = function(teamID)
    local id, leader, active, isDead, isAi, side,
          r, g, b, a, allyTeam = getTeamInfo(teamID)
    return id, leader, active, isDead, isAi, side, allyTeam
  end
end


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

local allModOptions = Spring.GetModOptions()
function Spring.GetModOption(s,bool)
  if (bool) then
    return (allModOptions[s]=="1")
  else
    return allModOptions[s]
  end
end


if (Spring.GetModOption("gamemode")=="deploy")or
   (Spring.GetModOption("gamemode")=="tactics")
then

  -----------------------------
  -- DEPLOYMENT MODE
  -----------------------------
  if (not Spring.IsDevLuaEnabled()) then
    VFS.Include(Script.GetName() .. "/Deploy/draw.lua", nil, VFS.ZIP_ONLY)
    Spring.Echo("LUARULES-DRAW  (DEPLOYMENT)")
  else
    VFS.Include(Script.GetName() .. "/Deploy/draw.lua", nil, VFS.RAW_ONLY)
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
    VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.RAW_ONLY)
    Spring.Echo("LUARULES-DRAW  (GADGETS)  --  DEVMODE")
  end

end
