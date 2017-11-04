function widget:GetInfo ()
    return {
        name = "Wiki Generator",
        desc = "Create the wiki tree with the description of the factions and units",
        author = "Jose Luis Cercos-Pita",
        date = "02/11/2017",
        license = "GPL v3",
        layer = 1,
        enabled = false,
    }
end

-- UNITS_PICS_URL = "https://gitlab.com/Spring1944/spring1944/raw/master/unitpics/"
UNITS_PICS_URL = "https://raw.githubusercontent.com/spring1944/spring1944/master/unitpics/"
-- FACTIONS_PICS_URL = "https://gitlab.com/Spring1944/spring1944/raw/master/LuaUI/Widgets/faction_change/"
FACTIONS_PICS_URL = "https://raw.githubusercontent.com/spring1944/spring1944/master/LuaUI/Widgets/faction_change/"

-- =============================================================================
-- STRING UTILITIES
-- =============================================================================

local function __to_string(data, indent)
    local str = ""

    if(indent == nil) then
        indent = 0
    end
    local indenter = "    "
    -- Check the type
    if(type(data) == "string") then
        str = str .. (indenter):rep(indent) .. data .. "\n"
    elseif(type(data) == "number") then
        str = str .. (indenter):rep(indent) .. data .. "\n"
    elseif(type(data) == "boolean") then
        if(data == true) then
            str = str .. "true"
        else
            str = str .. "false"
        end
    elseif(type(data) == "table") then
        local i, v
        for i, v in pairs(data) do
            -- Check for a table in a table
            if(type(v) == "table") then
                str = str .. (indenter):rep(indent) .. i .. ":\n"
                str = str .. __to_string(v, indent + 2)
            else
                str = str .. (indenter):rep(indent) .. i .. ": " .. __to_string(v, 0)
            end
        end
    elseif(type(data) == "function") then
        str = str .. (indenter):rep(indent) .. 'function' .. "\n"
    elseif(type(data) == "nil") then
        str = str .. "*nil"
    else
        print(1, "Error: unknown data type: %s", type(data))
    end

    return str
end

