-- Author: Jose Luis Cercos-Pita
-- License: GNU General Public License v2

--[[
This class generates new AI players with unique behaviour parameters, according
to a genetic algorithm, which make it "learn" from its previous experience.

All the parameters handled by this algorithm are renormalized, i.e. they take
values ranging [0, 1]

Public interface:

function Evolution.AddParam(param, default)
function Evolution.Procreate(teamID)
function Evolution.GetParam(teamID, param)
function Evolution.GetConfigData()
function Evolution.SetConfigData(data)
function Evolution.UnitFinished(unitID, unitDefID, unitTeam)
function Evolution.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
]]--

function CreateEvolution()

local LOADED_DATA = {}
local ELITISM = 10                  -- Number of individuals per generation
local MUTATION_PROB = 0.1           -- Chances to get a gen mutated
local MIN_DESTROYED_METAL = 200000  -- Avoid meaningless games

local Evolution = {}

-- The list of expected parameters, with their default values
local parameters = {}

-- The individuals, including the progenitors and one new individual per AI team
local individuals = {}
for i = 1,ELITISM do
    individuals[-i] = {
        score = 0.0,
        params = {},
    }
end

-- The sum of expent metal by all the players
local total_metal = 0
local destroyed_metal = 0

-- Utilities
-- =========

local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function crossover(progenitor1, progenitor2)
    local individual = {params = {}}
    for k, val1 in pairs(progenitor1.params) do
        if math.random() < 0.5 then
            individual.params[k] = val1
        else
            individual.params[k] = progenitor2.params[k]
        end
    end
    return individual
end

local function mutate(individual)
    local mutated = {params = {}}
    for k, v in pairs(individual.params) do
        if math.random() < MUTATION_PROB then
            mutated.params[k] = math.random()
        else
            mutated.params[k] = v
        end
    end
    return mutated
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-out routines
--

function Evolution.Procreate(teamID)
    -- Take 2 random progenitors
    local i0, i1 = math.random(ELITISM), math.random(ELITISM)
    while i1 == i0 do
        i1 = math.random(ELITISM)
    end

    local individual = crossover(individuals[-i0], individuals[-i1])
    individual = mutate(individual)
    individual.total_metal = 0
    individual.max_metal = 0
    individual.lost_metal = 1000
    individual.destroyed_metal = 0

    if gadget.IsDebug() then
        Log("New individue for team " .. tostring(teamID) .. ":")
        for k, v in pairs(individual.params) do
            Spring.Echo("    " .. k .. " = " .. tostring(v))
        end
    end

    individuals[teamID] = individual
end

function Evolution.AddParam(param, default)
    if param == "score" then
        Warning("Someone is trying to register 'score' parameter in the genetic algorithm, which is reserved")
    end

    parameters[param] = default
    -- Check if the individuals are missing this parameter
    for _, data in pairs(individuals) do
        if data.params[param] == nil then
            data.params[param] = default
        end
    end
end

function Evolution.GetParam(teamID, param)
    if individuals[teamID] == nil then
        return nil
    end
    return individuals[teamID].params[param]
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function Evolution.GetConfigData()
    Log("Storing evolution data...")
    if destroyed_metal < MIN_DESTROYED_METAL then
        Log("Meaningless game detected... " .. tostring(destroyed_metal) .. " / " .. tostring(MIN_DESTROYED_METAL) .. " wreackages")
        return LOADED_DATA
    end

    -- Select the fittest individuals
    for k, data in pairs(individuals) do
        if data.score == nil then
            data.score = data.max_metal / total_metal + data.destroyed_metal / data.lost_metal
        end
    end

    local selected = {}
    for _,data in spairs(individuals, function(t,a,b) return t[b].score < t[a].score end) do
        selected[#selected + 1] = {
            score = data.score
        }
        for k,v in pairs(parameters) do
            selected[#selected][k] = data.params[k] ~= nil and data.params[k] or v
        end
        if #selected >= ELITISM then
            break
        end
    end

    -- Save the parameters
    local new_params = {}
    for i,data in ipairs(selected) do
        for k,v in pairs(data) do
            new_params["i" .. tostring(i) .. "_" .. k] = v
        end
    end
    return new_params
end

function Evolution.SetConfigData(data)
    Log("Loading evolution data...")
    LOADED_DATA = data
    -- Load the parameters. The keys in data allways have the same format,
    -- i.e. an 'i' prefix followed by the individual identifier an underscore
    -- and the parameter name.
    -- There is also an special key containing the score, with the same format
    for k, v in pairs(data) do
        local i = k:find("_")
        if i ~= nil then
            local param = k:sub(i + 1)
            i = tonumber(k:sub(2, i - 1))
            if i ~= nil and i > 0 and i <= ELITISM then
                if param == "score" then
                    individuals[-i].score = v
                else
                    -- We store the parameter, even it it is not existing in
                    -- the parameters list. If that parameter is not added, it
                    -- will be discarded at the time of saving
                    individuals[-i].params[param] = v
                end
            end
        end
    end
end

function Evolution.UnitFinished(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    local metal = unitDef.metalCost
    total_metal = total_metal + metal

    if individuals[unitTeam] == nil then
        return
    end
    individuals[unitTeam].total_metal = individuals[unitTeam].total_metal + metal
    if individuals[unitTeam].total_metal > individuals[unitTeam].max_metal then
        individuals[unitTeam].max_metal = individuals[unitTeam].total_metal
    end
end

function Evolution.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    local unitDef = UnitDefs[unitDefID]
    local metal = unitDef.metalCost
    destroyed_metal = destroyed_metal + metal

    if individuals[unitTeam] ~= nil then
        individuals[unitTeam].total_metal = individuals[unitTeam].total_metal - metal
        individuals[unitTeam].lost_metal = individuals[unitTeam].lost_metal + metal
    end
    if individuals[attackerTeam] ~= nil then
        individuals[attackerTeam].destroyed_metal = individuals[unitTeam].destroyed_metal + metal
    end    
end

--------------------------------------------------------------------------------
--
--  Initialization
--

return Evolution
end
