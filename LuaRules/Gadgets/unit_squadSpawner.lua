--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: squad_spawner.lua
--  brief: Spawns set squads when certain units are built
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Squad definitions are defined in 'LuaRules/Configs/squad_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Squad Spawner",
		desc      = "Spawns squads",
		author    = "Maelstrom",
		date      = "31st August 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end


if (not gadgetHandler:IsSyncedCode()) then
	return false
end


	-- Speed ups
local GetCommandQueue      = Spring.GetCommandQueue
local CreateUnit           = Spring.CreateUnit
local DestroyUnit          = Spring.DestroyUnit
local GetUnitBasePosition  = Spring.GetUnitBasePosition
local GiveOrderToUnitArray = Spring.GiveOrderToUnitArray
local DelayCall            = GG.Delay.DelayCall
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
		unitHeading = Spring.GetUnitBuildFacing(builderID)
		states = Spring.GetUnitStates(builderID)
	end

	local squad_units = {}

	local xSpace, zSpace = -5, -5

	-- Spawn the units
	for i, unitName in ipairs(squadDef) do
		local newUnitID = CreateUnit(unitName, px + xSpace,py, pz + zSpace, unitHeading, teamID)
		if newUnitID then
			squad_units[#squad_units+1] = newUnitID
		end

		if (i % 4 == 0) then
			xSpace = -10
			zSpace = zSpace + 10
		else
			xSpace = xSpace + 10
		end
	end

	if states then
		-- 2009/10/02: T: movestate is overridden later on (not in this gadget) ...
		GiveOrderToUnitArray(squad_units, CMD.FIRE_STATE, { states.firestate }, 0)
		GiveOrderToUnitArray(squad_units, CMD.MOVE_STATE, { states.movestate }, 0)
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
