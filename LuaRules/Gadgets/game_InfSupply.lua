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

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local function CheckDist(unitID)
	local closestSupplier
	local closestDistance = math.huge
	local allyTeam = GetUnitAllyTeam(unitID)
	for supplierID in pairs(ammoSuppliers) do
		local supAllyTeam = GetUnitAllyTeam(supplierID)
		local supTeam = GetUnitTeam(supplierID)
		if allyTeam == supAllyTeam or supTeam == GAIA_TEAM_ID then
			local separation	= GetUnitSeparation(unitID, supplierID, true)
			if separation < closestDistance then
				closestSupplier = supplierID
				closestDistance = separation
			end
		end
	end	
	return closestSupplier, closestDistance
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.feartarget and ~ud.customParams.maxammo then
		infantry[unitID] = true
	end
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
			local weaponCost = UnitDefs[unitDefID].customParams.weaponcost or 1
			local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
			local reload = WeaponDefs[weaponID].reload
			local reloadFrameLength = (reload*30)
			local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
			if (logisticsLevel < 5) then
				Spring.SetUnitWeaponState(unitID, 0, {reloadTime = stallPenalty*reload})
				return
			end
			local supplierID, distanceFromSupplier = CheckDist(unitID)
			if supplierID then
				local supplierDefID = GetUnitDefID(supplierID)
				local supplyRange = tonumber(UnitDefs[supplierDefID].customParams.supplyrange)
				if (distanceFromSupplier < supplyRange) and (logisticsLevel > 5) then 
					Spring.SetUnitWeaponState(unitID, 0, {reloadTime = supplyBonus*reload})
				end
				if (distanceFromSupplier > supplyRange) and (logisticsLevel > 5) then
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
end

else
--	UNSYNCED
end
