local MAX_PASSENGERS = UnitDef.transportCapacity

local passengers = {}
local numPassengers = 0
local attachPoints = {}
for i = 1, MAX_PASSENGERS do
	attachPoints[i] = piece("p" .. i)
end

local wakes = {}
for i = 1,3 do
	wakes[i] = piece("wake" .. i)
end
local arm = piece "arm"
local ramp = piece "ramp"

local turrets = {}
local sleeves = {}
local flares = {}

for i = 1, #(UnitDef.weapons) do
	turrets[i] = piece("mount" .. i)
	sleeves[i] = piece("sleeve" .. i)
	flares[i] = piece("flare" .. i)
end

local function RampUp()
	--Spring.MoveCtrl.Enable(unitID)
	Turn(ramp, x_axis, math.rad(0), math.rad(30))
	WaitForTurn(ramp, x_axis)
	--Spring.MoveCtrl.Disable(unitID)
end

local function Wakes()
	Signal(1)
	SetSignalMask(1)
	while true do
		for i, wake in pairs(wakes) do
			Spring.UnitScript.EmitSfx(wake, SFX.WAKE)
			Sleep(90)
		end
	end
end

function script.StartMoving()
	StartThread(RampUp)
	StartThread(Wakes)
end

function script.StopMoving()
	Signal(1)
end

function script.TransportPickup(passengerID)
	if numPassengers == 0 then
		Move(arm, z_axis, 0)
	end
	numPassengers = numPassengers + 1
	passengers[numPassengers] = passengerID
	Spring.UnitScript.AttachUnit(attachPoints[numPassengers], passengerID)
	Spring.SetUnitNoMinimap(passengerID, true)
	--Spring.Echo("TransportPickup", numPassengers, "ID", passengerID)
end

function script.TransportDrop(passengerID, x, y, z)
	SetUnitValue(COB.BUSY, 1)
	Turn(ramp, x_axis, math.rad(95), math.rad(30))
	WaitForTurn(ramp, x_axis)
	for i = 1, numPassengers do
		env = Spring.UnitScript.GetScriptEnv(passengers[i])
		Spring.UnitScript.CallAsUnit(passengers[i], env.script.StartMoving)
	end
	Move(arm, z_axis, 42 - math.floor(numPassengers/3)*3, 9) -- 42
	WaitForMove(arm, z_axis)
	SetUnitValue(COB.BUSY, 0)
	local dropped = 0
	for i = 0, 2 do
		local passNum = numPassengers - i
		if passNum > 0 then
			--Spring.Echo("TransportDrop", passNum, x, y, z, "ID", passengerID)
			Spring.UnitScript.DropUnit(passengers[passNum])
			Spring.GiveOrderToUnit(passengers[passNum], CMD.MOVE, {x,y,z}, {})
			Spring.SetUnitNoMinimap(passengers[passNum], true)
			dropped = dropped + 1
		end
	end
	numPassengers = numPassengers - dropped
	if numPassengers == 0 then
		Move(arm, z_axis, 0)
	end
end

function script.TransportEnd()
	--Spring.Echo("TransportEnd")
end

function script.QueryWeapon(weaponNum)
	return flares[weaponNum]
end


function script.AimWeapon(weaponNum, heading, pitch)
	Turn(turrets[weaponNum], y_axis, heading, math.rad(40))
	Turn(sleeves[weaponNum], x_axis, -pitch, math.rad(80))
	WaitForTurn(turrets[weaponNum], y_axis)
	WaitForTurn(sleeves[weaponNum], x_axis)
	return true
end

function script.Shot(weaponNum)
	GG.EmitSfxName(unitID, flares[weaponNum], "MG_MUZZLEFLASH")
end