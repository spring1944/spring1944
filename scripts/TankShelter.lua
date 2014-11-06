local AttachUnit = Spring.UnitScript.AttachUnit
local DropUnit = Spring.UnitScript.DropUnit
local pieceBase = piece("base")

function script.TransportPickup(passengerID)
	AttachUnit(pieceBase, passengerID)
end

function script.TransportDrop(passengerID, x, y, z)
	-- release unit, destroy the shelter
	DropUnit(passengerID)
	Spring.DestroyUnit(unitID, false, true)
end