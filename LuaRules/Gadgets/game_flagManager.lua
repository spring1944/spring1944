function gadget:GetInfo()
	return {
		name	  = "Flag Manager",
		desc	  = "Populates maps with flags and handles control",
		author	  = "FLOZi, AnalyseMetalMap algorithm from easymetal.lua by CarRepairer",
		date	  = "31st July 2008",
		license   = "GNU GPL v2",
		layer	  = -5,
		enabled   = true  --  loaded by default?
	}
end

-- function localisations
local floor						= math.floor
-- Synced Read
local AreTeamsAllied			= Spring.AreTeamsAllied
local GetFeatureDefID			= Spring.GetFeatureDefID
local GetFeaturePosition		= Spring.GetFeaturePosition
local GetGroundHeight			= Spring.GetGroundHeight
-- 104.0.1: Spring.GetGroundInfo returns different values. Better using
-- Spring.GetMetalAmount
-- local GetGroundInfo				= Spring.GetGroundInfo
local GetMetalAmount			= Spring.GetMetalAmount
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitTransporter		= Spring.GetUnitTransporter
local GetTeamRulesParam			= Spring.GetTeamRulesParam
local GetTeamUnitDefCount		= Spring.GetTeamUnitDefCount
local GetTeamUnitsSorted		= Spring.GetTeamUnitsSorted
local GetUnitDefID				= Spring.GetUnitDefID
-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local CreateUnit				= Spring.CreateUnit
local DestroyFeature			= Spring.DestroyFeature
local GiveOrderToUnit			= Spring.GiveOrderToUnit
local SetTeamRulesParam			= Spring.SetTeamRulesParam
local SetUnitAlwaysVisible		= Spring.SetUnitAlwaysVisible
local SetUnitBlocking			= Spring.SetUnitBlocking
local SetUnitNeutral			= Spring.SetUnitNeutral
local SetUnitNoSelect			= Spring.SetUnitNoSelect
local SetUnitRulesParam			= Spring.SetUnitRulesParam
local TransferUnit				= Spring.TransferUnit

-- constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local PROFILE_PATH = "maps/flagConfig/" .. Game.mapName .. "_profile.lua"
local DEBUG	= false -- enable to print out flag locations in profile format

local CAP_MULT = 0.25 --multiplies against the FBI defined CapRate
local DEF_MULT = 0.25 --multiplies against the FBI defined DefRate

-- easymetal constants
local EXTRACT_RADIUS = Game.extractorRadius > 125 and Game.extractorRadius or 125
local GRID_SIZE	= Game.squareSize
local THRESH_FRACTION = 0.4
local MAP_WIDTH = floor(Game.mapSizeX / GRID_SIZE)
local MAP_HEIGHT = floor(Game.mapSizeZ / GRID_SIZE)

-- variables
local maxMetal = 1
local metalSpots = {}
local metalSpotCount	= 0
local metalData = {}
local metalDataCount = 0

local buoySpots = {}
local numBuoySpots = 0

local flagTypes = {"flag", "buoy"}
local flags = {} -- flags[flagType][index] == flagUnitID
local numFlags = {} -- numFlags[flagType] == numberOfFlagsOfType
local flagTypeData = {} -- flagTypeData[flagType] = {radius = radius, etc}
local flagTypeSpots = {} -- flagTypeSpots[flagType][metalSpotCount] == {x = x_coord, z = z_coord}
local flagTypeCappers = {} -- cappers[flagType][unitID] = true
local flagTypeDefenders	= {} -- defenders[flagType][unitID] = true

for _, flagType in pairs(flagTypes) do
	local cp = UnitDefNames[flagType].customParams
	flagTypeData[flagType] = {
		radius = tonumber(cp.flagradius) or 230, -- radius of flagTypes capping area
		capThreshold = tonumber(cp.capthreshold) or 10, -- number of capping points needed for flagType to switch teams
		regen = tonumber(cp.flagregen) or 1, -- how fast a flagType with no defenders or attackers will reduce capping statuses
		tooltip = UnitDefNames[flagType].tooltip or "Flag", -- what to call the flagType when it switches teams
		limit = cp.flaglimit or Game.maxUnits, -- How many of this flagType a player can hold at once
	}
	flags[flagType] = {}
	numFlags[flagType] = 0
	flagTypeSpots[flagType] = {}
	flagTypeCappers[flagType] = {}
	flagTypeDefenders[flagType] = {}
