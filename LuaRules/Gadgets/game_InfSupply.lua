function gadget:GetInfo()
	return {
		name		= "Infantry supply rules",
		desc		= "Infantry drain logistics when not in supply range and firing, firing rate bonus while in supply range, firing rate penalty when out of logistics",
		author	= "Nemo (B. Tyler), built on work by quantum and FLOZi",
		date		= "December 19, 2008",
		license = "CC attribution-noncommerical 3.0 or later",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end
	
-- function localisations
-- Synced Read
local GetUnitAllyTeam		 		=	Spring.GetUnitAllyTeam
local GetUnitDefID			 		=	Spring.GetUnitDefID
local GetUnitSeparation				=	Spring.GetUnitSeparation
local GetUnitTeam					=	Spring.GetUnitTeam
-- Synced Ctrl

-- Constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local stallPenalty				=	1.35 --1.35
local supplyBonus				=	0.65 --65
-- Variables
local ammoSuppliers		=	{}
local infantry			= 	{}
local savedFrame		=	{}

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local function FindSupplier(unitID)
	local closestSupplier
	local closestDistance = math.huge
	local allyTeam = GetUnitAllyTeam(unitID)
	for supplierID in pairs(ammoSuppliers) do
		local supAllyTeam = GetUnitAllyTeam(supplierID)
		local supTeam = GetUnitTeam(supplierID)
		if allyTeam == supAllyTeam or supTeam == GAIA_TEAM_ID then
			local separation = GetUnitSeparation(unitID, supplierID, true)
			local supplierDefID = GetUnitDefID(supplierID)
			local supplyRange = tonumber(UnitDefs[supplierDefID].customParams.supplyrange)
			if separation < closestDistance and separation <= supplyRange then
				closestSupplier = supplierID
				closestDistance = separation
			end
		end
	end
	
	return closestSupplier
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.feartarget and not(ud.customParams.maxammo) and (ud.weapons[1]) then
		infantry[unitID] = true
	end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.ammosupplier == '1' then
		ammoSuppliers[unitID] = true
	end
end


function gadget:UnitDestroyed(unitID)
	infantry[unitID] = nil
	ammoSuppliers[unitID] = nil
end


function gadget:GameFrame(n)
	if n % (1*30) < 0.1 then
		for unitID in pairs(infantry) do
			local unitDefID = GetUnitDefID(unitID)
			local teamID = Spring.GetUnitTeam(unitID)
			local weaponCost = UnitDefs[unitDefID].customParams.weaponcost or 1.5
			local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
			local reload = WeaponDefs[weaponID].reload
			local reloadFrameLength = (reload*30)
			local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
			if (logisticsLevel < 5) then
				Spring.SetUnitWeaponState(unitID, 0, {reloadTime = stallPenalty*reload})
				return
			end
			local supplierID = FindSupplier(unitID)
			if supplierID then
				local supplierDefID = GetUnitDefID(supplierID)
				local supplyRange = tonumber(UnitDefs[supplierDefID].customParams.supplyrange)
				Spring.SetUnitWeaponState(unitID, 0, {reloadTime = supplyBonus*reload})
			else
				local _, _, reloadFrame = Spring.GetUnitWeaponState(unitID, 0)
				if (savedFrame[unitID] == nil) or (savedFrame[unitID] == 0) then
					savedFrame[unitID] = reloadFrame + reloadFrameLength
				end
				Spring.SetUnitWeaponState(unitID, 0, {reloadTime = reload})
				if (reloadFrame > savedFrame[unitID]) then
					savedFrame[unitID] = reloadFrame
					Spring.UseUnitResource(unitID, "e", weaponCost)
				end
			end
		end
	end
end

else
--	UNSYNCED
end
