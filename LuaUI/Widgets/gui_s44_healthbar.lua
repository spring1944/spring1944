function widget:GetInfo()
	return {
		name	  = "S44 Healthbars",
		desc	  = "Custom healthbars",
		author	  = "TheFatController/Gnome, adapted from IW Healthbars",
		date	  = "November 2009",
		license	  = "PD",
		layer	  = 0,
		enabled	  = true
	}
end

local active = true
local myTeam = Spring.GetLocalTeamID()
local myAllyTeam = Spring.GetLocalAllyTeamID()
local iconDist = Spring.GetConfigInt('UnitIconDist')
local barUnits = {}

local IsGUIHidden = Spring.IsGUIHidden
local GetVisibleUnits = Spring.GetVisibleUnits
local IsUnitSelected = Spring.IsUnitSelected
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitIsBuilding = Spring.GetUnitIsBuilding
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GetUnitRulesParam = Spring.GetUnitRulesParam
local GetUnitShieldState = Spring.GetUnitShieldState
local GetCameraDirection = Spring.GetCameraDirection
local GetLocalTeamID = Spring.GetLocalTeamID
local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
local GetGameFrame = Spring.GetGameFrame
local GetUnitRadius = Spring.GetUnitRadius
local GetCameraPosition = Spring.GetCameraPosition
local GetUnitWeaponState = Spring.GetUnitWeaponState

local lastFrame = 0
local currentFrame = 0

local glColor = gl.Color
local glTex = gl.Texture
local glTexRect = gl.TexRect
local glRect = gl.Rect
local glDepthMask = gl.DepthMask
local glDepthTest = gl.DepthTest
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glBillboard = gl.Billboard
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList
local glDrawFuncAtUnit = gl.DrawFuncAtUnit
local glShape = gl.Shape

local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_LINE_STRIP = GL.LINE_STRIP

local mathFloor = math.floor
local mathMax = math.max
local mathMin = math.min
local mathRad = math.rad
local mathSin = math.sin
local mathCos = math.cos

local CIRCLE_DIVS = 32
local MIN_RELOAD_TIME = 4
local circleVertsList = {}

local reloadDataList = {} -- {[unitDefID] = {primaryWeapon, reloadTime}}

local displayList

local teamColors = {}
local function GetTeamColor(teamID)
  local color = teamColors[teamID]
  if (color) then
	return color[1],color[2],color[3]
  end
  local r,g,b = Spring.GetTeamColor(teamID)
  color = { r, g, b }
  teamColors[teamID] = color
  return r, g, b
end

local auraUnits = {}

local ICON_TYPE = {}
local SHOW_ICON = {}


local iconTypes = VFS.Include("gamedata/icontypes.lua")
for defID, defs in ipairs(UnitDefs) do
	if defs.iconType ~= "default" then
		ICON_TYPE[defID] = iconTypes[defs.iconType].bitmap
	end
	if (defs.modCategories["flag"] == nil) then
		SHOW_ICON[defID] = true
	end
end

-- see LuaRules/Gadgets/game_planes for details
local REFERENCE_FUEL_AMOUNT = 24
local function MAP_FUEL_SCALE(fuel)
	local mapX, mapY = Game.mapX, Game.mapY
	local mapDiagonalLength = math.sqrt(mapX ^ 2 + mapY ^ 2)
	local fuelBoost = mapDiagonalLength / REFERENCE_FUEL_AMOUNT
	return fuelBoost * fuel
end

local function hpdisp()
	if(not active) then
		widgetHandler:UpdateCallIn('DrawWorld')
		active = true
	else
		widgetHandler:RemoveCallIn('DrawWorld')
		active = false
	end
end

function widget:Initialize()
	Spring.SendCommands({"showhealthbars 0"})
	Spring.SendCommands({"showrezbars 0"})
	widgetHandler:AddAction("hpdisp", hpdisp)
	Spring.SendCommands({"unbind f9 showhealthbars"})
	Spring.SendCommands({"bind f9 luaui hpdisp"})
	
	local count = 0
	for udid, ud in pairs(UnitDefs) do
		for i=1, #ud.weapons do
			local weaponDefID = ud.weapons[i].weaponDef
			local weaponDef = WeaponDefs[weaponDefID]
			
			if not reloadDataList[udid] or weaponDef.reload > reloadDataList[udid][2] then
				reloadDataList[udid] = {i, weaponDef.reload}
				count = count + 1
			end
		end
	end
	Spring.Echo(count)
