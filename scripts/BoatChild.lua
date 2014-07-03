local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]
 
 -- TODO: in MCL lusHelper caches all this per unitdef into a single info table
local barrelRecoilDist = info.barrelRecoilDist
local barrelRecoilSpeed = info.barrelRecoilSpeed
local aaWeapon = info.aaWeapon
local rearFacing = info.rearFacing
local flareOnShots = info.flareOnShots
local numRockets = info.numRockets

local MIN_HEALTH = 1

local isDisabled = false
local aaAiming = false
local curRocket = 1

-- Pieces
local function findPieces(input, name)
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	--{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
	for pieceName, pieceNum in pairs(pieceMap) do
		local index = pieceName:find(name)
		if index then
			local num = tonumber(pieceName:sub(index + string.len(name), -1))
			input[num] = piece(pieceName)
		end
	end
end

local base = piece("base")
local turret, sleeve, flare, barrel = piece("turret", "sleeve",  "flare", "barrel")
local flares = {}
if not flare then findPieces(flares, "flare") end
local backBlast = piece("backblast")
local rockets = {}
if numRockets > 0 then findPieces(rockets, "r_rocket") end

function Disabled(state)
	isDisabled = state
end


function script.Create()
	--Spring.Echo("OH HAI", rearFacing)
	if rearFacing then 
		Turn(turret, y_axis, math.rad(180))
	end
end

function script.AimWeapon(weaponID, heading, pitch)
	if isDisabled then return false end -- don't even animate if we are disabled
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)
	if aaWeapon and aaWeapon == weaponID then
		aaAiming = true
	elseif aaAiming then
		return false
	end
	Turn(turret, y_axis, heading, math.rad(30))
	Turn(sleeve, x_axis, -pitch, math.rad(50))
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	--StartThread(RestoreAfterDelay)
	aaAiming = false
	return true
end

local function ShowRockets()
	Sleep((info.reloadTimes[1] - 1) * 1000) -- show 1 second before ready to fire
	for _, rocket in pairs(rockets) do
		Show(rocket)
		Sleep(info.burstRates * 1000)
	end
end

function script.FireWeapon(weaponID)
	if not flareOnShots[weaponID] then
		EmitSfx(flare or flares[weaponID], SFX.CEG + weaponID)
		if barrel then
			Move(barrel, z_axis, -barrelRecoilDist)
			WaitForMove(barrel, z_axis)
			Move(barrel, z_axis, 0, barrelRecoilSpeed)
		end
	elseif numRockets > 0 then
		StartThread(ShowRockets)
	end
end

function script.Shot(weaponID)
	if flareOnShots[weaponID] then
		EmitSfx(flare or flares[weaponID] or backBlast, SFX.CEG + weaponID)
		if barrel then
			Move(barrel, z_axis, -barrelRecoilDist)
			WaitForMove(barrel, z_axis)
			Move(barrel, z_axis, 0, barrelRecoilSpeed)
		elseif numRockets > 0 then
			Hide(rockets[curRocket])
			curRocket = curRocket + 1
			if curRocket > numRockets then curRocket = 1 end
		end
	end
end

function script.AimFromWeapon(weaponID) 
	return sleeve
end

function script.QueryWeapon(weaponID) 
	return flare or flares[weaponID] or rockets[curRocket]
end
