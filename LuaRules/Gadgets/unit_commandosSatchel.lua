function gadget:GetInfo()
	return {
		name      = "Satchels for Commandos",
		desc      = "Takes care of satchel building, supplying etc.",
		author    = "ashdnazg",
		date      = "29 Sep 2014",
		license   = "LGPL v2",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED
-- function localisations
-- Synced Read
local GetUnitRulesParam = Spring.GetUnitRulesParam
-- Synced Ctrl
local SetUnitRulesParam = Spring.SetUnitRulesParam
-- variables
local satchelIDs = {}

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if satchelIDs[unitDefID] then
		local ammoLevel = GetUnitRulesParam(builderID, "ammo")
		SetUnitRulesParam(builderID, "ammo",	ammoLevel - 1)
	end
end

function gadget:AllowUnitCreation(unitDefID, builderID)
	if satchelIDs[unitDefID] then
		local ammoLevel = GetUnitRulesParam(builderID, "ammo")
		return ammoLevel > 0
	end
	return true
end

function gadget:Initialize()
	for unitDefID, unitDef in pairs (UnitDefs) do
		if unitDef.customParams and unitDef.customParams.candetonate then
			satchelIDs[unitDefID] = true
		end
	end
end

end