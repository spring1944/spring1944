-- Constants
local MAX_DEPTH = 4

-- Sides
local sideDefs = VFS.Include("gamedata/sidedata.lua")

local function _is_a_side(side)
    for _, sidedata in ipairs(sideDefs) do
        if string.lower(side) == string.lower(sidedata.name) then
            return true
        end
    end
    return false
end

-- Morphs
local morphDefs = VFS.Include("LuaRules/Configs/morph_defs.lua")

local function _is_morph_link(id)
    -- Analyze the unit name to determine whether it is a morphing link or not
    local name = id
    if type(name) == "number" then
        name = UnitDefs[id].name
    end

    fields = __split_str(name, "_")
    if #fields >= 4 and fields[2] == "morph" then
        return true
    end

    return false
end

local function _unit_name(id)
    -- Get an unitDefID, and return its name. This function is also resolving
    -- morphing links.
    -- id can be directly the name of the unit in case just the morphing
    -- link resolution should be carried out
    local name = id
    if type(name) == "number" then
        name = UnitDefs[id].name
    end

    -- Morphing link resolution
    fields = __split_str(name, "_")
    if #fields >= 4 and _is_a_side(fields[1]) and fields[2] == "morph" then
        -- It is a morphing unit, see BuildMorphDef function in
        -- LuaRules/Gadgets/unit_morph. We are interested in the morphed
        -- unit instead of the morphing one
        name = fields[4]
        for i = 5,#fields do
            -- Some swe nightmare names has underscores...
            name = name .. "_" .. fields[i]
        end
    end

    return name
end

-- Check if units are factories/constructors (so they can be further
-- investigated)
function IsFactory(unitDefID)
    return UnitDefs[unitDefID].IsFactory
end

function IsConstructor(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    if UnitDefs[unitDefID].IsFactory or unitDef.speed == 0 then
        return false
    end
    local children = unitDef.buildOptions
    for _, c in ipairs(children) do
        if not _is_morph_link(c) then
            return true
        end
        if IsFactory(UnitDefs[_unit_name(c)].id) then
            -- Swedish volvo
            return true
        end
    end

    return false
end

-- Chain setups
local cached_chains = {}
local current_depth = 0
function GetBuildChains(unitDefID, chain)
    if current_depth == 0 and cached_chains[unitDefID] ~= nil then        
        return cached_chains[unitDefID]
    end

    current_depth = current_depth + 1
    if current_depth > MAX_DEPTH then
        current_depth = current_depth - 1
        return nil
    end

    if not IsConstructor(unitDefID) or not IsFactory(unitDefID) then
        current_depth = current_depth - 1
        return nil
    end

    -- Collect the children
    local unitDef = UnitDefs[unitDefID]
    local children = unitDef.buildOptions
    local buildOptions = {}
    for _, c in ipairs(children) do
        name = _unit_name(c)
        local udef = UnitDefNames[name]
        buildOptions[#buildOptions + 1] = {name=name,
                                           udef=udef,
                                           metal=udef.buildCostMetal}
    end
    -- Add also the morphs
    if morphDefs[unitDef.name] ~= nil then
        if morphDefs[startUnit].into ~= nil then
            -- Conveniently transform it in a single element table
            morphDefs[unitDef.name] = {morphDefs[unitDef.name]}
        end
        for _, morphDef in pairs(morphDefs[unitDef.name]) do
            local udef = UnitDefNames[morphDef.into]
            local name = udef.name
            buildOptions[#buildOptions + 1] = {name=name,
                                               udef=udef,
                                               metal=morphDef.metal}
        end
    end

    -- Setup the new chains
    local chains = {}
    for i,child in ipairs(buildOptions) do
        local new_chain = {units = {}, metal = chain.metal + child.metal}
        for _, unit in ipairs(chain.units) do
            new_chain.units[#new_chain.units + 1] = unit
        end
        new_chain.units[#new_chain.units + 1] = child.name
        if not IsConstructor(child.udef.id) or not IsFactory(child.udef.id) then
            chains[#chains + 1] = new_chain
        else
            if IsConstructor(child.udef.id) and child.udef.customParams.flagcaprate > 0 then
                -- Rus commisars
                chains[#chains + 1] = new_chain
            end
            local subchains = GetPossibilities(child.udef.id, new_chain)
            if subchains ~= nil then
                for _, subchain in ipairs(subchains) do
                    chains[#chains + 1] = subchain
                end
            end
        end
    end

    -- Store the result and return
    current_depth = current_depth - 1
    if current_depth == 0 then
        cached_chains[unitDefID] = chains
    end
    return chains
end

local cached_critical = {}
function GetBuildCriticalLines(unitDefID, min_depth)
    -- min_depth > 1 effectively removes engineers building mines or factories
    -- building units. That way, the base building manager may opt for building
    -- more barracks to get more infantry
    min_depth = min_depth ~= nil and min_depth or 2

    if cached_critical[unitDefID] then
        return cached_critical[unitDefID]
    end
    local chains = GetBuildChains(unitDefID)
    local critical = {}
    for _, chain in ipairs(chains) do
        if #chain.units >= min_depth then
            local target = chain.units[#chain.units]
            if critical[target] == nil or critical[target].metal > chain.metal then
                critical[target] = chain
            end
        end
    end

    cached_critical[unitDefID] = critical
    return critical
end

return {
    IsFactory = IsFactory,
    IsConstructor = IsConstructor,
    GetBuildChains = GetBuildChains,
    GetBuildCriticalLines = GetBuildCriticalLines,
}
