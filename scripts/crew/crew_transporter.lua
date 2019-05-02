-- Get all the available positions for crew
local function findPieces(input, name)
    local pieceMap = Spring.GetUnitPieceMap(unitID)
    --{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
    for pieceName, pieceNum in pairs(pieceMap) do
        local index = pieceName:find(name)
        if index then
            -- add a condition for unnumbered child which would be the first and only
            local num = tonumber(pieceName:sub(index + string.len(name), -1)) or 1
            input[num] = piece(pieceName)
        end
    end
end

local crewpieces = {}
findPieces(crewpieces, "crewman")

-- Function to give the crew member a position. If no positions are available,
-- -1 is returned, which means the crew member is inside the vehicle/structure
local function GetCrewPosition(crewID)
    local p = crewpieces[crewID]
    if p == nil then
        return -1
    end
    return p
end

-- Give back the usefull functions
return GetCrewPosition
