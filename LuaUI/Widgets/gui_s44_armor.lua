local versionNumber = "v1.1"

function widget:GetInfo()
	return {
		name = "1944 Armor Display",
		desc = versionNumber .. " Rollover display of armor.",
		author = "Evil4Zerggin",
		date = "20 July 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true
	}
end

------------------------------------------------
--config
------------------------------------------------
local MAX_DIST = 48
local fontSizeWorld = 10--12
local fontSizeScreen = 24
local lineWidth = 1
local maxArmor = 120
local maxSlope = 65
local smooth = false

------------------------------------------------
--vars
------------------------------------------------
local SQRT2 = math.sqrt(2)

local xlist
local weaponInfos = {}
local unitInfos = {}
local font

local spec = Spring.GetSpectatingState()

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local GetUnitDefID = Spring.GetUnitDefID
local GetWeaponDefID = Spring.GetWeaponDefID
local GetUnitPosition = Spring.GetUnitPosition
local GetFeaturePosition = Spring.GetFeaturePosition
local GetUnitVectors = Spring.GetUnitVectors
local GetSelectedUnits = Spring.GetSelectedUnits
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetActiveCommand = Spring.GetActiveCommand
local IsUnitAllied = Spring.IsUnitAllied
local AreTeamsAllied = Spring.AreTeamsAllied
local GetLocalTeamID = Spring.GetLocalTeamID
local GetUnitTeam = Spring.GetUnitTeam

local CMD_ATTACK = CMD.ATTACK

local abs = math.abs
local min = math.min
local max = math.max
local log = math.log
local exp = math.exp
local sqrt = math.sqrt
local floor = math.floor

local strFormat = string.format

local vMagnitude

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glColor = gl.Color
local glTranslate = gl.Translate
local glRotate = gl.Rotate
local glBillboard = gl.Billboard
local glLineWidth = gl.LineWidth
local glShape = gl.Shape


local GL_LINES = GL.LINES

local ARMOR_POWER = 8.75 --3.7
local DIRECT_HIT_THRESHOLD = 0.98
local HE_MULT = 1.45

------------------------------------------------
--local functions
------------------------------------------------

local function GetColor(t, maxValue)
	if t then 
		t = math.abs(t)
		return {2 - 2 * t / maxValue, 2 * t / maxValue, 0}
	end
	return
end

local function GetArmorColor(t)
	return GetColor(t, maxArmor)
end

local function GetSlopeColor(t)
	return GetColor(t, maxSlope)
end

local function GetDamageColor(percentage)
	local ratio = 3 * min(percentage, 100) / 100
	-- if percentage < 33 then
		-- return {3 * percentage / 100, 0, 0}
	-- end
	local green = max(ratio - 1, 0)
	local red = ratio - max(2 * green - 1, 0)
	return {red, green, 0}
end

local function GetString(a, suffix, prefix)
	return (prefix or "") .. a .. suffix
end

local function forwardArmorTranslation(x)
  return x ^ ARMOR_POWER
end

