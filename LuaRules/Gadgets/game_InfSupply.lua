function gadget:GetInfo()
	return {
		name		= "Infantry supply rules",
		desc		= "Infantry firing rate bonus while in supply range, firing rate penalty when out of logistics",
		author		= "Nemo (B. Tyler), FLOZi (C. Lawrence), quantum",
		date		= "December 19, 2008",
		license 	= "GNU GPL v2",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end

-- function localisations
-- Synced Read
local AreTeamsAllied			= Spring.AreTeamsAllied
local GetTeamInfo				= Spring.GetTeamInfo
local GetTeamResources		 	= Spring.GetTeamResources
local GetUnitDefID			 	= Spring.GetUnitDefID
local GetUnitSeparation			= Spring.GetUnitSeparation
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitIsStunned			= Spring.GetUnitIsStunned
--local GetUnitWeaponState		= Spring.GetUnitWeaponState
local ValidUnitID				= Spring.ValidUnitID
-- Synced Ctrl
local SetUnitWeaponState		= Spring.SetUnitWeaponState
--local UseUnitResource			= Spring.UseUnitResource

-- Constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local STALL_PENALTY				=	1.35 --1.35
local SUPPLY_BONUS				=	0.65 --65
-- Variables
local ammoRanges		= {}

local ammoSuppliers		= {}
local aIndices			= {}
local aLengths			= {}

local infantry 			= {}
local iIndices			= {}
local iLengths			= {}

local teams 			= Spring.GetTeamList()
local numTeams			= #teams

for i = 1, numTeams do
	local teamID = teams[i]
	-- setup per-team infantry arrays
	infantry[teamID] = {}
	iIndices[teamID] = {}
	iLengths[teamID] = 0
	-- setup per-team ammo supplier arrays
	ammoSuppliers[teamID] = {}
	aIndices[teamID] = {}
	aLengths[teamID] = 0
end

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local function FindSupplier(unitID, teamID)
	for i = 1, aLengths[teamID] do
		local supplierID = ammoSuppliers[teamID][i]
		local separation = GetUnitSeparation(unitID, supplierID, true)
		if separation <= ammoRanges[supplierID] then
			return supplierID
		end
	end
	-- no supplier found
	return
end

function gadget:Initialize()
	-- This is all actually redundant as base units are spawned after this gadget starts!
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

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.feartarget and not(cp.maxammo) and ud.weapons[1] then
		iLengths[teamID] = iLengths[teamID] + 1
		infantry[teamID][iLengths[teamID]] = unitID
		iIndices[teamID][unitID] = iLengths[teamID]
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	-- Build table of suppliers
	if cp and cp.supplyrange then
		ammoRanges[unitID] = tonumber(cp.supplyrange)	
		aLengths[teamID] = aLengths[teamID] + 1
		ammoSuppliers[teamID][aLengths[teamID]] = unitID
		aIndices[teamID][unitID] = aLengths[teamID]
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- return if team has already 'died'
	if #iIndices[teamID] == 0 then return end
	
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	-- Check if the unit was a supplier and was fully built
	if cp and cp.supplyrange and aIndices[teamID][unitID] then
		aIndices[teamID][ammoSuppliers[teamID][aLengths[teamID]]] = aIndices[teamID][unitID]
		ammoSuppliers[teamID][aIndices[teamID][unitID]] = ammoSuppliers[teamID][aLengths[teamID]]
		ammoSuppliers[teamID][aLengths[teamID]] = nil
		aIndices[teamID][unitID] = nil
		aLengths[teamID] = aLengths[teamID] - 1
		ammoRanges[unitID] = nil
	-- Check if the unit was infantry
	elseif cp and cp.feartarget and not(cp.maxammo) and ud.weapons[1] and teamID then
		iIndices[teamID][infantry[teamID][iLengths[teamID]]] = iIndices[teamID][unitID]
		infantry[teamID][iIndices[teamID][unitID]] = infantry[teamID][iLengths[teamID]]
		infantry[teamID][iLengths[teamID]] = nil
		iIndices[teamID][unitID] = nil
		iLengths[teamID] = iLengths[teamID] - 1
	end
end

function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	gadget:UnitDestroyed(unitID, unitDefID, oldTeam)
	gadget:UnitCreated(unitID, unitDefID, newTeam)
	gadget:UnitFinished(unitID, unitDefID, newTeam)
end

function gadget:TeamDied(teamID)
	infantry[teamID] = {}
	iIndices[teamID] = {}
	iLengths[teamID] = 0
	ammoSuppliers[teamID] = {}
	aIndices[teamID] = {}
	aLengths[teamID] = 0
end

local function ProcessUnit(unitID, unitDefID, teamID, stalling)
	--local weaponCost = UnitDefs[unitDefID].customParams.weaponcost or 0.15
	local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
	local reload = WeaponDefs[weaponID].reload
	--local reloadFrameLength = (reload*30)

	if ValidUnitID(unitID) then
		-- Stalling. (stall penalty!)
		if (stalling) then
			SetUnitWeaponState(unitID, 0, {reloadTime = STALL_PENALTY*reload})
			return
		end

		-- In supply radius. (supply bonus!)
		-- First check own team
		local supplierID = FindSupplier(unitID, teamID)
		-- Then check all allied teams if no supplier found
		local i = 1
		while not supplierID and i <= numTeams do
			local supTeam = teams[i]
			if supTeam ~= teamID and (AreTeamsAllied(supTeam, teamID) or supTeam == GAIA_TEAM_ID) then
				supplierID = FindSupplier(unitID, supTeam)
			end
			i = i + 1
		end
		if supplierID then
			SetUnitWeaponState(unitID, 0, {reloadTime = SUPPLY_BONUS*reload})
			return
		end

		-- reset reload time otherwise
		SetUnitWeaponState(unitID, 0, {reloadTime = reload})
		
		-- Use resources if outside of supply
		--[[if (reloadFrame > savedFrame[unitID]) then
			savedFrame[unitID] = reloadFrame
			UseUnitResource(unitID, "e", weaponCost)
		end]]
	end
end

function gadget:GameFrame(n)
	for i = 1, numTeams do
		if (n + (math.floor(30 / numTeams) * i)) % (30 * 3) < 0.1 then -- every 3 seconds with each team offset by 30 / numTeams * teamNum frames
			local teamID = teams[i]
			local teamIsDead = select(3, GetTeamInfo(teamID))
			if not teamIsDead and teamID ~= GAIA_TEAM_ID then
				for j = 1, iLengths[teamID] do
					local unitID = infantry[teamID][j]
					if ValidUnitID(unitID) then
						local unitDefID = GetUnitDefID(unitID)
						local logisticsLevel = GetTeamResources(teamID, "energy")
						local stalling = logisticsLevel < 50
						ProcessUnit(unitID, unitDefID, teamID, stalling)
					end
				end
			end
		end
	end
end

else
--	UNSYNCED
end
