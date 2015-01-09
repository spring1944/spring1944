function gadget:GetInfo()
	return {
		name = "Game Over Control",
		desc = "Implements the game ends conditions",
		author = "FLOZi (C. Lawrence)", -- based on doesNotCount by KDR_11k (D. Becker)
		date = "19 January 2012",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end

-- use the custom param dontcount = 1, to mark a unit as not counted

if gadgetHandler:IsSyncedCode() then

--SYNCED
-- localisations
local DelayCall = GG.Delay.DelayCall

-- SyncedCtrl
local KillTeam			= Spring.KillTeam
local TransferUnit		= Spring.TransferUnit
local SetUnitNeutral	= Spring.SetUnitNeutral

-- SyncedRead
local GetTeamInfo	= Spring.GetTeamInfo
local GetUnitDefID	= Spring.GetUnitDefID
local GetUnitTeam	= Spring.GetUnitTeam
local GetAllyTeamList = Spring.GetAllyTeamList
local GetPlayerList = Spring.GetPlayerList
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamList = Spring.GetTeamList

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local GAIA_ALLY_ID = select(6, GetTeamInfo(GAIA_TEAM_ID))

-- Variables
local aliveCount = {}

-- to be initialized on first frame
local isAbandonedTeamCheckActive = nil

local allyTeams = Spring.GetAllyTeamList()
local allyTeamMemberCount = {}
for i = 1, #allyTeams do
	local allyTeam = allyTeams[i]
	if allyTeam == GAIA_ALLY_ID then 
		allyTeams[i] = nil
	else
		allyTeamMemberCount[allyTeam] = #GetTeamList(allyTeam)
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

local function CheckTeams(teamID)
	local allyTeamID = select(6, GetTeamInfo(teamID))
	if allyTeamID and allyTeamID ~= GAIA_TEAM_ID then
		allyTeamMemberCount[allyTeamID] = allyTeamMemberCount[allyTeamID] - 1
		-- Check for game over
		if allyTeamMemberCount[allyTeamID] == 0 then -- an allyteam has died
			local allyTeamsAlive = 0
			local livingAllyTeam
			for allyTeam, memberCount in pairs(allyTeamMemberCount) do
				if memberCount > 0 then
					allyTeamsAlive = allyTeamsAlive + 1
					livingAllyTeam = allyTeam
				end
			end
			-- Game Over if only one allyTeam remains alive
			if allyTeamsAlive == 1 then 
				Spring.GameOver({livingAllyTeam})
				-- no need to do anything beyond this point
				gadgetHandler:RemoveGadget()
			end
		end
	end
end

local function CheckAbandonedAllyTeams()
	local currentATList = GetAllyTeamList()
	for i = 1, #currentATList do
		local allyTeamID = currentATList[i]
		if allyTeamID ~= GAIA_TEAM_ID then
			local allyTeamIsDead = true
			local playerList = GetPlayerList()

			for _, playerID in ipairs(playerList) do
				local _, isPlayerActive, _, _, playerAllyTeamID = GetPlayerInfo(playerID)
				if isPlayerActive and (playerAllyTeamID == allyTeamID) then
					allyTeamIsDead = false
					break
				end
			end

			if allyTeamIsDead then
				-- kill off the teams which compose this AllyTeam
				local teamList = GetTeamList(allyTeamID)
				for i = 1, #teamList do
					local teamID = teamList[i]
					local _, _, isDead, isAI = GetTeamInfo(teamID)
					if (not isDead) and (not isAI) then
						KillTeam(teamID)
					end
				end
			end
		end
	end
end

function gadget:TeamDied(teamID)
	DelayCall(CheckTeams, {teamID}, 1)
end

function gadget:GameFrame(n)
	-- should the check be active at all?
	if isAbandonedTeamCheckActive == nil then
		if Spring.GetGameRulesParam("runningWithoutScript") or 0 == 1 then
			isAbandonedTeamCheckActive = false
			Spring.Echo('Game launched without script, disabling abandoned team check')
		else
			isAbandonedTeamCheckActive = true
			Spring.Echo('Abandoned team check active')
		end
	end
	-- check for abandoned units, about once per 2 seconds
	if isAbandonedTeamCheckActive then
		if (n > 0) and (n % 60 < 0.1) then
			CheckAbandonedAllyTeams()
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
