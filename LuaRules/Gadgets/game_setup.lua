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
-- SyncedRead
local GetFeaturesInRectangle	= Spring.GetFeaturesInRectangle
local GetGroundHeight			= Spring.GetGroundHeight
local GetSideData				= Spring.GetSideData
local GetTeamInfo				= Spring.GetTeamInfo
local GetTeamStartPosition		= Spring.GetTeamStartPosition
local GetTeamUnits				= Spring.GetTeamUnits -- backwards compat
local GetUnitDefID				= Spring.GetUnitDefID
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local TestBuildOrder			= Spring.TestBuildOrder
-- SyncedCtrl
local CreateUnit				= Spring.CreateUnit
local DestroyFeature			= Spring.DestroyFeature
local SetTeamResource			= Spring.SetTeamResource


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
local HALF_MAP_X = Game.mapSizeX/2
local HALF_MAP_Z = Game.mapSizeZ/2
local STARTING_LOGISTICS = 1040 + 1 -- Add 1 storage so losing all storage buildings doesn't cause everything to cease working

local hqDefs = VFS.Include("LuaRules/Configs/hq_spawn.lua")
local modOptions = Spring.GetModOptions()

local function IsPositionValid(unitDefID, x, z)
	-- Don't place units underwater. (this is also checked by TestBuildOrder
	-- but that needs proper maxWaterDepth/floater/etc. in the UnitDef.)
	local y = GetGroundHeight(x, z)
	if (y <= 0) then
		return false
	end
	-- Don't place units where it isn't be possible to build them normally.
	local test = TestBuildOrder(unitDefID, x, y, z, 0)
	if (test ~= 2) then
		return false
	end
	-- Don't place units too close together.
	local ud = UnitDefs[unitDefID]
	local units = GetUnitsInCylinder(x, z, CLEARANCE)
	if (units[1] ~= nil) then
		return false
	end
	return true
end

local function ClearUnitPosition(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local ud = UnitDefs[unitDefID]
	
	local px, py, pz = GetUnitPosition(unitID)
	local sideLength = math.max(ud.xsize, ud.zsize) * 7 -- why 14/2?
	local xmin = px - sideLength
	local xmax = px + sideLength
	local zmin = pz - sideLength
	local zmax = pz + sideLength
			
	local features = GetFeaturesInRectangle(xmin, zmin, xmax, zmax)
			
	if features then
		for i = 1, #features do
			DestroyFeature(features[i])
		end
	end
end

local function SpawnBaseUnits(teamID, startUnit, px, pz)
	local spawnList = hqDefs[startUnit]
	if spawnList then
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
					-- hack to make soviet AIs spawn with static storage instead of deployable truck
					if unitName == "russupplytruck" and Spring.GetAIInfo(teamID) then
						local unitID = CreateUnit("russtorage", x, 0, z, 0, teamID)
						ClearUnitPosition(unitID)
						break
					end
					local unitID = CreateUnit(unitName, x, 0, z, 0, teamID)
					ClearUnitPosition(unitID)
					break
				end
				spread = spread * SPREAD_MULT
			end
		end
	end
end

local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, GetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = GetSideData()
		if (sidedata and #sidedata > 0) then
			startUnit = sidedata[1 + teamID % #sidedata].startUnit
		end
	else
		startUnit = GetSideData(side)
	end
	-- Check for GM / Random team
	if (modOptions.gm_team_enable == "0") then
		if startUnit == "gmtoolbox" then
			local randSide = math.random(1,4)	
			side, startUnit = GetSideData(randSide)
		end
	end
	GG.teamSide[teamID] = side
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = GetStartUnit(teamID)
	if (startUnit and startUnit ~= "") then
		-- spawn the specified start unit
		local x,y,z = GetTeamStartPosition(teamID)
		-- snap to 16x16 grid
		x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		y = GetGroundHeight(x, z)
		-- facing toward map center
		local facing=math.abs(HALF_MAP_X - x) > math.abs(HALF_MAP_Z - z)
			and ((x > HALF_MAP_X) and "west" or "east")
			or ((z > HALF_MAP_Z) and "north" or "south")
		
		local unitID = CreateUnit(startUnit, x, y, z, facing, teamID)
		ClearUnitPosition(unitID)
		SpawnBaseUnits(teamID, startUnit, x, z)
	end
end

local function SetStartResources(teamID)
	-- in S44, starting logisticsStorage is always 1k
	SetTeamResource(teamID, "es", STARTING_LOGISTICS)
	-- and teams start with full logistics
	SetTeamResource(teamID, "e", STARTING_LOGISTICS)
	-- commandStorage is set through modOptions, default 1k
	local commandStorage = tonumber(modOptions.command_storage) or 1000
	SetTeamResource(teamID, "ms", commandStorage)
	-- and teams start with 1k command
	SetTeamResource(teamID, "m", 1000)
end


function gadget:GameStart()
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	
	--Make a global list of the side for each team, because with random faction
	--it is not trivial to find out the side of a team using Spring's API.
	-- data set in GetStartUnit function. NB. The only use for this currently is flags
	GG.teamSide = {}

	-- spawn start units
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			SpawnStartUnit(teamID)
			SetStartResources(teamID)
		end
	end
	-- Run once then remove the gadget
	gadgetHandler:RemoveGadget()
end
