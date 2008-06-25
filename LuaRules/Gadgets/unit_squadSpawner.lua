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
--  Squad definitions are defined in 'gamedata/LuaConfigs/squad_defs.lua'
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

if (gadgetHandler:IsSyncedCode()) then
	
	local squadDefs = { }
	
	local newSquads = { }
	
	function gadget:Initialize()
		
		squadDefs = include("gamedata/LuaConfigs/squad_defs.lua")
		
	end
	
	
	function gadget:GameFrame(n)
		while # newSquads ~= 0 do
				
				-- Get the orders for the squad spawner
			local squad_spawner = newSquads[1].unitID;
			local squad_members = newSquads[1].members;
			
			local queue = GetCommandQueue(squad_spawner);
			
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
						GiveOrderToUnits(squad_members, v.id, v.params, newopts)
						
					end
					
				end
				
			end
			
			table.remove(newSquads)
			
			DestroyUnit(squad_spawner, false, true)
			
		end
	end
	
		-- Adds a HQ to the HQ table, if a HQ has been created
	function gadget:UnitFinished(unitID, unitDefID, teamID)
		
		local squadDef = squadDefs[unitDefID]
		
		if squadDef ~= nil then
			
			local px, py, pz = GetUnitBasePosition(unitID)
			
			
			
			local unitArray = { }
			
			for i, unitName in ipairs(squadDef) do
				
				local newUnitID = CreateUnit(unitName,px,py,pz,0,teamID)
				
				table.insert(unitArray,newUnitID)
				
			end
			
			table.insert(newSquads, {unitID = unitID, members = unitArray})
			
		end
		
	end
	
end
