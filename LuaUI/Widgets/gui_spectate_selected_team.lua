function widget:GetInfo()
  return {
    name      = "Spectate selected team",
    desc      = "Switch to viewing a team based on selected units on spectator mode",
    author    = "ashdnazg",
    date      = "19 May 2015",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local currentTeam

function widget:Update(dt)
	local units = Spring.GetSelectedUnits()
	if units and units[1] then
		local unitTeam = Spring.GetUnitTeam(units[1])
		if unitTeam ~= currentTeam then
			Spring.SendCommands("specteam ".. unitTeam)
			currentTeam = unitTeam
		end
	end
end

function widget:Initialize()
	local spec = Spring.GetSpectatingState()
	if not spec then
		WG.RemoveWidget(self)
	end
end
