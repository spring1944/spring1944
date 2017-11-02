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
    else
        print(1, "Error: unknown data type: %s", type(data))
    end

    return str
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
