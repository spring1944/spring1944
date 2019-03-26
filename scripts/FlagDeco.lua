local base = piece("base")
if base == nil then
    local pieceMap = Spring.GetUnitPieceMap(unitID)
    for pieceName, pieceNum in pairs(pieceMap) do
        if pieceName:find("flag") then
            base = piece(pieceName)
        end
    end
end

-- Check if it is a dae object, which may affect the motion axis
local unitDefID = Spring.GetUnitDefID(unitID)
local modeltype = UnitDefs[unitDefID].modeltype or UnitDefs[unitDefID].model.type

function RaiseFlag()
    if (modeltype == "dae") then
        Move(base, z_axis, 65, 10)
        WaitForMove(base, z_axis)
    else
        Move(base, y_axis, 65, 10)
        WaitForMove(base, y_axis)
    end
end

function script.Create()
    StartThread(RaiseFlag)
end

function script.Killed(recentDamage, maxHealth)
    if (modeltype == "dae") then
        Move(base, z_axis, 0, 20)
        WaitForMove(base, z_axis)
    else
        Move(base, y_axis, 0, 20)
        WaitForMove(base, y_axis)
    end
    return 1
end

function script.WindChanged(heading, strength)
    Turn(base, y_axis, heading, math.rad(20))
end
