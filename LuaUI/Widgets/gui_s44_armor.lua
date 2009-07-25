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
local dist = 32
local fontSizeWorld = 12
local fontSizeScreen = 24
local lineWidth = 1
local maxArmor = 120
local smooth = false

------------------------------------------------
--vars
------------------------------------------------
local closeDist = dist - fontSizeWorld
local farDist = dist + fontSizeWorld
local SQRT2 = math.sqrt(2)

local xlist
local infos = {}
local font

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitPosition = Spring.GetUnitPosition
local GetFeaturePosition = Spring.GetFeaturePosition
local GetUnitVectors = Spring.GetUnitVectors
local GetSelectedUnits = Spring.GetSelectedUnits
local GetActiveCommand = Spring.GetActiveCommand

local CMD_ATTACK = CMD.ATTACK

local log = math.log
local exp = math.exp

local strFormat = string.format

local vMagnitude = WG.Vector.Magnitude

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glColor = gl.Color
local glTranslate = gl.Translate
local glRotate = gl.Rotate
local glBillboard = gl.Billboard
local glLineWidth = gl.LineWidth
local glShape = gl.Shape

local glSmoothing = gl.Smoothing

local GL_LINES = GL.LINES

------------------------------------------------
--local functions
------------------------------------------------
local function GetArmorColor(t)
  return {2 - 2 * t / maxArmor, 2 * t / maxArmor, 0}
end

------------------------------------------------
--callins
------------------------------------------------

function widget:Initialize()
  for unitDefID=1, #UnitDefs do
    local unitDef = UnitDefs[unitDefID]

    local penetration, dropoff
    for i=1,#unitDef.weapons do
      local weapon = unitDef.weapons[i]
      local weaponDef = WeaponDefs[weapon.weaponDef]
      local customParams = weaponDef.customParams
      
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
    
    if penetration then
      infos[unitDefID] = {penetration, dropoff}
    end
  end
  
  font = WG.S44Fonts.TypewriterBold32
end

function widget:DrawWorld()
  local mx, my = GetMouseState()
  local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
  local selectedUnit = GetSelectedUnits()[1]
  
  if mouseTargetType == "unit" then
    local unitDef = UnitDefs[GetUnitDefID(mouseTarget)]
    local customParams = unitDef.customParams
    
    if customParams.armor_front then
      local armor_front = customParams.armor_front
      local armor_side = customParams.armor_side or armor_front
      local armor_rear = customParams.armor_rear or armor_side
      local armor_top = customParams.armor_top or armor_rear
      local tx, ty, tz = GetUnitPosition(mouseTarget)
      local frontdir, updir, rightdir = GetUnitVectors(mouseTarget)
      
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
      glSmoothing(false, smooth, false)
      
      glPushMatrix()
        glTranslate(tx, ty, tz)
        glColor(1, 1, 1)
        glShape(GL_LINES, vertices)
        
        glColor(GetArmorColor(armor_front))
        glPushMatrix()
          glTranslate(frontdir[1] * dist, frontdir[2] * dist, frontdir[3] * dist)
          glBillboard()
          font:Print(armor_front .. "mm", 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
        glPopMatrix()
        
        glColor(GetArmorColor(armor_side))
        glPushMatrix()
          glTranslate(rightdir[1] * dist, rightdir[2] * dist, rightdir[3] * dist)
          glBillboard()
          font:Print(armor_side .. "mm", 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
        glPopMatrix()
        
        glPushMatrix()
          glTranslate(-rightdir[1] * dist, -rightdir[2] * dist, -rightdir[3] * dist)
          glBillboard()
          font:Print(armor_side .. "mm", 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
        glPopMatrix()
        
        glColor(GetArmorColor(armor_rear))
        glPushMatrix()
          glTranslate(-frontdir[1] * dist, -frontdir[2] * dist, -frontdir[3] * dist)
          glBillboard()
          font:Print(armor_rear .. "mm", 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
        glPopMatrix()
        
        glColor(GetArmorColor(armor_top))
        glPushMatrix()
          glTranslate(updir[1] * dist / 2, updir[2] * dist / 2, updir[3] * dist / 2)
          glBillboard()
          font:Print(armor_top .. "mm", 0, -fontSizeWorld / 2, fontSizeWorld, "nc")
        glPopMatrix()
        
      glPopMatrix()
      
      glLineWidth(1)
      glSmoothing(false, false, false)
    end
  end
end

function widget:DrawScreen()
  local selectedUnit = GetSelectedUnits()[1]
  
  if selectedUnit then
    local _, cmd, _ = GetActiveCommand()
    if cmd == CMD_ATTACK then
      local unitDefID = GetUnitDefID(selectedUnit)
      if infos[unitDefID] then
        local mx, my = GetMouseState()
        local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
        local tx, ty, tz
        
        if mouseTargetType == "unit" then
          tx, ty, tz = GetUnitPosition(mouseTarget)
        elseif mouseTargetType == "feature" then
          tx, ty, tz = GetFeaturePosition(mouseTarget)
        elseif mouseTargetType == "ground" then
          tx, ty, tz = mouseTarget[1], mouseTarget[2], mouseTarget[3]
        else
          return
        end
        
        local ux, uy, uz = GetUnitPosition(selectedUnit)
        local penetration, dropoff = infos[unitDefID][1], infos[unitDefID][2]
        local dist = vMagnitude(ux - tx, uy - ty, uz - tz)
        penetration = penetration * exp(dropoff * dist)
        
        glColor(GetArmorColor(penetration))
        font:Print(strFormat("%.0fmm", penetration), mx + 16, my - fontSizeScreen / 2, fontSizeScreen, "n")
      end
    end
  end
end