end


local flagCapStatuses = {} -- table of flag's capping statuses

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

-- easymetal code starts
local function round(num, idp)
  local mult = 10^(idp or 0)
  return floor(num * mult + 0.5) / mult
end


local function mergeToSpot(spotNum, px, pz, pWeight)
	local sx = metalSpots[spotNum].x
	local sz = metalSpots[spotNum].z
	local sWeight = metalSpots[spotNum].weight

	local avgX, avgZ

	if sWeight > pWeight then
		local sStrength = round(sWeight / pWeight)
		avgX = (sx*sStrength + px) / (sStrength +1)
		avgZ = (sz*sStrength + pz) / (sStrength +1)
	else
		local pStrength = (pWeight / sWeight)
		avgX = (px*pStrength + sx) / (pStrength +1)
		avgZ = (pz*pStrength + sz) / (pStrength +1)
	end

	metalSpots[spotNum].x = avgX
	metalSpots[spotNum].z = avgZ
	metalSpots[spotNum].weight = sWeight + pWeight
end


local function NearSpot(px, pz, dist)
	for k, spot in pairs(metalSpots) do
		local sx, sz = spot.x, spot.z
		if (px-sx)^2 + (pz-sz)^2 < dist then
			return k
		end
	end
	return false
end


local function AnalyzeMetalMap()
	for mx_i = 1, MAP_WIDTH do
		for mz_i = 1, MAP_HEIGHT do
			local mx = mx_i * GRID_SIZE
			local mz = mz_i * GRID_SIZE
			-- 104.0.1: Spring.GetGroundInfo returns different values. Better
			-- using Spring.GetMetalAmount
			local mCur = GetMetalAmount(mx / (GRID_SIZE * 2),
			                            mz / (GRID_SIZE * 2))
			--mCur = floor(mCur * 100)
			if (mCur > maxMetal) then
				maxMetal = mCur
			end
		end
	end

	local lowMetalThresh = floor(maxMetal * THRESH_FRACTION)

	for mx_i = 1, MAP_WIDTH do
		for mz_i = 1, MAP_HEIGHT do
			local mx = mx_i * GRID_SIZE
			local mz = mz_i * GRID_SIZE
			-- Storing metalMap may be too much memory consuming. Even more if
			-- a wrong GRID_SIZE is choosen (like it happened before). Hence, is
			-- better calling GetMetalAmount again (since it is pure C
			-- implementation, it would be even faster!).
			local mCur = GetMetalAmount(mx / (GRID_SIZE * 2),
			                            mz / (GRID_SIZE * 2))
			if mCur > lowMetalThresh then
				metalDataCount = metalDataCount +1

				metalData[metalDataCount] = {
					x = mx_i * GRID_SIZE,
					z = mz_i * GRID_SIZE,
					metal = mCur
				}

			end
		end
	end

	table.sort(metalData, function(a,b) return a.metal > b.metal end)

	for index = 1, metalDataCount do
		local mx = metalData[index].x
		local mz = metalData[index].z
		local mCur = metalData[index].metal
		local underwater = GetGroundHeight(mx, mz) <= 0

		local nearSpotNum = NearSpot(mx, mz, EXTRACT_RADIUS*EXTRACT_RADIUS)

		if nearSpotNum then
			mergeToSpot(nearSpotNum, mx, mz, mCur)
		else
			metalSpotCount = metalSpotCount + 1
			metalSpots[metalSpotCount] = {
				x = mx,
				z = mz,
				weight = mCur,
				underwater = underwater
			}
		end
	end

	local controlPoints = { buoy = {}, flag = {} }

	for _, spot in pairs(metalSpots) do
		if spot.underwater then
			table.insert(controlPoints['buoy'], spot)
		else
			table.insert(controlPoints['flag'], spot)
		end
	end

	return controlPoints
end
-- easymetal code ends

-- this function is used to add any additional flagType specific behaviour
function FlagSpecialBehaviour(flagType, flagID, flagTeamID, teamID)
	if flagType == "flag" then
		local env = Spring.UnitScript.GetScriptEnv(flagID)
		Spring.UnitScript.CallAsUnit(flagID, env.script.Create, teamID)
	end
end

