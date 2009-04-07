function widget:GetInfo()
	return {
		name = "1944 Player List Echo for Stats",
		desc = "echos players for stats purposes",
		author = "B. Tyler",
		date = "April 04 2009",
		license = "PD",
		layer = 1,
		enabled = true
	}
end

function widget:GameStart()
  	local plist = ""
	gaiaTeam = Spring.GetGaiaTeamID()
	for _, teamID in ipairs(Spring.GetTeamList()) do
		local teamLuaAI = Spring.GetTeamLuaAI(teamID)
		if ((teamLuaAI == nil or teamLuaAI == "") and teamID ~= gaiaTeam) then
			local _,_,_,ai,side,ally = Spring.GetTeamInfo(teamID)
			if (not ai) then 
				for _, pid in ipairs(Spring.GetPlayerList(teamID)) do
					local name, active, spec = Spring.GetPlayerInfo(pid)
					if active and not spec then plist = plist .. "," .. name end
				end
			end	
		end
	end
	Spring.Echo("STATS:plist"..plist)
  return
end
