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
local GetUnitHeight			=	Spring.GetUnitHeight
local GetUnitPosition		=	Spring.GetUnitPosition

local damageSiteIndex		=	1
local damageZones			=	{}
local unitsToDamage			=	{}
local burningUnits			=	{}
local movingZones			=	{}

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if WeaponDefs[weaponID].customParams.damagetime then
		local damageTime = WeaponDefs[weaponID].customParams.damagetime
		local gameFrame = GetGameFrame()
		local damageZone = WeaponDefs[weaponID].areaOfEffect
		local damagePerSecond = WeaponDefs[weaponID].damages[1]
		local weaponCeg = WeaponDefs[weaponID].customParams.ceg
		for _, unitID in ipairs(GetUnitsInCylinder(px, pz, damageZone)) do
			burningUnits[unitID] = {
				exTime = gameFrame,
				dmgPerSecond = damagePerSecond,
				damageDuration = damageTime,
				expCeg = weaponCeg,
			}
		end
		if damageZones[damageSiteIndex] == nil then
			damageZones[damageSiteIndex] = {
					x = px,
					y = py,
					z = pz,
					exTime = gameFrame,
					damageArea = damageZone,
					dmgPerSecond = damagePerSecond,
					damageDuration = damageTime,
					expCeg = weaponCeg,
				}		
		else
			if ((damageZones[damageSiteIndex].x - px) > damageZone) or ((damageZones[damageSiteIndex].z - pz) > damageZone) then
				damageSiteIndex = damageSiteIndex + 1
				damageZones[damageSiteIndex] = {
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
	end
end

function gadget:GameFrame(n)
	if (n % (0.1*30) < 0.1) then
		for unitID,someThing in pairs(burningUnits) do
			if unitID ~= nil then
				local explodeTime = tonumber(burningUnits[unitID].exTime)
				local damageTime = tonumber(burningUnits[unitID].damageDuration)
				if (n - explodeTime)/32 < damageTime then
					local px, py, pz = GetUnitPosition(unitID)
					if py then
						local height = (GetUnitHeight(unitID)/3) + py
						local weaponCeg = burningUnits[unitID].expCeg
						local damagePerSecond = (burningUnits[unitID].dmgPerSecond/10)
						SpawnCEG(weaponCeg, px, height, pz)
						AddUnitDamage(unitID, damagePerSecond)
					end
				else
					burningUnits[unitID] = nil
				end	
			end
		end
		for damageSiteIndex,someThing in pairs(damageZones) do
			local explodeTime = tonumber(damageZones[damageSiteIndex].exTime)
			local damageTime = tonumber(damageZones[damageSiteIndex].damageDuration)
			if (n - explodeTime)/32 < damageTime then
				local px, py, pz = damageZones[damageSiteIndex].x, damageZones[damageSiteIndex].y, damageZones[damageSiteIndex].z
				local weaponCeg = damageZones[damageSiteIndex].expCeg
				SpawnCEG(weaponCeg, px, py, pz)
				local damageZone = damageZones[damageSiteIndex].damageArea
				local damagePerSecond = damageZones[damageSiteIndex].dmgPerSecond
				unitsToDamage = GetUnitsInCylinder(px, pz, damageZone)
				if unitsToDamage ~= nil then
					 for i = 1, #unitsToDamage do
						local unitToDamage = unitsToDamage[i]
						local unitDefID = Spring.GetUnitDefID(unitToDamage)
						local ud = UnitDefs[unitDefID]
						if (ud.customParams.feartarget == "1") then
							if burningUnits[unitToDamage] == nil then	
								local unitDefID = Spring.GetUnitDefID(unitToDamage)
								local ud = UnitDefs[unitDefID]
								if (ud.customParams.feartarget == "1") then
									burningUnits[unitToDamage] = {
										exTime = explodeTime,
										dmgPerSecond = damagePerSecond,
										damageDuration = damageTime,
										expCeg = weaponCeg,
									}
								end
							end
						else
							AddUnitDamage(unitToDamage, (damagePerSecond/10))
						end
						
					end
				end
			else
			damageZones[damageSiteIndex] = nil
			end
		end
	end
end

function gadget:UnitDestroyed(unitID)
	unitsToDamage[unitID] = nil
	burningUnits[unitID] = nil
end
