function gadget:GetInfo()
	return {
		name      = "Ban Racists",
		desc      = "Bans racists",
		author    = "FLOZi (C.Lawrence)",
		date      = "5th June 2014",
		license   = "GNU GPL v2",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local racists = {["zCram"] = true}

function gadget:GameFrame(n)
	if n == 10 then -- wait a few frames for lua setup
		local playerList = Spring.GetPlayerList()
		for _, playerID in pairs(playerList) do
			local playerName, _, _, teamID = Spring.GetPlayerInfo(playerID)
			if racists[playerName] then
				Spring.SendMessageToTeam(teamID, "There is a racist on your team, goodbye.")
				Spring.KillTeam(teamID)
			end
		end
	end
end

else
-- UNSYNCED
end
