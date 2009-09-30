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
local GetUnitIsStunned				=	Spring.GetUnitIsStunned
-- Synced Ctrl

-- Constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local stallPenalty				=	1.35 --1.35
local supplyBonus				=	0.65 --65
-- Variables
local ammoSuppliers		=	{}
local savedFrame		=	{}  -- infantry
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

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitTeam = GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		local _,stunned,beingBuilt = GetUnitIsStunned(unitID)
		-- Unless the unit is being transported consider whether it is infantry.
		if (not stunned) then
			gadget:UnitCreated(unitID, unitDefID, unitTeam)
		end
		-- Unless the unit is being built consider whether it is an ammo supplier.
		if (not beingBuilt) then
			gadget:UnitFinished(unitID, unitDefID, unitTeam)
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.feartarget and not(ud.customParams.maxammo) and (ud.weapons[1]) then
		savedFrame[unitID] = 0
	end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.ammosupplier == '1' then
		ammoSuppliers[unitID] = true
	end
end


function gadget:UnitDestroyed(unitID)
	savedFrame[unitID] = nil
	ammoSuppliers[unitID] = nil
end


function gadget:UnitLoaded(unitID)
	-- If a unit is loaded into a transport and temporarily can't fire,
	-- behave as if it didn't exist until it gets unloaded again.
	local _, stunned = GetUnitIsStunned(unitID)
	if stunned then
		savedFrame[unitID] = nil
	end
end


-- If a unit is unloaded, do exactly the same as for newly created units.
gadget.UnitUnloaded = gadget.UnitCreated


local function ProcessUnit(unitID, unitDefID, teamID)
	local weaponCost = UnitDefs[unitDefID].customParams.weaponcost or 1.5
	local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
	local reload = WeaponDefs[weaponID].reload
	local reloadFrameLength = (reload*30)

	-- Stalling. (stall penalty!)
	local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
	if (logisticsLevel < 5) then
		Spring.SetUnitWeaponState(unitID, 0, {reloadTime = stallPenalty*reload})
		return
	end

	-- In supply radius. (supply bonus!)
	local supplierID = FindSupplier(unitID)
	if supplierID then
		Spring.SetUnitWeaponState(unitID, 0, {reloadTime = supplyBonus*reload})
		return
	end

	local _, _, reloadFrame = Spring.GetUnitWeaponState(unitID, 0)
	if (savedFrame[unitID] == 0) then
		savedFrame[unitID] = reloadFrame + reloadFrameLength
	end
	Spring.SetUnitWeaponState(unitID, 0, {reloadTime = reload})
	if (reloadFrame > savedFrame[unitID]) then
		savedFrame[unitID] = reloadFrame
		Spring.UseUnitResource(unitID, "e", weaponCost)
	end
end


function gadget:GameFrame(n)
	if n % (1*30) < 0.1 then
		for unitID in pairs(savedFrame) do
			local unitDefID = GetUnitDefID(unitID)
			local teamID = GetUnitTeam(unitID)
			ProcessUnit(unitID, unitDefID, teamID)
		end
	end
end

else
--	UNSYNCED
end
