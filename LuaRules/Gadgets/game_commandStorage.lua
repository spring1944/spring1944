function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Command/Logisticsf Storage",
		desc      = "Sets command storage at the beginning of the game.",
		author    = "Evil4Zerggin",
		date      = "21 February 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if not gadgetHandler:IsSyncedCode() then return end

local SetTeamResource = Spring.SetTeamResource
local GetTeamResources = Spring.GetTeamResources

function gadget:GameFrame(n)
	if n > 32 then
		local modOptions = Spring.GetModOptions()
		local commandStorage = tonumber(modOptions.command_storage) or 1000
		if modOptions.gametype ~= 1 then
			if commandStorage > 0 then
				local teamIDs = Spring.GetTeamList()
				for i=1, #teamIDs do
					local teamID = teamIDs[i]
					SetTeamResource(teamID, "es", 1041) --ugly, but effective for now
					local _, currStorage = GetTeamResources(teamID, "metal")
					if commandStorage > currStorage then
						SetTeamResource(teamID, "ms", commandStorage)
						SetTeamResource(teamID, "m", 1000) -- make sure rus also starts with 1k command
					end
				end
			end
		end
		gadgetHandler:RemoveGadget()
	end
end
