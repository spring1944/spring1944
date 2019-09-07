function gadget:GetInfo()
	return {
		name      = "Squad Spawner",
		desc      = "Spawns squads",
		author    = "Maelstrom, FLOZi (C. Lawrence)",
		date      = "31st August 2007",
		license   = "GNU GPL v2",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if (not gadgetHandler:IsSyncedCode()) then
	return false
end


-- Localisations
-- Synced Read
local GetCommandQueue      = Spring.GetCommandQueue
local GetUnitBasePosition  = Spring.GetUnitBasePosition
local GetUnitBuildFacing   = Spring.GetUnitBuildFacing
local GetUnitStates        = Spring.GetUnitStates
-- Synced Ctrl
local CreateUnit           = Spring.CreateUnit
local DestroyUnit          = Spring.DestroyUnit
local SetUnitNoSelect      = Spring.SetUnitNoSelect
-- Unsynced Ctrl
local GiveOrderToUnit      = Spring.GiveOrderToUnit
local GiveOrderToUnitArray = Spring.GiveOrderToUnitArray

-- Constants
local NONBLOCKING_TIME = 30 * 5 -- how long after spawn they don't block. 5 seconds.

-- Variables
local initFrame

local squadDefs = { }
local builderOf = { }  -- maps unitID -> builderID
local builders  = { }  -- keep track of builders
local transporters = {} -- unitDefID = squadDefID


local function GetUnitNames(pattern)
	local list = {}
	for unitName in pairs (UnitDefNames) do
		if unitName:find(pattern) == 1 then
			if not unitName:find("_all") then -- prevent recursion
				table.insert(list, unitName)
			end
		end
	end
	return list
end

function gadget:Initialize()
	squadDefs = include("LuaRules/Configs/squad_defs.lua")
	squadDefs.hun_all.members = GetUnitNames("hun")
	squadDefs.ger_all.members = GetUnitNames("ger")
	initFrame = Spring.GetGameFrame()
end

function gadget:gameFrame(n)
	if n == initFrame then
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local teamID = Spring.GetUnitTeam(unitID)
			local unitDefID = Spring.GetUnitDefID(unitID)
			gadget:UnitCreated(unitID, unitDefID, teamID)
		end
	end
end

local function CreateSquadMember(unitName, x,y,z, unitHeading, teamID, queue)
	local newUnitID = CreateUnit(unitName, x,y+1,z, unitHeading, teamID)
	Spring.Echo("SQUADSPAWNER: ", unitName, newUnitID)
	if newUnitID then
		if states then
			if UnitDefNames[unitName].fireState == -1 then -- unit set to inherit from builder
				GiveOrderToUnit(newUnitID,  CMD.FIRE_STATE, { states.firestate }, 0)
			end
			if UnitDefNames[unitName].moveState == -1 then -- unit set to inherit from builder
				GiveOrderToUnit(newUnitID,  CMD.MOVE_STATE, { states.movestate }, 0)
			end
		end
		-- If its a valid queue
		if queue then
			-- Fix some things up
			for k,v in ipairs(queue) do
				local opts = v.options
				if (not opts.internal) then
					-- Give order to the units
					GiveOrderToUnit(newUnitID, v.id, v.params, opts.coded)
				end
			end
		end
	end
end

local function CreateSquad(unitID, unitDefID, teamID, builderID)
	local squadDef = squadDefs[unitDefID]

	if squadDef == nil then return end

	local px, py, pz = GetUnitBasePosition(unitID)

	-- Get the orders for the squad spawner
	local unitHeading = 0
	local states = nil
	local queue = GetCommandQueue(unitID, -1)

	if builderID then
		unitHeading = GetUnitBuildFacing(builderID)
		states = GetUnitStates(builderID)
	end

	local wait = 2 * 30 / #squadDef.members
	
	-- Spawn the units
	for i, unitName in ipairs(squadDef.members) do
		GG.Delay.DelayCall(CreateSquadMember, {unitName, px,py,pz, unitHeading, teamID, queue}, wait*(i-1))

	end
	DestroyUnit(unitID, false, true)
end


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	if squadDefs[unitDefID] then
		SetUnitNoSelect(unitID, true)
		builderOf[unitID] = builderID
		if builderID then
			builders[builderID] = true
		end
	end
end

local function SpawnTransportSquad(unitID, teamID, transportSquad)
	local squadDef = squadDefs[transportSquad].members
	local x,y,z = Spring.GetUnitPosition(unitID)
	for foo, passengerDefName in ipairs(squadDef) do -- ipairs to ensure LCT tanks are in correct positions
		local passID = CreateUnit(passengerDefName, x, y, z, 0, teamID)
		if (passID ~= nil) then
			local passDefCP = UnitDefNames[passengerDefName].customParams
			if passDefCP and passDefCP.maxammo then
				Spring.SetUnitRulesParam(passID, "ammo", passDefCP.maxammo)
			end
			local env = Spring.UnitScript.GetScriptEnv(unitID)
			if env then
				Spring.UnitScript.CallAsUnit(unitID, env.script.TransportPickup, passID)
			else
				Spring.CallCOBScript(unitID, "TransportPickup", 0, passID, 1)
			end
		end
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	if squadDefs[unitDefID] then
		GG.Delay.DelayCall(CreateSquad, {unitID, unitDefID, teamID, builderOf[unitID]})
	elseif transporters[unitDefID] then
		-- spawn transportees
		GG.Delay.DelayCall(SpawnTransportSquad, {unitID, teamID, transporters[unitDefID]})
	else
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.transportsquad then
			transporters[unitDefID] = cp.transportsquad
			GG.Delay.DelayCall(SpawnTransportSquad, {unitID, teamID, cp.transportsquad})
		end
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	builderOf[unitID] = nil

	if builders[unitID] then
		-- A factory was destroyed: kill any squad spawners it has created
		local builderID = builders[unitID]
		builders[unitID] = nil
		for k,v in pairs(builderOf) do
			if (v == builderID) then
				builderOf[k] = nil
				DestroyUnit(k, false, true)
				return
			end
		end
	end
end
