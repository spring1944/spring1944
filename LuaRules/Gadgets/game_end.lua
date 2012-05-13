function gadget:GetInfo()
	return {
		name = "Game Over Control",
		desc = "Implements the game ends conditions",
		author = "FLOZi (C. Lawrence)", -- based on doesNotCount by KDR_11k (D. Becker)
		date = "19 January 2012",
		license = "GNU GPL v2",
		layer = 1,
		enabled = false
	}
end

-- use the custom param dontcount = 1, to mark a unit as not counted

if gadgetHandler:IsSyncedCode() then

--SYNCED
-- localisations
-- SyncedCtrl
local KillTeam			= Spring.KillTeam
local TransferUnit		= Spring.TransferUnit
local SetUnitNeutral	= Spring.SetUnitNeutral

-- SyncedRead
local GetTeamInfo	= Spring.GetTeamInfo
local GetUnitDefID	= Spring.GetUnitDefID
local GetUnitTeam	= Spring.GetUnitTeam

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local GAIA_ALLY_ID = select(6, GetTeamInfo(GAIA_TEAM_ID))

-- Variables
local aliveCount = {}

local allyTeams = Spring.GetAllyTeamList()
local allyTeamMemberCount = {}
for i = 1, #allyTeams do
	local allyTeam = allyTeams[i]
	if allyTeam == GAIA_ALLY_ID then 
		allyTeams[i] = nil
	else
		allyTeamMemberCount[allyTeam] = #Spring.GetTeamList(allyTeam)
	end
end

-- Code starts
function gadget:UnitCreated(unitID, unitDefID, teamID)
	local cp = UnitDefs[unitDefID].customParams
	if cp and cp.dontcount ~= "1" then
		aliveCount[teamID] = aliveCount[teamID] + 1
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	local cp = UnitDefs[unitDefID].customParams
	if cp and cp.dontcount ~= "1" then
		aliveCount[teamID] = aliveCount[teamID] - 1
		if aliveCount[teamID] <= 0 then
			KillTeam(teamID)
		end
	end
end


function gadget:UnitTaken(unitID, unitDefID, oldTeamID, newTeamID)
	gadget:UnitCreated(unitID, unitDefID, newTeamID)
	gadget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end


function gadget:TeamDied(teamID)
	Spring.Echo("Team died: " .. teamID)
	local allyTeamID = select(6, GetTeamInfo(teamID))
	if allyTeamID and allyTeamID ~= GAIA_TEAM_ID then
	Spring.Echo("test 1")
		allyTeamMemberCount[allyTeamID] = allyTeamMemberCount[allyTeamID] - 1
		-- Check for game over
		if allyTeamMemberCount[allyTeamID] == 0 then -- an allyteam has died
		Spring.Echo("test 2")
			local allyTeamsAlive = 0
			local livingAllyTeam
			for allyTeam, memberCount in pairs(allyTeamMemberCount) do
				if memberCount > 0 then
					Spring.Echo("test 3")
					allyTeamsAlive = allyTeamsAlive + 1
					livingAllyTeam = allyTeam
				end
			end
			-- Game Over if only one allyTeam remains alive
			if allyTeamsAlive == 1 then Spring.Echo("test 4")
			Spring.GameOver({livingAllyTeam}) end
		end
	end
end


function gadget:Initialize()
	-- This is mainly for /luarules reload, 
	-- but it doesn't take into account allyTeams that might already be dead
	for _, teamID in ipairs(Spring.GetTeamList()) do
		aliveCount[teamID] = 0
	end
	-- count all units already existing
	local allUnits = Spring.GetAllUnits()
	for i = 1, #allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, GetUnitDefID(unitID), GetUnitTeam(unitID))
	end
end

else

--UNSYNCED

return false
end
