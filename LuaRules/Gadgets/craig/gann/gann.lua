-- Author: Jose Luis Cercos-Pita
-- License: GNU General Public License v2

--[[
This class generates new AI players with unique behaviour parameters, according
to a Genetic Artificial Neural Network, which make it "learn" from its previous
experience.

The inputs provided to this class shall be renormalized to have values ranging
[-1, 1]

To create a GANN...
===================

First, the global system shall be generated calling
CreateGANN(population, mutation_prob, mutation_size).

Afterwards, all the inputs to be used by the GANN shall be declared calling
GANN.DeclareInput(inputName) function. Outputs must be also declared with the
GANN.DeclareOutput(outputName).

Then GANN.SetConfigData(data) can be called to load the already available AI
data, generating the progenitors (random one if no data is available).

Now you can call GANN.Procreate(teamID) to generate new population, which are
managing each AI controlled team.

To use the GANN...
==================

At the time of using the GANN, you can call GANN.Evaluate(teamID, inputs). You
are entitled to train the neural network at any time using
GANN.Train(teamID, inputs, outputs)

To end the GANN...
==================

Finally, GANN.GetConfigData() can be called to get a table which can be saved
for later usage.
]]--

function CreateGANN(population, mutation_prob, mutation_size)

population = population or 10
mutation_prob = mutation_prob ~= nil and mutation_prob or 0.05
mutation_size = mutation_size or 0.25

local NeuralNetwork = VFS.Include("LuaRules/Gadgets/craig/gann/neuralnet.lua")
local GANN = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Initialization
--

-- The list of declared inputs and outputs
local inputNames, outputNames = {}, {}
local inputIDs, outputIDs = {}, {}

