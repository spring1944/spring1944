--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_spawn.lua
--  brief:   spawns start unit and sets storage levels
--  author:  Tobi Vollebregt
--
--  Copyright (C) 2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start unit and sets storage levels",
		author    = "Tobi Vollebregt, Craig Lawrence (FLOZi), B. Tyler (Nemo)",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- localisations
-- SyncedCtrl
local SetTeamResource = Spring.SetTeamResource

-- constants
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

local hqDefs = VFS.Include("LuaRules/Configs/hq_spawn.lua")
local modOptions = Spring.GetModOptions()

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

local function ClearUnitPosition(unitID)
	local unitDefID = Spring.GetUnitDefID(unitID)
	local ud = UnitDefs[unitDefID]
	
	local px, py, pz = Spring.GetUnitPosition(unitID)
	local sideLength = math.max(ud.xsize, ud.zsize) * 7 -- why 14/2?
	local xmin = px - sideLength
	local xmax = px + sideLength
	local zmin = pz - sideLength
	local zmax = pz + sideLength
			
	local features = Spring.GetFeaturesInRectangle(xmin, zmin, xmax, zmax)
			
	if features then
		for i = 1, #features do
			Spring.DestroyFeature(features[i])
		end
	end
end

local function SpawnBaseUnits(teamID, startUnit, px, pz)
	local spawnList = hqDefs[startUnit]
	for i = 1, #spawnList.units do
		local unitName = spawnList.units[i]
		local udid = UnitDefNames[unitName].id
		local spread = spawnList.spread
		while (spread < MAX_SPREAD) do
			local dx = math.random(-spread, spread)
			local dz = math.random(-spread, spread)
			local x = px + dx
			local z = pz + dz
			if (dx*dx + dz*dz > HQ_CLEARANCE * HQ_CLEARANCE) and IsPositionValid(udid, x, z) then
				local unitID = Spring.CreateUnit(unitName, x, 0, z, 0, teamID)
				ClearUnitPosition(unitID)
				break
			end
			spread = spread * SPREAD_MULT
		end
	end
end

local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, Spring.GetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = Spring.GetSideData()
		if (sidedata and #sidedata > 0) then
			startUnit = sidedata[1 + teamID % #sidedata].startUnit
		end
	else
		startUnit = Spring.GetSideData(side)
	end
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = GetStartUnit(teamID)
	if (startUnit and startUnit ~= "") then
		-- spawn the specified start unit
		local x,y,z = Spring.GetTeamStartPosition(teamID)
		-- snap to 16x16 grid
		x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		y = Spring.GetGroundHeight(x, z)
		-- facing toward map center
		local facing=math.abs(Game.mapSizeX/2 - x) > math.abs(Game.mapSizeZ/2 - z)
			and ((x>Game.mapSizeX/2) and "west" or "east")
			or ((z>Game.mapSizeZ/2) and "north" or "south")
		
		-- only spawn start unit if not already spawned by engine (backwards compat)
		if not (#Spring.GetTeamUnits(teamID) > 0) then
			local unitID = Spring.CreateUnit(startUnit, x, y, z, facing, teamID)
			-- set the *team's* lineage root
			Spring.SetUnitLineage(unitID, teamID, true)
		end
		ClearUnitPosition(Spring.GetTeamUnits(teamID)[1]) -- simplify to CUP(unitID) when removing backwards compat
		SpawnBaseUnits(teamID, startUnit, x, z)
	end
end

local function SetStartResources(teamID)
	-- in S44, starting logisticsStorage is always 1k
	SetTeamResource(teamID, "es", 1000)
	-- and teams start with full logistics
	SetTeamResource(teamID, "e", 1000)
	-- commandStorage is set through modOptions, default 1k
	local commandStorage = tonumber(modOptions.command_storage) or 1000
	SetTeamResource(teamID, "ms", commandStorage)
	-- and teams start with full command
	SetTeamResource(teamID, "m", 1000)
end


function gadget:GameStart()
	-- spawn start units
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			SpawnStartUnit(teamID)
			SetStartResources(teamID)
		end
	end
end
