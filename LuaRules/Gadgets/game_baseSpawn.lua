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
		author    = "B. Tyler, Tobi Vollebregt",
		date      = "31th Jan. 2009",
		license   = "CC BY-NC",
		layer     = -5,
		enabled   = true --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then

---------------------------------------------------------------------------
	local hqDefs = VFS.Include("LuaRules/Configs/hq_spawn.lua")

	-- Each time an invalid position is randomly chosen, spread is multiplied by SPREAD_MULT.
	-- If spread reaches MAX_SPREAD, the unit is not deployed AT ALL.
	-- (This prevents infinite loops and units being spawned over entire map.)
	-- 1000|1.1 will result in approx. 16 tries before giving up (200 * 1.1^17 > 1000)
	local MAX_SPREAD = 1000
	local SPREAD_MULT = 1.1

	-- Removes this gadget if the game has started.
	-- Only needs to run once at game start
	--[[function gadget:GameFrame(n)
		if n<2 then
			gadgetHandler:RemoveGadget()
		end
	end]]--

	local function IsPositionValid(unitDefID, x, z)
		-- Don't place units underwater. (this is also checked by TestBuildOrder
		-- but that needs proper maxWaterDepth/floater/etc. in the UnitDef.)
		local y = Spring.GetGroundHeight(x, z)
		if (y <= 0) then
			return false
		end
		-- Don't place units where it isn't be possible to build them normally.
		local test = Spring.TestBuildOrder(unitDefID, x, y, z, 0)
		if (test ~= 2) then
			return false
		end
		-- Don't place units too close together.
		local ud = UnitDefs[unitDefID]
		local units = Spring.GetUnitsInCylinder(x, z, 100)
		if (units[1] ~= nil) then
			return false
		end
		return true
	end

	function gadget:UnitFinished(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		if ud.customParams.hq == "1" then
			local spawnList = hqDefs[ud.name]
			if not spawnList then return end
			local px, py, pz = Spring.GetUnitPosition(unitID)
			for _, unitName in ipairs(spawnList.units) do
				local udid = UnitDefNames[unitName].id
				local spread = spawnList.spread
				while (spread < MAX_SPREAD) do
					local x = px + math.random(-spread, spread)
					local z = pz + math.random(-spread, spread)
					if IsPositionValid(udid, x, z) then
						Spring.CreateUnit(unitName, x, py, z, 0, teamID)
						break
					end
					spread = spread * SPREAD_MULT
				end
				--Spring.Echo(unitName .. ", spread: " .. spread)
			end
		end
	end

else -- UNSYNCED

end
