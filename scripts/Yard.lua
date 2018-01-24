local info = GG.lusHelper[unitDefID]

local SetUnitNoSelect = Spring.SetUnitNoSelect

local CreateUnit = Spring.CreateUnit
local AttachUnit = Spring.UnitScript.AttachUnit

local base = piece("base") or piece("building")
local radar = piece("radar")

-- Compositing
local childrenPieces = {}
local children = info.children

if info.customAnimsName then
	info.customAnims = include("anims/yard/" .. info.customAnimsName .. ".lua")
end

local customAnims = info.customAnims

local function DamageSmoke(smokePieces)
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	local n = #smokePieces
	if n == 0 then
		return
	end
	_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress < 1) do
		Sleep(150)
		_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*33
	Sleep(timeDelay)
	while true do
		curHealth, maxHealth = Spring.GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(smokePieces[math.random(1,n)], SFX.WHITE_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 2000 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 33 then
				timeDelay = 33
			end
		else
			timeDelay = 2000
		end
		Sleep(timeDelay)
	end
end

-- this is for SWE radar equivalent
local function AirScanner()
	local turret, balancer = piece("scanner_turret"), piece("scanner_balancer")
	if turret and balancer then
		local scanSpeed = math.rad(5)
		while true do
			Turn(turret, y_axis, math.rad(math.random(0, 50) - 25), scanSpeed)
			Turn(balancer, x_axis, math.rad(math.random(0, 80) - 40), scanSpeed)
			WaitForTurn(turret, y_axis)
			WaitForTurn(balancer, x_axis)
			Sleep(1000)
		end
	end
end

local function Raise()
	local height = Spring.GetUnitHeight(unitID)
	while select(5, Spring.GetUnitHealth(unitID)) < 1 do
		Move(base, y_axis, -height * (1 - select(5, Spring.GetUnitHealth(unitID))))
		Sleep(100)
 	end
	Move(base, y_axis, 0)
	if radar then
		Spin(radar, y_axis, math.rad(60), math.rad(5))
	end
	if piece("scanner_turret") then
		StartThread(AirScanner)
	end
end

local function SpawnChildren()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	local teamID = Spring.GetUnitTeam(unitID)
	Sleep(50)
	for i, childDefName in ipairs(children) do
		local childID = CreateUnit(childDefName, x, y, z, 0, teamID)
		if (childID ~= nil) then
			AttachUnit(childrenPieces[i], childID)
			Hide(childrenPieces[i])
			SetUnitNoSelect(childID, true)
		end
	end
end

function script.Create()
	-- get children if any
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for pieceName, pieceNum in pairs(pieceMap) do
		local childPos = pieceName:find("child")
		if childPos then
			-- try to guess child number
			local childNumStr = pieceName:sub(childPos + 5)
			childrenPieces[tonumber(childNumStr)] = pieceNum
			--childrenPieces[#childrenPieces + 1] = pieceNum
		end
	end
	if customAnims and customAnims.preCreate then
		customAnims.preCreate()
	end
	StartThread(Raise)

	-- composite units
	if #children > 0 then
		StartThread(SpawnChildren)
	end

	if base then
		StartThread(DamageSmoke, {base})
	end
	if customAnims and customAnims.postCreate then
		customAnims.postCreate()
	end
end

function script.Killed(recentDamage, maxHealth)
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for _,pieceID in pairs(pieceMap) do
		if math.random(8) < 2 then
			Explode(pieceID, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		else
			Explode(pieceID, SFX.SHATTER)
		end
	end
	
	return 1
end

if UnitDef.isBuilder then -- yard

	Spring.SetUnitNanoPieces(unitID, {piece("beam")})
	local pad = piece("pad")
	local door = piece("door")

	function build(buildID, buildDefID)
		if UnitDef.customParams.separatebuildspot then
			local buildDef = UnitDefs[buildDefID]
			if buildDef and buildDef.customParams.buildoutside then
				Move(pad, x_axis, 60)
			else
				Move(pad, x_axis, 0)
			end
		end
	end

	function script.QueryBuildInfo()
		return pad or base
	end

	local function OpenCloseAnim(open)
		Signal(1) -- Kill any other copies of this thread
		SetSignalMask(1) -- Allow this thread to be killed by fresh copies
		if door then
			if open then
				Turn(door, y_axis, math.rad(130), math.rad(50))
			else
				Turn(door, y_axis, 0, math.rad(50))
			end
		end
		SetUnitValue(COB.INBUILDSTANCE, open)
		SetUnitValue(COB.BUGGER_OFF, open)
	end

	-- Called when factory yard opens
	function script.Activate()
		-- OpenCloseAnim must be threaded to call Sleep() or WaitFor functions
		StartThread(OpenCloseAnim, true)
	end

	-- Called when factory yard closes
	function script.Deactivate()
		-- OpenCloseAnim must be threaded to call Sleep() or WaitFor functions
		StartThread(OpenCloseAnim, false)
	end

	function script.StartBuilding()
		if customAnims and customAnims.startBuildingAnim then
			customAnims.startBuildingAnim()
		end	
		-- TODO: You can run any animation that continues throughout the build process here e.g. spin pad
	end

	function script.StopBuilding()
		if customAnims and customAnims.stopBuildingAnim then
			customAnims.stopBuildingAnim()
		end		
		-- TODO: You can run any animation that signifies the end of the build process here
	end

end -- yard

-- GERHQBunker has an MG turret
do
	local flare, flare1 = piece("flare", "flare1")
	
	if flare then -- bunker
	
		function script.QueryWeapon(weaponID)
			return flare
		end
		
		function script.AimFromWeapon(weaponID)
			return flare1
		end
		
		function script.AimWeapon(weaponID, heading, pitch)
			Signal(2)
			SetSignalMask(2)
			Turn(flare1, y_axis, heading)
			return true
		end
		
		function script.Shot(weaponID)
			GG.EmitSfxName(unitID, flare, "MG_MUZZLEFLASH")
		end
	
	end -- bunker
	-- Hungarian fortified storage
	if info.numWeapons > 1 then
		local guns = {}
		local flares = {}
		local n
		for n = 1, info.numWeapons do
			if info.reloadTimes[n] then
				guns[n] = piece("gun"..n) or base
				flares[n] = piece("flare"..n) or base
			end
		end

		function script.QueryWeapon(weaponNum)
			return flares[weaponNum]
		end

		function script.AimFromWeapon(weaponNum)
			return guns[weaponNum]
		end
		
		function script.AimWeapon(weaponNum, heading, pitch)
			Turn(guns[weaponNum], y_axis, heading)
			return true
		end
		
		function script.Shot(weaponNum)
			local ceg = info.weaponCEGs[weaponNum]
			if ceg then
				GG.EmitSfxName(unitID, flares[weaponNum], ceg)
			end
		end
	end
end