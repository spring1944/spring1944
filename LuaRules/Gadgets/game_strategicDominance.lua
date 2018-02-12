local moduleInfo = {
	name = "game_strategicDominance",
	desc = "Custom endgame rules.",
	author = "PepeAmpere",
	date = "2018-01-29",
	license = "notAlicense",
	layer = 0,
	enabled = true -- loaded by default?
}

function gadget:GetInfo()
	return moduleInfo
end

if (not gadgetHandler:IsSyncedCode()) then return end -- SYNCED only

-- INITIAL PARAMETERS
-- NOTE: All fall-back values are used only if launched without lobby (or simplified startscript), otherwise some defaults are present
-- init default if no mode selected
local victoryMode = Spring.GetModOptions().victorymode or "strategicdominance"
-- stop loading if different end game mode
if (victoryMode ~= "strategicdominance") then return false end

-- MODULES
-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

hmsf = attach.Module(modules, "hmsf")
tableExt = attach.Module(modules, "tableExt")
strongpoints = attach.Module(modules, "strongpoints")
goals = attach.Module(modules, "goals")

-- CONSTANTS
local STRONGPOINTS_RATIO = tonumber(Spring.GetModOptions().strongpointsratio or "0.7")
local DOMINANCE_TIMEOUT = tonumber(Spring.GetModOptions().dominancetimeout or "6")
local DOMINANCE_TIMEOUT_RESET = Spring.GetModOptions().strongpointsration or "noWithPenalty"
local DOMINANCE_TIMEOUT_TEXT = DOMINANCE_TIMEOUT .. " minutes" 
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local _,_,_,_,_,GAIA_ALLY_ID = Spring.GetTeamInfo(GAIA_TEAM_ID)
local DEFAULT_DOMINATING_ALLY_ID = GAIA_ALLY_ID
local DEFAULT_PENALTY_PER_TEAM_SECONDS = 10
local TICK_STEP_FRAMES = 5

-- LOCAL DATA STRUCTURES
local teamList = Spring.GetTeamList()
local teamIDtoAllyID = {} -- teamID => allyID
local alliancesScores = {} -- allyID => number
local allFlagsCount = 0
local dominatingAlly = DEFAULT_DOMINATING_ALLY_ID
local dominationCount = math.huge
local defaultTimerValue = hmsf(0, DOMINANCE_TIMEOUT, 0, 0):Normalize()
local alliancesCountdowns = {} -- allyID => hmsf() time
local ZERO_TIME = hmsf(0, 0, 0, 0)
local actualPenalty = ZERO_TIME:Copy()
victoryDeclared = false
--local lastUpdates = {}

-- LOCAL FUNCTIONS
local function FlagsOfThisTeam(previousValue, flagID, flagData, teamID)
	if (flagData.ownerTeamID == teamID) then
		previousValue = previousValue + 1
	end
	return previousValue
end

