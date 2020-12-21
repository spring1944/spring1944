-- Constants
local MAX_DEPTH = 4

-- Utils
local function __split_str(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function __deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[__deepcopy(orig_key)] = __deepcopy(orig_value)
        end
        setmetatable(copy, __deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

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

local function is_morph_link(id)
    -- Analyze the unit name to determine whether it is a morphing link or not
    local name = id
    if type(name) == "number" then
        name = UnitDefs[id].name
    end

    local fields = __split_str(name, "_")
    if #fields >= 4 then
        for _,field in ipairs(fields) do
            if field == "morph" then
                return true
            end
        end
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
    local fields = __split_str(name, "_")
    if #fields >= 4 and _is_a_side(fields[1]) then
        local morph_i = nil
        for i,field in ipairs(fields) do
            if field == "morph" then
                morph_i = i
                break
            end
        end
        if morph_i then
            -- It is a morphing unit, see BuildMorphDef function in
            -- LuaRules/Gadgets/unit_morph. We are interested in the morphed
            -- unit instead of the morphing one
            name = fields[morph_i + 2]
            for i = morph_i + 3,#fields do
                -- Some swe nightmare names has underscores...
                name = name .. "_" .. fields[i]
            end
        end
    end

    return name
end

-- Check if units are factories/constructors (so they can be further
-- investigated)
local function IsFactory(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    if not unitDef.isFactory then
        return false
    end

    -- Avoid "factories" which only have morphing options, like storages
    local children = unitDef.buildOptions
    for _, c in ipairs(children) do
        if not is_morph_link(c) then
            return true
        end
    end

    return false
end

local function IsPackedFactory(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef.isFactory or unitDef.speed == 0 then
        return false
    end

    local morphs = GG['morphHandler'].GetMorphDefs()[unitDefID]
    if morphs == nil then
        return false
    end
    for _, morph in pairs(morphs) do
        if IsFactory(morph.into) then
            return true
        end
    end

    return false
end

local function IsConstructor(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef.isFactory or unitDef.speed == 0 then
        return false
    end
    local resemble_builder = unitDef.isMobileBuilder and unitDef.canAssist
    local children = unitDef.buildOptions
    for _, c in ipairs(children) do
        if resemble_builder and not is_morph_link(c) then
            return true
        end
    end

    return false
end

local function IsChainLink(unitDefID)
    -- Units that can be considered as intermediate units in a construction
    -- chain
    return IsFactory(unitDefID) or IsPackedFactory(unitDefID) or IsConstructor(unitDefID)
end

-- Chain setups
local cached_chains = {}
local current_depth = 0
local function GetBuildChains(unitDefID, chain)
    if (current_depth == 0) and (cached_chains[unitDefID] ~= nil) then
        return __deepcopy(cached_chains[unitDefID])
    end

    current_depth = current_depth + 1
    if current_depth > MAX_DEPTH then
        current_depth = current_depth - 1
        return nil
    end

    if not IsChainLink(unitDefID) then
        current_depth = current_depth - 1
        return nil
    end

    -- Collect the children
    local unitDef = UnitDefs[unitDefID]
    local children = unitDef.buildOptions
    local buildOptions = {}
    for _, c in ipairs(children) do
        local name = _unit_name(c)
        local udef = UnitDefNames[name]
        buildOptions[#buildOptions + 1] = {name=name,
                                           udef=udef,
                                           metal=udef.metalCost}
    end
    -- Add also the morphs
    local morphs = GG['morphHandler'].GetMorphDefs()[unitDefID]
    if morphs ~= nil then
        if morphs.into ~= nil then
            -- Conveniently transform it in a single element table
            morphs = {morphs}
        end
        for _, morphDef in pairs(morphs) do
            local udef = UnitDefs[morphDef.into]
            local name = udef.name
            buildOptions[#buildOptions + 1] = {name=name,
                                               udef=udef,
                                               metal=morphDef.metal}
        end
    end

    -- Setup the new chains
    local chains = {}
    for i,child in ipairs(buildOptions) do
        local chain_metal = chain and chain.metal or 0
        local chain_units = chain and chain.units or {}
        local new_chain = {units = {}, metal = chain_metal + child.metal}
        for _, unit in ipairs(chain_units) do
            new_chain.units[#new_chain.units + 1] = unit
        end
        new_chain.units[#new_chain.units + 1] = child.name
        if not IsChainLink(child.udef.id) then
            chains[#chains + 1] = new_chain
        else
            local subchains = GetBuildChains(child.udef.id, new_chain)
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
        cached_chains[unitDefID] = __deepcopy(chains)
    end
    return chains
end

local function GetBuildCriticalLines(unitDefID, min_depth)
    -- min_depth > 1 effectively removes engineers building mines or factories
    -- building units. That way, the base building manager may opt for building
    -- more barracks to get more infantry
    min_depth = min_depth ~= nil and min_depth or 2

    local chains = GetBuildChains(unitDefID)
    local critical = {}
    for _, chain in ipairs(chains) do
        local units_str = ""
        for _, u in ipairs(chain.units) do
            units_str = units_str .. u .. " -> "
        end
        if #chain.units >= min_depth then
            local target = chain.units[#chain.units]
            if (critical[target] == nil) or (critical[target].metal > chain.metal) then
                critical[target] = chain
            end
        end
    end

    return critical
end

return {
    is_morph_link = is_morph_link,
    IsFactory = IsFactory,
    IsPackedFactory = IsPackedFactory,
    IsConstructor = IsConstructor,
    GetBuildChains = GetBuildChains,
    GetBuildCriticalLines = GetBuildCriticalLines,
}