function GANN.DeclareInput(inputName)
    if inputIDs[inputName] ~= nil then
        Log("Redeclared GANN input '" .. inputName .. "'")
        return nil
    end
    inputNames[#inputNames + 1] = inputName
    inputIDs[inputName] = #inputNames
end

function GANN.DeclareOutput(outputName)
    if outputIDs[outputName] ~= nil then
        Log("Redeclared GANN output '" .. outputName .. "'")
        return nil
    end
    outputNames[#outputNames + 1] = outputName
    outputIDs[outputName] = #outputNames
end

-- The individuals, i.e. the progenitors and one new individual per AI team
local individuals = {}
local individualTeams = {}

function GANN.SetConfigData(data)
    Log("Load GANN data")

    -- The data is a list of individuals, with information about the score and
    -- the neural network
    for i, individual in ipairs(data) do
        local nn = NeuralNetwork.unserialize(individual.nn)
        local valid = true
        if nn == nil then
            Warning("Failed neural network load for individual " .. i)
            valid = false
        elseif #nn[1] ~= #inputNames then
            Warning("Loaded neural network handles " .. #nn[1] .. " inputs while " .. #inputNames .. " are declared")
            valid = false
        elseif #nn[#nn] ~= #outputNames then
            Warning("Loaded neural network handles " .. #nn[1] .. " outputs while " .. #outputNames .. " are declared")
            valid = false
        end
        if valid then
            local score = individual.score
            if score == nil then
                score = 0
            elseif gadget.IsTraining() then
                -- Progressively enworse progenitors, so they do not get stucked
                -- with a population that got lucky once
                score = score - 0.01
            end
            individuals[#individuals + 1] = {
                score = math.min(1.0, score),
                nn = nn
            }
        end
    end

    -- Create new random individuals until the population is filled (they will
    -- be replaced by their children, for sure)
    for i = #individuals + 1, population do
        individuals[i] = {
            score = 0.0,
            nn = NeuralNetwork.create(#inputNames, #outputNames)
        }
    end
end

local function crossover(progenitor1, progenitor2)
    local nn = NeuralNetwork.create(#inputNames, #outputNames)

    if #nn ~= #(progenitor1.nn) or #nn ~= #(progenitor2.nn) then
        Warning("Progenitors number of layers doesn't match the children ones... No crossover will be carried out")
        Log("  Children layers = ", #nn)
        Log("  Progenitor #1 layers = ", #(progenitor1.nn))
        Log("  Progenitor #2 layers = ", #(progenitor2.nn))
        return {score = 0.0, nn = nn}
    elseif #nn[2] ~= #(progenitor1.nn[2]) or #nn[2] ~= #(progenitor2.nn[2]) then
        Warning("Progenitors number of nodes per layer doesn't match the children ones... No crossover will be carried out")
        return {score = 0.0, nn = nn}
    end

    local prog1_genes = 0
    for i = 2, #nn do
        -- We mix the progenitors by entire layers
        local selected
        if math.random() < 0.5 then
            selected = progenitor1
            prog1_genes = prog1_genes + 1
        else
            selected = progenitor2
        end
        for j = 1, #(nn[i]) do
            nn[i][j].bias = selected.nn[i][j].bias
            for k = 1, #(nn[i - 1]) do
                nn[i][j][k] = selected.nn[i][j][k]
            end
        end
    end

    local prog1_genes = prog1_genes / (#nn - 1.0)
    local score = math.min(progenitor1.score, progenitor2.score)
    if prog1_genes > 0.99 then
        score = progenitor1.score
    elseif prog1_genes < 0.01 then
        score = progenitor2.score
    end
    Log("  It is mixed ", math.floor(100 * prog1_genes + 0.5), "% / ",
        math.floor(100 * (1.0 - prog1_genes) + 0.5), "%",
        ", with a score ", score)

    return {score = score, nn = nn}
end

local function clamp(v, min_val, max_val)
    min_val = min_val ~= nil and min_val or -1
    max_val = max_val ~= nil and max_val or 1    
    return math.min(math.max(v, min_val), max_val)
end

local function mutate(individual)
    local mutated, total = 0.0, 0.0
    for i = 2, #(individual.nn) do
        for j = 1, #(individual.nn[i]) do
            total = total + 1.0
            if math.random() < mutation_prob then
                mutated = mutated + 1.0
                individual.nn[i][j].bias = clamp(individual.nn[i][j].bias +
                    (2.0 * math.random() - 1.0) * mutation_size)
            end
            for k = 1, #(individual.nn[i - 1]) do
                total = total + 1.0
                if math.random() < mutation_prob then
                    mutated = mutated + 1.0
                    individual.nn[i][j][k] = clamp(individual.nn[i][j][k] +
                        (2.0 * math.random() - 1.0) * mutation_size)
                end
            end
        end
    end

    mutated = mutated / total
    individual.score = individual.score * (1.0 - mutated)
    Log("  And ", math.floor(100 * mutated + 0.5), "% mutated")

    return individual
end

function GANN.Procreate(teamID)
    -- Take 2 random progenitors
    local i0, i1 = math.random(population), math.random(population)
    while i1 == i0 do
        i1 = math.random(population)
    end

    Log("GANN Progenitors ", i0, " and ", i1, " are creating a new individual")

    local individual = crossover(individuals[i0], individuals[i1])
    individual = mutate(individual)
    individual.teamID = teamID

    individualTeams[teamID] = individual
    individuals[#individuals + 1] = individual
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Usage
--

function GANN.Evaluate(teamID, inputs)
    if individualTeams[teamID] == nil then
        Warning("There is not GANN for the team " .. tostring(teamID))
        return nil
    end
    local nn = individualTeams[teamID].nn
    local nn_in = {}
    for i, k in ipairs(inputNames) do
        if inputs[k] == nil then
            Warning("Missing GANN input '" .. k .. "'")
            return nil
        end
        nn_in[i] = inputs[k]
    end

    local nn_out = nn:predict(nn_in)
    local output = {}
    for i, k in ipairs(outputNames) do
        output[k] = nn_out[i]
    end

    return output
end

function GANN.Train(teamID, inputs, outputs)
    if individualTeams[teamID] == nil then
        Warning("There is not GANN for the team " .. tostring(teamID))
        return nil
    end
    local nn = individualTeams[teamID].nn
    local nn_in = {}
    for i, k in ipairs(inputNames) do
        if inputs[k] == nil then
            nn_in[i] = 2.0 * math.random() - 1.0
        else
            nn_in[i] = inputs[k]
        end
    end
    local nn_out = {}
    for i, k in ipairs(outputNames) do
        if outputs[k] == nil then
            nn_out[i] = 2.0 * math.random() - 1.0
        end
        nn_out[i] = outputs[k]
    end

    nn:train(nn_in, nn_out)
end

function GANN.GetScore(teamID)
    -- Return the last computed individual score. At the beggining it is just
    -- an expected value according to the parents and level of mutation
    return individualTeams[teamID].score
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Finalization
--

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

local function GetTeamStats(teamID)
    local cur_max_index = Spring.GetTeamStatsHistory(teamID)
    if not cur_max_index then
        return {metal=0, ammo=0, damage_dealt=0}
    end
    local stats = Spring.GetTeamStatsHistory(teamID, cur_max_index)[1]
    return {metal = stats.metalUsed,
            ammo = stats.energyUsed,
            damage_dealt = stats.damageDealt}
end

function GANN.GetConfigData()
    Log("Storing GANN data...")

    -- Get the score basis
    local total = {metal=0, ammo=0, damage_dealt=0}
    local stats = {}
    for _, teamID in ipairs(Spring.GetTeamList()) do
        stats[teamID] = GetTeamStats(teamID)
        for k,v in pairs(total) do
            total[k] = v + stats[teamID][k]
        end
    end

    -- Evaluate the score of the children
    for i = population + 1, #individuals do
        local teamID = individuals[i].teamID
        local score, n_score = 0.0, 0
        for k,v in pairs(total) do
            score = score + stats[teamID][k] / v
            n_score = n_score + 1
        end
        individuals[i].score = score / n_score
    end

    -- Select the fittest individuals
    local selected = {}
    for _,data in spairs(individuals, function(t,a,b) return t[b].score < t[a].score end) do
        if data.teamID ~= nil then
            Log("Keeping GANN for team " .. tostring(data.teamID) .. " with a score " .. tostring(data.score))
        else
            Log("Keeping progenitor GANN with a score " .. tostring(data.score))
        end
        selected[#selected + 1] = {
            score = data.score,
            nn = data.nn:serialize(),
        }
        if #selected >= population then
            break
        end
    end

    return selected
end

return GANN
end
