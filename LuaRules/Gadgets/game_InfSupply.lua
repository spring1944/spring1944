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
local GetTeamRulesParam			= Spring.GetTeamRulesParam
local ValidUnitID				= Spring.ValidUnitID
-- Synced Ctrl
local SetUnitWeaponState		= Spring.SetUnitWeaponState
--local UseUnitResource			= Spring.UseUnitResource

-- Constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local STALL_PENALTY				=	1.35 --1.35
local SUPPLY_BONUS				=	0.65 --65
-- Variables
local ammoRanges		= {} -- supplierID = ammoRange
local ammoRangeCache		= {} -- unitDefID = range
local infReloadCache	= {} -- unitDefID = reload

local ammoSuppliers		= {} -- teamID = {[supplierID] = range, [supplierID] = range, ...}
local teamSupplyRangeModifierParamName = 'supply_range_modifier'

local infantry 			= {} -- teamID = {[infID] = reload, [infID] = reload, ...}

local teams 			= Spring.GetTeamList()
local numTeams			= #teams - 1 -- ignore GAIA at this point

for i = 1, numTeams do
	local teamID = teams[i]
	-- setup per-team infantry arrays
	infantry[teamID] = {}
	-- setup per-team ammo supplier arrays
	ammoSuppliers[teamID] = {}
end

-- Can't ignore GAIA anymore, there can be neutral suppliers now with Spoils of War
ammoSuppliers[GAIA_TEAM_ID] = {}

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local function GetSupplyRangeModifier(teamID)
	return 1 + (GetTeamRulesParam(teamID, teamSupplyRangeModifierParamName) or 0)
end

local function CheckAmmoSupplier(unitID, unitDefID, teamID, cp)
	if cp.supplyrange then
		ammoRangeCache[unitDefID] = tonumber(cp.supplyrange)	
		ammoSuppliers[teamID][unitID] = ammoRangeCache[unitDefID]
	end
end

local function FindSupplier(unitID, teamID)
	local rangeModifier = GetSupplyRangeModifier(teamID)
	for supplierID, ammoRange in pairs(ammoSuppliers[teamID]) do
		local separation = GetUnitSeparation(unitID, supplierID, true) or math.huge
		if separation <= ammoRange * rangeModifier then
			return supplierID
		end
	end
	-- no supplier found
	return
end

function gadget:Initialize()
	-- for luarules reload
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
	if not teamID then return end -- team already died
	if not infantry[teamID] then
		-- cheat-spawning units for a team that was not there at game start?
		infantry[teamID] = {}
	end
	if infReloadCache[unitDefID] then
		infantry[teamID][unitID] = infReloadCache[unitDefID]
		Spring.SetUnitBlocking(unitID, true, true, true, true, true, false, false)
	else
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.feartarget and not(cp.maxammo) and ud.weapons[1] and not ud.canFly then -- unit is armed inf
			infReloadCache[unitDefID] = WeaponDefs[ud.weapons[1].weaponDef].reload
			infantry[teamID][unitID] = infReloadCache[unitDefID]
			Spring.SetUnitBlocking(unitID, true, true, true, true, true, false, false)
		end
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	if ammoRangeCache[unitDefID] then
		ammoSuppliers[teamID][unitID] = ammoRangeCache[unitDefID]
	else
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		-- Build table of suppliers
		if cp then -- can be a supplier
			CheckAmmoSupplier(unitID, unitDefID, teamID, cp)
		end
	end
end

local function CleanUp(unitID, unitDefID, teamID)
	if ammoRangeCache[unitDefID] then
		ammoSuppliers[teamID][unitID] = nil
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- return if team has already died
	if not teamID or (teamID ~= GAIA_TEAM_ID and select(3, Spring.GetTeamInfo(teamID))) then return end

	CleanUp(unitID, unitDefID, teamID)
end

function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	gadget:UnitDestroyed(unitID, unitDefID, oldTeam)
	gadget:UnitCreated(unitID, unitDefID, newTeam)
	gadget:UnitFinished(unitID, unitDefID, newTeam)
end

function gadget:TeamDied(teamID)
	infantry[teamID] = {}
	ammoSuppliers[teamID] = {}
end

local function ProcessUnit(unitID, teamID, reload, stalling)
	if ValidUnitID(unitID) then
		-- Stalling. (stall penalty!)
		if (stalling) then
			SetUnitWeaponState(unitID, 1, {reloadTime = STALL_PENALTY*reload})
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
			-- Stalling. (stall penalty!)
			if (stalling) then
				Spring.SetUnitRulesParam(unitID, "insupply", 2)
				return
			end
			Spring.SetUnitRulesParam(unitID, "insupply", 1)
			SetUnitWeaponState(unitID, 1, {reloadTime = SUPPLY_BONUS*reload})
			return
		elseif not stalling then
			Spring.SetUnitRulesParam(unitID, "insupply", 0)
			-- reset reload time otherwise
			SetUnitWeaponState(unitID, 1, {reloadTime = reload})
		end
		-- Use resources if outside of supply
		--[[if (reloadFrame > savedFrame[unitID]) then
			savedFrame[unitID] = reloadFrame
			UseUnitResource(unitID, "e", weaponCost)
		end]]
	end
end

local UPDATE_PERIOD = 30 * 3 -- updates are spread over 3 seconds
local UPDATE_PER_TEAM = math.floor(UPDATE_PERIOD / numTeams)
-- e.g. 3 teams, 0 @ 0, 1 @ 1 * UPDATE_PERIOD/3, 2@ 2 * UPDATE_PERIOD/3, 0@ 3 * UPDATE_PERIOD/3
local currTeam = 0

function gadget:GameFrame(n)
	if n % UPDATE_PER_TEAM == 0 then
		local teamID = currTeam
		local teamIsDead = select(3, GetTeamInfo(teamID))
		if not teamIsDead then
			local logisticsLevel = GetTeamResources(teamID, "energy")
			local stalling = logisticsLevel < 50
			for unitID, reload in pairs(infantry[teamID]) do
				if ValidUnitID(unitID) then
					ProcessUnit(unitID, teamID, reload, stalling)
				end
			end
		end
		currTeam = currTeam + 1
		if currTeam == numTeams then currTeam = 0 end
	end
end

else
--	UNSYNCED
end