function PlaceFlag(spot, flagType, unitID)
	if DEBUG then
		Spring.Echo("{")
		Spring.Echo("	x = " .. spot.x .. ",")
		Spring.Echo("	z = " .. spot.z .. ",")
		Spring.Echo("	initialProduction = 5, --default value. change!")
		Spring.Echo("},")
	end

	local newFlag = unitID or CreateUnit(flagType, spot.x, 0, spot.z, 0, GAIA_TEAM_ID)

	-- this is picked up in game_handleFlagReturns to actually produce the
	-- resources
	if spot.initialProduction then
		SetUnitRulesParam(newFlag, "map_config_init_production", spot.initialProduction, {public = true})
	end

	numFlags[flagType] = numFlags[flagType] + 1
	flags[flagType][numFlags[flagType]] = newFlag
	flagCapStatuses[newFlag] = {}

	SetUnitBlocking(newFlag, false, false, false)
	SetUnitNeutral(newFlag, true)
	SetUnitNoSelect(newFlag, true)
	SetUnitAlwaysVisible(newFlag, true)


	if modOptions and modOptions.always_visible_flags == "0" then
		-- Hide the flags after a 1 second (30 frame) delay so they are ghosted
		GG.Delay.DelayCall(SetUnitAlwaysVisible, {newFlag, false}, 30)
	end

	table.insert(GG.flags, newFlag)
end


function gadget:Initialize()
	if DEBUG then Spring.Echo(PROFILE_PATH) end
	-- CHECK FOR PROFILES
	if VFS.FileExists(PROFILE_PATH) then
		local flagSpots, buoySpots = VFS.Include(PROFILE_PATH)
		if flagSpots and #flagSpots > 0 then
			Spring.Log('flag manager', 'info', "Map Flag Profile found. Loading Flag positions...")
			flagTypeSpots["flag"] = flagSpots
		end
		if buoySpots and #buoySpots > 0 then
			Spring.Log('flag manager', 'info', "Map Buoy Profile found. Loading Buoy positions...")
			flagTypeSpots["buoy"] = buoySpots
		end
	end
	-- TODO: for loop this somehow (table values can't be called, table keys can?)
	local generatedSpots = AnalyzeMetalMap()
	-- no flag profile found, use metal map for flag spawns
	if #flagTypeSpots["flag"] == 0 then
		Spring.Log('flag manager', 'info', "Map Flag Profile not found. Using autogenerated Flag positions...")
		flagTypeSpots['flag'] = generatedSpots['flag']
	end
	-- no buoy profile found, use metal map for flag spawns
	if #flagTypeSpots["buoy"] == 0 then
		Spring.Log('flag manager', 'info', "Map Buoy Profile not found. Using autogenerated Buoy positions...")
		flagTypeSpots['buoy'] = generatedSpots['buoy']
	end

	-- populated by placeFlag
	GG.flags = {}
	for _, flagType in pairs(flagTypes) do
		for i = 1, #flagTypeSpots[flagType] do
			local sx, sz = flagTypeSpots[flagType][i].x, flagTypeSpots[flagType][i].z
			local units = GetUnitsInCylinder(sx, sz, 1)
			for _, unitID in pairs(units) do
				local name = UnitDefs[GetUnitDefID(unitID)].name
				if name == flagType then
					PlaceFlag(flagTypeSpots[flagType][i], flagType, unitID)
					break
				end
			end
		end
	end

	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, GetUnitDefID(unitID))
	end
end


function gadget:GameStart()
	-- FLAG PLACEMENT
	for _, flagType in pairs(flagTypes) do
		if DEBUG then Spring.Echo("-- flagType is " .. flagType) end
		for i = 1, #flagTypeSpots[flagType] do
			PlaceFlag(flagTypeSpots[flagType][i], flagType)
		end
	end
end


