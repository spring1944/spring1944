-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Slightly based on the Kernel Panic AI by KDR_11k (David Becker) and zwzsg.
-- Thanks to lurker for providing hints on how to make the AI run unsynced.

-- In-game, type /luarules craig in the console to toggle the ai debug messages

function gadget:GetInfo()
    return {
        name = "C.R.A.I.G.",
        desc = "Configurable Reusable Artificial Intelligence Gadget",
        author = "Tobi Vollebregt",
        date = "2009-02-12",
        license = "GNU General Public License",
          layer = 1,
        enabled = true
    }
end


-- Read mod options, we need this in both synced and unsynced code!
if (Spring.GetModOptions) then
    local modOptions = Spring.GetModOptions()
    local lookup = {"easy", "medium", "hard"}
    difficulty = lookup[tonumber(modOptions.craig_difficulty) or 2]
else
    difficulty = "hard"
end

-- include configuration
include("LuaRules/Configs/craig/config.lua")


if (gadgetHandler:IsSyncedCode()) then

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  SYNCED
--

-- globals
local unitLimits = {}

-- include code
include("LuaRules/Gadgets/craig/unitlimits.lua")

function gadget:GamePreload()
    -- Initialise unit limit for all AI teams.
    local name = gadget:GetInfo().name
    for _,t in ipairs(Spring.GetTeamList()) do
        if Spring.GetTeamLuaAI(t) ==  name then
            unitLimits[t] = CreateUnitLimitsMgr(t)
        end
    end
end

local function Refill(myTeamID, resource)
    if (gadget.difficulty ~= "easy") then
        local value,storage = Spring.GetTeamResources(myTeamID, resource)
        if (gadget.difficulty ~= "medium") then
            -- hard: full refill
            Spring.AddTeamResource(myTeamID, resource, storage - value)
        else
            -- medium: partial refill
            -- 1000 storage / 128 * 30 = approx. +234
            -- this means 100% cheat is bonus of +234 metal at 1k storage
            Spring.AddTeamResource(myTeamID, resource, (storage - value) * 0.05)
        end
    end
end

function gadget:GameFrame(f)
    -- Perform economy cheating, this must be done in synced code!
    if f % 128 < 0.1 then
        for t,_ in pairs(team) do
            Refill(t, "metal")
            Refill(t, "energy")
        end
    end
end

function gadget:AllowUnitCreation(unitDefID, builderID, builderTeam, x, y, z)
    if unitLimits[builderTeam] then
        return unitLimits[builderTeam].AllowUnitCreation(unitDefID)
    end
    return true
end

else

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  UNSYNCED
--

--constants
local MY_PLAYER_ID = Spring.GetMyPlayerID()

-- globals
waypointMgr = {}
intelligences = {}  -- One per team

-- include code
include("LuaRules/Gadgets/craig/buildsite.lua")
include("LuaRules/Gadgets/craig/base.lua")
include("LuaRules/Gadgets/craig/combat.lua")
include("LuaRules/Gadgets/craig/flags.lua")
include("LuaRules/Gadgets/craig/pathfinder.lua")
include("LuaRules/Gadgets/craig/unitlimits.lua")
include("LuaRules/Gadgets/craig/heatmap.lua")
include("LuaRules/Gadgets/craig/team.lua")
include("LuaRules/Gadgets/craig/waypoints.lua")
include("LuaRules/Gadgets/craig/intelligence.lua")

-- locals
local CRAIG_Debug_Mode = 0 -- Must be 0 or 1
local team = {}
local waypointMgrGameFrameRate = 0

--------------------------------------------------------------------------------

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
    --Script.AddActionFallback(cmd .. ' ',help)
end

function gadget.Log(...)
    if CRAIG_Debug_Mode > 0 then
        Spring.Echo("C.R.A.I.G.: " .. table.concat{...})
    end
end

-- This is for log messages which can not be turned off (e.g. while loading.)
function gadget.Warning(...)
    Spring.Echo("C.R.A.I.G.: " .. table.concat{...})
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
    setmetatable(gadget, {
        __index = function() error("Attempt to read undeclared global variable", 2) end,
        __newindex = function() error("Attempt to write undeclared global variable", 2) end,
    })
    SetupCmdChangeAIDebugVerbosity()
end

function gadget:GamePreload()
    -- This is executed BEFORE headquarters / commander is spawned
    Log("gadget:GamePreload")
    -- Intialise waypoint manager
    waypointMgr = CreateWaypointMgr()
    if waypointMgr then
        waypointMgrGameFrameRate = waypointMgr.GetGameFrameRate()
    end
