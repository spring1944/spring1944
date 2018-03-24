local spGetUnitDefID = Spring.GetUnitDefID
local unitDefID = spGetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitNoSelect = Spring.SetUnitNoSelect

unitDefID = spGetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]

if info.customAnimsName then
	info.customAnims = include("anims/ships/" .. info.customAnimsName .. ".lua")
end

local customAnims = info.customAnims

local minRanges = info.minRanges
local SIG_MOVE = 1

local children = info.children

-- Pieces
local base = piece("base")

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

local childrenPieces = {} -- {[1] = unitname, etc}
findPieces(childrenPieces, "child")
local wakes = {}
findPieces(wakes, "wake")
local exhausts = {}
findPieces(exhausts, "exhaust")
local propellers = {}
findPieces(propellers, "prop")
local tpTurrets = {}
findPieces(tpTurrets, "tpturret")

-- transport capacity
local cargoPlacesLarge = {}
findPieces(cargoPlacesLarge, "cargo")
local cargoPlacesSmall = {}
findPieces(cargoPlacesSmall, "seat")

local canTransport = (UnitDef.customParams.compositetransporter)

local function FlagFlap()
	local flags = {}
	findPieces(flags, "flag")
	if #flags == 0 then
		return
	end
	if flags[1] then
		Turn(flags[1], y_axis, math.rad(180))
	end
	local _,_,_,_,buildProgress = GetUnitHealth(unitID)
	while (buildProgress > 0) do
		Sleep(150)
		_,_,_,_,buildProgress = GetUnitHealth(unitID)
	end
	local FLAG_FLAP_ANGLE = math.rad(30)
	local FLAG_FLAP_SPEED = math.rad(45)
	local FLAG_FLAP_PERIOD = 2000 * FLAG_FLAP_ANGLE / FLAG_FLAP_SPEED
	local direction = 1
	while true do
		direction = -1 * direction
		local direction2 = direction
		local correction_past_first = 1
		for i = 1, #flags do
			local angle = FLAG_FLAP_ANGLE * direction2
			Turn(flags[i], y_axis, angle * correction_past_first, FLAG_FLAP_SPEED * correction_past_first)
			direction2 = -1 * direction2
			if i == 1 then
				correction_past_first = 2
			end
		end
		Sleep(FLAG_FLAP_PERIOD)
	end
end

