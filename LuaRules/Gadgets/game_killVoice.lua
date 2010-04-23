function gadget:GetInfo()
	return {
		name = "Kill Voice",
		desc = "Makes certain units say things when they kill something",
		author = "yuritch",
		date = "2009-06-05",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end

-- use the custom param killvoice=1 (capitalization doesn't matter in a .fbi, only
-- in a .lua unit definition) to mark a unit as viable for saying things after it kills something:
--
-- [customParams]
-- {
--     killvoice=1;
-- }
--
-- the unit must also have a KillVoice() BOS function, that will get called when it's time to say funny things


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if gadgetHandler:IsSyncedCode() then
		if attackerID ~= nil then
			if UnitDefs[attackerDefID].customParams.killvoice=="1" then
				Spring.CallCOBScript(attackerID, "KillVoice", 0)
			end
		end
	end
end
