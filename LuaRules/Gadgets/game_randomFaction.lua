function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Random faction",
		desc      = "Sets player to random faction (if GM mode is off)",
		author    = "Nemo",
		date      = "17 May 2009",
		license   = "Public domain",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if not gadgetHandler:IsSyncedCode() then return end


function gadget:GameFrame(n)
	if n == 1 then
		local modOptions = Spring.GetModOptions()
		if (modOptions.gm_team_enable == "0") then
			for _, unitID in ipairs(Spring.GetAllUnits()) do
				local udid = Spring.GetUnitDefID(unitID)
				local ud = UnitDefs[udid]
				if (ud.customParams.gm) then
					local x,y,z = Spring.GetUnitPosition(unitID)
					local teamID = Spring.GetUnitTeam(unitID)
					local randomComm = math.random(1,4)
					if randomComm == 1 then
						Spring.CreateUnit("gerhqbunker", x, y, z, 0, teamID)
					end
					if randomComm == 2 then
						Spring.CreateUnit("ushq", x, y, z, 0, teamID)
					end
					if randomComm == 3 then
						Spring.CreateUnit("ruscommander", x, y, z, 0, teamID)
					end
					if randomComm == 4 then
						Spring.CreateUnit("gbrhq", x, y, z, 0, teamID)
					end
				Spring.DestroyUnit(unitID, false, true)
				end
			end
		end
	end
	--[[if (n==10) then
		gadgetHandler:RemoveGadget()
	end]]--
end
