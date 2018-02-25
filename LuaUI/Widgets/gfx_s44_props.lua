local versionNumber = "v2.0"

function widget:GetInfo()
	return {
		name      = "1944 Propeller FX",
		desc      = versionNumber .. " Draws motion-blurred propellers on aircraft",
		author    = "Zpock and Evil4Zerggin",
		date      = "22 March 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = 10000,
		enabled   = true  --  loaded by default?
  }
end

local size = 10

local GetUnitVelocity = Spring.GetUnitVelocity
local GetUnitPieceList = Spring.GetUnitPieceList
local GetUnitPieceInfo = Spring.GetUnitPieceInfo
local GetVisibleUnits = Spring.GetVisibleUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetGameSpeed = Spring.GetGameSpeed

local glDepthTest = gl.DepthTest
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glUnitMultMatrix = gl.UnitMultMatrix
local glUnitPieceMultMatrix = gl.UnitPieceMultMatrix
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glRotate = gl.Rotate

local strFind = string.find
local random = math.random
local sqrt = math.sqrt

--unitDefID = propellers
local infos = {}

--unitID = rotation
local rotations = {}

local path = "LuaUI/Images/Props/"

function widget:Initialize()
end

function widget:DrawWorld()
	glDepthTest(true)
	local visibleUnits = GetVisibleUnits()
	for i=1,#visibleUnits do
		local unitID = visibleUnits[i]
		local unitDefID = GetUnitDefID(unitID)
		if unitDefID and not infos[unitDefID] and UnitDefs[unitDefID].canFly then
			local pieces = GetUnitPieceList(unitID)
			local propellers = {}
			local tex = path .. (UnitDefs[unitDefID]["customParams"]["proptexture"] or "prop.tga")
			for pieceNum=1,#pieces do
				local pieceName = pieces[pieceNum]
				if strFind(pieceName, "propeller") then
					propellers[1] = tex
					propellers[#propellers+1] = pieceNum
				end
			end
			infos[unitDefID] = propellers
		end
		
		local propellers = infos[unitDefID] or {}
		if propellers[1] then
			glPushMatrix()
				glUnitMultMatrix(unitID)
				glTexture(propellers[1])
				for j=2,#propellers do
					propeller = propellers[j]
					glPushMatrix()
						glUnitPieceMultMatrix(unitID, propeller)
						if not rotations[unitID] then
							rotations[unitID] = unitID * 97
						end
						glRotate(rotations[unitID], 0, 0, 1)
						glTexRect(-size, -size, size, size)
					glPopMatrix()
				end
				glTexture(false)
			glPopMatrix()
		end
	end
	glDepthTest(false)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	rotations[unitID] = nil
end

function widget:Update(dt)
	local _, speedFactor, paused = GetGameSpeed()
	if not paused then
		local realdt = dt * speedFactor
		for unitID, rotation in pairs(rotations) do
			local vx, vy, vz = GetUnitVelocity(unitID)
			if vx then
				local dr = realdt * (vx*vx + vy*vy + vz*vz)
				rotations[unitID] = rotation + dr
			end
		end
	end
end
