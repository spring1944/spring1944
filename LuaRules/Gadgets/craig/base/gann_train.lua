local MIN_INT, MAX_INT = -2147483648, 2147483648
local MAX_SQUAD_SIZE = 10.0
local random, min, max, abs = math.random, math.min, math.max, math.abs
local squadDefs = VFS.Include("LuaRules/Configs/squad_defs.lua")
local sortieDefs = VFS.Include("LuaRules/Configs/sortie_defs.lua")
for name, data in pairs(sortieDefs) do
    squadDefs[name] = {
        members = data.members
    }
end

local unit_chains = VFS.Include("LuaRules/Gadgets/craig/base/unit_reqs.lua")
local unit_scores = VFS.Include("LuaRules/Gadgets/craig/base/unit_score.lua")


local function __clamp(v, min_val, max_val)
    min_val = min_val ~= nil and min_val or -1
    max_val = max_val ~= nil and max_val or 1    
    return min(max(v, min_val), max_val)
end

local function ChainScore(gann, myTeamID, target, mCurr, eCurr, cons, cap, los)
    local unitDef = UnitDefNames[target]
    local chain = {metal=unitDef.metalCost}

    local score = MIN_INT
    local gann_inputs = {
        sim_time = random(),
        metal_curr = mCurr ~= nil and mCurr or random(),
        metal_push = random(),
        metal_pull = random(),
        energy_curr = eCurr ~= nil and eCurr or random(),
        energy_storage = random(),
        construction_capacity = cons ~= nil and cons or random(),
        capturing_capacity = cap ~= nil and cap or random(),
        los_capacity = los ~= nil and los or random(),
        chain_cost = 0.0,
        unit_cost = __clamp(unitDef.metalCost / 10000.0),
        unit_in_factories = random(),
    }
    if squadDefs[unitDef.name] == nil then
        local firepower, accuracy, penetration, range = unit_scores.GetUnitWeaponsFeatures(unitDef)
        local armour = unit_scores.GetUnitArmour(unitDef)

        gann_inputs.squad_size = 1.0 / MAX_SQUAD_SIZE
        gann_inputs.unit_storage = __clamp(unitDef.energyStorage / 3000.0)
        gann_inputs.unit_is_constructor = unit_chains.IsConstructor(unitDef.id) and 1.0 or 0.0
        gann_inputs.unit_cap = __clamp((unitDef.customParams.flagcaprate or 0) / 10.0)
        gann_inputs.unit_view = __clamp(unitDef.losRadius / 1000.0 / MAX_SQUAD_SIZE)
        gann_inputs.unit_speed = __clamp(unitDef.speed / 20.0)
        gann_inputs.unit_armour = __clamp(armour / 200.0)
        gann_inputs.unit_firepower = __clamp(firepower / 1000.0)
        gann_inputs.unit_accuracy = __clamp(accuracy / 2000.0)
        gann_inputs.unit_penetration = __clamp(penetration / 200.0)
        gann_inputs.unit_range = __clamp(range / 15000.0)
    else
        gann_inputs.squad_size = 0.0
        gann_inputs.unit_storage = 0.0
        gann_inputs.unit_is_constructor = 0.0
        gann_inputs.unit_cap = 0.0
        gann_inputs.unit_view = 0.0
        gann_inputs.unit_speed = 0.0
        gann_inputs.unit_armour = 0.0
        gann_inputs.unit_firepower = 0.0
        gann_inputs.unit_accuracy = 0.0
        gann_inputs.unit_penetration = 0.0
        gann_inputs.unit_range = 0.0

        for _, member in ipairs(squadDefs[unitDef.name].members) do
            local udef = UnitDefNames[member]

            -- For the time being, ignore air units
            if udef.canFly or udef.floatOnWater or udef.isHoveringAirUnit then
                return MIN_INT
            end

            local firepower, accuracy, penetration, range = unit_scores.GetUnitWeaponsFeatures(udef)
            local armour = unit_scores.GetUnitArmour(udef)

            gann_inputs.squad_size = gann_inputs.squad_size + 1
            if unit_chains.IsConstructor(udef.id) then
                gann_inputs.unit_is_constructor = 1.0
            end

            gann_inputs.unit_storage = gann_inputs.unit_storage +
                    udef.energyStorage
            gann_inputs.unit_cap = gann_inputs.unit_cap +
                    (unitDef.customParams.flagcaprate or 0)
            gann_inputs.unit_view = gann_inputs.unit_view +
                    udef.losRadius
            gann_inputs.unit_speed = gann_inputs.unit_speed +
                    udef.speed
            gann_inputs.unit_firepower = gann_inputs.unit_firepower +
                    firepower
            gann_inputs.unit_accuracy = gann_inputs.unit_accuracy +
                    accuracy

            if armour > gann_inputs.unit_armour then
                gann_inputs.unit_armour = armour
            end
            if penetration > gann_inputs.unit_penetration then
                gann_inputs.unit_penetration = penetration
            end
            if range > gann_inputs.unit_range then
                gann_inputs.unit_range = range
            end

        end

        gann_inputs.unit_storage = gann_inputs.unit_storage / 3000.0
        gann_inputs.unit_cap = gann_inputs.unit_cap / 10.0

        gann_inputs.unit_speed = gann_inputs.unit_speed /
                (20.0 * gann_inputs.squad_size)
        gann_inputs.unit_firepower = gann_inputs.unit_firepower /
                (1000.0 * gann_inputs.squad_size)
        gann_inputs.unit_accuracy = gann_inputs.unit_accuracy /
                (2000.0 * gann_inputs.squad_size)
        gann_inputs.unit_storage = gann_inputs.unit_storage / 3000.0

        gann_inputs.unit_view = gann_inputs.unit_view /
                (1000.0 * MAX_SQUAD_SIZE)
        gann_inputs.unit_armour = gann_inputs.unit_armour / 200.0
        gann_inputs.unit_penetration = gann_inputs.unit_penetration / 200.0
        gann_inputs.unit_range = gann_inputs.unit_range / 15000.0

        gann_inputs.squad_size = gann_inputs.squad_size / MAX_SQUAD_SIZE
    end

    score = gann.Evaluate(myTeamID, gann_inputs).score

    return gann_inputs, score