local function DrawValuesOnUnit(unitID, textTable, colorFunction, stringFunction, suffix, prefix, piece, dist)
	dist = dist or MAX_DIST
	local closeDist = dist/1.5 - fontSizeWorld
	local farDist = dist + fontSizeWorld
	local front, side, rear, top = unpack(textTable)
	local tx, ty, tz =  GetUnitPosition(unitID)
	local matrix
	if piece ~= "base" then 
		local pieceMap = Spring.GetUnitPieceMap(unitID) -- TODO: cache this
		matrix = {Spring.GetUnitPieceMatrix(unitID, pieceMap[piece])}
		if piece == "super" then -- more ick, superstructure origin is in same place as base
			ty = ty + 20
		end
	end
	local frontdir, updir, rightdir = GetUnitVectors(unitID)

	if not suffix then suffix = "" end
	
	local diagdir1 = {
		(frontdir[1] + rightdir[1]) / SQRT2,
		(frontdir[2] + rightdir[2]) / SQRT2,
		(frontdir[3] + rightdir[3]) / SQRT2,
	}

	local diagdir2 = {
		(frontdir[1] - rightdir[1]) / SQRT2,
		(frontdir[2] - rightdir[2]) / SQRT2,
		(frontdir[3] - rightdir[3]) / SQRT2,
	}

	local vertices = {
		{v = {diagdir1[1] * closeDist, diagdir1[2] * closeDist, diagdir1[3] * closeDist}},
		{v = {diagdir1[1] * farDist, diagdir1[2] * farDist, diagdir1[3] * farDist}},
		{v = {diagdir2[1] * closeDist, diagdir2[2] * closeDist, diagdir2[3] * closeDist}},
		{v = {diagdir2[1] * farDist, diagdir2[2] * farDist, diagdir2[3] * farDist}},
		{v = {-diagdir1[1] * closeDist, -diagdir1[2] * closeDist, -diagdir1[3] * closeDist}},
		{v = {-diagdir1[1] * farDist, -diagdir1[2] * farDist, -diagdir1[3] * farDist}},
		{v = {-diagdir2[1] * closeDist, -diagdir2[2] * closeDist, -diagdir2[3] * closeDist}},
		{v = {-diagdir2[1] * farDist, -diagdir2[2] * farDist, -diagdir2[3] * farDist}},
	}

	glLineWidth(lineWidth)

	glPushMatrix()
		glTranslate(tx, ty, tz)
		if piece ~= "base" then 
			glPushMatrix()
			gl.MultMatrix(unpack(matrix))
		end
		glColor(1, 1, 1)
		glShape(GL_LINES, vertices)
		if front then
			glColor(colorFunction(front))
			glPushMatrix()
				glTranslate(frontdir[1] * dist, frontdir[2] * dist, frontdir[3] * dist)
				glBillboard()
				font:Print(stringFunction(front, suffix, prefix), 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
			glPopMatrix()
		end

		if side then
			glColor(colorFunction(side))
			glPushMatrix()
				glTranslate(rightdir[1] * dist, rightdir[2] * dist, rightdir[3] * dist)
				glBillboard()
				font:Print(stringFunction(side, suffix, prefix), 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
			glPopMatrix()
		
			glPushMatrix()
				glTranslate(-rightdir[1] * dist, -rightdir[2] * dist, -rightdir[3] * dist)
				glBillboard()
				font:Print(stringFunction(side, suffix, prefix), 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
			glPopMatrix()
		end
		
		if rear then
			glColor(colorFunction(rear))
			glPushMatrix()
				glTranslate(-frontdir[1] * dist, -frontdir[2] * dist, -frontdir[3] * dist)
				glBillboard()
				font:Print(stringFunction(rear, suffix, prefix), 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
			glPopMatrix()
		end

		--[[if top then
			glColor(colorFunction(top))
			glPushMatrix()
				glTranslate(updir[1] * dist / 2, updir[2] * dist / 2, updir[3] * dist / 2)
				glBillboard()
				font:Print(top .. suffix, 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
			glPopMatrix()
		end]]

	glPopMatrix()
	if piece ~= "base" then 
		glPopMatrix()
	end
	glLineWidth(1)
end

local function CalculateDamage(weaponInfo, unitInfo, distance, health, piece)
	local armorType = unitInfo.armorType
	local armour = unitInfo.armour
	-- TODO: cache this
	local front = forwardArmorTranslation(armour[piece].front.thickness / math.cos(math.rad(armour[piece].front.slope or 0)))
	local side = forwardArmorTranslation(armour[piece].side.thickness / math.cos(math.rad(armour[piece].side.slope or 0)))
	local rear = forwardArmorTranslation(armour[piece].rear.thickness / math.cos(math.rad(armour[piece].rear.slope or 0)))
	local top = forwardArmorTranslation(armour[piece].top.thickness / math.cos(math.rad(armour[piece].top.slope or 0)))
	
	local penetration, dropoff, range, damages, armorHitSide = unpack(weaponInfo)
	local isHE = (penetration == 0)
	distance = min(distance, range)
	local baseDamage = damages[armorType]
	if isHE then
		penetration = HE_MULT * sqrt(baseDamage)
	elseif dropoff ~= 0 then
		penetration = penetration * exp(dropoff * distance)
	end
	penetration = forwardArmorTranslation(penetration)
	baseDamage = (baseDamage / health) * 100
	local numerator = baseDamage * penetration
	
	local damage
	
	if armorHitSide then
		local armor
		local i
		if armorHitSide == "top" then 
			armor = top
			i = 4
		elseif armorHitSide == "rear" then 
			armor = rear
			i = 3
		elseif armorHitSide == "side" then 
			armor = side
			i = 2
		else 
			armor = front
			i = 1
		end
		damage = {
			false,
			false,
			false,
			false
		}
		damage[i] = floor(numerator / (penetration + armor))
	else
		damage = {
			floor(numerator / (penetration + front)),
			floor(numerator / (penetration + side)),
			floor(numerator / (penetration + rear)),
			false
		}
	end
	if isHE and Game.armorTypes[armorType] == "armouredvehicles" then
		for i = 1,4 do
			if damage[i] then
				damage[i] = damage[i] + floor(baseDamage)
			end
		end
	end
	return damage
end

------------------------------------------------
--callins
------------------------------------------------

function widget:Initialize()
	vMagnitude = WG.Vector.Magnitude
	
	local armorTypes = Game.armorTypes
	for unitDefID, unitDef in pairs(UnitDefs) do
		local cp = unitDef.customParams
		if cp.armour then
			unitInfos[unitDefID] = {
				["armorType"] = unitDef.armorType,
				["armour"] = table.unserialize(cp.armour),
			}
		end
	end
	for i, weaponDef in pairs(WeaponDefs) do
		local customParams = weaponDef.customParams
		local penetration
		local dropoff
		local range = weaponDef.range
		local damages = weaponDef.damages
		local armorHitSide = customParams.armor_hit_side
		if (customParams.damagetype ~= "grenade") then
			if (customParams.damagetype == "shapedcharge") then 
				local armor_penetration = customParams.armor_penetration
				penetration = tonumber(armor_penetration)
				dropoff = 0
			elseif (customParams.damagetype == "explosive") then
				penetration = 0
				dropoff = 0
			else
				if (tonumber(customParams.armor_penetration) or 0) > (penetration or 0) then
					local armor_penetration = customParams.armor_penetration
					local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration
					penetration = tonumber(armor_penetration)
					dropoff = log(armor_penetration_1000m / armor_penetration) / 1000
				elseif (tonumber(customParams.armor_penetration_100m) or 0) > (penetration or 0) then
					local armor_penetration_100m = customParams.armor_penetration_100m
					local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration_100m
					penetration = (armor_penetration_100m / armor_penetration_1000m) ^ (1/9) * armor_penetration_100m
					dropoff = log(armor_penetration_1000m / armor_penetration_100m) / 900
				end
			end
		end
		if penetration then
			weaponInfos[i] = {penetration, dropoff, range, damages, armorHitSide}
		end
	end

	font = WG.S44Fonts.TypewriterBold32
end

local function DrawValuesWrapper(unitInfo, mouseTarget, textTable, suffix, prefix, part, name, dist)
	local textTable = {
		unitInfo.armour[part].front[name] or 0,
		unitInfo.armour[part].side[name] or 0,
		unitInfo.armour[part].rear[name] or 0,
		unitInfo.armour[part].top[name] or 0,
	}
	DrawValuesOnUnit(mouseTarget, textTable, GetArmorColor, GetString, suffix, prefix, part, dist)
end

function widget:DrawWorld()
	local mx, my = GetMouseState()
	local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)

	if mouseTargetType == "unit" then
		local udid = GetUnitDefID(mouseTarget)
		if (not udid) then return end	-- may happen when hovering over enemy radar dot
		local unitDef = UnitDefs[udid]
		local customParams = unitDef.customParams
		local unitInfo = unitInfos[udid]
		if unitInfo then
			if (not IsUnitAllied(mouseTarget) or spec and not AreTeamsAllied(GetLocalTeamID(), GetUnitTeam(mouseTarget))) then
				local sorted = GetSelectedUnitsSorted()
				local maxDamagePerUnit = {}
				local drawDamage = false
				local ux, uy, uz = GetUnitPosition(mouseTarget)
				local unitDistances = {}
				for selectedUnitDefID, selectedUnits in pairs(sorted) do
					local unitDef = UnitDefs[selectedUnitDefID]
					if unitDef then
						local weapons = unitDef.weapons
						for _, weapon in pairs(weapons) do
							local weaponID = weapon.weaponDef
							local weaponInfo = weaponInfos[weaponID]
							if weaponInfos[weaponID] then
								drawDamage = true
								for _, selectedUnitID in pairs(selectedUnits) do
									local distance
									if not unitDistances[selectedUnitID] then
										local wx, wy, wz = GetUnitPosition(selectedUnitID)
										unitDistances[selectedUnitID] = vMagnitude(ux - wx, uy - wy, uz - wz)
									end
									distance = unitDistances[selectedUnitID]
									local _, health = Spring.GetUnitHealth(mouseTarget)
									for piece, _ in pairs(unitInfo.armour) do
										local damage = CalculateDamage(weaponInfo, unitInfo, distance, health, piece)
										if not maxDamagePerUnit[piece] then
											maxDamagePerUnit[piece] = {-1, -1, -1, -1}
										end
										for i = 1,4 do -- 4 sides
											if damage[i] and damage[i] > maxDamagePerUnit[piece][i] then
												maxDamagePerUnit[piece][i] = damage[i]
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if drawDamage then
				DrawValuesOnUnit(mouseTarget, maxDamagePerUnit["base"], GetDamageColor, GetString, "%", nil, "base", MAX_DIST)
				if unitInfo.armour.super then
					DrawValuesOnUnit(mouseTarget, maxDamagePerUnit["super"], GetDamageColor, GetString, "%", nil, "super", MAX_DIST/2)	
				elseif unitInfo.armour.turret then
					DrawValuesOnUnit(mouseTarget, maxDamagePerUnit["turret"], GetDamageColor, GetString, "%", nil, "turret", MAX_DIST/2)
				end
				return
			end
			DrawValuesWrapper(unitInfo, mouseTarget, textTable, "mm", nil, "base", "thickness", MAX_DIST)
			DrawValuesWrapper(unitInfo, mouseTarget, textTable, "°", "\n", "base", "slope", MAX_DIST)
			if unitInfo.armour.super then
				DrawValuesWrapper(unitInfo, mouseTarget, textTable, "mm", nil, "super", "thickness", MAX_DIST/2)
				DrawValuesWrapper(unitInfo, mouseTarget, textTable, "°", "\n", "super", "slope", MAX_DIST/2)
			elseif unitInfo.armour.turret then
				DrawValuesWrapper(unitInfo, mouseTarget, textTable, "mm", nil, "turret", "thickness", MAX_DIST/2)
				DrawValuesWrapper(unitInfo, mouseTarget, textTable, "°", "\n", "turret", "slope", MAX_DIST/2)
			end
		end
	end
end


function widget:DrawScreen()
	local selectedUnit = GetSelectedUnits()[1]

	if selectedUnit then
		local _, cmd, _ = GetActiveCommand()
		if cmd == CMD_ATTACK then
			local unitDefID = GetUnitDefID(selectedUnit)
			local weapons = UnitDefs[unitDefID].weapons
			local maxPenetration
			local isHeat = false
			local mx, my = GetMouseState()
			local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
			local tx, ty, tz
	
			if mouseTargetType == "unit" then
				tx, ty, tz = GetUnitPosition(mouseTarget)
			elseif mouseTargetType == "feature" then
				tx, ty, tz = GetFeaturePosition(mouseTarget)
			elseif mouseTargetType == "ground" then
				tx, ty, tz = unpack(mouseTarget)
			else
				return
			end
			if (tx == nil) or (ty == nil) or (tz == nil) then
				return
			end
			local ux, uy, uz = GetUnitPosition(selectedUnit)
			local dist = vMagnitude(ux - tx, uy - ty, uz - tz)
			for _, weapon in pairs(weapons) do
				local weaponID = weapon.weaponDef
				if weaponInfos[weaponID] then
					
					local penetration, dropoff, range = unpack(weaponInfos[weaponID])
	                if dropoff ~= 0 then
						penetration = penetration * exp(dropoff * dist)
					end
					if dist < range and (not maxPenetration or maxPenetration < penetration) then
						maxPenetration = penetration
						isHeat = (dropoff == 0)
					end
	                
					-- if penetrationheat and radiusrange > dist then 
						-- glColor(GetArmorColor(penetrationheat)) 
						-- font:Print(strFormat("%.0fmm", penetrationheat), mx + 16, my - fontSizeScreen / 2, fontSizeScreen, "n")
						-- font:Print("HEAT", mx + 16, - 16 + my - fontSizeScreen / 2, fontSizeScreen, "n")
					-- else
						-- if dropoff then 
							-- glColor(GetArmorColor(penetration)) 
							-- font:Print(strFormat("%.0fmm", penetration), mx + 16, my - fontSizeScreen / 2, fontSizeScreen, "n")
						-- end
					-- end
				end
			end
			if maxPenetration and maxPenetration > 0 then
				glColor(GetArmorColor(maxPenetration)) 
				font:Print(strFormat("%.0fmm", maxPenetration), mx + 16, my - fontSizeScreen / 2, fontSizeScreen, "n")
				if isHeat then
					font:Print("HEAT", mx + 16, - 16 + my - fontSizeScreen / 2, fontSizeScreen, "n")
				end
			end
		end
	end
end
