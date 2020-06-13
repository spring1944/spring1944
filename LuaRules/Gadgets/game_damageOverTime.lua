function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Damage Over Time",
		desc      = "Allows weapons to continue dealing damage to a specific area over time.",
		author    = "Nemo",
		date      = "13 Jan 2010",
		license   = "LGPL 2.0",
		layer     = 1,
		enabled   = true --  loaded by default?
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
		local damageZone = wd.damageAreaOfEffect*1.15
		local damagePerSecond = wd.damages[1]
		local weaponCeg = wd.customParams.ceg
		local units = GetUnitsInSphere(px, py, pz, damageZone)
		for _, unitID in pairs(units) do
			if unitID ~= ownerID then --prevent units from setting themselves on fire
				burningUnits[unitID] = {
					exTime = gameFrame,
					CEGSpawnY = (GetUnitHeight(unitID)/3),
					dmgPerSecond = damagePerSecond,
					damageDuration = damageTime,
					expCeg = weaponCeg,
				}
			end
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
		else  --if the new explosion is sufficiently far away from the one immediately previous, increment and add to list
			if (math.abs(damageZones[damageSiteIndex].x - px) > damageZone/2) or (math.abs(damageZones[damageSiteIndex].z - pz) > damageZone/2) then
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
			else --if its close to an old one, just overwrite that one.
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
	if (n % (0.5*30) < 0.1) then
		-- items to delete from looped tables, but only AFTER the loop finishes
		local unitsToDamage = {}
		local itemsToDelete = {}
		for unitID, info in pairs(burningUnits) do
			if info ~= nil then
				local explodeTime = info.exTime
				local damageTime = info.damageDuration
				if (n - explodeTime)/30 < damageTime then
					local px, py, pz = GetUnitPosition(unitID)
					if py then
						local height = info.CEGSpawnY + py
						local weaponCeg = info.expCeg
						local damagePerSecond = (info.dmgPerSecond)
						SpawnCEG(weaponCeg, px, height, pz)
						--AddUnitDamage(unitID, damagePerSecond)
						unitsToDamage[unitID] = damagePerSecond
					end
				else
					itemsToDelete[unitID] = true
				end	
			end
		end
		for unitID, damagePerSecond in pairs(unitsToDamage) do
			AddUnitDamage(unitID, damagePerSecond)
		end
		for unitID, _ in pairs(itemsToDelete) do
			burningUnits[unitID] = nil
		end
		itemsToDelete = {}
		unitsToDamage = {}
		for damageSiteIndex, siteInfo in pairs(damageZones) do
			if siteInfo ~= nil then
				local explodeTime = siteInfo.exTime
				local damageTime = siteInfo.damageDuration
				if (n - explodeTime)/30 < damageTime then
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
							if (ud and ud.customParams.feartarget == "1") then
								if burningUnits[unitToDamage] == nil then	
									local unitDefID = Spring.GetUnitDefID(unitToDamage)
									local ud = UnitDefs[unitDefID]
									if (ud.customParams.feartarget == "1") then
										burningUnits[unitToDamage] = {
											exTime = explodeTime,
											CEGSpawnY = (GetUnitHeight(unitToDamage)/3),
											dmgPerSecond = damagePerSecond,
											damageDuration = damageTime,
											expCeg = weaponCeg,
										}
									end
								end
							else
								--AddUnitDamage(unitToDamage, damagePerSecond)
								unitsToDamage[unitToDamage] = damagePerSecond
							end
						
						end
					end
				end
			else
				--damage area expired
				itemsToDelete[damageSiteIndex] = true
			end
		end
		for unitID, damagePerSecond in pairs(unitsToDamage) do
			AddUnitDamage(unitID, damagePerSecond)
		end
		for damageSiteIndex, _ in pairs(itemsToDelete) do
			damageZones[damageSiteIndex] = nil
		end
	end
end

function gadget:UnitDestroyed(unitID)
	unitsToDamage[unitID] = nil
	burningUnits[unitID] = nil
end
