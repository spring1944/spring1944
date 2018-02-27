local base = piece("base")
if base == nil then
    local pieceMap = Spring.GetUnitPieceMap(unitID)
    for pieceName, pieceNum in pairs(pieceMap) do
        local index = pieceName:find("flag")
        if index then
            base = piece(pieceName)
        end
    end
end

function RaiseFlag()
    Move(base, z_axis, 65, 10)
    WaitForMove(base, z_axis)
end

function script.Create()
    StartThread(RaiseFlag)
end

function script.Killed(recentDamage, maxHealth)
    Move(base, z_axis, 0, 20)
    WaitForMove(base, z_axis)
    return 1
end
