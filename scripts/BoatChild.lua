local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]
 
 -- TODO: in MCL lusHelper caches all this per unitdef into a single info table
local barrelRecoilDist = info.barrelRecoilDist
local barrelRecoilSpeed = info.barrelRecoilSpeed
local rearFacing = info.rearFacing
local flareOnShots = info.flareOnShots

local MIN_HEALTH = 1

local isDisabled = false
-- Pieces
local base = piece("base")
local turret, sleeve, barrel, flare = piece("turret", "sleeve", "barrel", "flare")

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
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)

	Turn(turret, y_axis, heading, math.rad(30))
	Turn(sleeve, x_axis, -pitch, math.rad(50))
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	--StartThread(RestoreAfterDelay)
	return not isDisabled
end

function script.FireWeapon(weaponID)
	if not flareOnShots[weaponID] then
		EmitSfx(flare, SFX.CEG + weaponID)
		Move(barrel, z_axis, -barrelRecoilDist)
		WaitForMove(barrel, z_axis)
		Move(barrel, z_axis, 0, barrelRecoilSpeed)
	end
end

function script.Shot(weaponID)
	if flareOnShots[weaponID] then
		EmitSfx(flare, SFX.CEG + weaponID)
		Move(barrel, z_axis, -barrelRecoilDist)
		WaitForMove(barrel, z_axis)
		Move(barrel, z_axis, 0, barrelRecoilSpeed)
	end
end

function script.AimFromWeapon(weaponID) 
	return turret
end

function script.QueryWeapon(weaponID) 
	return flare
end

-- TODO: better to use a gadget and unitpredamaged?
--[[function script.HitByWeapon( x, z, weaponDefID, damage)
	local health = Spring.GetUnitHealth(unitID)
	if health - damage < MIN_HEALTH then
		local newDamage = health - MIN_HEALTH
		Spring.Echo("DEATHBLOW", health, newDamage)
		return newDamage
	end
	return damage
end]]