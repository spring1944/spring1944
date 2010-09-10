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
local GetUnitsInSphere		=	Spring.GetUnitsInSphere
local GetUnitHeight			=	Spring.GetUnitHeight
local GetUnitPosition		=	Spring.GetUnitPosition

local damageSiteIndex		=	1
local damageZones			=	{}
local unitsToDamage			=	{}
local burningUnits			=	{}
local movingZones			=	{}

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	local wd = WeaponDefs[weaponID]
	local damageTime = tonumber(wd.customParams.damagetime)
	if damageTime then
		local gameFrame = GetGameFrame()
		local damageZone = wd.areaOfEffect
		local damagePerSecond = wd.damages[1]
		local weaponCeg = wd.customParams.ceg
		local units = GetUnitsInSphere(px, py, pz, damageZone)
		for i = 1, #units do
			burningUnits[units[i]] = {
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
			if ((damageZones[damageSiteIndex].x - px) > damageZone) or ((damageZones[damageSiteIndex].z - pz) > (damageZone/4)) then
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
		for unitID, info in pairs(burningUnits) do
			if unitID ~= nil then
				local explodeTime = info.exTime
				local damageTime = info.damageDuration
				if (n - explodeTime)/32 < damageTime then
					local px, py, pz = GetUnitPosition(unitID)
					if py then
						local height = (GetUnitHeight(unitID)/3) + py
						local weaponCeg = info.expCeg
						local damagePerSecond = (info.dmgPerSecond/10)
						SpawnCEG(weaponCeg, px, height, pz)
						AddUnitDamage(unitID, damagePerSecond)
					end
				else
					burningUnits[unitID] = nil
				end	
			end
		end
		for damageSiteIndex, siteInfo in pairs(damageZones) do
			local explodeTime = siteInfo.exTime
			local damageTime = siteInfo.damageDuration
			if (n - explodeTime)/32 < damageTime then
				local px, py, pz = siteInfo.x, siteInfo.y, siteInfo.z
				local weaponCeg = siteInfo.expCeg
				SpawnCEG(weaponCeg, px, py, pz)
				local damageZone = siteInfo.damageArea
				local damagePerSecond = siteInfo.dmgPerSecond
				unitsToDamage = GetUnitsInSphere(px, py, pz, damageZone)
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
