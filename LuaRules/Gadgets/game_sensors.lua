function gadget:GetInfo()
	return {
		name = "Game Sensors",
		desc = "Units in radar range become visible",
		author = "FLOZi (C. Lawrence)",
		date = "02/02/2011",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

-- Localisations
-- Synced Read
local GetGameFrame 		= Spring.GetGameFrame
local GetTeamInfo		= Spring.GetTeamInfo
local GetAllyTeamList   = Spring.GetAllyTeamList
local IsPosInAirLos     = Spring.IsPosInAirLos
local GetUnitPosition   = Spring.GetUnitPosition

-- Synced Ctrl
local SetUnitLosMask 	= Spring.SetUnitLosMask
local SetUnitLosState 	= Spring.SetUnitLosState

-- Unsynced Ctrl
-- Constants

-- Variables
local modOptions = Spring.GetModOptions()
local inRadarUnits = {}
local outRadarUnits = {}
-- ships get detected in air los ranges.
local ships = {}

local allyTeams = GetAllyTeamList()
local numAllyTeams = #allyTeams

for i = 1, numAllyTeams do
	local allyTeam = allyTeams[i]
	inRadarUnits[allyTeam] = {}
	outRadarUnits[allyTeam] = {}
end

local function showUnitToAllyTeam(unitID, allyTeamID)
    SetUnitLosState(unitID, allyTeamID, {los=true, prevLos=true, radar=true, contRadar=true} ) 
    SetUnitLosMask(unitID, allyTeamID, {los=true, prevLos=true, radar=false, contRadar=true} )	
end

local function hideUnitFromAllyTeam(unitID, allyTeamID)
    SetUnitLosMask(unitID, allyTeamID, {los=false, prevLos=false, radar=false, contRadar=false} )
end

--[[
-- Update a ship's LoS mask depending on whether or not they're in Air LoS for 
-- an allyTeam
--
-- @param shipUnitID
-- @param shipAllyTeamID
-- @return void
--]]
local function updateShipVisibility(shipUnitID, shipAllyTeamID)
    local shipX, shipY, shipZ = GetUnitPosition(shipUnitID)
	local turrets = GG.boatMothers[shipUnitID]
    for _, viewingAllyTeamID in ipairs(GetAllyTeamList()) do
        if viewingAllyTeamID ~= shipAllyTeamID and shipZ then
            if IsPosInAirLos(shipX, shipY, shipZ, viewingAllyTeamID) then
                showUnitToAllyTeam(shipUnitID, viewingAllyTeamID)
				if turrets then
					for _, turretUnitID in ipairs(turrets) do
						showUnitToAllyTeam(turretUnitID, viewingAllyTeamID)
					end
				end
            else
                hideUnitFromAllyTeam(shipUnitID, viewingAllyTeamID)
				if turrets then
					for _, turretUnitID in ipairs(turrets) do
						hideUnitFromAllyTeam(turretUnitID, viewingAllyTeamID)
					end
				end
            end
        end
    end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    if ud.modCategories.ship then
        local _, _, _, _, _, shipAllyTeamID = GetTeamInfo(teamID)
        ships[unitID] = shipAllyTeamID
        updateShipVisibility(unitID, shipAllyTeamID)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID)
    local ud = UnitDefs[unitDefID]
    if ud.floatOnWater then
        ships[unitID] = nil
    end
end

function gadget:UnitEnteredRadar(unitID, unitTeam, allyTeam, unitDefID)
	local ud = UnitDefs[unitDefID]
	local boatTurret = ud.customParams and ud.customParams.child
	if not ships[unitID] and not boatTurret then
		inRadarUnits[allyTeam][unitID] = true
		outRadarUnits[allyTeam][unitID] = nil
	end
end

function gadget:UnitLeftRadar(unitID, unitTeam, allyTeam, unitDefID)
    local ud = UnitDefs[unitDefID]
	local boatTurret = ud.customParams and ud.customParams.child
    if not ships[unitID] and not boatTurret then
        outRadarUnits[allyTeam][unitID] = true
        inRadarUnits[allyTeam][unitID] = nil
    end
end

function gadget:GameFrame(n)
    -- update ship visiblity every second. theoretically there should rarely be 
    -- more than ~30 ships in game at once, so this shouldn't be too crunchy.
	if n % (1*30) < 0.1 then
        for shipUnitID, shipAllyTeamID in pairs(ships) do
            updateShipVisibility(shipUnitID, shipAllyTeamID)
        end
    end

	for i = 1, numAllyTeams do
		local allyTeam = allyTeams[i]
		for unitID in pairs(inRadarUnits[allyTeam]) do
            showUnitToAllyTeam(unitID, allyTeam)
            inRadarUnits[allyTeam][unitID] = nil
		end
		for unitID in pairs(outRadarUnits[allyTeam]) do
            hideUnitFromAllyTeam(unitID, allyTeam)
            outRadarUnits[allyTeam][unitID] = nil
		end
	end
end

else

-- UNSYNCED

end
