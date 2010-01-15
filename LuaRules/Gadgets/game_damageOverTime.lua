function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Damage Over Time",
		desc      = "Allows weapons to continue dealing damage to a specific area over time.",
		author    = "Nemo",
		date      = "13 Jan 2010",
		license   = "LGPL 2.0",
		layer     = 1,
		enabled   = true  --  loaded by default?
	}
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local AddUnitDamage 		=	Spring.AddUnitDamage
local SpawnCEG 				=	Spring.SpawnCEG
local GetGameFrame			=	Spring.GetGameFrame
local GetUnitsInCylinder	=	Spring.GetUnitsInCylinder

local damageZones			=	{}
local unitsToDamage			=	{}

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	--Spring.Echo("Boom!")
	if WeaponDefs[weaponID].customParams.damagetime then
		--Spring.Echo("We've got a burner!")
		local damageTime = WeaponDefs[weaponID].customParams.damagetime
		local gameFrame = GetGameFrame()
		local areaID = math.random(0,gameFrame)
		local damageZone = WeaponDefs[weaponID].areaOfEffect
		local damagePerSecond = WeaponDefs[weaponID].damages[1]
		local weaponCeg = WeaponDefs[weaponID].customParams.ceg
		damageZones[areaID] = {
			x = px,
			y = py,
			z = pz,
			exTime = gameFrame,
			damageArea = damageZone,
			dmgPerSecond = damagePerSecond,
			damageDuration = damageTime,
			expCeg = weaponCeg,
		}
	end

end

function gadget:GameFrame(n)
	if (n % (0.25*30) < 0.1) then
		for areaID,someThing in pairs(damageZones) do
			local explodeTime = tonumber(damageZones[areaID].exTime)
			local damageTime = tonumber(damageZones[areaID].damageDuration)
			if (n - explodeTime)/32 < damageTime then
				local px, py, pz = damageZones[areaID].x, damageZones[areaID].y, damageZones[areaID].z
				local weaponCeg = damageZones[areaID].expCeg
				SpawnCEG(weaponCeg, px, py, pz)
				local damageZone = damageZones[areaID].damageArea
				local damagePerSecond = (damageZones[areaID].dmgPerSecond/4)
				unitsToDamage = GetUnitsInCylinder(px, pz, damageZone)
				if unitsToDamage ~= nil then
					 for i = 1, #unitsToDamage do
						local unitToDamage = unitsToDamage[i]
						AddUnitDamage(unitToDamage, damagePerSecond)
					end
				end
			else
			damageZones[areaID] = nil
			end
		end
	end
end

function gadget:UnitDestroyed(unitID)
	unitsToDamage[unitID] = nil
end
