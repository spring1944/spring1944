-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Slightly based on the Kernel Panic AI by KDR_11k (David Becker) and zwzsg.
-- Thanks to lurker for providing hints on how to make the AI run unsynced.

-- In-game, type /luarules craig teamID in the console to toggle the ai debug
-- messages. Use the same command skipping the teamID to disable debug messages

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

else

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  UNSYNCED
--

--constants
local MY_PLAYER_ID = Spring.GetMyPlayerID()
local FIX_CONFIG_FOLDER = "LuaRules/Configs/craig"
local CONFIG_FOLDER = "LuaRules/Config/craig"
local SAVE_PERIOD = 30 * 60  -- Save once per minute

-- globals
waypointMgr = {}
evolution = {}
intelligences = {}  -- One per team


-- include code
include("LuaRules/Gadgets/craig/base.lua")
include("LuaRules/Gadgets/craig/combat.lua")
include("LuaRules/Gadgets/craig/flags.lua")
include("LuaRules/Gadgets/craig/pathfinder.lua")
include("LuaRules/Gadgets/craig/heatmap.lua")
include("LuaRules/Gadgets/craig/team.lua")
include("LuaRules/Gadgets/craig/waypoints.lua")
include("LuaRules/Gadgets/craig/intelligence.lua")
include("LuaRules/Gadgets/craig/evolution.lua")

-- locals
local CRAIG_Debug_Team = -1 -- Must be nil or a teamID
local team = {}
local lastFrame = 0 -- To avoid repeated calls to GameFrame()

--------------------------------------------------------------------------------

local function ChangeAIDebugVerbosity(cmd,line,words,player)
    local team = tonumber(words[1])
    CRAIG_Debug_Team = team
    if CRAIG_Debug_Team ~= nil then
        Spring.Echo("C.R.A.I.G.: debug verbosity set to team " .. CRAIG_Debug_Team)
    else
        Spring.Echo("C.R.A.I.G.: disable debug verbosity")
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

function gadget.IsDebug(teamID)
    if teamID == nil then
        return CRAIG_Debug_Team ~= nil
    end
    return CRAIG_Debug_Team == teamID
end

function gadget.Log(...)
    if CRAIG_Debug_Team ~= nil then
        Spring.Echo("C.R.A.I.G.: " .. table.concat{...})
    end
end

-- This is for log messages which can not be turned off (e.g. while loading.)
function gadget.Warning(...)
    Spring.Echo("C.R.A.I.G.: " .. table.concat{...})
end

-- To read/save data, they replace widgets GetConfigData() and SetConfigData()
-- callins
function SetConfigData()
    local data = {}
    if VFS.FileExists(CONFIG_FOLDER .. "/evolution.lua") then
        data = VFS.Include(CONFIG_FOLDER .. "/evolution.lua")
    elseif VFS.FileExists(FIX_CONFIG_FOLDER .. "/evolution.lua") then
        data = VFS.Include(FIX_CONFIG_FOLDER .. "/evolution.lua")
    end
    if data.evolution ~= nil then
        evolution.SetConfigData(data.evolution)
    end
end

function GetConfigData()
    local new_data = {}
    new_data.evolution = evolution.GetConfigData()

    Script.LuaUI.CraigGetConfigData(CONFIG_FOLDER,
                                    "evolution.lua",
                                    table.serialize(new_data))
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
--  gadget:GameFrame

function gadget:Initialize()
    setmetatable(gadget, {
        __index = function() error("Attempt to read undeclared global variable", 2) end,
        __newindex = function() error("Attempt to write undeclared global variable", 2) end,
    })
    SetupCmdChangeAIDebugVerbosity()
    evolution = CreateEvolution()
    SetConfigData()
end

function gadget:GamePreload()
    -- This is executed BEFORE headquarters / commander is spawned
    Log("gadget:GamePreload")
    GetConfigData()
    waypointMgr = CreateWaypointMgr()
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
                    -- Intialise intelligence and new evolution individue
                    intelligences[t] = CreateIntelligence(t, at)

                    team[t] = CreateTeam(t, at, side)
                    evolution.Procreate(t)
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
    if (f < 1) or (f == lastFrame) then
        return
    end
    lastFrame = f

    if f == 1 then
        -- This is executed AFTER headquarters / commander is spawned
        Log("gadget:GameFrame 1")
        waypointMgr.GameStart()

        -- We perform this only this late, and then fake UnitFinished for all units
        -- in the team, to support random faction (implemented by swapping out HQ
        -- in GameStart of that gadget.)
        CreateTeams()

        for _, intelligence in pairs(intelligences) do
            intelligence.GameStart()
        end
    end

    if f % SAVE_PERIOD < 0.01 then
        GetConfigData()
    end

    waypointMgr.GameFrame(f)
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

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    waypointMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if team[unitTeam] then
        team[unitTeam].UnitCreated(unitID, unitDefID, unitTeam, builderID)
    end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    evolution.UnitFinished(unitID, unitDefID, unitTeam)
    if team[unitTeam] then
        team[unitTeam].UnitFinished(unitID, unitDefID, unitTeam)
    end
    for _, intelligence in pairs(intelligences) do
        intelligence.UnitFinished(unitID, unitDefID, unitTeam)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    evolution.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    waypointMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
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
    --"GamePreload",
    --"GameStart",
    --"GameFrame",
    --"TeamDied",
    --"UnitCreated",
    --"UnitFinished",
    --"UnitDestroyed",
    --"UnitTaken",
    --"UnitGiven",
    --"UnitIdle",
    --"UnitEnteredLos",
    --"UnitLeftLos",
}

VFS.Include("LuaRules/Gadgets/craig/framework.lua", nil, VFS.ZIP)