local function DamageSmoke()
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	_,_,_,_,buildProgress = GetUnitHealth(unitID)
	while (buildProgress > 0) do
		Sleep(150)
		_,_,_,_,buildProgress = GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*30
	Sleep(timeDelay)
	while (1 == 1) do
		curHealth, maxHealth = GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(base, SFX.BLACK_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 500 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 30 then
				timeDelay = 30
			end
		else
			timeDelay = 500
		end
		Sleep(timeDelay)
	end
end

local function SpawnChildren()
	-- To avoid recursion errors, we better spawn children in a separate thread,
	-- with a neglectible delay. Otherwise, ships would not work with
	-- Spring.CreateUnit synced commands
	Sleep(1)
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		if (childID ~= nil) then
			Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
			Hide(childrenPieces[i])
			SetUnitNoSelect(childID, true)
		end
	end    
end

function script.Create()
	StartThread(SpawnChildren)
	StartThread(DamageSmoke)
	StartThread(FlagFlap)
	if customAnims and customAnims.postCreated then
		StartThread(customAnims.postCreated)
	end
end

local function EmitWakes()
	SetSignalMask(SIG_MOVE)
	while true do
		for _, wake in pairs(wakes) do
			EmitSfx(wake, SFX.WAKE)
		end
		for _, exhaust in pairs(exhausts) do
			EmitSfx(exhaust, SFX.BLACK_SMOKE)
		end
		Sleep(300)
	end
end

function script.StartMoving()
	Signal(SIG_MOVE)
	StartThread(EmitWakes)
	if customAnims and customAnims.CloseRamp then
		StartThread(customAnims.CloseRamp)
	end
	local propSpeed = math.rad(180)
	for _, prop in pairs(propellers) do
		Spin(prop, z_axis, propSpeed)
	end
end

function script.StopMoving()
	Signal(SIG_MOVE)
	for _, prop in pairs(propellers) do
		StopSpin(prop, z_axis)
	end
end

-- boat mothers have no real weapons of their own; they carry copies of the
-- main gun for unit AI purposes, but should never fire
function script.AimWeapon(weaponID, heading, pitch)
	return false
end

function script.FireWeapon(weaponID)
	EmitSfx(base, SFX.CEG + weaponID)
end

function script.AimFromWeapon(weaponID) 
	return base
end

function script.QueryWeapon(weaponID) 
	return base
end

--Transports
if canTransport then
	local spMoveCtrlEnable = Spring.MoveCtrl.Enable
	local spMoveCtrlDisable = Spring.MoveCtrl.Disable
	local spSetUnitHealth = Spring.SetUnitHealth
	local spSetUnitBlocking = Spring.SetUnitBlocking

	local turret, grabber, link = piece('turret', 'grabber', 'link')

	local AttachUnit = Spring.UnitScript.AttachUnit
	-- index: attach piece. Value: ID of transported unit
	local cargoAttachList = {}
	-- index: ID of transported unit. Value: attach piece
	local cargoList = {}
	local function GetPieceForPassenger(passengerID, mass)
		-- find first empty piece to hold this passenger
		local attachPiece = -1
		local n
		if mass < 100 then
			n = 1
			while n <= #cargoPlacesSmall do
				local currentPiece = cargoPlacesSmall[n]
				if not cargoAttachList[currentPiece] then
					attachPiece = currentPiece
					break
				end
				n = n + 1
			end
		end
		-- if we did not find a small attach piece, try pieces for large cargo
		if attachPiece == -1 then
			n = 1
			while n <= #cargoPlacesLarge do
				local currentPiece = cargoPlacesLarge[n]
				if not cargoAttachList[currentPiece] then
					attachPiece = currentPiece
					break
				end
				n = n + 1
			end
		end
		-- we have a piece, or at least a -1
		return attachPiece
	end

	-- adapted from ZK, thank you for a few ideas
	function DropPassenger(passengerID, x, y, z)
		local emptyTable = {}
		local px1, py1, pz1 = Spring.GetUnitBasePosition(unitID)
		local surfaceY = math.max(0, Spring.GetGroundHeight(px1, pz1))
		local DropUnit = Spring.UnitScript.DropUnit

		if customAnims and customAnims.OpenRamp then
			StartThread(customAnims.OpenRamp)
		end
		
		SetUnitValue(COB.BUSY, 1)
		spMoveCtrlEnable(unitID) -- freeze in place during unloading to make sure the passenger gets unloaded at the right place
		
		y = y - Spring.GetUnitHeight(passengerID) - 10
		local dx, dy, dz = x - px1, y - py1, z - pz1
		local heading = (Spring.GetHeadingFromVector(dx, dz) - Spring.GetUnitHeading(unitID))/32768*math.pi
		local sqDist2D = dx*dx + dz*dz
		local dist2D = math.sqrt(sqDist2D)
		local dist3D = math.sqrt(sqDist2D + dy*dy)
		
		AttachUnit(link, passengerID)
		Turn(turret, y_axis, heading)
		if (dist3D > 0) then
			spSetUnitBlocking(unitID, false, false, true)
			Move(turret, y_axis, dy)
			Move(grabber, z_axis, dist2D)
			Sleep(30)
		end
		
		DropUnit(passengerID)
		SetUnitNoSelect(passengerID, false)
		spSetUnitHealth(passengerID, { paralyze = 0 })    -- re-enable the passenger

		spSetUnitBlocking(unitID, true, true, true)
		
		-- remove passenger from transported list, mark piece as free
		if cargoList[passengerID] ~= -1 then
			cargoAttachList[cargoList[passengerID]] = nil
		end
		cargoList[passengerID] = nil
		
		Move(grabber, z_axis, 0)
		Move(turret, y_axis, 0)
		
		spMoveCtrlDisable(unitID)
		SetUnitValue(COB.BUSY, 0)
	end
	
	function script.TransportPickup(passengerID)
		-- check that it is not a turret
		local ud = UnitDefs[spGetUnitDefID(passengerID)]
		if ud and ud.customParams and ud.customParams.child then
			return
		end
		if customAnims and customAnims.OpenRamp then
			StartThread(customAnims.OpenRamp)
		end
		local mass = ud.mass
		local attachPiece = GetPieceForPassenger(passengerID, mass)

		AttachUnit(attachPiece, passengerID)
		cargoAttachList[attachPiece] = passengerID
		cargoList[passengerID] = attachPiece
		SetUnitNoSelect(passengerID, true)
		spSetUnitHealth(passengerID, { paralyze = 1.0e9 })    -- disable the passenger just in case
	end

	-- note x, y z is in worldspace
	function script.TransportDrop(passengerID, x, y, z)
		local ud = UnitDefs[spGetUnitDefID(passengerID)]
		-- are we trying to drop a turret?
		if ud and ud.customParams and ud.customParams.child then
			-- Try to drop one valid passenger instead
			local passengerFound = 0
			for realPassengerID, _ in pairs(cargoList) do
				passengerFound = 1
				DropPassenger(realPassengerID, x, y, z)
				break
			end
			-- if we did not find any valid passengers, it's time to cancel unload command
			if passengerFound == 0 then
				local cmdQueue = Spring.GetUnitCommands(unitID, 1)
				if #cmdQueue > 0 then
					local cmd = cmdQueue[1]
					Spring.GiveOrderToUnit(unitID, CMD.REMOVE, {cmd.tag}, 0)
				end
			end
		else
			-- just drop the passenger
			DropPassenger(passengerID, x, y, z)
		end
	end
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth * 100
	local corpseType
	
	for _, child in pairs(childrenPieces) do
		Show(child)
	end
	--signal SIG_DEATH
	--if severity < 99 then
		local dA = info.deathAnim
		corpseType = 1
		for axis, data in pairs(dA) do
			Turn(base, info.axes[axis] or z_axis, -math.rad(data.angle or 30), math.rad(data.speed or 10))
		end
		for axis, data in pairs(dA) do
			WaitForTurn(base, info.axes[axis] or z_axis)
		end
		for _, child in pairs(childrenPieces) do
			GG.EmitSfxName(unitID, child, "klara") -- FIXME: Explosion is rather OTT
		end
		--Explode(base, SFX.SHATTER)
	--[[else
		corpseType = 2
		Explode(base, SFX.SHATTER)
	end]]
	return corpseType
end
