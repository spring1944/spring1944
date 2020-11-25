function gadget:GetInfo()
    return {
        name = "Crew members notifier",
        desc = "Notify the transporter script about events regarding their transportees (crew)",
        author = "Jose Luis Cercos-Pita",
        date = "Apr 30, 2019",
        license = "GNU GPL v2",
        layer = 0,
        enabled = true
    }
end

-- UNSYNCED
if not gadgetHandler:IsSyncedCode() then 
    return
end

-- SYNCED
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTransporter = Spring.GetUnitTransporter
local GetUnitPosition = Spring.GetUnitPosition
local ValidUnitID = Spring.ValidUnitID
local IsUnitVisible = Spring.IsUnitVisible
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local UnitAttach = Spring.UnitAttach
local UnitDetach = Spring.UnitDetach
local GetUnitPieceMap = Spring.GetUnitPieceMap

local crew_members = {}

-- Get all the available positions for crew
local function findPieces(input, unitID, name)
    local pieceMap = GetUnitPieceMap(unitID)
    --{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
    for pieceName, pieceNum in pairs(pieceMap) do
        local index = pieceName:find(name)
        if index then
            input[#input + 1] = pieceNum
        end
    end
end

function gadget:Initialize()
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
    -- We are looking for loaded units with crew members
    local unitDef = UnitDefs[unitDefID]
    local crew = GetUnitIsTransporting(unitID)
    if not unitDef.customParams.infgun or crew == nil or #crew == 0 then
        return
    end
    -- So a unit with crew members has been loaded. Let's attach the crew
    -- members "inside" the transport (hiding them)
    crew_members[unitID] = {}
    for i, pax in ipairs(crew) do
        UnitAttach(unitID, pax, -1)
        crew_members[unitID][i] = pax
    end
end

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
    -- First check the unloaded unit is looking for its crew
    if crew_members[unitID] == nil then
        return
    end
    -- Get the crew places
    local crewpieces = {}
    findPieces(crewpieces, unitID, "crewman")
    local x,y,z = GetUnitPosition(unitID)
    -- Traverse the crew members, and reattach them to the transporter positions
    for i, pax in ipairs(crew_members[unitID]) do
        local piece = crewpieces[i] or -1
        UnitAttach(unitID, pax, piece)
    end
    -- Drop crew data
    crew_members[unitID] = nil
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    local tid = GetUnitTransporter(unitID)
    if tid == nil or not ValidUnitID(tid) then
        return
    end
    -- If we reached this point is because a transported unit has been killed.
    -- However, there are (and will be) many units that can be in this situation
    -- without becoming crew members. So we better check that the unit actually
    -- has crew members
    local tDef = UnitDefs[GetUnitDefID(tid)]
    if not tDef.customParams.infgun then
        return
    end
    local x, y, z = GetUnitPosition(tid)
    local env = Spring.UnitScript.GetScriptEnv(tid)
    Spring.UnitScript.CallAsUnit(tid, env.script.TransportDrop, unitID, x, y, z)
end