end

local function CreateTeams()
    -- Initialise AI for all team that are set to use it
    local sidedata = Spring.GetSideData()
    local name = gadget:GetInfo().name
    for _,t in ipairs(Spring.GetTeamList()) do
        if (Spring.GetTeamLuaAI(t) == name) then
            local _,leader,_,_,_,at = Spring.GetTeamInfo(t)
            if (leader == MY_PLAYER_ID) then
                local units = Spring.GetTeamUnits(t)
                -- Figure out the side we're on by searching for our
                -- startUnit in Spring's sidedata.
                local side
                for _,u in ipairs(units) do
                    if (not Spring.GetUnitIsDead(u)) then
                        local unit = UnitDefs[Spring.GetUnitDefID(u)].name
                        for _,s in ipairs(sidedata) do
                            if (s.startUnit == unit) then side = s.sideName end
                        end
                    end
                end
                if (side) then
                    -- Intialise intelligence
                    intelligences[t] = CreateIntelligence(t, at)

                    team[t] = CreateTeam(t, at, side)
                    team[t].GameStart()
                    -- Call UnitCreated and UnitFinished for the units we have.
                    -- (the team didn't exist when those were originally called)
                    for _,u in ipairs(units) do
                        if (not Spring.GetUnitIsDead(u)) then
                            local ud = Spring.GetUnitDefID(u)
                            team[t].UnitCreated(u, ud, t)
                            team[t].UnitFinished(u, ud, t)
                        end
                    end
                else
                    Warning("Startunit not found, don't know as which side I'm supposed to be playing.")
                end
            end
        end
    end
end

function gadget:GameFrame(f)
    if f == 1 then
        -- This is executed AFTER headquarters / commander is spawned
        Log("gadget:GameFrame 1")
        if waypointMgr then
            waypointMgr.GameStart()
        end

        -- We perform this only this late, and then fake UnitFinished for all units
        -- in the team, to support random faction (implemented by swapping out HQ
        -- in GameStart of that gadget.)
        CreateTeams()

        for _, intelligence in pairs(intelligences) do
            intelligence.GameStart()
        end
    end
    -- waypointMgr update
    if waypointMgr and f % waypointMgrGameFrameRate < .1 then
        waypointMgr.GameFrame(f)
    end
    
    -- AI update
    for _, intelligence in pairs(intelligences) do
        intelligence.GameFrame(f)
    end
    for _,t in pairs(team) do
        t.GameFrame(f)
    end
end

--------------------------------------------------------------------------------
--
--  Game call-ins
--

function gadget:TeamDied(teamID)
    if team[teamID] then
        team[teamID] = nil
        Log("removed team ", teamID)
    end

    --TODO: need to call this for other/enemy teams too, so a team
    -- can adjust it's fight orders to the remaining living teams.
    --for _,t in pairs(team) do
    --    t.TeamDied(teamID)
    --end
end

-- This is not called by Spring, only the synced version of this function is
-- called by Spring.  This unsynced version is here to allow the AI itself to
-- determine whether a unit creation would be allowed.
function gadget:AllowUnitCreation(unitDefID, builderID, builderTeam, x, y, z)
    if team[builderTeam] then
        return team[builderTeam].AllowUnitCreation(unitDefID)
    end
    return true
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if waypointMgr then
        waypointMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
    end
    if team[unitTeam] then
        team[unitTeam].UnitCreated(unitID, unitDefID, unitTeam, builderID)
    end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if team[unitTeam] then
        team[unitTeam].UnitFinished(unitID, unitDefID, unitTeam)
    end
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitFinished(unitID, unitDefID, unitTeam)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if waypointMgr then
        waypointMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    end
    for teamID, t in pairs(team) do
        t.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    end
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
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
    if team[unitTeam] then
        team[unitTeam].UnitIdle(unitID, unitDefID, unitTeam)
    end
end

function gadget:UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
    end
end

function gadget:UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
    end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    end
end

end


-- Set up LUA AI framework.
callInList = {
    "GamePreload",
    --"GameStart",
    "GameFrame",
    "TeamDied",
    "UnitCreated",
    "UnitFinished",
    "UnitDestroyed",
    "UnitTaken",
    "UnitGiven",
    "UnitIdle",
    "UnitEnteredLos",
    "UnitLeftLos",
}
return include("LuaRules/Gadgets/craig/framework.lua")
