function gadget:GetInfo()
	return {
		name      = "Flag Manager",
		desc      = "Populates maps with flags and handles control",
		author    = "FLOZi",
		date      = "31st July 2008",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = false  --  loaded by default?
	}
end

-- function localisations
-- Synced Read
local GetGroundInfo					= Spring.GetGroundInfo
local GetGroundHeight				=	Spring.GetGroundHeight
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitAllyTeam				= Spring.GetUnitAllyTeam
local GetUnitRulesParam			= Spring.GetUnitRulesParam
-- Synced Ctrl
local CreateUnit						= Spring.CreateUnit
local SetUnitNeutral				=	Spring.SetUnitNeutral
local SetUnitAlwaysVisible	= Spring.SetUnitAlwaysVisible
local SetUnitRulesParam			= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID					= Spring.GetGaiaTeamID()
local BLOCK_SIZE						= 32	-- size of map to check at once
local METAL_THRESHOLD				= 1 
local PROFILE_PATH					= "maps/" .. string.sub(Game.mapName, 1, string.len(Game.mapName) - 4) .. "_profile.lua"
local FLAG_RADIUS						= 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD		= 100 -- number of capping points needed for a flag to switch teams

-- variables
--local maxMetal 							= 0 -- maximum metal found on map
local avgMetal							= 0	-- average metal per spot
local totalMetal						= 0 -- total metal found
local minMetalLimit 				= 0	-- minimum metal to place a flag at
local numSpots							= 0 -- number of spots found
local spots 								= {} -- table of flag locations
local flags 								= {} -- table of flag unitIDs
local cappers 							= {} -- table of flag cappers
local defenders							= {} -- table of flag defenders
local flagCapStatuses				= {{}} -- table of flag's capping statuses
local allyTeams							= Spring.GetAllyTeamList()


if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function PlaceFlag(spot)
	newFlag = CreateUnit("flag", spot.x, 0, spot.z, 0, GAIA_TEAM_ID)
	SetUnitNeutral(newFlag, true)
	SetUnitAlwaysVisible(newFlag, true)
	table.insert(flags, newFlag)
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
							--maxMetal = math.max(metal, maxMetal)
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
			flagCapStatuses[flagID] = allyTeams
		end
			
	end
	
	-- FLAG CONTROL
	-- TODO: stuff!
	if n % 30 == 5 and n > 40 then
		for spotNum, flagID in pairs(flags) do
			local unitsAtFlag = GetUnitsInCylinder(spots[spotNum].x, spots[spotNum].z, FLAG_RADIUS)
			for _, unitID in pairs(unitsAtFlag) do
				local unitAllyTeamID = GetUnitAllyTeam(unitID)
				local flagAllyTeamID = GetUnitAllyTeam(flagID)
				if unitAllyTeamID ~= flagAllyTeamID and cappers[unitID] then
					flagCapStatuses[flagID][unitAllyTeamID] = (flagCapStatuses[flagID][unitAllyTeamID] or 0) + cappers[unitID]
				elseif unitAllyTeamID == flagAllyTeamID and defenders[unitID] then
					flagCapStatuses[flagID][flagAllyTeamID] = (flagCapStatuses[flagID][flagAllyTeamID] or 0) + defenders[unitID]
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
