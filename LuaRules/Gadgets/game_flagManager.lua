function gadget:GetInfo()
	return {
		name      = "Flag Manager",
		desc      = "Populates maps with flags and handles control",
		author    = "FLOZi",
		date      = "31st July 2008",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-- function localisations
-- Synced Read
local AreTeamsAllied				= Spring.AreTeamsAllied
local GetGroundInfo					= Spring.GetGroundInfo
local GetGroundHeight				=	Spring.GetGroundHeight
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitTeam						= Spring.GetUnitTeam
local GetUnitDefID       		= Spring.GetUnitDefID
local GetTeamInfo						= Spring.GetTeamInfo
-- Synced Ctrl
local CreateUnit						= Spring.CreateUnit
local SetUnitNeutral				=	Spring.SetUnitNeutral
local SetUnitAlwaysVisible	= Spring.SetUnitAlwaysVisible
local TransferUnit					= Spring.TransferUnit
local GiveOrderToUnit				= Spring.GiveOrderToUnit
local CallCOBScript					= Spring.CallCOBScript
local SetUnitRulesParam			= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID					= Spring.GetGaiaTeamID()
local BLOCK_SIZE						= 32	-- size of map to check at once
local METAL_THRESHOLD				= 1 
local PROFILE_PATH					= "maps/" .. string.sub(Game.mapName, 1, string.len(Game.mapName) - 4) .. "_profile.lua"
local FLAG_RADIUS						= 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD		= 10 -- number of capping points needed for a flag to switch teams, again possibilities for modoptions
local FLAG_REGEN						= 1		-- how fast a flag with no defenders or attackers will reduce capping statuses
local SIDES									= {gbr = 1, ger = 2, rus = 3, us = 4}

-- variables
local avgMetal							= 0	-- average metal per spot
local totalMetal						= 0 -- total metal found
local minMetalLimit 				= 0	-- minimum metal to place a flag at
local numSpots							= 0 -- number of spots found
local spots 								= {} -- table of flag locations
local flags 								= {} -- table of flag unitIDs
local cappers 							= {} -- table of flag cappers
local defenders							= {} -- table of flag defenders
local flagCapStatuses				= {{}} -- table of flag's capping statuses
local teams									= Spring.GetTeamList()


if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function PlaceFlag(spot)
	newFlag = CreateUnit("flag", spot.x, 0, spot.z, 0, GAIA_TEAM_ID)
	SetUnitNeutral(newFlag, true)
	SetUnitAlwaysVisible(newFlag, true)
	table.insert(flags, newFlag)
end


function getFlagControl(flagID)
	local flagControl = 0
end


function gadget:GameFrame(n)
	-- FLAG PLACEMENT
	if n == 5 then
		if not VFS.FileExists(PROFILE_PATH) then
			Spring.Echo("Map Flag Profile not found. Autogenerating flag positions.")
			for z = 0, Game.mapSizeZ, BLOCK_SIZE do
				for x = 0, Game.mapSizeX, BLOCK_SIZE do
					if GetGroundHeight(x,z) > 0 then
						_, metal = GetGroundInfo(x, z)
						if metal >= METAL_THRESHOLD then
							table.insert(spots, {x = x, z = z, metal = metal})
							numSpots = numSpots + 1
							totalMetal = totalMetal + metal
						end
					end
				end
			end
			avgMetal = totalMetal / numSpots
			minMetalLimit = 0.75 * avgMetal
			local onlyFlagSpots = {}
			for _, spot in pairs(spots) do
				if spot.metal >= minMetalLimit then
					local unitsAtSpot = GetUnitsInCylinder(spot.x, spot.z, Game.extractorRadius * 1.5, GAIA_TEAM_ID)
					if #unitsAtSpot == 0 then
						PlaceFlag(spot)
						table.insert(onlyFlagSpots, {x = spot.x, z = spot.z})
					end
				end
			end
			spots = onlyFlagSpots
			
		else -- load the flag positions from profile
			Spring.Echo("Map Flag Profile found. Loading flag positions.")
			spots = VFS.Include(PROFILE_PATH)
			for _, spot in pairs(spots) do
				PlaceFlag(spot)
			end
		end
		
	elseif n == 40 then
		for _, flagID in pairs(flags) do
			SetUnitAlwaysVisible(flagID, false)
			flagCapStatuses[flagID] = {}
		end
			
	end
	
	-- FLAG CONTROL
	if n % 30 == 5 and n > 40 then
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
							SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID])
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
							SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID])
						end
					end
					if (flagCapStatuses[flagID][teamID] or 0) > FLAG_CAP_THRESHOLD and teamID ~= flagTeamID then
						if (flagTeamID == GAIA_TEAM_ID) then
							Spring.SendMessageToTeam(teamID, "Flag Captured!")
							TransferUnit(flagID, teamID, false)
							local _, _, _, _, side = GetTeamInfo(teamID)
							CallCOBScript(flagID, "ShowFlag", 0, SIDES[side] or 0)
						else
							Spring.SendMessageToTeam(teamID, "Flag Neutralised!")
							TransferUnit(flagID, GAIA_TEAM_ID, false)	
							CallCOBScript(flagID, "ShowFlag", 0, 0)
						end
						GiveOrderToUnit(flagID, CMD.ONOFF, {1}, {})
						for cleanTeamID = 0, #teams-1 do
							flagCapStatuses[flagID][cleanTeamID] = 0
							SetUnitRulesParam(flagID, "cap" .. tostring(cleanTeamID), 0)
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
		cappers[unitID] = ud.customParams.flagcaprate
		defenders[unitID] = ud.customParams.flagcaprate
	end
	if (ud.customParams.flagdefendrate) then
		defenders[unitID] = ud.customParams.flagdefendrate
	end
end

else
-- UNSYNCED
end