local function __split_str(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- =============================================================================
-- FACTIONS AUTO-DOCUMENTATION
-- =============================================================================

UNITS = {}  -- Global list of units to document
morphDefs = include("LuaRules/Configs/morph_defs.lua")

function _is_morph_link(id)
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

local function _to_wikilist(data, url_base, prefix)
    local str = ""

    if(prefix == nil) then
        prefix = ""
    end
    local i, v
    local count = 1
    -- Let's add first the "end of lines", i.e. the ones which may not build
    -- more units
    for i, v in pairs(data) do
        if next(v) == nil then
            -- Prefix (replace indentation)
            local prefix_to_add = tostring(count)
            if count < 10 then
                prefix_to_add = "0" .. prefix_to_add
            end
            str = str .. prefix .. prefix_to_add .. ".- "
            -- Image/Logo
            local buildPic = string.lower(UnitDefNames[i].buildpicname)
            str = str .. "![" .. i .. "-logo]"
            str = str .. "(" .. UNITS_PICS_URL .. buildPic .. ") "
            -- Unit name
            str = str .. "[" .. UNITS[i] .. "]"
            str = str .. "(" .. url_base .. i .. ")\n\n"

            count = count + 1
        end
    end
    -- Now add the units with additional children
    for i, v in pairs(data) do
        if next(v) ~= nil then
            -- Prefix (replace indentation)
            local prefix_to_add = tostring(count)
            if count < 10 then
                prefix_to_add = "0" .. prefix_to_add
            end
            str = str .. prefix .. prefix_to_add .. ".- "
            -- Image/Logo
            local buildPic = string.lower(UnitDefNames[i].buildpicname)
            str = str .. "![" .. i .. "-logo]"
            str = str .. "(" .. UNITS_PICS_URL .. buildPic .. ") "
            -- Unit name
            str = str .. "[" .. UNITS[i] .. "]"
            str = str .. "(" .. url_base .. i .. ")\n\n"

            str = str .. _to_wikilist(v, url_base, prefix .. prefix_to_add .. ".")
            count = count + 1
        end
    end

    return str
end

function _unit_name(id, side)
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
    if #fields >= 4 and fields[1] == side and fields[2] == "morph" then
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

function _units_tree(startUnit, side)
    -- Departs from the starting unit, and traverse all the tech tree derived
    -- from him, simply following the building capabilities of each unit.
    local name = startUnit

    local unitDef = UnitDefNames[name]
    local tree = {}

    if UNITS[name] ~= nil then
        -- The unit has been already digested. Parsing that again will result
        -- in an infinite loop
        return tree
    end
    UNITS[name] = unitDef.humanName

    -- Add its children to the tree
    local children = unitDef.buildOptions
    if name == side .. "pontoontruck" then
        -- The factories transformations are added as morphing links build
        -- options. However, the pontoontruck morph to shipyard is not specified
        -- as a build option, so we must manually add it
        children[#children + 1] = side .. "boatyard"
    end
    for i = 1,#children do
        name = _unit_name(children[i], side)
        tree[name] = _units_tree(name, side)
    end
    return tree
end

function _gen_faction(folder, faction)
    local side = faction.sideName
    local faction_folder = folder .. "/factions/" .. side
    if Spring.CreateDir(faction_folder) == false then
        Spring.Log("cmd_generatewiki.lua", "error",
            "Failure creating the folder '" .. faction_folder .. "'")
    end

    -- Create the wiki page
    local handle = io.open(faction_folder .. "/main.md", "w")
    handle.write(handle, "# ![side-logo]")
    handle.write(handle, "(" .. FACTIONS_PICS_URL .. side .. ".png) ")
    handle.write(handle, faction.title .. "\n\n")
    handle.write(handle, faction.wiki .. "\n\n")

    -- Faction units tree
    local tree = {}
    tree[faction.startUnit] = _units_tree(faction.startUnit, side)
    handle.write(handle, "## Units tree\n\n")
    handle.write(handle, _to_wikilist(tree, "units/"))
    handle.write(handle, "\n")    

    handle.close(handle)
end

-- =============================================================================
-- UNITS AUTO-DOCUMENTATION
-- =============================================================================

TEMPLATES_FOLDER = "LuaUI/Widgets/generatewiki/templates/"

function _parse_yard(unitDef)
    local t = VFS.LoadFile(TEMPLATES_FOLDER .. "yard.md")
    t = string.gsub(t,
                    "{subclass_comments}",
                    unitDef.customParams.wiki_subclass_comments)
    t = string.gsub(t,
                    "{comments}",
                    unitDef.customParams.wiki_comments)
    t = string.gsub(t,
                    "{buildCost}",
                    tostring(unitDef.metalCost))
    t = string.gsub(t,
                    "{buildTime}",
                    tostring(unitDef.buildTime / unitDef.buildSpeed))
    t = string.gsub(t,
                    "{maxDamage}",
                    tostring(unitDef.health))
    t = string.gsub(t,
                    "{supplyRange}",
                    tostring(unitDef.customParams.supplyrange))
    return t
end

function _parse_storage(unitDef)
    local t = VFS.LoadFile(TEMPLATES_FOLDER .. "storage.md")
    t = string.gsub(t,
                    "{comments}",
                    unitDef.customParams.wiki_comments)
    t = string.gsub(t,
                    "{buildCost}",
                    tostring(unitDef.metalCost))
    local buildSpeed = unitDef.buildSpeed
    if buildSpeed == nil or buildSpeed == 0 then
        buildSpeed = 1
    end
    t = string.gsub(t,
                    "{buildTime}",
                    tostring(unitDef.buildTime / buildSpeed))
    t = string.gsub(t,
                    "{maxDamage}",
                    tostring(unitDef.health))
    t = string.gsub(t,
                    "{energyStorage}",
                    tostring(unitDef.energyStorage))
    return t
end

function _parse_supplies(unitDef)
    local t = VFS.LoadFile(TEMPLATES_FOLDER .. "supplies.md")
    t = string.gsub(t,
                    "{comments}",
                    unitDef.customParams.wiki_comments)
    t = string.gsub(t,
                    "{buildCost}",
                    tostring(unitDef.metalCost))
    local buildSpeed = unitDef.buildSpeed
    if buildSpeed == nil or buildSpeed == 0 then
        buildSpeed = 1
    end
    t = string.gsub(t,
                    "{buildTime}",
                    tostring(unitDef.buildTime / buildSpeed))
    t = string.gsub(t,
                    "{maxDamage}",
                    tostring(unitDef.health))
    t = string.gsub(t,
                    "{supplyRange}",
                    tostring(unitDef.customParams.supplyrange))
    return t
end

function _gen_unit(name, folder)
    local unitDef = UnitDefNames[name]
    local unit_folder = folder .. "/units/"
    -- Title line
    -- ==========
    local handle = io.open(unit_folder .. name .. ".md", "w")
    handle.write(handle, "# ![" .. name .. "-buildpic]")
    handle.write(handle, "(" .. UNITS_PICS_URL .. string.lower(unitDef.buildpicname) .. ") ")
    handle.write(handle, unitDef.humanName .. "\n\n")
    -- Parse the unit by its class
    -- ===========================
    local customParams = unitDef.customParams
    if customParams then
        local parser = customParams.wiki_parser
        if parser == "yard" then
            handle.write(handle, _parse_yard(unitDef))
        elseif parser == "storage" then
            handle.write(handle, _parse_storage(unitDef))
        elseif parser == "supplies" then
            handle.write(handle, _parse_supplies(unitDef))
        end
    end
    -- Get the morphing alternatives
    -- =============================
    local nMorphs = 0
    if morphDefs[name] ~= nil then
        handle.write(handle, "## Transformations\n\n")
        handle.write(handle, "This unit can be converted in the following ones:\n\n")
        local morphDef
        if morphDefs[name].into ~= nil then
            -- Conveniently transform it in a single element table
            morphDefs[name] = {morphDefs[name]}
        end
        for _, morphDef in pairs(morphDefs[name]) do
            local childName = UnitDefNames[morphDef.into].name
            local childHumanName = UnitDefNames[morphDef.into].humanName
            local childBuildPic = string.lower(UnitDefNames[morphDef.into].buildpicname)
            -- Image/Logo
            handle.write(handle, "![" .. childName .. "-logo]")
            handle.write(handle, "(" .. UNITS_PICS_URL .. childBuildPic .. ") ")
            -- Name
            handle.write(handle, "[" .. childHumanName .. "]")
            handle.write(handle, "(units/" .. childName .. ")\n\n")

            nMorphs = nMorphs + 1
        end
    end
    -- Document the build options
    -- ==========================
    local children = unitDef.buildOptions
    if #children - nMorphs > 0 then
        handle.write(handle, "## Build options\n\n")
        handle.write(handle, "This unit can build the following items:\n\n")
        local child
        for _, child in pairs(children) do
            if not _is_morph_link(child) then
                local childName = UnitDefs[child].name
                local childHumanName = UnitDefs[child].humanName
                local childBuildPic = string.lower(UnitDefs[child].buildpicname)
                -- Image/Logo
                handle.write(handle, "![" .. childName .. "-logo]")
                handle.write(handle, "(" .. UNITS_PICS_URL .. childBuildPic .. ") ")
                -- Name
                handle.write(handle, "[" .. childHumanName .. "]")
                handle.write(handle, "(units/" .. childName .. ")\n\n")
            end
        end
    end

    handle.close(handle)
end

function _gen_wiki(folder)
    -- Factions documentation
    -- ======================
    if not Spring.CreateDir(folder .. "/factions") then
        Spring.Log("cmd_generatewiki.lua", "error",
            "Failure creating the folder '" .. folder .. "/factions" .. "'")
        return false
    end
    local handle = io.open(folder .. "/factions/main.md", "w")
    handle.write(handle, "# Factions\n")
    local factions = Spring.GetSideData()
    local extra_data = include("gamedata/sidedata.lua")
    for i = 1,#factions do
        if factions[i].startUnit ~= 'gmtoolbox' then
            factions[i].title = extra_data[i].wiki_title
            factions[i].wiki = extra_data[i].wiki_desc
            _gen_faction(folder, factions[i])
            local side = factions[i].sideName
            handle.write(handle, "* ![" .. side .. "]")
            handle.write(handle, "(" .. FACTIONS_PICS_URL .. side .. ".png) ")
            handle.write(handle, "[" .. factions[i].title .. "]")
            handle.write(handle, "(factions/" .. side .. "/main)\n")
        end
    end
    handle.write(handle, "\n")
    handle.close(handle)

    -- Units documentation
    -- ===================
    if not Spring.CreateDir(folder .. "/units") then
        Spring.Log("cmd_generatewiki.lua", "error",
            "Failure creating the folder '" .. folder .. "/units" .. "'")
        return false
    end
    for id,unitDef in pairs(UnitDefs) do
        _gen_unit(unitDef.name, folder)
    end
    
    return true
end

function GenerateWiki(cmd, optLine)
    local folder = Game.gameShortName .. "_wiki"
    
    words = {}
    for word in optLine:gmatch("%S+") do
        table.insert(words, word)
    end
    for i = 1,#words,2 do
        if words[i] == 'folder' then
            folder = words[i + 1]
        end
    end

    Spring.Echo("GenerateWiki", folder)
    return _gen_wiki(folder)
end

function widget:Initialize()
    -- /wiki [folder path]
    widgetHandler:AddAction("wiki", GenerateWiki)
end
