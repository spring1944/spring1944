local base = piece "base"
local wheel1 = piece "wheel1"
local wheel2 = piece "wheel2"
local wheel3 = piece "wheel3"
local spare = piece "spare"
local carriage = piece "carriage"

local SHATTER = 1
local EXPLODE_ON_HIT = 2

local wheelSpeed

local SIG_MOVE = 1

local WHEEL_CHECK_DELAY = 1000

local WHEEL_ACCELERATION_FACTOR = 3

function script.Create()

end

local function SpinWheels()
	SetSignalMask(SIG_MOVE)
	local wheelSpeeds = GG.lusHelper[unitDefID].wheelSpeeds
	while true do
		local frontDir = Spring.GetUnitVectors(unitID)
		local vx, vy, vz = Spring.GetUnitVelocity(unitID)
		local dotFront = vx * frontDir[1] + vy * frontDir[2] + vz * frontDir[3]
		local direction = dotFront > 0 and 1 or -1
		for wheelPiece, speed in pairs(wheelSpeeds) do
			Spin(wheelPiece, x_axis, speed * direction, speed / WHEEL_ACCELERATION_FACTOR)
		end
		Sleep(WHEEL_CHECK_DELAY)
	end
end

local function StopWheels()
	for wheelPiece, speed in pairs(GG.lusHelper[unitDefID].wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

function script.StartMoving()
	Signal(SIG_MOVE)
	if GG.lusHelper[unitDefID].numWheels > 0 then
		StartThread(SpinWheels)
	end
end

function script.StopMoving()
	Signal(SIG_MOVE)
	StopWheels()
end

function script.Killed(recentDamage, maxHealth)

	if recentDamage <= 999 then
		Explode(wheel1, SHATTER + EXPLODE_ON_HIT)
		Explode(wheel2, SHATTER + EXPLODE_ON_HIT)
		Explode(wheel3, SHATTER + EXPLODE_ON_HIT)
	else
		Explode(wheel1, SHATTER + EXPLODE_ON_HIT)
		Explode(wheel2, SHATTER + EXPLODE_ON_HIT)
		Explode(carriage, SHATTER + EXPLODE_ON_HIT)
		Explode(base, SHATTER)
	end
	return 1
end