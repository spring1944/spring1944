local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local ud = UnitDefs[unitDefID]

local rearFacing = ud.customParams.rearfacing

-- Pieces
local base = piece("base")
local turret, sleeve, barrel, flare = piece("turret", "sleeve", "barrel", "flare")

function script.Create()
	--Spring.Echo("OH HAI", rearFacing)
	if rearFacing then 
		Turn(turret, y_axis, math.rad(180))
	end
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)

	Turn(turret, y_axis, heading, math.rad(30))
	Turn(sleeve, x_axis, -pitch, math.rad(50))
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	--StartThread(RestoreAfterDelay)
	return true
end

function script.FireWeapon(weaponID)
	Move(barrel, z_axis, -5, 100)
	WaitForMove(barrel, z_axis)
	Move(barrel, z_axis, 0, 10)
end

function script.AimFromWeapon(weaponID) 
	return turret
end

function script.QueryWeapon(weaponID) 
	return flare
end