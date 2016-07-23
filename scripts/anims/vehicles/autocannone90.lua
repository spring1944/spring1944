local gunner1 = piece "gunner1"
local gunner2 = piece "gunner2"

local f11 = piece "f11"
local f12 = piece "f12"
local f21 = piece "f21"
local f22 = piece "f22"

local leg1 = piece "leg1"
local leg2 = piece "leg2"

local support_rods = piece "support_rods"
local support_pads = piece "support_pads"

local turret = piece "turret"
local sleeve = piece "sleeve"

local function deploy()
	Turn(f11, z_axis, 0, math.rad(15))
	Turn(f12, z_axis, 0, math.rad(15))
	Turn(f21, z_axis, 0, math.rad(15))
	Turn(f22, z_axis, 0, math.rad(15))

	Turn(leg1, z_axis, 0, math.rad(15))
	Turn(leg2, z_axis, 0, math.rad(15))

	Move(support_rods, y_axis, 0, 1)

	WaitForTurn(f11, z_axis)
	
	Show(support_rods)
	
	Show(gunner1)
	Show(gunner2)
end

local function undeploy()
	
	Hide(gunner1)
	Hide(gunner2)

	local turnSpeed = UnitDef.customParams.turretTurnSpeed or 24
	
	Turn(turret, y_axis, 0, turnSpeed)
	Turn(sleeve, x_axis, 0, turnSpeed)
	
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)

	Hide(support_pads)
	
	Turn(f21, z_axis, math.rad(-90), math.rad(15))
	Turn(f22, z_axis, math.rad(90), math.rad(15))
	Turn(f11, z_axis, math.rad(-90), math.rad(15))
	Turn(f12, z_axis, math.rad(90), math.rad(15))

	Turn(leg1, z_axis, math.rad(90), math.rad(15))
	Turn(leg2, z_axis, math.rad(-90), math.rad(15))

	Move(support_rods, y_axis, 3, 1)
	
	--WaitForTurn(f11, z_axis)
end

local anims =
{
	deploy = deploy,
	undeploy = undeploy,
}

return anims