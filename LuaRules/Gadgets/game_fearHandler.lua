function gadget:GetInfo()
	return {
		name      = "Infantry Suppression",
		desc      = "Lua Implementation of fear weapons causing suppression",
		author    = "FLOZi",
		date      = "13 October 2008", -- Happy Birthday Charlie!
		license   = "GNU CPL v2",
		layer     = 0,
		enabled   = true
	}
end

-- function localisations
-- Synced Read
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitDefID       		= Spring.GetUnitDefID
local GetUnitAllyTeam			= Spring.GetUnitAllyTeam
local ValidUnitID				= Spring.ValidUnitID
-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local SetUnitExperience			= Spring.SetUnitExperience
-- constants

-- variables

local targets = {}
local tLength = 0

local blockAllyTeams = {}

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	local weapDef = WeaponDefs[weaponID]
	local cp = weapDef.customParams
	local fearID = cp.fearid
	
	if not fearID then return false end
  
	local unitsAtSpot = GetUnitsInCylinder(px, pz, cp.fearaoe)
	
	-- if the weapon is a howitzer shell reset the gun's experience to 0
	if ValidUnitID(ownerID) and (cp.howitzer or cp.infgun) then
		SetUnitExperience(ownerID, 0)
	end
	
	for i = 1, #unitsAtSpot do
		local unitID = unitsAtSpot[i]
		local ud = UnitDefs[GetUnitDefID(unitID)]
		if ud.customParams.blockfear == "1" then
			blockAllyTeams[GetUnitAllyTeam(unitID)] = true
		elseif ud.customParams.feartarget then
			tLength = tLength + 1
			targets[tLength] = unitID
		end
	end
	
	for i = 1, tLength do
		local unitID = targets[i]
		if unitID ~= ownerID and not blockAllyTeams[GetUnitAllyTeam(unitID)] then
			Spring.CallCOBScript(unitID, "HitByWeaponId", 0, 0, 0, fearID, 0)
		end
	end
	-- reset tables
	targets = {}
	tLength = 0
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