end

function widget:Shutdown()
	widgetHandler:RemoveAction("hpdisp", hpdisp)
	Spring.SendCommands({"unbind f9 luaui"})
	Spring.SendCommands({"bind f9 showhealthbars"})
	Spring.SendCommands({"showhealthbars 1"})
	Spring.SendCommands({"showrezbars 1"})
end

function widget:GameFrame(n)
  currentFrame = n
end

local function OutlineTriangleLoopVertices(vertices)
	local result = {}
	local ri = 1
	local vi = 2
	while vertices[vi] do
		result[ri] = {v = vertices[vi].v}
		ri = ri + 1
		vi = vi + 1
	end
	
	return result
end

local function DrawCircle(divs, height, scale, percentage, position)
	local radius = 3 * scale
	local spacing = 5 * scale
	local centerX = height * -0.55 - scale + spacing * position + 2 * radius
	local centerZ = -2.5 * scale - radius
	
	local triangleVertices = {
		{v = {centerX, centerZ, 0}, c = {0.00,0.60,0.60}},
		{v = {centerX, centerZ + radius, 0}, c = {0.00,0.40,0.40}},
	}
	local angleIncrement = mathRad(360 / divs)
	local angle = 0
	local drawnDivs = mathFloor(divs * percentage)
	
	for i=1, drawnDivs do
		angle = angle + angleIncrement
		triangleVertices[i+2] = {
			v = {centerX + mathSin(angle) * radius, centerZ + mathCos(angle) * radius, 0},
			c = color
		}
	end
	
	local lineVertices = OutlineTriangleLoopVertices(triangleVertices)
	
	glShape(GL_TRIANGLE_FAN, triangleVertices)
	glColor(0, 0.45, 0.45, 1)
	glShape(GL_LINE_STRIP, lineVertices)
end

local function DrawAuraIndicator(num, type, data, height, scale)
	if data then
		iconwidth = (5 * scale)
		glColor(1,1,1,1)
		glTex("LuaUI/Images/" .. type .. "/" .. type .. data .. ".png")
		glTexRect(
			height * -0.55 - scale + (iconwidth * num),			--left edge
			-1.5 * scale - iconwidth,
			height * -0.55 - scale + iconwidth + (iconwidth * num),				--right
			-1.5 * scale)
		glTex(false)
	end
end

