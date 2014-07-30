
function widget:GetInfo()
  return {
    name      = "Auto First Build Facing",
    desc      = "Set buildfacing toward map center on the first building placed",
    author    = "zwzsg with lotsa help from #lua channel",
    date      = "October 26, 2008",
    license   = "Free",
    layer     = 0,
    enabled   = true  -- loaded by default
  }
end


-- Set buildfacing the first time a building is about to be built
function widget:Update()
  local _,cmd=Spring.GetActiveCommand()
  if cmd and cmd<0 then
    x,_,z=Spring.GetTeamStartPosition(Spring.GetMyTeamID())
    local facing
    if math.abs(Game.mapSizeX - 2*x) > math.abs(Game.mapSizeZ - 2*z) then
      if (2*x>Game.mapSizeX) then
        facing="west"
      else
        facing="east"
      end
    else
      if (2*z>Game.mapSizeZ) then
        facing="north"
      else
        facing="south"
      end
    end
    Spring.SendCommands({"buildfacing "..facing})
    widgetHandler:RemoveWidget()
  end
end
