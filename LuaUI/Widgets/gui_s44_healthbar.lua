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
local iconDist = Spring.GetConfigInt('UnitIconDist')

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
local GetUnitRadius = Spring.GetUnitRadius
local GetCameraPosition = Spring.GetCameraPosition
local GetUnitWeaponState = Spring.GetUnitWeaponState

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

local mathFloor = math.floor
local mathMax = math.max
local mathMin = math.min
local mathRad = math.rad
local mathSin = math.sin
local mathCos = math.cos


local MIN_RELOAD_TIME = 4
local reloadDataList = {} -- {[unitDefID] = {primaryWeapon, reloadTime}}


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

local unitData = {}
local unitAuras = {}
local unitBars = {}

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
		WG.RemoveWidgetCallIn('DrawWorld', widget)
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
	if (n % 300) < 1 then
		local toDelete = {}
		for uid, data in pairs(unitData) do
			if not data.display then
				toDelete[#toDelete + 1] = uid
			end
		end
		for _, uid in pairs(toDelete) do
			unitBars[uid] = nil
			unitAuras[uid] = nil
			unitData[uid] = nil
		end
	end
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

local function GenerateUnitGraphics(uid, udid, getAuras)
	
	--General
	local ud = UnitDefs[udid]
	
	-- Don't show transported
	if Spring.GetUnitTransporter(uid) and not ud.customParams.child then
		return
	end
	
	local bars = unitBars[uid]
	if not bars then
		unitData[uid] = {}
		unitBars[uid] = {}
		getAuras = true
		bars = unitBars[uid]
		local _,maxHP = GetUnitHealth(uid)
		if maxHP then
			bars.health = {}
			bars.health.color = {0,0,0,0.8}
		end
		
		if ud.customParams.maxammo then
			bars.ammo = {}
			bars.ammo.max = ud.customParams.maxammo
			bars.ammo.color = {1.0, 1.0, 0, 0.8}
		end
		
		if ud.maxFuel > 0 then
			bars.fuel = {}
			bars.fuel.max = MAP_FUEL_SCALE(ud.maxFuel)
			bars.fuel.color = {0.9, 0.5766, 0.207, 0.8}
		end
		
		if ud.isBuilder then
			bars.build = {}
			bars.build.color = {0, 0, 0, 0.8}
		end
		
		if ud.isTransport then
			bars.transport = {}
			bars.transport.max = ud.transportMass
			bars.transport.color = {1, 1, 1, 0.8}
		end
		
		if reloadDataList[udid] then
			bars.reload = {}
			bars.reload.max = 1
			bars.reload.color = {0, 0.5, 0.9, 0.8}
		end
	end
	
	unitData[uid].frame = currentFrame
	
	local display = false
	
	
	
	-- HEALTH
	if bars.health then
		local curHP,maxHP,paradmg = GetUnitHealth(uid)
		if not curHP then --not really accessible
			return
		end
		curHP = math.max(0, curHP)
		local pct = (curHP / maxHP)
		local health = bars.health
		health.cur = curHP
		health.max = maxHP
		health.pct = pct
		health.color[1], health.color[2] = 2 * (1 - pct), 2.0 * pct
		if (mathFloor(maxHP) ~= mathFloor(curHP)) and (curHP > 0) then
			Spring.Echo("health", uid)
			display = true
		end
	end
	
	
	-- AMMO
	if bars.ammo then
		local maxAmmo = ud.customParams.maxammo
		local curAmmo = GetUnitRulesParam(uid, "ammo")
		if(curAmmo) then
			bars.ammo.cur = curAmmo
			bars.ammo.pct = curAmmo / maxAmmo
			if(mathFloor(maxAmmo) ~= mathFloor(curAmmo)) then
				display = true
			end
		end
	end
	
	
	-- FUEL
	if bars.fuel then
		local curFuel = Spring.GetUnitFuel(uid)
		bars.fuel.cur = curFuel
		bars.fuel.pct = curFuel / MAP_FUEL_SCALE(ud.maxFuel)
		display = true
	end
	
	
	-- BUILD
	local unitbuildid
	
	if bars.build then
		unitbuildid = GetUnitIsBuilding(uid)
		if unitbuildid then
			local curbHP,maxbHP,_,_,unitbuildprog = GetUnitHealth(unitbuildid)
			bars.build.cur = curbHP
			bars.build.max = maxbHP
			bars.build.pct = curbHP / maxbHP
			bars.build.color[1], bars.build.color[2] = 1 - unitbuildprog, 1 + unitbuildprog
			display = true
		end
	end
	
	
	-- TRANSPORT
	local transportingUnits
	if bars.transport then
		transportingUnits = GetUnitIsTransporting(uid)
		local currentmass = 0
		for i=1,#transportingUnits do
			local transuid = transportingUnits[i]
			local transudid = GetUnitDefID(transuid)
			currentmass = currentmass + UnitDefs[transudid].mass
		end
		if(currentmass > 0) then
			bars.transport.cur = currentmass
			bars.transport.pct = currentmass / ud.transportMass
			display = true
		end
	end
	
	
	-- RELOAD
	if bars.reload then 
		local reloadData = reloadDataList[udid]
		local primaryWeapon, reloadTime = reloadData[1], reloadData[2]
		if reloadTime >= MIN_RELOAD_TIME then
			local _, reloaded, reloadFrame = GetUnitWeaponState(uid, primaryWeapon)
			if not reloaded then
				--Spring.Echo("being reloaded")
				percentage = 1 - (((reloadFrame or 0) - currentFrame ) / 30) / reloadTime
				if percentage >= 0 then
					bars.reload.cur = percentage
					bars.reload.pct = percentage
					display = true
				end
			end
		end
	end
	
	-- AURAS
	
	if getAuras then
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
			unitAuras[uid] = 
			{
				["suppress"] = (aurasuppress > (0.8 * (tonumber(ud.customParams.fearlimit) or 25)) and 2) or (aurasuppress > 0) and 1 or 0,
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
		else
			unitAuras[uid] = nil
		end
	end
	
	if ud.customParams.child then 
		display = true
	end
	
	unitData[uid].display = unitAuras[uid] or display
end

function widget:GameStart()
	iconDist = Spring.GetConfigInt('UnitIconDist')
end

function DrawBar(barNum, heightscale, width, height, max, cur, pct, color, paralyze)
	heightscale = 0.75 * heightscale
	glColor(0, 0, 0, 1)
	local x1 = width * -0.6
	local y1 = (-1 + (2 * barNum)) * height -- bar1 = 1h, bar2 = 3h, bar3 = 5h
	local x2 = width * -0.6 + (width * 1.6)
	local y2 = (1 + (2 * barNum)) * height -- bar1 = 3h, bar2 = 5h, bar3 = 7h
	glRect(x1 - heightscale, y1 - ((barNum == 0 and heightscale) or 0), x2 + heightscale, y2)
	glColor(color)
	glTexRect(x1, y1, width * -0.6 + (width * (pct * 1.6)), y2 - heightscale)
end

function widget:DrawWorld()
	if not IsGUIHidden() then
		local getAuras = false
		local scalefactor = 500
		glDepthMask(true)
		glDepthTest(false)
		local camX,camY,camZ = GetCameraPosition()
		local getAuras = (currentFrame-1) % 30 < 1
		for _,uid in pairs(GetVisibleUnits(ALL_UNITS,iconDist,false)) do
			
			local udid = GetUnitDefID(uid)
			if not unitData[uid] or unitData[uid].frame < currentFrame then
				GenerateUnitGraphics(uid, udid, getAuras)
			end
			
			local display = unitData[uid].display or IsUnitSelected(uid)
			unitData[uid].display = display
			
			local radius,r,g,b,x,y,z,heightscale
			
			if display or SHOW_ICON[udid] then
			
				radius = GetUnitRadius(uid)
				if radius <= 4 then radius = radius * 7 end
				local teamID = GetUnitTeam(uid)
				r,g,b = GetTeamColor(teamID)
				x,y,z = GetUnitBasePosition(uid)
				heightscale = mathMax((camX - x) / scalefactor, (camY - y) / scalefactor, (camZ - z) / scalefactor)
				
				
				glPushMatrix()
					glTranslate(x, y, z)
					glBillboard()
					glTranslate(0, -radius, 0)
				
					local alpha = 1
					if not display then
						alpha = (heightscale/3.4)
					end
					
					if ICON_TYPE[udid] and alpha > 0.3 then
						glColor(r,g,b,alpha)
						glTex(ICON_TYPE[udid])
						glTexRect(radius*-0.65-(16 * heightscale), -8*heightscale, radius*-0.65, 8*heightscale)
						glTex(false)
					end
			end
			if display then
					local counter = 0
					if unitAuras[uid] then
						for type, data in pairs(unitAuras[uid]) do
							if(data > 0) then
								DrawAuraIndicator(counter, type, data, radius, heightscale * 1.5)
								counter = counter + 1
							end
						end
						counter = 0
					end
					
					
					--glTex('LuaUI/zui/bars/hp.png')
					for bar, bardata in pairs(unitBars[uid]) do
						local pct = bardata.pct
						if(pct) then
							if pct > 1 then
								pct = 1
							elseif pct < 0 then
								pct = 0
							end
							DrawBar(counter, heightscale, radius, heightscale, bardata.max, bardata.cur, pct, bardata.color, bardata.paralyze)
							counter = counter + 1
						end
					end
					--glTex(false)
				
			end
			if display or SHOW_ICON[udid] then 
				glPopMatrix() 
			end
		end
		glColor(1,1,1,1)
		glDepthTest(false)
		glDepthMask(false)
	end
end
