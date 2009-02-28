--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: startpos_clear.lua
--  brief: Removes any features around the  Commanders start positions
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Base Spawner",
		desc      = "Spawns around the HQ units",
		author    = "B. Tyler",
		date      = "31th Jan. 2009",
		license   = "CC BY-NC",
		layer     = -5,
		enabled   = true --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then

---------------------------------------------------------------------------
	local hqDefs = VFS.Include("LuaRules/Configs/hq_spawn.lua")
		-- Removes this gadget if the game has started.
		-- Only needs to run once at game start
	--[[function gadget:GameFrame(n)
		if n<2 then
			gadgetHandler:RemoveGadget()
		end
	end]]--
	
	function gadget:UnitFinished(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		local unitDefName = ud.name
		if ud.customParams.hq == "1" then
			local spawnList = hqDefs[unitDefName]
			if not spawnList then return end
			--Spring.Echo(spawnList.units[1])
			local spread = spawnList.spread
			local px, py, pz = Spring.GetUnitPosition(unitID)
			local xmin = px - ((2*ud.xsize) * spread) / 2
			local xmax = px + ((2*ud.xsize) * spread) / 2
			local zmin = pz - ((2*ud.zsize) * spread) / 2
			local zmax = pz + ((2*ud.zsize) * spread) / 2
			if ud.customParams.feartarget ~= nil then
				xmin = px - ((6*ud.xsize) * spread) / 2
				xmax = px + ((6*ud.xsize) * spread) / 2
				zmin = pz - ((6*ud.zsize) * spread) / 2
				zmax = pz + ((6*ud.zsize) * spread) / 2
			end
			for blah, unitName in ipairs(spawnList.units) do
				--Spring.Echo(unitName)
				local x = math.random(xmin, xmax)
				local z = math.random(zmin, zmax)
				local occupied = Spring.GetUnitsInCylinder(x, z, 100, teamID)
				while (occupied[1] ~= nil) do
					spread = spawnList.spread + (0.1*spread)
					xmin = px - ((2*ud.xsize) * spread) / 2
					xmax = px + ((2*ud.xsize) * spread) / 2
					zmin = pz - ((2*ud.zsize) * spread) / 2
					zmax = pz + ((2*ud.zsize) * spread) / 2
					x = math.random(xmin, xmax)
					z = math.random(zmin, zmax)
					occupied = Spring.GetUnitsInCylinder(x, z, 100, teamID)
				end
				Spring.CreateUnit(unitName, x, py, z, 0, teamID)
			end		
		end
	end	
	
else -- UNSYNCED

end
