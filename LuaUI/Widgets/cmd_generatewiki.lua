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


UNITS = {}  -- Global list of units to document

local function _to_wikilist(data, url_base, prefix)
    local str = ""

    if(prefix == nil) then
        prefix = ""
    end
    local i, v
    local count = 1
    for i, v in pairs(data) do
        if UNITS[i] ~= "" then
            -- We are not interested on adding morphs to this list, which are
            -- featured by the abscence of a human readable name
            str = str .. prefix .. tostring(count) .. ".- "
            str = str .. "[" .. UNITS[i] .. "]"
            str = str .. "(" .. url_base .. i .. ")\n\n"
            str = str .. _to_wikilist(v, url_base, prefix .. tostring(count) .. ".")
            count = count + 1
        end
    end

    return str
end

function _units_tree(startUnit)
    -- Departs from the starting unit, and traverse all the tech tree derived
    -- from him, simply following the building capabilities of each unit.
    local name = startUnit
    if type(name) == "number" then
        name = UnitDefs[startUnit].name
    end
    local tree = {}
    local unitDef = UnitDefNames[name]
    if UNITS[name] == nil then
        UNITS[name] = unitDef.humanName
    else
        -- The unit has been already digested. Parsing that again will result
        -- in an infinite loop
        return {}
    end
    local children = unitDef.buildOptions
    for i = 1,#children do
        local name = children[i]
        if type(name) == "number" then
            name = UnitDefs[name].name
        end
        tree[name] = _units_tree(name)
    end
    return tree
end

FACTIONS_PICS_URL = "https://gitlab.com/Spring1944/spring1944/raw/master/LuaUI/Widgets/faction_change/"

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
    tree[faction.startUnit] = _units_tree(faction.startUnit)
    handle.write(handle, "## Units tree\n\n")
    handle.write(handle, _to_wikilist(tree, "factions/" .. side .. "/"))
    handle.write(handle, "\n")    

    handle.close(handle)
end

function _gen_wiki(folder)
    if Spring.CreateDir(folder .. "/factions") == false then
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