local function InitTeamsAndAlliances()
	for i=1, #teamList do
		local teamID = teamList[i]
		local _,_,_,isAI,side,allyID = Spring.GetTeamInfo(teamID)
		teamIDtoAllyID[teamID] = allyID
		
		if (alliancesScores[allyID] == nil) then
			alliancesScores[allyID] = 0
		end
		
		if (alliancesCountdowns[allyID] == nil) then
			alliancesCountdowns[allyID] = defaultTimerValue:Copy()
		end
	end
	
	actualPenalty = hmsf(0, 0, DEFAULT_PENALTY_PER_TEAM_SECONDS, 0) * math.log(#teamList, 2) 
end

local function InitCounts()
	allFlagsCount = Script.LuaRules.Strongpoints_Count()
	dominationCount = math.ceil(allFlagsCount * STRONGPOINTS_RATIO)
end

local function ResetAllyScores()
	for allyID,_ in pairs(alliancesScores) do
		alliancesScores[allyID] = 0
	end
end

local function UpdateAllyScores()
	ResetAllyScores()
	for i=1, #teamList do
		local teamID = teamList[i]
		local thisTeamFlagsCount = tableExt.Fold(Script.LuaRules.Strongpoints_GetAll(), 0, FlagsOfThisTeam, teamID)
		alliancesScores[teamIDtoAllyID[teamID]] = alliancesScores[teamIDtoAllyID[teamID]] + thisTeamFlagsCount
	end
end

local function UpdateGoals()	
	for scoreAllyID, score in pairs(alliancesScores) do
		local goalNameBase = scoreAllyID .. scoreAllyID .. "_"
		
		-- first ally-own flags and timers
		local thisAllyGoals = {
			{
				key = goalNameBase .. "captureFlags",
				goalType = "captureFlags",
				ownerAllianceID = scoreAllyID,
				
				currentFlags = score,
				flagsToWin = dominationCount,
			},
			{
				key = goalNameBase .. "holdFlags",
				goalType = "holdFlags",
				ownerAllianceID = scoreAllyID,
				
				remainingTime = alliancesCountdowns[scoreAllyID]:Copy(),
				totalTime = defaultTimerValue:Copy(),
				totalTimeText = DOMINANCE_TIMEOUT_TEXT,
				flagsToWin = dominationCount,
			}
		}
	
		for countdownAllyID, timeValue in pairs(alliancesCountdowns) do
			-- if not same ally
			-- + avoid making mission goals to fight with gaia
			if (scoreAllyID ~= countdownAllyID and countdownAllyID ~= GAIA_ALLY_ID) then
				
				goalNameBase = scoreAllyID .. countdownAllyID .. "_"				
				
				-- one enemy ally flags
				thisAllyGoals[#thisAllyGoals + 1] = {
					key = goalNameBase .. "preventCapturingFlags",
					goalType = "preventCapturingFlags",
					ownerAllianceID = scoreAllyID,
					
					currentFlags = alliancesScores[countdownAllyID],
					flagsToWin = dominationCount,
					allianceID = countdownAllyID,
				}
				
				-- one enemy ally holding flags			
				thisAllyGoals[#thisAllyGoals + 1] = {
					key = goalNameBase .. "preventHoldingFlags",
					goalType = "preventHoldingFlags",
					ownerAllianceID = scoreAllyID,
					
					remainingTime = timeValue:Copy(),
					totalTime = defaultTimerValue:Copy(),
					totalTimeText = DOMINANCE_TIMEOUT_TEXT,
					flagsToWin = dominationCount,
					allianceID = countdownAllyID,
				}
			end
		end
		
		-- save to team info of each team in currently probed ally 
		for teamID, allyID in pairs(teamIDtoAllyID) do
			if allyID == scoreAllyID then
				message.SendSyncedInfoTeamPacked(
					"missionGoals",
					message.Encode(thisAllyGoals),
					teamID,
					"allied"
				)
			end
		end
			
	end	
end

local function TriggerCountdown(allyID)
	-- nothing yet
end

local function StopCountdown(allyID)
	-- resets 
	if     (DOMINANCE_TIMEOUT_RESET == "yes") then
		alliancesCountdowns[allyID] = defaultTimerValue:Copy()
	elseif (DOMINANCE_TIMEOUT_RESET == "noWithPenalty") then
		alliancesCountdowns[allyID] = alliancesCountdowns[allyID] + actualPenalty
	end
	-- if set to "no", we can skip it
end

local function TickCountdown(allyID)
	alliancesCountdowns[allyID] = alliancesCountdowns[allyID] - hmsf(0, 0, 0, TICK_STEP_FRAMES)
	-- Spring.Echo(allyID .. " is going to win. Remaining time is " .. alliancesCountdowns[allyID]:HHMMSSFF(false, true, true, false))
end

local function CheckDominance()
	for allyID, strongpointsCount in pairs(alliancesScores) do
		-- Spring.Echo(strongpointsCount .. " of " .. allFlagsCount)
		if (allyID ~= GAIA_ALLY_ID) then
			if (strongpointsCount >= dominationCount) then
				if (dominatingAlly ~= allyID) then
					TriggerCountdown(allyID)
					dominatingAlly = allyID
				end
				break
			else
				if (dominatingAlly == allyID) then
					StopCountdown(allyID)
					dominatingAlly = DEFAULT_DOMINATING_ALLY_ID
				end
			end
		end
	end
end

local function DeclareVictory(allyID)
	Spring.GameOver({allyID})
	
	victoryDeclared = true
end

local function CheckVictory()
	for allyID, countdown in pairs(alliancesCountdowns) do
		if countdown ~= nil then
			if (countdown <= ZERO_TIME) then
				DeclareVictory(allyID)
				break
			end
		end
	end
end

-- HANDLERS
function gadget:Initialize()
	gadgetHandler:RegisterGlobal('Strongpoints_Add', strongpoints.Add)
	gadgetHandler:RegisterGlobal('Strongpoints_Count', strongpoints.Count)
	gadgetHandler:RegisterGlobal('Strongpoints_GetAll', strongpoints.GetAll)
	gadgetHandler:RegisterGlobal('Strongpoints_Remove', strongpoints.Remove)
	gadgetHandler:RegisterGlobal('Strongpoints_Update', strongpoints.Update)
	gadgetHandler:RegisterGlobal('Strongpoints_UpdateParameter', strongpoints.UpdateParameter)
	
	InitTeamsAndAlliances()
end

function gadget:GameFrame(n)
	-- init values after the game starts and strongpoints are spawned
	if (n == 4) then
		InitCounts()
	end
	
	-- update 5x per second
	if (n % 6 == TICK_STEP_FRAMES and not victoryDeclared) then
		UpdateAllyScores()
		CheckDominance()
		if (dominatingAlly ~= DEFAULT_DOMINATING_ALLY_ID) then
			TickCountdown(dominatingAlly)
		end
		UpdateGoals()
		CheckVictory()
	end
end