-- $Id$

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


if (select == nil) then
  select = function(n,...) 
    local arg = arg
    if (not arg) then arg = {...}; arg.n = #arg end
    return arg[((n=='#') and 'n')or n]
  end
end


do  --  wrap print() in a closure
  local origPrint = print
  print = function(arg1,...)
    if (arg1) then
      arg1 = '>> ' .. tostring(arg1)
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


if (Spring.GetModOption("gamemode")=="1")
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
