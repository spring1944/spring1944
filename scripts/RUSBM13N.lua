local info = GG.lusHelper[unitDefID]

local backblast = piece "backblast"
local rails = piece "rails"


local SIG_AIM = 1 --I hope this is high enough that nothing bad will be caused by this
local SIG_MOVE = 2

local STOP_AIM_DELAY = 2000
local ROCKET_RESTORE_DELAY = info.reloadTimes[1]
local WHEEL_ACCELERATION_FACTOR = 3
local WHEEL_CHECK_DELAY = 990

local moving = false
local firing = false
local lastRocket = info.numRockets

local origReverseSpeed = Spring.GetUnitMoveTypeData(unitID).maxReverseSpeed
local deploying = false
local deployed = false

if not info.wheelSpeeds then
	info.wheelSpeeds = {}
	info.smokePieces = {}
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for pieceName, pieceNum in pairs(pieceMap) do
		-- Find Wheel Speeds
		if pieceName:find("wheel") then
			local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
			local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
			info.wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
		end
		if pieceName:find("base") or pieceName:find("rails") or pieceName:find("wheel1") or pieceName:find("wheel2") then
			info.smokePieces[#info.smokePieces + 1] = pieceNum
		end
	end
end


local function Delay(func, duration, mask, ...)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end

local function UpdateSpeed()
	--Spring.Echo("speed up to date")
	if deployed or deploying then
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = 0.001, maxReverseSpeed = 0.001, turnRate = 0, accRate = 0.005})
	else
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = UnitDef.speed, maxReverseSpeed = origReverseSpeed, turnRate = UnitDef.turnRate, accRate = UnitDef.maxAcc})
		local cmds = Spring.GetCommandQueue(unitID, 2)
		if #cmds >= 2 then
			if cmds[1].id == CMD.MOVE or cmds[1].id == CMD.FIGHT or cmds[1].id == CMD.ATTACK then
				if cmds[2] and cmds[2].id == CMD.SET_WANTED_MAX_SPEED then
					Spring.GiveOrderToUnit(unitID,CMD.REMOVE,{cmds[2].tag},{})
				end
				local params = {1, CMD.SET_WANTED_MAX_SPEED, 0, 1}
				Spring.GiveOrderToUnit(unitID, CMD.INSERT, params, {"alt"})
			end
		end
	end
end

local function Deploy()
	if deployed then return end
	--Spring.Echo("deploying")
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	deploying = true
	UpdateSpeed()
	Turn(backblast, x_axis, 1, 0.1) --10 seconds delay
	WaitForTurn(backblast, x_axis)
	deployed = true
	--Spring.Echo("deployed")
end

local function Undeploy()
	if not deploying then return end
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	--Spring.Echo("undeploying")
	deployed = false
	Turn(backblast, x_axis, 0, 0.1) --10 seconds delay
	WaitForTurn(backblast, x_axis)
	deploying = false
	UpdateSpeed()
	--Spring.Echo("undeployed")
end


local function SpinWheels()
	SetSignalMask(SIG_MOVE)
	local wheelSpeeds = info.wheelSpeeds
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
	for wheelPiece, speed in pairs(info.wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

local function Move()
	while firing do
		Sleep(100)
	end
	Undeploy()
	Signal(SIG_MOVE)
	StartThread(SpinWheels)
end

function script.StartMoving()
	moving = true
	StartThread(Move)
end

function script.StopMoving()
	moving = false
	Signal(SIG_MOVE)
	StopWheels()
end

function script.Create()
	for i = 1,info.numRockets do
		Hide(piece("rocket" .. i))
	end
end

local function RestoreTurret()
	Turn(rails, y_axis, 0, info.turretTurnSpeed)
	Turn(rails, x_axis, 0, info.elevationSpeed)
	Undeploy()
end

local function _RestoreRockets(restoreDelay)
	Sleep(restoreDelay)
	for i = 1,info.numRockets do
		Show(piece("rocket" .. i))
	end
end

function RestoreRockets(restoreDelay)
	StartThread(_RestoreRockets, restoreDelay)
end


function script.AimWeapon(weaponNum, heading, pitch)
	if firing or moving then return false end
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Deploy()
	StartThread(Delay, RestoreTurret, STOP_AIM_DELAY, SIG_AIM)
	--Turn(rails, y_axis, heading, info.turretTurnSpeed)
	Turn(rails, x_axis, -pitch, info.elevationSpeed)
	WaitForTurn(rails, x_axis)
	return true
end

function script.QueryWeapon(weaponNum)
	return piece("rocket" .. lastRocket)
end

function script.AimFromWeapon(weaponNum)
	return rails
end

function script.FireWeapon(weaponNum)
	Signal(SIG_AIM)
	firing = true
end

function script.Shot(weaponNum)
	lastRocket = lastRocket % info.numRockets + 1
	Hide(piece("rocket" .. lastRocket))
	
	local ceg = info.weaponCEGs[weaponNum]
	GG.EmitSfxName(unitID, backblast, ceg)
	
	local ping = info.seismicPings[weaponNum]
	if ping then
		Spring.AddUnitSeismicPing(unitID, ping)
	end
end

function script.EndBurst(weaponNum)
	StartThread(RestoreTurret)
	firing = false
end

function script.Killed(recentDamage, maxHealth)
	local corpse = 1
	
	for wheelPiece, _ in pairs(info.wheelSpeeds) do
		Explode(wheelPiece, SFX.SHATTER + SFX.EXPLODE_ON_HIT)
	end
	if recentDamage > maxHealth then -- Overkill
		Explode(rails, SFX.FIRE + SFX.FALL + SFX.EXPLODE_ON_HIT + SFX.SMOKE)
		corpse = 2
	end
	
	return math.min(info.numCorpses - 1, corpse)
end