local drawDistSq            = 0
local drawUnitStatusBars    = false

local m_min    = math.min
local m_max    = math.max
local m_bit_or = math.bit_or

local Echo               = Spring.Echo
local GetConfigInt       = Spring.GetConfigInt
local SetConfigInt       = Spring.SetConfigInt
local GetCameraPosition  = Spring.GetCameraPosition
local GetUnitPosition    = Spring.GetUnitPosition
local GetFeaturePosition = Spring.GetFeaturePosition
local GetUnitVelocity    = Spring.GetUnitVelocity
local GetFrameTimeOffset = Spring.GetFrameTimeOffset
local GetUnitTeam        = Spring.GetUnitTeam
local GetUnitAllyTeam    = Spring.GetUnitAllyTeam
local GetMyTeamID     = Spring.GetLocalTeamID
local GetMyAllyTeamID    = Spring.GetMyAllyTeamID
local GetSpectatingState = Spring.GetSpectatingState
local ValidUnitID = Spring.ValidUnitID

local GetUnitDefID        = Spring.GetUnitDefID
local GetUnitHealth       = Spring.GetUnitHealth
local GetUnitExperience   = Spring.GetUnitExperience
local GetUnitIsStunned    = Spring.GetUnitIsStunned
local GetUnitStockpile    = Spring.GetUnitStockpile
local GetUnitGroup        = Spring.GetUnitGroup
local GetUnitHeight       = Spring.GetUnitHeight
local GetFeatureHeight    = Spring.GetFeatureHeight
local GetFeatureResources = Spring.GetFeatureResources
local GetFeatureHealth    = Spring.GetFeatureHealth

local glPushMatrix   = gl.PushMatrix
local glPopMatrix    = gl.PopMatrix
local glLoadIdentity = gl.LoadIdentity
local glTranslate    = gl.Translate
local glBillboard    = gl.Billboard
local glPushAttrib   = gl.PushAttrib
local glPopAttrib    = gl.PopAttrib
local glDepthTest    = gl.DepthTest
local glColor        = gl.Color
local glRect         = gl.Rect
local glText         = gl.Text
local glFont         = gl.Font -- table
local GL_CURRENT_BIT = GL.CURRENT_BIT
local GL_ENABLE_BIT  = GL.ENABLE_BIT


