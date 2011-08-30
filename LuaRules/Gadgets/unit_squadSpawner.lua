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
local DelayCall            = GG.Delay.DelayCall
-- Synced Read
local GetCommandQueue      = Spring.GetCommandQueue
local GetUnitBasePosition  = Spring.GetUnitBasePosition
local GetUnitBuildFacing   = Spring.GetUnitBuildFacing
local GetUnitStates        = Spring.GetUnitStates
-- Synced Ctrl
local CreateUnit           = Spring.CreateUnit
local DestroyUnit          = Spring.DestroyUnit
-- Unsynced Ctrl
local GiveOrderToUnit      = Spring.GiveOrderToUnit
local GiveOrderToUnitArray = Spring.GiveOrderToUnitArray

-- Constants

-- Variables
local initFrame

local squadDefs = { }
local builderOf = { }  -- maps unitID -> builderID
local builders  = { }  -- keep track of builders


function gadget:Initialize()
	squadDefs = include("LuaRules/Configs/squad_defs.lua")
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


local function CreateSquad(unitID, unitDefID, teamID, builderID)
	local squadDef = squadDefs[unitDefID]

	if squadDef == nil then return end

	local px, py, pz = GetUnitBasePosition(unitID)

	-- Get the orders for the squad spawner
	local unitHeading = 0
	local states = nil
	local queue = GetCommandQueue(unitID)

	if builderID then
		unitHeading = GetUnitBuildFacing(builderID)
		states = GetUnitStates(builderID)
	end

	local squad_units = {}

	local xSpace, zSpace = -5, -5

	-- Spawn the units
	for i, unitName in ipairs(squadDef) do
		local newUnitID = CreateUnit(unitName, px + xSpace,py, pz + zSpace, unitHeading, teamID)
		if newUnitID then
			squad_units[#squad_units+1] = newUnitID
			if states then
				if UnitDefNames[unitName].fireState == -1 then -- unit set to inherit from builder
					GiveOrderToUnit(newUnitID,  CMD.FIRE_STATE, { states.firestate }, 0)
				end
				if UnitDefNames[unitName].moveState == -1 then -- unit set to inherit from builder
					GiveOrderToUnit(newUnitID,  CMD.MOVE_STATE, { states.movestate }, 0)
				end
			end
		end

		if (i % 4 == 0) then
			xSpace = -10
			zSpace = zSpace + 10
		else
			xSpace = xSpace + 10
		end
	end

	-- If its a valid queue
	if queue then
		-- Fix some things up
		for k,v in ipairs(queue) do
			local opts = v.options
			if (not opts.internal) then
				-- Give order to the units
				GiveOrderToUnitArray(squad_units, v.id, v.params, opts.coded)
			end
		end
	end

	DestroyUnit(unitID, false, true)
end


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	if squadDefs[unitDefID] then
		builderOf[unitID] = builderID
		if builderID then
			builders[builderID] = true
		end
	end
end


function gadget:UnitFinished(unitID, unitDefID, teamID)
	if squadDefs[unitDefID] then
		DelayCall(CreateSquad, {unitID, unitDefID, teamID, builderOf[unitID]})
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
