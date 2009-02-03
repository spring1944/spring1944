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

	-- Speed ups
local GetCommandQueue     = Spring.GetCommandQueue
local CreateUnit          = Spring.CreateUnit
local DestroyUnit         = Spring.DestroyUnit
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GiveOrderToUnits    = Spring.GiveOrderToUnitArray

local ADD_BAR = "AddBar"
local SET_BAR = "SetBar"
local REMOVE_BAR = "RemoveBar"

if (gadgetHandler:IsSyncedCode()) then

	local squadDefs = { }
	local newSquads = { }
	local watchUnits = { }

	function gadget:Initialize()
		squadDefs = include("LuaRules/Configs/squad_defs.lua")
		watchUnits = { }
	end

	function gadget:GameFrame(n)
		--while # newSquads ~= 0 do
		for index, squad in ipairs(newSquads) do

				-- Get the orders for the squad spawner
			local squad_spawner = squad.unitID

			_,_,_,_,buildprog = Spring.GetUnitHealth(squad_spawner)

			if(buildprog ~= nil and buildprog >= 1) then

				local squad_members = squad.members
				local squad_builder = squad.builderID
				local squad_units = {}
				local states = {}

				local queue = GetCommandQueue(squad_spawner)
				if squad_builder then
					states = Spring.GetUnitStates(squad_builder)
				end

				for _,unit in ipairs(squad_members) do
					local newUnitID = CreateUnit(unit.unitname,unit.x,unit.y,unit.z,unit.heading,unit.team)
					if (states) then
						if(states.movestate ~= nil) then
							Spring.GiveOrderToUnit(newUnitID, CMD.FIRE_STATE, { states.firestate }, 0)
							Spring.GiveOrderToUnit(newUnitID, CMD.MOVE_STATE, { states.movestate }, 0)
						end
						table.insert(squad_units,newUnitID)
					end
				end

					-- If its a valid queue
				if (queue ~= nil) then

					local first = next(queue, nil)

						-- Fix some things up
					for k,v in ipairs(queue) do

						local opts = v.options
						if (not opts.internal) then

							local newopts = {}
							if (opts.alt)   then table.insert(newopts, "alt")   end
							if (opts.ctrl)  then table.insert(newopts, "ctrl")  end
							if (opts.shift) then table.insert(newopts, "shift") end
							if (opts.right) then table.insert(newopts, "right") end

							if (k == first) then
								if (opts.ctrl) then
									table.insert(newopts, "shift")
								end
							end

								-- Give order to the units
							GiveOrderToUnits(squad_units, v.id, v.params, newopts)
						end
					end
				end
				watchUnits[squad_spawner] = nil

				table.remove(newSquads[index])
				DestroyUnit(squad_spawner, false, true)
			end
		end
	end

--	function gadget:UnitFromFactory(unitID, unitDefID, teamID, factID, factDefID, userOrders)
	function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)

		local squadDef = squadDefs[unitDefID]
		
		if squadDef ~= nil then
			
			local px, py, pz = GetUnitBasePosition(unitID)
			
			local unitArray = { }

			local xSpace, zSpace = -5, -5
			
			for i, unitName in ipairs(squadDef) do
				local unitHeading = 0
				if builderID then 
					unitHeading = Spring.GetUnitBuildFacing(builderID)
				end
				local newUnit = {
					unitname = unitName,
					x = px + xSpace,
					y = py,
					z = pz + zSpace,
					heading = unitHeading,
					team = teamID,
				}

				table.insert(unitArray,newUnit)

				if(i % 4 == 0) then
					xSpace = -10
					zSpace = zSpace + 10
				else
					xSpace = xSpace + 10
				end
			end

			table.insert(newSquads, {unitID = unitID, builderID = builderID, members = unitArray})
		end
	end
	
	function gadget:UnitDestroyed(unitID, unitDefID, teamID)
		if (watchUnits[unitID] ~= nil) then
			watchUnits[unitID] = nil
		end
	end
	
end