local function ___DrawUnitStatusBars(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local unitDef = UnitDefs[unitDefID or -1]

	local hideDamage = (unitDef and unitDef.hideDamage) or false
	local _, specFullView, _ = GetSpectatingState()

	-- hide bars for non-allied units in LOS if not a global spectator
	if ((GetMyAllyTeamID() ~= GetUnitAllyTeam(unitID)) and (not specFullView) and hideDamage) then
		return
	end

	local exp, limExp = GetUnitExperience(unitID)
	local health, maxHealth, paraDmg, captProg, buildProg = GetUnitHealth(unitID)

	if (health < maxHealth or paraDmg > 0.0) then
		-- black background for healthbar
		glColor(0.0, 0.0, 0.0)
		glRect(-5.0, 4.0, 5.0, 6.0)

		-- health & stun level
		local rhealth = m_max(0.0, health / maxHealth)
		local rstun = m_min(1.0, paraDmg / maxHealth)
		local hsmin = m_min(rhealth, rstun)
	
		colR = m_max(0.0, 2.0 - 2.0 * rhealth)
		colG = m_min(2.0 * rhealth, 1.0)

		if (hsmin > 0.0) then
			hscol = 0.8 - 0.5 * hsmin
			hsmin = hsmin * 10.0

			glColor(colR * hscol, colG * hscol, 1.0)
			glRect(-5.0, 4.0, hsmin - 5.0, 6.0)
		end
		if (rhealth >= rstun) then
			glColor(colR, colG, 0.0)
			glRect(hsmin - 5.0, 4.0, rhealth * 10.0 - 5.0, 6.0)
		else
			glColor(0.0, 0.0, 1.0)
			glRect(hsmin - 5.0, 4.0, rstun * 10.0 - 5.0, 6.0)
		end
	end

	-- skip the rest of the indicators if it isn't a local unit
	if ((GetMyTeamID() ~= GetUnitTeam(unitID)) and (not specFullView)) then
		return
	end
	local groupID = GetUnitGroup(unitID)
	local _, _, beingBuilt = GetUnitIsStunned(unitID)
	local _, _, stockPileBuildPercent = GetUnitStockpile(unitID)

	-- experience bar
	local eEnd = (limExp * 0.8) * 10.0
	local bEnd = (buildProg and ((buildProg * 0.8) * 10.0)) or 0.0
	local sEnd = (stockPileBuildPercent and ((stockPileBuildPercent * 0.8) * 10.0)) or 0.0

	--glColor(1.0, 1.0, 1.0)
	--glRect(6.0, -2.0, 8.0, eEnd - 2.0)

	if (beingBuilt) then
		glColor(1.0, 0.0, 0.0)
		glRect(-8.0, -2.0, -6.0, bEnd - 2.0)
	elseif (stockPileBuildPercent ~= nil) then
		glColor(1.0, 0.0, 0.0)
		glRect(-8.0, -2.0, -6.0, sEnd - 2.0)
	end

	if (groupID ~= nil) then
		glColor(1.0, 1.0, 1.0, 1.0)
		glText(("" .. groupID), 8.0, 10.0,  12.0, "x")   -- "x" == FONT_BASELINE
	end
end


function widget:GetInfo()
	return {
		name    = "object_statusbars_default (v1.0)",
		desc    = "draws default unit and feature status-bars",
		author  = "Kloot, stripped down and widget-ized by FLOZi (C. Lawrence(",
		date    = "August 2, 2010",
		license = "GPL v2",
		layer   = -99999999, -- other widgets could block the Draw* callins
		enabled = true,
	}
end

local function ToggleShowHealthbars()
	drawUnitStatusBars = not drawUnitStatusBars
end

function widget:Initialize()
	Spring.SendCommands({"showhealthbars 0"})
	widgetHandler:AddAction("showhealthbars", ToggleShowHealthbars)
	Spring.SendCommands({"unbind f9 showhealthbars"})
	Spring.SendCommands({"bind f9 luaui showhealthbars"})
	drawUnitStatusBars    = (GetConfigInt("ShowHealthBars", 1) ~= 0)

	drawDistSq = GetConfigInt("UnitLodDist", 1000)
	drawDistSq = drawDistSq * drawDistSq

end

function widget:Shutdown()
	widgetHandler:RemoveAction("showhealthbars") --, ToggleShowHealthbars) 
	Spring.SendCommands({"unbind f9 luaui"})
	Spring.SendCommands({"bind f9 showhealthbars"})
	SetConfigInt("ShowHealthBars", (drawUnitStatusBars    and 1) or 0)
end



function widget:DrawWorld()
	if not drawUnitStatusBars then
		return
	end

	local cx, cy, cz = GetCameraPosition()

	-- we can't draw directly in the Draw{Unit, Feature}
	-- callins (engine shaders are active at that point)
	glPushAttrib(m_bit_or(GL_CURRENT_BIT, GL_ENABLE_BIT))
	glDepthTest(true)
	glPushMatrix()
		if (drawUnitStatusBars) then
			for _, unitID in pairs(Spring.GetVisibleUnits()) do
				if ValidUnitID(unitID) then
					local px, py, pz = GetUnitPosition(unitID)
					local vx, vy, vz = GetUnitVelocity(unitID)
					local dx, dy, dz = ((px - cx) * (px - cx)), ((py - cy) * (py - cy)), ((pz - cz) * (pz - cz))

					if ((dx + dy + dz) < (drawDistSq * 500)) then
					-- note: better add a GetUnitDrawPosition callout
						local t = GetFrameTimeOffset()
						local h = GetUnitHeight(unitID) + 5.0

						glPushMatrix()
							glTranslate(px + vx * t, py + h + vy * t, pz + vz * t)
							glBillboard()
							___DrawUnitStatusBars(unitID)
						glPopMatrix()
					end
				end
			end
		end

	glPopMatrix()
	glPopAttrib()
end
