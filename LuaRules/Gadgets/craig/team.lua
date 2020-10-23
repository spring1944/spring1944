-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local Team = CreateTeam(myTeamID, myAllyTeamID, mySide)

function Team.Log(...)
function Team.UnitCreated(unitID, unitDefID, unitTeam, builderID)
function Team.UnitFinished(unitID, unitDefID, unitTeam)
function Team.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
function Team.UnitTaken(unitID, unitDefID, unitTeam, newTeam)
function Team.UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
]]--

function CreateTeam(myTeamID, myAllyTeamID, mySide)

local Team = {}

do
    local GadgetLog = gadget.Log
    function Team.Log(...)
        GadgetLog("Team[", myTeamID, "] ", ...)
    end
end
local Log = Team.Log

-- constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local TEAMS_UPDATE_PERIOD = 128  -- In frames (128 ~ 4.5 seconds)
local TEAMS_UPDATE_LAG = 16      -- In frames (16 ~ 0.5 seconds)

-- Number of enemies
local enemies_number = 0

-- Base building (one global buildOrder)
local baseMgr = CreateBaseMgr(myTeamID, myAllyTeamID, mySide, Log)

-- Unit building (one buildOrder per factory)
local unitBuildOrder = gadget.unitBuildOrder

-- Unit limits
local unitLimitsMgr = CreateUnitLimitsMgr(myTeamID)

-- Combat units control
local heatmapMgr = CreateHeatmapMgr(myTeamID, myAllyTeamID, Log)
local combatMgr = CreateCombatMgr(myTeamID, myAllyTeamID, heatmapMgr, Log)
local flagsMgr = CreateFlagsMgr(myTeamID, myAllyTeamID, mySide, Log)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function Team.GameStart()
    Log("GameStart")
    -- Can not run this in the initialization code at the end of this file,
    -- because at that time Spring.GetTeamStartPosition seems to always return 0,0,0.
    for _,t in ipairs(Spring.GetTeamList()) do
        if (t ~= GAIA_TEAM_ID) and (not Spring.AreTeamsAllied(myTeamID, t)) then
            local x,y,z = Spring.GetTeamStartPosition(t)
            if x and x ~= 0 then
                enemies_number = enemies_number + 1
                Log("Enemy base spotted at coordinates: ", x, ", ", z)
            else
                Log("Oops, Spring.GetTeamStartPosition failed")
            end
        end
    end
    flagsMgr.GameStart()
    heatmapMgr.GameStart()
    Log("Preparing to attack ", enemies_number, " enemies")
end

function Team.GameFrame(f)
    heatmapMgr.GameFrame(f)

    if gadget.IsDebug(myTeamID) then
        -- Erase the map marks the frame before updating again
        if (f + TEAMS_UPDATE_LAG * myTeamID) % TEAMS_UPDATE_PERIOD > (TEAMS_UPDATE_PERIOD - 1.1) then
            Spring.SendCommands({"ClearMapMarks"})
        end
    end

    if (f + TEAMS_UPDATE_LAG * myTeamID) % TEAMS_UPDATE_PERIOD > .1 then
        return
    end

    --Log("GameFrame")

    baseMgr.GameFrame(f)
    flagsMgr.GameFrame(f)
    combatMgr.GameFrame(f)
end

--------------------------------------------------------------------------------
--
--  Game call-ins
--

-- Short circuit callin which would otherwise only forward the call..
Team.AllowUnitCreation = unitLimitsMgr.AllowUnitCreation

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

-- Currently unitTeam always equals myTeamID (enforced in gadget)

-- Short circuit callin which would otherwise only forward the call..
Team.UnitCreated = baseMgr.UnitCreated

function Team.UnitFinished(unitID, unitDefID, unitTeam)
    Log("UnitFinished: ", UnitDefs[unitDefID].humanName)

    -- idea from BrainDamage: instead of cheating huge amounts of resources,
    -- just cheat in the cost of the units we build.
    --Spring.AddTeamResource(myTeamID, "metal", UnitDefs[unitDefID].metalCost)
    --Spring.AddTeamResource(myTeamID, "energy", UnitDefs[unitDefID].energyCost)

    -- queue unitBuildOrders if we have any for this unitDefID
    if unitBuildOrder[unitDefID] then
        -- factory or builder?
        if not (UnitDefs[unitDefID].speed > 0) then
            -- If there are no enemies, don't bother lagging Spring to death:
            -- just go through the build queue exactly once, instead of repeating it.
            if (enemies_number > 0 or Spring.GetGameSeconds() < 0.1) then
                GiveOrderToUnit(unitID, CMD.REPEAT, {1}, {})
            end
            for _,bo in ipairs(unitBuildOrder[unitDefID]) do
                if bo and UnitDefs[bo] then
                    Log("Queueing: ", UnitDefs[bo].humanName)
                    GiveOrderToUnit(unitID, -bo, {}, {})
                else
                    Spring.Echo("CRAIG: invalid buildorder found: " .. UnitDefs[unitDefID].humanName .. " -> " .. (bo or 'nil'))
                end
            end
        else
            Log("Warning: unitBuildOrder can only be used to control factories")
        end
    end

    -- if any unit manager takes care of the unit, return
    -- managers are in order of preference

    -- need to prefer flag capping over building to handle Russian commissars
    if flagsMgr.UnitFinished(unitID, unitDefID, unitTeam) then return end
    if baseMgr.UnitFinished(unitID, unitDefID, unitTeam) then return end
    if combatMgr.UnitFinished(unitID, unitDefID, unitTeam) then return end
end

function Team.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    Log("UnitDestroyed: ", UnitDefs[unitDefID].humanName)

    heatmapMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if unitTeam ~= myTeamID then
        return
    end

    baseMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    flagsMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    combatMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
end

function Team.UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    Team.UnitDestroyed(unitID, unitDefID, unitTeam)
end

function Team.UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
    Team.UnitCreated(unitID, unitDefID, unitTeam, nil)
    local _, _, inBuild = Spring.GetUnitIsStunned(unitID)
    if not inBuild then
        Team.UnitFinished(unitID, unitDefID, unitTeam)
    end
end

function Team.UnitIdle(unitID, unitDefID, unitTeam)
    Log("UnitIdle: ", UnitDefs[unitDefID].humanName)
end

function Team.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
    heatmapMgr.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
end

function Team.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
    heatmapMgr.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
end

--------------------------------------------------------------------------------
--
--  Initialization
--

Log("assigned to ", gadget.ghInfo.name, " (allyteam: ", myAllyTeamID, ", side: ", mySide, ")")

return Team
end
