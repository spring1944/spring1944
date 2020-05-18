-- Author: Jose Luis Cercos-Pita
-- License: GNU General Public License v2

--[[
This class provides information regarding enemy units. There are 3 levels of
intelligence, dependending on the difficulty level:

* easy = Just information about units on LOS is handled. Information on
         permanent structures is preserved
* medium = Information about units attacking or getting attacked are also
           considered
* hard = All the enemy units is perfectly known

Public interface:

function Intelligence.GetUnits(n)
function Intelligence.GameStart()
function Intelligence.GameFrame(f)
function Intelligence.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
function Intelligence.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
function Intelligence.UnitFinished(unitID, unitDefID, unitTeam)
function Intelligence.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
function Intelligence.UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
]]--

function CreateIntelligence(myAllyTeamID)
    
local DIFFICULTY = gadget.difficulty
local Intelligence = {}

local enemyTeams = {}
for _,t in ipairs(Spring.GetTeamList()) do
    if t ~= Spring.GetGaiaTeamID() then
        local _,_,_,_,_,allyTeamID = Spring.GetTeamInfo(t)
        if allyTeamID ~= myAllyTeamID then
            enemyTeams[#enemyTeams + 1] = t
        end
    end
end

local units = {}
local unitIDs = {}
local time_to_forget = {}

local function tableConcat(t1, t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

local function lstRemove(t, i)
    for j = i, #t - 1 do
        t[j] = t[j + 1]
    end
    t[#t] = nil
    return t
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

local first_unit = 1

function Intelligence.GetUnits(n)
    local last_unit = math.min(first_unit + n - 1, #units)
    local to_return = {}
    for i = first_unit, last_unit do
        to_return[#to_return + 1] = units[i]
    end
    first_unit = last_unit + 1
    if first_unit > #units then
        first_unit = 1
    end
    return to_return
end

function Intelligence.GameStart()
    if DIFFICULTY ~= "hard" then
        return
    end
    units = {}
    time_to_forget = {}
    for _, t in ipairs(enemyTeams) do
        units = tableConcat(units, Spring.GetTeamUnits(t))
    end
    for i, unitID in ipairs(units) do
        unitIDs[unitID] = i
    end
end

function Intelligence.GameFrame(f)
    if DIFFICULTY == "hard" then
        return
    end
end

function Intelligence.UnitFinished(unitID, unitDefID, unitTeam)
    if DIFFICULTY ~= "hard" then
        return
    end
    for _, t in ipairs(enemyTeams) do
        if t == unitTeam then
            units[#units + 1] = unitID
            unitIDs[unitID] = #units
            return
        end
    end
end

function Intelligence.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if unitIDs[unitID] ~= nil then
        units = lstRemove(units, unitIDs[unitID])
        unitIDs[unitID] = nil
    end
end

function Intelligence.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
    if DIFFICULTY == "hard" then
        return
    end
    for _, t in ipairs(enemyTeams) do
        if t == unitTeam then
            units[#units + 1] = unitID
            unitIDs[unitID] = #units
            return
        end
    end
end

function Intelligence.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
    if DIFFICULTY == "hard" then
        return
    end
    if unitIDs[unitID] ~= nil then
        units = lstRemove(units, unitIDs[unitID])
        unitIDs[unitID] = nil
    end
end

function Intelligence.UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if DIFFICULTY ~= "medium" then
        return
    end

    local alliedVsEnemy = 0
    for _, t in ipairs(enemyTeams) do
        if t == unitTeam then
            alliedVsEnemy = alliedVsEnemy + 1
        end
        if t == attackerTeam then
            alliedVsEnemy = alliedVsEnemy - 1
        end
    end

    if alliedVsEnemy == 1 then
        units[#units + 1] = unitID
        unitIDs[unitID] = #units
    elseif alliedVsEnemy == -1 then
        units[#units + 1] = attackerID
        unitIDs[attackerID] = #units
    end
end

--------------------------------------------------------------------------------
--
--  Initialization
--

return Intelligence
end
