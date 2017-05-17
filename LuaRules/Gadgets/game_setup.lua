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
local GetTeamRulesParam			= Spring.GetTeamRulesParam
local GetTeamStartPosition		= Spring.GetTeamStartPosition
local GetTeamUnits				= Spring.GetTeamUnits -- backwards compat
local GetUnitDefID				= Spring.GetUnitDefID
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local TestBuildOrder			= Spring.TestBuildOrder
local TestMoveOrder				= Spring.TestMoveOrder
local GetPlayerInfo				= Spring.GetPlayerInfo
local GetGameFrame				= Spring.GetGameFrame
-- SyncedCtrl
local CreateUnit				= Spring.CreateUnit
local DestroyFeature			= Spring.DestroyFeature
local SetTeamResource			= Spring.SetTeamResource
local SetTeamRulesParam			= Spring.SetTeamRulesParam


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

local AIUnitReplacementTable = {}

local function IsPositionValid(teamID, unitDefID, x, z)
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
	local ud = UnitDefs[unitDefID]
	-- avoid plopping units in places they can't move out of
	if ud.speed > 0 then
		local sx, sy, sz = GetTeamStartPosition(teamID)
		local validMoveToStart = TestMoveOrder(unitDefID, x, y, z, sx, sy, sz, true, true)
		if not validMoveToStart then
			return false
		end
	end
	-- Don't place units too close together.
	local units = GetUnitsInCylinder(x, z, CLEARANCE)
	if (units[1] ~= nil) then
		return false
	end
	return true
end

local function ClearUnitPosition(unitID)
	if not unitID then
		Spring.Log('game setup', 'error', "tried to clear unit position with a nil unitID")
		return
	end

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
	local isLuaAITeam = ((Spring.GetTeamLuaAI(teamID) or '') ~= '')
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
				if (dx*dx + dz*dz > HQ_CLEARANCE * HQ_CLEARANCE) and IsPositionValid(teamID, udid, x, z) then
					-- hack to make soviet AIs spawn with static storage instead of deployable truck
					-- and possibly other AI-specific units
					-- facing toward map center
		local facing=math.abs(HALF_MAP_X - x) > math.abs(HALF_MAP_Z - z)
			and ((x > HALF_MAP_X) and "west" or "east")
			or ((z > HALF_MAP_Z) and "north" or "south")
					if AIUnitReplacementTable[unitName] and isLuaAITeam then
						unitName = AIUnitReplacementTable[unitName]
					end
					local unitID = CreateUnit(unitName, x, 0, z, facing, teamID)
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
	local side = GG.teamSide[teamID]
	if side == "" then side = select(5, GetTeamInfo(teamID)) end
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = GetSideData()
		if (sidedata and #sidedata > 0) then
			local sideNum = math.random(2,#GetSideData()) --2 + teamID % #sidedata
			startUnit = sidedata[sideNum].startUnit
			side = sidedata[sideNum].sideName
		end
		-- set the gamerules param to notify other gadgets it was a direct launch
		Spring.SetGameRulesParam("runningWithoutScript", 1)
	else
		startUnit = GetSideData(side)
	end
	-- Check for GM / Random team
	if startUnit == "gmtoolbox" then
		local randSide = math.random(2,#GetSideData())	-- start at 2 to avoid picking random side again
		if (modOptions.gm_team_enable == "0") then
			side, startUnit = GetSideData(randSide)
		else
			side = GetSideData(randSide)
		end
	end
	GG.teamSide[teamID] = side
	SetTeamRulesParam(teamID, "side", side)
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = GetStartUnit(teamID)
	if (startUnit and startUnit ~= "") then
		-- spawn the specified start unit
		local x,y,z = GetTeamStartPosition(teamID)
		-- Erase start position marker while we're here
		Spring.MarkerErasePosition(x or 0, y or 0, z or 0)
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

local function InitAIUnitReplacementTable()
	Spring.Log('game setup', 'info', "Loading AI unit replacement tables...")
	local SideFiles = VFS.DirList("luarules/configs/side_ai_unit_replacement", "*.lua")
	Spring.Log('game setup', 'info', "Found "..#SideFiles.." tables")
	-- then add their contents to the main table
	for _, SideFile in pairs(SideFiles) do
		Spring.Log('game setup', 'info', " - Processing "..SideFile)
		local tmpTable = VFS.Include(SideFile)
		if tmpTable then
			local tmpCount = 0
			for unitName, replacementName in pairs(tmpTable) do
				AIUnitReplacementTable[unitName] = replacementName
				tmpCount = tmpCount + 1
			end
			Spring.Log('game setup', 'info', " -- Added "..tmpCount.." entries")
			tmpTable = nil
		end
	end
end

function gadget:Initialize()
	GG.teamSide = {}
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			local side = GetTeamRulesParam(teamID, "side")
			if side then
				GG.teamSide[teamID] = side
			else
				GG.teamSide[teamID] = ""
			end
		end
	end
end

function gadget:GameStart()
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()

	InitAIUnitReplacementTable()

	--Make a global list of the side for each team, because with random faction
	--it is not trivial to find out the side of a team using Spring's API.
	-- data set in GetStartUnit function. NB. The only use for this currently is flags

	-- spawn start units
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			SpawnStartUnit(teamID)
			SetStartResources(teamID)
		end
	end
	-- not needed after spawning everyone
	GG.RemoveGadget(self)
end

-- keep track of choosing faction ingame
function gadget:RecvLuaMsg(msg, playerID)
	-- these messages are only useful during pre-game placement
	if GetGameFrame() > 0 then
		return false
	end

	local code = string.sub(msg,1,1)
	if code ~= '\138' then
		return
	end
	local side = string.sub(msg,2,string.len(msg))
	local _, _, playerIsSpec, playerTeam = GetPlayerInfo(playerID)
	if not playerIsSpec then
		GG.teamSide[playerTeam] = side
		SetTeamRulesParam(playerTeam, "side", side, {allied=true, public=false}) -- visible to allies only, set visible to all on GameStart
		side = select(5, GetTeamInfo(playerTeam))
		return true
	end
end
