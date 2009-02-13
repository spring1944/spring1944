-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Slightly based on the Kernel Panic AI by KDR_11k (David Becker) and zwzsg.

-- In-game, type /luarules craig in the console to toggle the ai debug messages

function gadget:GetInfo()
	return {
		name = "C.R.A.I.G.: 1944",
		desc = "Configurable Reusable Artificial Intelligence Gadget for Spring: 1944",
		author = "Tobi Vollebregt",
		date = "2009-02-12",
		license = "GNU General Public License",
  		layer = 82,
		enabled = true
	}
end

do
-- If not in synced code, ask for a quiet death.
-- (Tried to make the AI unsynced one time but I seem to get no
--  Unit events then so it's pointless... (no errors either))
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- If no AIs are in the game, ask for a quiet death.
local function CountBots()
	local count = 0
	for _,t in ipairs(Spring.GetTeamList()) do
		if Spring.GetTeamLuaAI(t) == gadget:GetInfo().name then
			count = count + 1
		end
	end
	return count
end

if CountBots() == 0 then
	return false
end
end

--------------------------------------------------------------------------------

-- include configuration
include("LuaRules/Configs/craig/buildorder.lua")

-- include code
include("LuaRules/Gadgets/craig/buildorder.lua")
include("LuaRules/Gadgets/craig/buildsite.lua")
include("LuaRules/Gadgets/craig/team.lua")

-- globals
local CRAIG_Debug_Mode = 0 -- Must be 0 or 1

local team = {}

local function ChangeAIDebugVerbosity(cmd,line,words,player)
	local lvl = tonumber(words[1])
	if lvl then
		CRAIG_Debug_Mode = lvl
		Spring.Echo("C.R.A.I.G.: debug verbosity set to " .. CRAIG_Debug_Mode)
	else
		if CRAIG_Debug_Mode > 0 then
			CRAIG_Debug_Mode = 0
		else
			CRAIG_Debug_Mode = 1
		end
		Spring.Echo("C.R.A.I.G.: debug verbosity toggled to " .. CRAIG_Debug_Mode)
	end
	return true
end

local function SetupCmdChangeAIDebugVerbosity()
	local cmd,func,help
	cmd  = "craig"
	func = ChangeAIDebugVerbosity
	help = " [0|1]: make C.R.A.I.G. shut up or fill your infolog"
	gadgetHandler:AddChatAction(cmd,func,help)
	Script.AddActionFallback(cmd .. ' ',help)
end

function Log(message)
	if CRAIG_Debug_Mode > 0 then
		Spring.Echo("C.R.A.I.G.: " .. message)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

-- Execution order:
--  gadget:Initialize
--  gadget:GamePreload
--  gadget:UnitCreated (for each HQ / comm)
--  gadget:GameStart

function gadget:Initialize()
	--Log("gadget:Initialize")
	SetupCmdChangeAIDebugVerbosity()
end

function gadget:GamePreload()
	-- This is executed BEFORE headquarters / commander is spawned
	--Log("gadget:GamePreload")
	-- Initialise AI for all team that are set to use it
	for _,t in ipairs(Spring.GetTeamList()) do
		--Log("considering team " .. t)
		if Spring.GetTeamLuaAI(t) == gadget:GetInfo().name then
			local _,_,_,_,side,at = Spring.GetTeamInfo(t)
			team[t] = CreateTeam(t, at, side)
		end
	end
end

function gadget:GameStart()
	-- This is executed AFTER headquarters / commander is spawned
	--Log("gadget:GameStart")
	for _,t in pairs(team) do
		t.GameStart()
	end
end

function gadget:GameFrame(f)
	-- AI update
	if f % 128 < .1 then
		for _,t in pairs(team) do
			t.GameFrame(f)
		end
	end
end

--------------------------------------------------------------------------------
--
--  Game call-ins
--

function gadget:TeamDied(teamID)
	if team[teamID] then
		team[teamID] = nil
		Log("removed team " .. teamID)
	end

	--TODO: need to call this for other/enemy teams too, so a team
	-- can adjust it's fight orders to the remaining living teams.
	--for _,t in pairs(team) do
	--	t.TeamDied(teamID)
	--end
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if team[unitTeam] then
		team[unitTeam].UnitCreated(unitID, unitDefID, unitTeam, builderID)
	end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	if team[unitTeam] then
		team[unitTeam].UnitFinished(unitID, unitDefID, unitTeam)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if team[unitTeam] then
		team[unitTeam].UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	end
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	if team[unitTeam] then
		team[unitTeam].UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	if team[unitTeam] then
		team[unitTeam].UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	end
end

-- This may be called by engine from inside Spring.GiveOrderToUnit (e.g. if unit limit is reached)
function gadget:UnitIdle(unitID, unitDefID, unitTeam)
end