function gadget:GameFrame(n)
	-- FLAG CONTROL
	if n % 30 == 5 then -- every second with a 5 frame offset
		local teams = Spring.GetTeamList()
		for _, flagType in pairs(flagTypes) do
			local flagData = flagTypeData[flagType]
			--for spotNum, flagID in pairs(flags[flagType]) do
			for spotNum = 1, numFlags[flagType] do -- WARNING: Assumes flags are placed in order they exist in flags[flagType]
				local flagID = flags[flagType][spotNum]
				local flagTeamID = GetUnitTeam(flagID)
				local spots = flagTypeSpots[flagType]
				local cappers = flagTypeCappers[flagType]
				local defenders = flagTypeDefenders[flagType]
				local defendTotal = 0
				local unitsAtFlag = GetUnitsInCylinder(spots[spotNum].x, spots[spotNum].z, flagData.radius)
				if #unitsAtFlag == 1 then -- Only the flag, no other units
					for _, teamID in pairs(teams) do
						if teamID ~= flagTeamID then
							if (flagCapStatuses[flagID][teamID] or 0) > 0 then
								flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - flagData.regen
								SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
							end
						end
					end
				else -- Attackers or defenders (or both) present
					for i = 1, #unitsAtFlag do
						local unitID = unitsAtFlag[i]
						local unitTeamID = GetUnitTeam(unitID)
						if defenders[unitID] and AreTeamsAllied(unitTeamID, flagTeamID) and not GetUnitTransporter(unitID) then
							defendTotal = defendTotal + defenders[unitID]
						end
						if cappers[unitID] and (not AreTeamsAllied(unitTeamID, flagTeamID)) and not GetUnitTransporter(unitID) then
							if (flagTeamID ~= GAIA_TEAM_ID or GetTeamUnitDefCount(unitTeamID, UnitDefNames[flagType].id) < flagData.limit) then
								flagCapStatuses[flagID][unitTeamID] = (flagCapStatuses[flagID][unitTeamID] or 0) + cappers[unitID]
							end
						end
					end
					for _, teamID in pairs(teams) do
						if teamID ~= flagTeamID then
							if (flagCapStatuses[flagID][teamID] or 0) > 0 then
								flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - defendTotal
								if flagCapStatuses[flagID][teamID] < 0 then
									flagCapStatuses[flagID][teamID] = 0
								end
								SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
							end
						end
						if (flagCapStatuses[flagID][teamID] or 0) > flagData.capThreshold and teamID ~= flagTeamID then
							-- Flag is ready to change team
							if (flagTeamID == GAIA_TEAM_ID) then
								-- Neutral flag being capped
								--Spring.SendMessageToTeam(teamID, flagData.tooltip .. " Captured!")
								TransferUnit(flagID, teamID, false)
								SetTeamRulesParam(teamID, "flags", (GetTeamRulesParam(teamID, "flags") or 0) + 1, {public = true})
								-- send message to other gadgets should they need it
								if GG.FlagCapNotification then
									GG.FlagCapNotification(flagID, teamID)
								end
							else
								-- Team flag being neutralised
								--Spring.SendMessageToTeam(teamID, flagData.tooltip .. " Neutralised!")
								TransferUnit(flagID, GAIA_TEAM_ID, false)
								SetTeamRulesParam(teamID, "flags", (GetTeamRulesParam(teamID, "flags") or 0) - 1, {public = true})
							end
							-- reset production
							SetUnitRulesParam(flagID, "lifespan", 0)

							-- Perform any flagType specific behaviours
							FlagSpecialBehaviour(flagType, flagID, flagTeamID, teamID)
							-- Turn flag back on
							GiveOrderToUnit(flagID, CMD.ONOFF, {1}, {})
							-- Flag has changed team, reset capping statuses
							for _, cleanTeamID in pairs(teams) do
								flagCapStatuses[flagID][cleanTeamID] = 0
								SetUnitRulesParam(flagID, "cap" .. tostring(cleanTeamID), 0, {public = true})
							end
						end
						-- cleanup defenders
						flagCapStatuses[flagID][flagTeamID] = 0
					end
				end
			end
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	local flagCapRate = cp.flagcaprate
	local flagDefendRate = cp.flagdefendrate or flagCapRate
	local flagCapType = ud.customParams.flagcaptype or "flag"
	if flagCapRate then
		flagTypeCappers[flagCapType][unitID] = (CAP_MULT * flagCapRate)
		flagTypeDefenders[flagCapType][unitID] = (DEF_MULT * flagCapRate)
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	local flagCapRate = cp.flagcaprate
	local flagCapType = ud.customParams.flagcaptype or "flag"
	if flagCapRate then
		flagTypeCappers[flagCapType][unitID] = nil
		flagTypeDefenders[flagCapType][unitID] = nil
	end
end

else
-- UNSYNCED
end