end

local tests = {
    {target = "gbrhqengineer", score = 1.0, inputs = {mCurr = nil,
                                                      eCurr = nil,
                                                      cons = 0.0,
                                                      cap = nil,
                                                      los = nil}},
    {target = "gbrhqengineer", score = 0.0, inputs = {mCurr = nil,
                                                      eCurr = nil,
                                                      cons = 1.0,
                                                      cap = nil,
                                                      los = nil}},
    {target = "rus_platoon_rifle", score = 1.0, inputs = {mCurr = nil,
                                                          eCurr = nil,
                                                          cons = nil,
                                                          cap = 0.0,
                                                          los = nil}},
    {target = "gbr_platoon_rifle", score = 1.0, inputs = {mCurr = nil,
                                                          eCurr = nil,
                                                          cons = nil,
                                                          cap = nil,
                                                          los = 0.0}},
    {target = "usstorage", score = 0.8, inputs = {mCurr = nil,
                                                  eCurr = 0.05,
                                                  cons = nil,
                                                  cap = nil,
                                                  los = nil}},
    {target = "usstoragelarge", score = 1.0, inputs = {mCurr = nil,
                                                       eCurr = 0.05,
                                                       cons = nil,
                                                       cap = nil,
                                                       los = nil}},
    
}

local function TrainGann(gann, myTeamID, e_max, max_iters)
    local e = math.huge
    e_max = e_max or 0.1
    max_iters = max_iters or 100

    Spring.Echo("Training neural network for team " .. tostring(myTeamID) .. ". This would take a lot of time...")
    local iters = 0
    while e > e_max and iters < max_iters do
        iters = iters + 1
        e = 0.0
        local dominant_test
        for i, test in ipairs(tests) do
            local inputs, score = ChainScore(gann, myTeamID, test.target,
                                             test.inputs.mCurr,
                                             test.inputs.eCurr,
                                             test.inputs.cons,
                                             test.inputs.cap,
                                             test.inputs.los)
            local e_test = abs(test.score - score)
            if e_test > e then
                e = e_test
                dominant_test = test
            end
            gann.Train(myTeamID, inputs, {score = test.score})
        end
        Spring.Echo("    i = " .. tostring(iters) .. ", Max fitting error = " .. tostring(e))
        Spring.Echo("    target = " .. tostring(dominant_test.target) .. ", score = " .. tostring(dominant_test.score))
    end

    return e < e_max
end

return TrainGann