function widget:Update(deltaTime)
	if (lastFrame ~= currentFrame) then
		lastFrame = currentFrame
		if(not IsGUIHidden()) then
			myTeam = GetLocalTeamID()
			myAllyTeam = GetLocalAllyTeamID()
			local getAuras = false
			local scalefactor = 500
			if ((currentFrame-1) % 30 < 1) then getAuras = true end
			if (displayList) then glDeleteList(displayList) end
			displayList = glCreateList( function()
				glDepthMask(true)
				glDepthTest(false)
				for _,uid in pairs(GetVisibleUnits(ALL_UNITS,iconDist,false)) do
					local camX,camY,camZ = GetCameraPosition()
					local udid = GetUnitDefID(uid)
					local ud = UnitDefs[udid]
					local display = false
					local health, build, upgrade, transport, ammo, fuel, aura
					local reload = -1
					local reloadData = reloadDataList[udid]
					local reloadTime, primaryWeapon
					local upgradeProgress = GetUnitRulesParam(uid, "upgradeProgress")
					local curHP,maxHP,paradmg = GetUnitHealth(uid)
					local curFuel = Spring.GetUnitFuel(uid)
					local unitbuildid = GetUnitIsBuilding(uid)
					local transportingUnits = GetUnitIsTransporting(uid)
					local isBeingTransported = Spring.GetUnitTransporter(uid) or false
					if(getAuras) then
						--[[local aurabuildspeed = GetUnitRulesParam(uid, "aurabuildspeed") or 0
						local aurahp = GetUnitRulesParam(uid, "aurahp") or 0
						local auraheal = GetUnitRulesParam(uid, "auraheal") or 0
						local auraenergy = GetUnitRulesParam(uid, "auraenergy") or 0
						local aurametal = GetUnitRulesParam(uid, "aurametal") or 0
						local aurarange = GetUnitRulesParam(uid, "aurarange") or 0
						local aurareload = GetUnitRulesParam(uid, "aurareload") or 0]]
						local aurasuppress = GetUnitRulesParam(uid, "suppress") or 0
						local auraoutofammo = (GetUnitRulesParam(uid, "ammo") or 100) <= 0
						local aurainsupply = GetUnitRulesParam(uid, "insupply") or 0
						if ((aurasuppress + aurainsupply) > 0 or auraoutofammo) then
							auraUnits[uid] = 
							{
								["suppress"] = (aurasuppress > 20 and 2) or (aurasuppress > 0) and 1 or 0,
								["ammo"] = auraoutofammo and 4 or nil,
								["insupply"] = aurainsupply,
								--['buildspeed'] = aurabuildspeed,
								--['hp'] = aurahp,
								--['heal'] = auraheal,
								--['power'] = auraenergy,
								--['req'] = aurametal,
								--['range'] = aurarange,
								--['reload'] = aurareload,
							}
							aura = auraUnits[uid]
						else
							auraUnits[uid] = nil
						end		  
					else
						aura = auraUnits[uid] or nil
					end

					if(maxHP) then
						curHP = math.max(0, curHP)
						local pct = (curHP / maxHP)
						health = {
							cur = curHP,
							max = maxHP,
							pct = pct,
							--paralyze = paradmg,
							color = {2 * (1 - pct), 2.0 * pct, 0, 0.8},
						}
						if (mathFloor(maxHP) ~= mathFloor(curHP)) and (curHP > 0) then
							display = true
						else
							display = false
						end
					end
					
					if(ud.customParams and ud.customParams.maxammo) then
						local maxAmmo = ud.customParams.maxammo
						local curAmmo = GetUnitRulesParam(uid, "ammo")
						if(curAmmo) then
							ammo = {
								max = maxAmmo,
								cur = curAmmo,
								pct = curAmmo / maxAmmo,
								--color = {2 * (1 - (curAmmo / maxAmmo)), (1 - (curAmmo / maxAmmo)), 2 * (curAmmo / maxAmmo), 0.8},
								color = {1.0, 1.0, 0, 0.8},
							}
							if(mathFloor(maxAmmo) ~= mathFloor(curAmmo)) then
								display = true
							end
						end
					end
					
					if(curFuel and curFuel > 0) then
						fuel = {
							cur = curFuel,
							max = ud.maxFuel,
							pct = curFuel / MAP_FUEL_SCALE(ud.maxFuel),
							color = {0.2, 0.5, 0.9, 0.8},
						}
						display = true
					end
					
					if(unitbuildid) then
						local curbHP,maxbHP,_,_,unitbuildprog = GetUnitHealth(unitbuildid)
						build = {
							cur = curbHP,
							max = maxbHP,
							pct = curbHP / maxbHP,
							color = {1 - unitbuildprog, 1 + unitbuildprog, 0, 0.8},
						}
						display = true
					end

					if(upgradeProgress) and (upgradeProgress > 0) then
						upgrade = {
							cur = 1,
							max = 100,
							pct = upgradeProgress,
							color = {1 - upgradeProgress, 1 + upgradeProgress, 0, 0.8},
						}
						display = true
					end

					if(transportingUnits) then
						maxtransmass = ud.transportMass
						currentmass = 0
						for i=1,#transportingUnits do
							transuid = transportingUnits[i]
							transudid = GetUnitDefID(transuid)
							currentmass = currentmass + UnitDefs[transudid].mass
						end
						if(currentmass > 0) then
							transport = {
								max = maxtransmass,
								cur = currentmass,
								pct = currentmass / maxtransmass,
								color = {1, 1, 1, 0.8},
							}
							display = true
						end
					end
					
					if reloadData then 
						primaryWeapon, reloadTime = reloadData[1], reloadData[2]
						if reloadTime >= MIN_RELOAD_TIME then
							local _, reloaded, reloadFrame = GetUnitWeaponState(uid, primaryWeapon)
							if not reloaded then
								--Spring.Echo("being reloaded")
								reload = 1 - ((reloadFrame - currentFrame ) / 30) / reloadTime
								if reload >= 0 then
									display = true
								end
							end
						end
					end
					
					if (not display) and (IsUnitSelected(uid) or aura) then display = true end
					if isBeingTransported then display = false end
					
					local radius,r,g,b,x,y,z,heightscale

					if display or (SHOW_ICON[udid] and not isBeingTransported) then
					
						radius = GetUnitRadius(uid)
						if(radius <= 4) then radius = radius * 7 end
						local teamID = GetUnitTeam(uid)
						r,g,b = GetTeamColor(teamID)
						x,y,z = GetUnitBasePosition(uid)
						heightscale = mathMax((camX - x) / scalefactor, (camY - y) / scalefactor, (camZ - z) / scalefactor)
						
						
						glPushMatrix()
							glTranslate(x, y, z)
							glBillboard()
							glTranslate(0, 0-radius, 0)
						
							local alpha = 1
							if (not display) then
								alpha = (heightscale/3.4)
							end
						
							if(ICON_TYPE[udid]) and (alpha > 0.3) then
								glColor(r,g,b,alpha)
								glTex(ICON_TYPE[udid])
								glTexRect(radius*-0.65-(16 * heightscale), -8*heightscale, radius*-0.65, 8*heightscale)
								glTex(false)
							end
						end
						if display then

							local counter = 0
							if(aura) then
								for type, data in pairs(aura) do
									if(data > 0) then
										DrawAuraIndicator(counter, type, data, radius, heightscale * 1.5)
										counter = counter + 1
									end
								end
								--counter = 0
							end
							
							if reload >= 0 then
								DrawCircle(CIRCLE_DIVS, radius, heightscale, reload, counter)
								--Spring.Echo("drawing reload")
							end
							counter = 0
							
							--glTex('LuaUI/zui/bars/hp.png')
							for bar, bardata in pairs({health,ammo,fuel,build,upgrade,transport}) do
								if(bardata.pct) then
									DrawBar(counter, heightscale, radius, heightscale, bardata.max, bardata.cur, bardata.pct, bardata.color, bardata.paralyze)
									counter = counter + 1
								end
							end
							--glTex(false)
						
						end
					if display or (SHOW_ICON[udid] and not isBeingTransported) then 
						glPopMatrix() 
					end
				end
				glColor(1,1,1,1)
				glDepthTest(false)
				glDepthMask(false)
			end)
		end
	end
end

function widget:GameStart()
  iconDist = Spring.GetConfigInt('UnitIconDist')
end

function DrawBar(barNum, heightscale, width, height, max, cur, pct, color, paralyze)
	heightscale = 0.75 * heightscale
	glColor(0, 0, 0, 1)
	glRect(width * -0.6 - heightscale, (-1 + (2 * barNum)) * height - heightscale, width * -0.6 + (width * 1.6) + heightscale, (1 + (2 * barNum)) * height + heightscale)
	glColor(color)
	glTexRect(width * -0.6, (-1 + (2 * barNum)) * height, width * -0.6 + (width * (pct * 1.6)), (1 + (2 * barNum)) * height)
	if(paralyze ~= nil) then
		local parapct = paralyze / max
		if(parapct > pct) then parapct = pct end --amount of hp is more important than stun time
		glColor(0,0.75,1,1)
		glTexRect(width * -0.6, (-1 + (2 * barNum)) * height, width * -0.6 + (width * (parapct * 1.6)), (1 + (2 * barNum)) * height)
	end
end

function widget:DrawWorld()
	if displayList and (not IsGUIHidden()) then
		glCallList(displayList)
	end
end
