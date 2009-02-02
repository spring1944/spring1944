--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: squad_spawner.lua
--  brief: Spawns set squads when certain units are built
--  author: Maelstrom

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
		author    = "Maelstrom", --revisions by Gnome and Flozi
		date      = "31st August 2007",
		license   = "Public Domain",
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
	local verifyRemoval = { }

	function gadget:Initialize()
		squadDefs = include("LuaRules/Configs/squad_defs.lua")
	end

	function gadget:GameFrame(n)
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
					if(states and states.movestate ~= nil) then
						Spring.GiveOrderToUnit(newUnitID, CMD.FIRE_STATE, { states.firestate }, 0)
						Spring.GiveOrderToUnit(newUnitID, CMD.MOVE_STATE, { states.movestate }, 0)
					end
					table.insert(squad_units,newUnitID)
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

				newSquads[index] = nil
				DestroyUnit(squad_spawner, false, true)
			end
		end
		for uid, udid in ipairs(verifyRemoval) do --let's make double plus sure the dummy gets destroyed when the squad builder does
			if(udid == Spring.GetUnitDefID(uid)) then
				DestroyUnit(uid, false, true)
				verifyRemoval[uid] = nil
			end
		end
	end

	function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)

		local squadDef = squadDefs[unitDefID]
		
		if squadDef ~= nil then
			
			local px, py, pz = GetUnitBasePosition(unitID)
			
			local unitArray = { }

			local xSpace, zSpace = -10, -10
			
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

			table.insert(newSquads, {unitID = unitID, builderID = builderID, members = unitArray, udid = unitDefID})
		end
	end

	function gadget:UnitDestroyed(uid, udid, tid)
		for index, squad in ipairs(newSquads) do
			if(squad.builderID == uid) then
				newSquads[index] = nil
				verifyRemoval[squad.unitID] = squad.udid
			end
		end
	end

end
