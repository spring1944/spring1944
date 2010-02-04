function gadget:GetInfo()
	return {
		name      = "Infantry Suppression",
		desc      = "Lua Implementation of fear weapons causing suppression",
		author    = "FLOZi",
		date      = "13 October 2008", -- Happy Birthday Charlie!
		license   = "CC by-nc, version 3.0",
		layer     = 0,
		enabled   = true
	}
end

-- function localisations
-- Synced Read
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitDefID       		= Spring.GetUnitDefID
local GetUnitAllyTeam			= Spring.GetUnitAllyTeam
-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local SetUnitExperience			= Spring.SetUnitExperience
-- constants

-- variables

local targets = {}
local blockAllyTeams = {}

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:Explosion(weaponId, px, py, pz, ownerID)
	local weapDef = WeaponDefs[weaponId]
	
	if not weapDef.customParams.fearid then return false end
  
	local unitsAtSpot = GetUnitsInCylinder(px, pz, weapDef.customParams.fearaoe)
	
	-- if the weapon is a howitzer shell reset the gun's experience to 0
	if weapDef.customParams.howitzer then
		--SetUnitExperience(ownerID, 0)
	end
	
	--local fearBlockerFound	= false
	for i = 1, #unitsAtSpot do
		local unitId = unitsAtSpot[i]
		local ud = UnitDefs[GetUnitDefID(unitId)]
		if ud.customParams.blockfear == "1" then
			blockAllyTeams[GetUnitAllyTeam(unitId)] = true
		elseif ud.customParams.feartarget then
			table.insert(targets, unitId)
		end
	end
	
	for i = 1, #targets do
		local unitId = targets[i]
		if unitId ~= ownerID and not blockAllyTeams[GetUnitAllyTeam(unitId)] then
			Spring.CallCOBScript(unitId, "HitByWeaponId", 0, 0, 0, weapDef.customParams.fearid, 0)
		end
		targets[i] = nil
	end
		targets = {}
		blockAllyTeams = {}
	return false
end


function gadget:Initialize()
	for weaponId, weaponDef in pairs (WeaponDefs) do
		if weaponDef.customParams.fearid then
			--Spring.Echo(weaponDef.name) -- useful for debugging
			Script.SetWatchWeapon(weaponId, true)
		end
	end
end

else
-- UNSYNCED
end
