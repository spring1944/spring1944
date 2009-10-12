function gadget:GetInfo()
	return {
		name      = "Base Spawner",
		desc      = "Spawns around the HQ units",
		author    = "B. Tyler, Tobi Vollebregt",
		date      = "2009/08/18",
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
	-- with spread defined in spawnList as 200
	-- 1000|1.1 will result in approx. 16 tries before giving up (200 * 1.1^17 > 1000)
	-- 1000|1.02 will result in approx. 81 tries before giving up (200 * 1.02^82 > 1000)
	-- The max number of tries should at least be higher then the average number
	-- of tries required when placing a HQ in the corner of the map.
	-- (In this case the search space is reduced by 75% ...)
	local MAX_SPREAD = 1000
	local SPREAD_MULT = 1.02
	-- Minimum distance between any two spawned units.
	local CLEARANCE = 125
	-- Minimum distance bewteen each unit and the spawn center (HQ position)
	local HQ_CLEARANCE = 200
	local spawnQueue = {}

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
		local units = Spring.GetUnitsInCylinder(x, z, CLEARANCE)
		if (units[1] ~= nil) then
			return false
		end
		return true
	end

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		-- special case for Soviet commander
		if ud.name:lower() == "ruscommissar1" then
			spawnQueue[unitID] = true
			return
		end
		if Spring.GetGameFrame() == 1 then
			if (ud.customParams.hq == "1") then
				spawnQueue[unitID] = true
			end
		end
	end

	function gadget:GameFrame(n)
		if next(spawnQueue) then
			for unitID, someThing in pairs(spawnQueue) do
				local unitDefID = Spring.GetUnitDefID(unitID)
				local teamID = Spring.GetUnitTeam(unitID)
				local ud = UnitDefs[unitDefID]
				local spawnList = hqDefs[ud.name]
				if not spawnList then return end
				local px, py, pz = Spring.GetUnitPosition(unitID)
				--local steps = 1
				for _, unitName in ipairs(spawnList.units) do
					local udid = UnitDefNames[unitName].id
					local spread = spawnList.spread
					while (spread < MAX_SPREAD) do
						local dx = math.random(-spread, spread)
						local dz = math.random(-spread, spread)
						local x = px + dx
						local z = pz + dz
						if (dx*dx + dz*dz > HQ_CLEARANCE * HQ_CLEARANCE) and IsPositionValid(udid, x, z) then
							Spring.CreateUnit(unitName, x, py, z, 0, teamID)
							break
						end
						spread = spread * SPREAD_MULT
						--steps = steps + 1
					end
				end
				--Spring.Echo("average number of steps: " .. (steps / #spawnList.units))
			end
			spawnQueue = {}
		end
		-- Removes this gadget if the game has started.
		-- Only needs to run once at game start
		if (n==10) then
			gadgetHandler:RemoveGadget()
		end
	end


else -- UNSYNCED

end
