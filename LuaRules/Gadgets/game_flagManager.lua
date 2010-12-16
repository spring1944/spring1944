function gadget:GetInfo()
	return {
		name      = "Flag Manager",
		desc      = "Populates maps with flags and handles control",
		author    = "FLOZi, AnalyseMetalMap algorithm from easymetal.lua by CarRepairer",
		date      = "31st July 2008",
		license   = "GNU GPL v2",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-- function localisations
local floor						= math.floor
-- Synced Read
local AreTeamsAllied			= Spring.AreTeamsAllied
local GetGroundInfo				= Spring.GetGroundInfo
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitTeam				= Spring.GetUnitTeam
local GetTeamRulesParam			= Spring.GetTeamRulesParam

-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local CreateUnit				= Spring.CreateUnit
local GiveOrderToUnit			= Spring.GiveOrderToUnit
local SetTeamRulesParam			= Spring.SetTeamRulesParam
local SetUnitAlwaysVisible		= Spring.SetUnitAlwaysVisible
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitNeutral			= Spring.SetUnitNeutral
local SetUnitNoSelect			= Spring.SetUnitNoSelect
local SetUnitResourcing			= Spring.SetUnitResourcing
local SetUnitRulesParam			= Spring.SetUnitRulesParam
local TransferUnit				= Spring.TransferUnit

-- constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local PROFILE_PATH = "maps/flagConfig/" .. Game.mapName .. "_profile.lua"

local EXTRACT_RADIUS = Game.extractorRadius > 125 and Game.extractorRadius or 125
local GRID_SIZE	= 4
local THRESH_FRACTION = 0.4
local MAP_WIDTH = floor(Game.mapSizeX / GRID_SIZE)
local MAP_HEIGHT = floor(Game.mapSizeZ / GRID_SIZE)

local FLAG_RADIUS = 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD = 10 -- number of capping points needed for a flag to switch teams, again possibilities for modoptions
local FLAG_REGEN = 1 -- how fast a flag with no defenders or attackers will reduce capping statuses
local CAP_MULT = 0.25 --multiplies against the FBI defined CapRate
local DEF_MULT = 1 --multiplies against the FBI defined DefRate
local SIDES	= {gbr = 1, ger = 2, rus = 3, us = 4, [""] = 2}
local DEBUG	= false -- enable to print out flag locations in profile format

-- variables
local metalMap = {}
local maxMetal = 0
local totalMetal = 0
local spots = {}
local spotCount	= 0
local metalData = {}
local metalDataCount = 0

local flags = {}
local numFlags = 0
local cappers = {} -- table of flag cappers
local defenders	= {} -- table of flag defenders
local flagCapStatuses = {} -- table of flag's capping statuses
local teams	= Spring.GetTeamList()

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end
local metalMake = tonumber(modOptions.map_command_per_player) or -1

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local DelayCall = GG.Delay.DelayCall

local function round(num, idp)
  local mult = 10^(idp or 0)
  return floor(num * mult + 0.5) / mult
end


local function mergeToSpot(spotNum, px, pz, pWeight)
	local sx = spots[spotNum].x
	local sz = spots[spotNum].z
	local sWeight = spots[spotNum].weight
	
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
	
	spots[spotNum].x = avgX
	spots[spotNum].z = avgZ
	spots[spotNum].weight = sWeight + pWeight
end


local function NearSpot(px, pz, dist)
	for k, spot in pairs(spots) do
		local sx, sz = spot.x, spot.z
		if (px-sx)^2 + (pz-sz)^2 < dist then
			return k
		end
	end
	return false
end


local function AnalyzeMetalMap()	
	for mx_i = 1, MAP_WIDTH do
		metalMap[mx_i] = {}
		for mz_i = 1, MAP_HEIGHT do
			local mx = mx_i * GRID_SIZE
			local mz = mz_i * GRID_SIZE
			local _, curMetal = GetGroundInfo(mx, mz)
			totalMetal = totalMetal + curMetal
			--curMetal = floor(curMetal * 100)
			metalMap[mx_i][mz_i] = curMetal
			if (curMetal > maxMetal) then
				maxMetal = curMetal
			end	
		end
	end
	
	local lowMetalThresh = floor(maxMetal * THRESH_FRACTION)
	
	for mx_i = 1, MAP_WIDTH do
		for mz_i = 1, MAP_HEIGHT do
			local mCur = metalMap[mx_i][mz_i]
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
		
		local nearSpotNum = NearSpot(mx, mz, EXTRACT_RADIUS*EXTRACT_RADIUS)
	
		if nearSpotNum then
			mergeToSpot(nearSpotNum, mx, mz, mCur)
		else
			spotCount = spotCount + 1
			spots[spotCount] = {
				x = mx,
				z = mz,
				weight = mCur
			}
		end
	end
	if metalMake >= 0 then
		metalMake = metalMake * (#teams - 1) / #spots
	end
end


function PlaceFlag(spot)
	local newFlag = CreateUnit("flag", spot.x, 0, spot.z, 0, GAIA_TEAM_ID)
	numFlags = numFlags + 1
	flags[numFlags] = newFlag
	
	if DEBUG then
		Spring.Echo("{")
		Spring.Echo("	x = " .. spot.x .. ",")
		Spring.Echo("	z = " .. spot.z .. ",")
		Spring.Echo("	feature = nil")
		Spring.Echo("},")
	end
	
	SetUnitNeutral(newFlag, true)
	SetUnitNoSelect(newFlag, true)
	SetUnitAlwaysVisible(newFlag, true)
	if modOptions and modOptions.always_visible_flags == "0" then
		-- Hide the flags after a 1 second (30 frame) delay so they are ghosted
		DelayCall(SetUnitAlwaysVisible, {newFlag, false}, 30)
	end
	if metalMake >= 0 then
		SetUnitMetalExtraction(newFlag, 0, 0) -- remove extracted metal
		SetUnitResourcing(newFlag, "umm", metalMake)
	end
	
	flagCapStatuses[newFlag] = {}
end


function gadget:GamePreload()
	-- FIND METAL SPOTS
	if not VFS.FileExists(PROFILE_PATH) then
		Spring.Echo("Map Flag Profile not found. Autogenerating flag positions.")
		AnalyzeMetalMap()
	end
end


function gadget:GameStart()
	-- FLAG PLACEMENT
	if DEBUG then
		Spring.Echo(PROFILE_PATH)
	end
	if  VFS.FileExists(PROFILE_PATH) then -- load the flag positions from profile
		Spring.Echo("Map Flag Profile found. Loading flag positions.")
		spots = VFS.Include(PROFILE_PATH)
	end
	for i = 1, spotCount do
		PlaceFlag(spots[i])
	end
	GG['flags'] = flags
end


function gadget:GameFrame(n)
	-- FLAG CONTROL
	if n % 30 == 5 then -- every second with a 5 frame offset
		for spotNum, flagID in pairs(flags) do
			local flagTeamID = GetUnitTeam(flagID)
			local defendTotal = 0
			local unitsAtFlag = GetUnitsInCylinder(spots[spotNum].x, spots[spotNum].z, FLAG_RADIUS)
			--Spring.Echo ("There are " .. #unitsAtFlag .. " units at flag " .. flagID)
			if #unitsAtFlag == 1 then -- Only the flag, no other units
				for teamID = 0, #teams-1 do
					if teamID ~= flagTeamID then
						if (flagCapStatuses[flagID][teamID] or 0) > 0 then
							flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - FLAG_REGEN
							SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
						end
					end
				end
			else -- Attackers or defenders (or both) present
				for i = 1, #unitsAtFlag do
					local unitID = unitsAtFlag[i]
					local unitTeamID = GetUnitTeam(unitID)
					if AreTeamsAllied(unitTeamID, flagTeamID) and defenders[unitID] then
						--Spring.Echo("Defender at flag " .. flagID .. " Value is: " .. defenders[unitID])
						defendTotal = defendTotal + defenders[unitID]
					end
					if (not AreTeamsAllied(unitTeamID, flagTeamID)) and cappers[unitID] then
						--Spring.Echo("Capper at flag " .. flagID .. " Value is: " .. cappers[unitID])
						flagCapStatuses[flagID][unitTeamID] = (flagCapStatuses[flagID][unitTeamID] or 0) + cappers[unitID]
					end
				end
				for j = 1, #teams do
					teamID = teams[j]
					if teamID ~= flagTeamID then
						if (flagCapStatuses[flagID][teamID] or 0) > 0 then
							--Spring.Echo("Capping: " .. flagCapStatuses[flagID][teamID] .. " Defending: " .. defendTotal)
							flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - defendTotal
							if flagCapStatuses[flagID][teamID] < 0 then
								flagCapStatuses[flagID][teamID] = 0
							end
							SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
						end
					end
					if (flagCapStatuses[flagID][teamID] or 0) > FLAG_CAP_THRESHOLD and teamID ~= flagTeamID then
						if (flagTeamID == GAIA_TEAM_ID) then
							Spring.SendMessageToTeam(teamID, "Flag Captured!")
							TransferUnit(flagID, teamID, false)
							SetUnitRulesParam(flagID, "lifespan", 0)
							SetTeamRulesParam(teamID, "flags", (GetTeamRulesParam(teamID, "flags") or 0) + 1, {public = true})
							CallCOBScript(flagID, "ShowFlag", 0, SIDES[GG.teamSide[teamID]] or 0)
						else
							Spring.SendMessageToTeam(teamID, "Flag Neutralised!")
							TransferUnit(flagID, GAIA_TEAM_ID, false)
							SetUnitRulesParam(flagID, "lifespan", 0)
							SetTeamRulesParam(teamID, "flags", (GetTeamRulesParam(teamID, "flags") or 0) - 1, {public = true})
							CallCOBScript(flagID, "ShowFlag", 0, 0)
						end
						GiveOrderToUnit(flagID, CMD.ONOFF, {1}, {})
						for cleanTeamID = 0, #teams-1 do
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


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if (ud.customParams.flagcaprate) then
		cappers[unitID] = (CAP_MULT*ud.customParams.flagcaprate)
		defenders[unitID] = (CAP_MULT*ud.customParams.flagcaprate)
	end
	if (ud.customParams.flagdefendrate) then
		defenders[unitID] = (DEF_MULT*ud.customParams.flagdefendrate)
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	cappers[unitID] = nil
	defenders[unitID] = nil
end

else
-- UNSYNCED
end
