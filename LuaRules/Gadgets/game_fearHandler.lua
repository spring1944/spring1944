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
local GetUnitAllyTeam				= Spring.GetUnitAllyTeam
local GetGameFrame 					= Spring.GetGameFrame
local GetUnitPosition				= Spring.GetUnitPosition
-- Synced Ctrl
local CallCOBScript					= Spring.CallCOBScript

-- constants

-- variables

local targets = {}
local unitsWithShields = {}
local unitsInShields = {}


if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	local fearShieldRadius = tonumber(ud.customParams.fearshieldradius or 0)
	if fearShieldRadius > 0 then
		unitsWithShields[unitID] = fearShieldRadius
		--Spring.Echo("FEAR SHIELD FOUND!", unitID, fearShieldRadius)
	end
end

function gadget:UnitDestroyed(unitID)
	unitsWithShields[unitID] = nil
end

function gadget:Explosion(weaponId, px, py, pz, ownerId)
	local weapDef = WeaponDefs[weaponId]
	local unitsAtSpot = GetUnitsInCylinder(px, pz, weapDef.customParams.fearaoe)
	
	if #unitsAtSpot > 0 then
		buildShieldTables()
		for i = 1, #unitsAtSpot do
			local unitId = unitsAtSpot[i]
			local ud = UnitDefs[GetUnitDefID(unitId)]
			if ud.customParams.feartarget then
				table.insert(targets, unitId)
			end
		end
	
		for i = 1, #targets do
			local unitId = targets[i]
			--Spring.Echo(unitsInShields[unitId])
			if unitId ~= ownerId and not unitsInShields[unitId] then
				Spring.CallCOBScript(unitId, "HitByWeaponId", 0, 0, 0, weapDef.customParams.fearid, 0)
			end
			targets[i] = nil
		end
		targets = {}
		unitsInShields = {}
	end
	return false
end

function buildShieldTables()
	--Spring.Echo("BUILDING SHIELD TABLES")
	for unitID, fearShieldRadius in pairs(unitsWithShields) do
		--Spring.Echo("Shield unit is " .. unitID .. " with radius " .. fearShieldRadius)
		local x, _, z = GetUnitPosition(unitID)
		local unitsInThisShield = GetUnitsInCylinder(x, z, fearShieldRadius)
		for i = 1, #unitsInThisShield do
			local unitID2 = unitsInThisShield[i]
			local ud = UnitDefs[GetUnitDefID(unitID2)]
			if ud.customParams.feartarget then
				unitsInShields[unitID2] = true
				--Spring.Echo("Unit " .. unitID2 .. " is in a shield!")
			end
		end
	end
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
