local versionNumber = "v0.5"

function widget:GetInfo()
  return {
    name      = "1944 Ranks",
    desc      = versionNumber .. " Displays rank icons for units.",
    author    = "Evil4Zerggin",
    date      = "GNU LGPL, v2.1 or later",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

----------------------------------------------------------------
--pre-config
----------------------------------------------------------------
local sin, cos, tan = math.sin, math.cos, math.tan
local sqrt = math.sqrt
local rad = math.rad

--format: [i] = {minXP, listNum}
local usRanks = {}
local gbRanks = {}
local grRanks = {}
local ruRanks = {}

----------------------------------------------------------------
--config
----------------------------------------------------------------
local iconSize = 0.4
local maxScale = 7
local lineWidth = 0.25
local defaultRanks = usRanks

----------------------------------------------------------------
--local vars
----------------------------------------------------------------

local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Ranks/"

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local GetVisibleUnits = Spring.GetVisibleUnits
local GetUnitExperience = Spring.GetUnitExperience
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitRadius = Spring.GetUnitRadius
local GetUnitHeight = Spring.GetUnitHeight

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate

local glBillboard = gl.Billboard

local glColor = gl.Color
local glShape = gl.Shape
local glRect = gl.Rect

local glTexture = gl.Texture
local glTexRect = gl.TexRect

local glLineWidth = gl.LineWidth

local glBlendFunc = gl.BlendFunc
local glDepthTest = gl.DepthTest

local strSub = string.sub

local GL_QUADS = GL.QUADS
local GL_QUAD_STRIP = GL.QUAD_STRIP
local GL_LINES = GL.LINES
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local GL_TRIANGLES = GL.TRIANGLES

local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA

----------------------------------------------------------------
--util
----------------------------------------------------------------
local function OutlineQuadStripVertices(vertices)
	local result = {}
	local ri = 1
	local vi = 1
	while vertices[vi] do
		result[ri] = {v = vertices[vi].v}
		ri = ri + 1
		vi = vi + 2
	end
	
	vi = vi - 1
	
	while vertices[vi] do
		result[ri] = {v = vertices[vi].v}
		ri = ri + 1
		vi = vi - 2
	end
	
	return result
end

local function OutlineTriangleLoopVertices(vertices)
	local result = {}
	local ri = 1
	local vi = 3
	while vertices[vi] do
		result[ri] = {v = vertices[vi].v}
		ri = ri + 1
		vi = vi + 1
	end
	
	return result
end

----------------------------------------------------------------
--basic shapes
----------------------------------------------------------------
local function DrawCircle(color, highlightColor, divs)
	local triangleVertices = {
		{v = {0, 0, 0}, c = highlightColor},
		{v = {1, 0, 0}, c = color},
	}
	
	local angleIncrement = rad(360 / divs)
	local angle = 0
	
	for i=1,divs do
		angle = angle + angleIncrement
		triangleVertices[i+2] = {
			v = {cos(angle), sin(angle), 0},
			c = color
		}
	end
	
	local lineVertices = OutlineTriangleLoopVertices(triangleVertices)
	
	glShape(GL_TRIANGLE_FAN, triangleVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawTopChevron(color, highlightColor)
	local quadVertices = {
		{v = {-1, 0, 0}, c = color,},
		{v = {-1, 0.25, 0}, c = color,},
		{v = {0, 0.75, 0}, c = highlightColor,},
		{v = {0, 1, 0}, c = highlightColor,},
		{v = {1, 0, 0}, c = color,},
		{v = {1, 0.25, 0}, c = highlightColor,},
	}
	
	local lineVertices = OutlineQuadStripVertices(quadVertices)
	
	glShape(GL_QUAD_STRIP, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawBottomChevron()
	local quadVertices = {
		{v = {-1, -0.25, 0}, c = {1, 1, 0.25},},
		{v = {-1, 0, 0}, c = {1, 1, 0.25},},
		{v = {-0.75, -0.5, 0}, c = {1, 1, 0.325},},
		{v = {-0.75, -0.25, 0}, c = {1, 1, 0.325},},
		{v = {0, -0.75, 0}, c = {1, 1, 0.5},},
		{v = {0, -0.5, 0}, c = {1, 1, 0.5},},
		{v = {0.75, -0.5, 0}, c = {1, 1, 0.325},},
		{v = {0.75, -0.25, 0}, c = {1, 1, 0.325},},
		{v = {1, -0.25, 0}, c = {1, 1, 0.25},},
		{v = {1, 0, 0}, c = {1, 1, 0.25},},
	}
	
	local lineVertices = OutlineQuadStripVertices(quadVertices)
	
	glShape(GL_QUAD_STRIP, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawLozenge()
	local quadVertices = {
		{v = {0.25, 0, 0}, c = {1, 1, 0.25},},
		{v = {0.5, 0, 0}, c = {1, 1, 0.25},},
		{v = {0, 0.25, 0}, c = {1, 1, 0.5},},
		{v = {0, 0.5, 0}, c = {1, 1, 0.5},},
		{v = {-0.25, 0, 0}, c = {1, 1, 0.25},},
		{v = {-0.5, 0, 0}, c = {1, 1, 0.25},},
		{v = {0, -0.25, 0}, c = {1, 1, 0.5},},
		{v = {0, -0.5, 0}, c = {1, 1, 0.5},},
		{v = {0.25, 0, 0}, c = {1, 1, 0.25},},
		{v = {0.5, 0, 0}, c = {1, 1, 0.25},},
	}
	
	local lineVerticesInner = {
		{v = {0.25, 0, 0}},
		{v = {0, 0.25, 0}},
		{v = {-0.25, 0, 0}},
		{v = {0, -0.25, 0}},
	}
	
	local lineVerticesOuter = {
		{v = {0.5, 0, 0}},
		{v = {0, 0.5, 0}},
		{v = {-0.5, 0, 0}},
		{v = {0, -0.5, 0}},
	}
	
	glShape(GL_QUAD_STRIP, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVerticesInner)
	glShape(GL_LINE_LOOP, lineVerticesOuter)
end

local function DrawVerticalBar(color, highlightColor)
	local third = 1/3
	local quadVertices = {
		{v = {-third, -1, 0}, c = color,},
		{v = {third, -1, 0}, c = color,},
		{v = {third, 1, 0}, c = color,},
		{v = {-third, 1, 0}, c = highlightColor,},
	}
	
	local lineVertices = {
		{v = {-third, -1, 0}},
		{v = {third, -1, 0}},
		{v = {third, 1, 0}},
		{v = {-third, 1, 0}},
	}
	
	glShape(GL_QUADS, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawHorizontalLine(color, highlightColor)
	local quadVertices = {
		{v = {-1, -0.125, 0}, c = color,},
		{v = {1, -0.125, 0}, c = color,},
		{v = {1, 0.125, 0}, c = color,},
		{v = {-1, 0.125, 0}, c = highlightColor,},
	}
	
	local lineVertices = {
		{v = {-1, -0.125, 0}},
		{v = {1, -0.125, 0}},
		{v = {1, 0.125, 0}},
		{v = {-1, 0.125, 0}},
	}
	
	glShape(GL_QUADS, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawVerticalLine(color, highlightColor)
	local quadVertices = {
		{v = {-0.125, -1, 0}, c = color,},
		{v = {0.125, -1, 0}, c = color,},
		{v = {0.125, 1, 0}, c = color,},
		{v = {-0.125, 1, 0}, c = highlightColor,},
	}
	
	local lineVertices = {
		{v = {-0.125, -1, 0}},
		{v = {0.125, -1, 0}},
		{v = {0.125, 1, 0}},
		{v = {-0.125, 1, 0}},
	}
	
	glShape(GL_QUADS, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawStar(color, highlightColor)
	local shortLength = sin(rad(18)) / sin(rad(126))
	local triangleVertices = {
		{v = {0, 0, 0}, c = highlightColor},
		{v = {0, 1, 0}, c = highlightColor},
		{v = {shortLength * -sin(rad(36)), shortLength * cos(rad(36)), 0}, c = color},
		{v = {-sin(rad(72)), cos(rad(72)), 0}, c = highlightColor},
		{v = {shortLength * -sin(rad(108)), shortLength * cos(rad(108)), 0}, c = color},
		{v = {-sin(rad(144)), cos(rad(144)), 0}, c = highlightColor},
		{v = {0, - shortLength, 0}, c = color},
		{v = {sin(rad(144)), cos(rad(144)), 0}, c = highlightColor},
		{v = {shortLength * sin(rad(108)), shortLength * cos(rad(108)), 0}, c = color},
		{v = {sin(rad(72)), cos(rad(72)), 0}, c = highlightColor},
		{v = {shortLength * sin(rad(36)), shortLength * cos(rad(36)), 0}, c = color},
		{v = {0, 1, 0}, c = highlightColor},
	}
	
	local lineVertices = OutlineTriangleLoopVertices(triangleVertices)
	
	glShape(GL_TRIANGLE_FAN, triangleVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawOrderOfBath(color, highlightColor)
	local function DrawPoints(sideLength, centerLength)
		local quadVertices = {
			{v = {-sideLength, -1/12, 0}, c = color},
			{v = {sideLength, -1/12, 0}, c = color},
			{v = {-centerLength, 0, 0}, c = highlightColor},
			{v = {centerLength, 0, 0}, c = highlightColor},
			{v = {-sideLength, 1/12, 0}, c = color},
			{v = {sideLength, 1/12, 0}, c = color},
		}
		
		local lineVertices = OutlineQuadStripVertices(quadVertices)
		
		glShape(GL_QUAD_STRIP, quadVertices)
		glColor(0, 0, 0, 1)
		glShape(GL_LINE_LOOP, lineVertices)
	end
	
	local function DrawLongPoints()
		glPushMatrix()
			glTranslate(0, -1/6, 0)
			DrawPoints(9/12, 10/12)
			glTranslate(0, 1/6, 0)
			DrawPoints(10/12, 11/12)
			glTranslate(0, 1/6, 0)
			DrawPoints(9/12, 10/12)
		glPopMatrix()
	end
	
	local function DrawShortPoints()
		glPushMatrix()
			glTranslate(0, -1/12, 0)
			DrawPoints(8/12, 9/12)
			glTranslate(0, 1/6, 0)
			DrawPoints(8/12, 9/12)
		glPopMatrix()
	end
	
	local crossVertices = {
		{v = {0, 0, 0}, c = color},
		{v = {0.5, -0.25, 0}, c = highlightColor},
		{v = {0.5, 0.25, 0}, c = highlightColor},
	}
	
	local crossLineVertices = {
		{v = {0, 0, 0}},
		{v = {0.5, -0.25, 0}},
		{v = {0.5, 0.25, 0}},
	}
	
	DrawLongPoints()
	
	glPushMatrix()
		glRotate(90, 0, 0, 1)
		DrawLongPoints()
	glPopMatrix()
	
	glPushMatrix()
		glRotate(45, 0, 0, 1)
		DrawShortPoints()
	glPopMatrix()
	
	glPushMatrix()
		glRotate(-45, 0, 0, 1)
		DrawShortPoints()
	glPopMatrix()
	
	glPushMatrix()
		for i=1,4 do
			glShape(GL_TRIANGLES, crossVertices)
			glColor(0, 0, 0, 1)
			glShape(GL_LINE_LOOP, crossLineVertices)
			glRotate(90, 0, 0, 1)
		end
	glPopMatrix()
	
	glPushMatrix()
		glScale(0.375, 0.375, 0.375)
		DrawCircle(highlightColor, color, 16)
	glPopMatrix()
	
	glPushMatrix()
		glScale(0.25, 0.25, 0.25)
		DrawCircle(color, highlightColor, 16)
	glPopMatrix()
end

local function DrawGEPip(color, highlightColor)
	local triangleVertices = {
		{v = {0, 0, 0}, c = highlightColor},
		{v = {1, 0, 0}, c = highlightColor},
	}
	
	local angle = rad(-45)
	local increment = rad(7.5)
	
	for i=1,6 do
		angle = angle + increment
		triangleVertices[i*2+1] = {
			v = {0.5 * (1 - tan(angle)) - 0.03125, 0.5 * (1 + tan(angle)) - 0.03125, 0},
			c = color,
		}
		
		angle = angle + increment
		triangleVertices[i*2+2] = {
			v = {0.5 * (1 - tan(angle)), 0.5 * (1 + tan(angle)), 0},
			c = highlightColor,
		}
	end
	
	local lineVertices = OutlineTriangleLoopVertices(triangleVertices)
	
	glPushMatrix()
		for i=1,4 do
			glShape(GL_TRIANGLE_FAN, triangleVertices)
			glColor(0, 0, 0, 1)
			glShape(GL_LINE_STRIP, lineVertices)
			glRotate(90, 0, 0, 1)
		end
	glPopMatrix()
	
	glPushMatrix()
		glScale(0.375, 0.375, 0.375)
		DrawCircle(highlightColor, color, 16)
	glPopMatrix()
	
	glPushMatrix()
		glScale(0.25, 0.25, 0.25)
		DrawCircle(highlightColor, color, 16)
	glPopMatrix()
	
	glPushMatrix()
		glScale(0.125, 0.125, 0.125)
		DrawCircle(highlightColor, color, 16)
	glPopMatrix()
end

local function DrawShoulder(color, highlightColor)
	local quadVertices = {
		{v = {0.25, -1, 0}, c = highlightColor},
		{v = {0.375, -1, 0}, c = color},
		{v = {0.25, 0.75, 0}, c = highlightColor},
		{v = {0.375, 0.75, 0}, c = color},
		{v = {0.125, 0.875, 0}, c = highlightColor},
		{v = {0.125, 1, 0}, c = color},
		{v = {-0.125, 0.875, 0}, c = highlightColor},
		{v = {-0.125, 1, 0}, c = color},
		{v = {-0.25, 0.75, 0}, c = highlightColor},
		{v = {-0.375, 0.75, 0}, c = color},
		{v = {-0.25, -1, 0}, c = highlightColor},
		{v = {-0.375, -1, 0}, c = color},
	}
	
	local lineVertices = OutlineQuadStripVertices(quadVertices)
	
	glShape(GL_QUAD_STRIP, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
	
	glPushMatrix()
		glTranslate(0, 0.625, 0)
		glScale(0.25, 0.25, 0.25)
		DrawCircle(color, highlightColor, 16)
	glPopMatrix()
end

local function DrawShoulderBottom(color, highlightColor)
	local quadVertices = {
		{v = {0.375, -1, 0}, c = color},
		{v = {0.25, -0.875, 0}, c = highlightColor},
		{v = {-0.25, -0.875, 0}, c = highlightColor},
		{v = {-0.375, -1, 0}, c = color},
	}
	
	local lineVertices = {
		{v = {0.375, -1, 0}},
		{v = {0.25, -0.875, 0}},
		{v = {-0.25, -0.875, 0}},
		{v = {-0.375, -1, 0}},
	}
	
	glShape(GL_QUADS, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, lineVertices)
end

local function DrawShoulderFull(color, highlightColor)
	local quadVertices = {
		{v = {-0.375, -1, 0}, c = highlightColor},
		{v = {0.375, -1, 0}, c = color},
		{v = {-0.375, 0.75, 0}, c = highlightColor},
		{v = {0.375, 0.75, 0}, c = color},
		{v = {-0.125, 1, 0}, c = highlightColor},
		{v = {0.125, 1, 0}, c = color},
	}
	
	local quadLineVertices = OutlineQuadStripVertices(quadVertices)
	
	glShape(GL_QUAD_STRIP, quadVertices)
	glColor(0, 0, 0, 1)
	glShape(GL_LINE_LOOP, quadLineVertices)
	
	glPushMatrix()
		glTranslate(0, 0.625, 0)
		glScale(0.25, 0.25, 0.25)
		DrawCircle(color, highlightColor, 16)
	glPopMatrix()
end

local function DrawEpaulette(color, highlightColor, color2, highlightColor2, divs)
	local divAngle = rad(90) / divs
	local function DrawStraight()
		local function DrawSingleStraight(color, highlightColor)
			local quadVertices = {
				{v = {-1, 0, 0}, c = color},
				{v = {1, 0, 0}, c = color},
				{v = {-1, 1/3, 0}, c = highlightColor},
				{v = {1, 1/3, 0}, c = highlightColor},
				{v = {-1, 2/3, 0}, c = color},
				{v = {1, 2/3, 0}, c = color},
			}
			
			glShape(GL_QUAD_STRIP, quadVertices)
		end
		
		glPushMatrix()
			glTranslate(0, -1, 0)
			DrawSingleStraight(color, highlightColor)
			glTranslate(0, 2/3, 0)
			DrawSingleStraight(color2, highlightColor2)
			glTranslate(0, 2/3, 0)
			DrawSingleStraight(color, highlightColor)
		glPopMatrix()
	end
	
	local function DrawCurved()
		local function DrawSingleCurved(color, highlightColor, innerRadius, outerRadius)
			local midRadius = 0.5 * (innerRadius + outerRadius)
			if innerRadius > 0 then
				local quadVertices1 = {}
				local quadVertices2 = {}
				
				local angle = 0
				
				for i=0,divs do
					quadVertices1[2*i+1] = {
						v = {cos(angle) * innerRadius, sin(angle) * innerRadius, 0},
						c = color,
					}
					
					quadVertices1[2*i+2] = {
						v = {cos(angle) * midRadius, sin(angle) * midRadius, 0},
						c = highlightColor,
					}
					
					quadVertices2[2*i+1] = {
						v = {cos(angle) * midRadius, sin(angle) * midRadius, 0},
						c = highlightColor,
					}
					
					quadVertices2[2*i+2] = {
						v = {cos(angle) * outerRadius, sin(angle) * outerRadius, 0},
						c = color,
					}
					
					angle = angle + divAngle
				end
				
				glShape(GL_QUAD_STRIP, quadVertices1)
				glShape(GL_QUAD_STRIP, quadVertices2)
			else
				local angle = 0
				local triangleVertices = {
					{v = {0, 0, 0}, c = color},
				}

				local quadVertices = {}
				
				for i=0,divs do
					
					triangleVertices[i+2] = {
						v = {cos(angle) * midRadius, sin(angle) * midRadius, 0},
						c = highlightColor,
					}
					
					quadVertices[2*i+1] = {
						v = {cos(angle) * midRadius, sin(angle) * midRadius, 0},
						c = highlightColor,
					}
					
					quadVertices[2*i+2] = {
						v = {cos(angle) * outerRadius, sin(angle) * outerRadius, 0},
						c = color,
					}
					angle = angle + divAngle
				end
				
				glShape(GL_TRIANGLE_FAN, triangleVertices)
				glShape(GL_QUAD_STRIP, quadVertices)
			end
		end --end DrawSingleCurved
		
		local function DrawSingleCurvedLine(radius)
			local angle = 0
			
			local lineVertices = {}
			
			for i=0,divs do
				lineVertices[i+1] = {
					v = {cos(angle) * radius, sin(angle) * radius, 0},
				}
				angle = angle + divAngle
			end
			
			glColor(0, 0, 0, 1)
			glShape(GL_LINES, lineVertices)
		end
		
		glPushMatrix()
			glTranslate(-1, -1, 0)
			DrawSingleCurved(color, highlightColor, 0, 2/3)
			DrawSingleCurved(color2, highlightColor2, 2/3, 4/3)
			DrawSingleCurved(color, highlightColor, 4/3, 2)
			DrawSingleCurvedLine(2)
		glPopMatrix()
	end --end DrawCurved
	
	local scale = 0.125 * sqrt(0.5)
	glPushMatrix()
		--columns 1, 3, 5
		glTranslate(-0.25, -0.625, 0)
		glPushMatrix()
			for i = 1, 5 do
				glPushMatrix()
					glRotate(135, 0, 0, 1)
					glScale(scale, scale, 1)
					DrawCurved()
				glPopMatrix()
				glTranslate(0, 0.25, 0)
			end
		glPopMatrix()
		glTranslate(0.25, 0, 0)
		glPushMatrix()
			for i = 1, 5 do
				glPushMatrix()
					glRotate(45, 0, 0, 1)
					glScale(scale, scale, 1)
					DrawStraight()
				glPopMatrix()
				glTranslate(0, 0.25, 0)
			end
		glPopMatrix()
		glTranslate(0.25, 0, 0)
		glPushMatrix()
			for i = 1, 5 do
				glPushMatrix()
					glRotate(-45, 0, 0, 1)
					glScale(scale, scale, 1)
					DrawCurved()
				glPopMatrix()
				glTranslate(0, 0.25, 0)
			end
		glPopMatrix()
		
		--columns 4, 2
		glTranslate(-0.125, -0.125, 0)
		glPushMatrix()
			glPushMatrix()
				glRotate(-135, 0, 0, 1)
				glScale(scale, scale, 1)
				DrawCurved()
			glPopMatrix()
			for i = 1, 5 do
				glTranslate(0, 0.25, 0)
				glPushMatrix()
					glRotate(-45, 0, 0, 1)
					glScale(scale, scale, 1)
					DrawStraight()
				glPopMatrix()
			end
		glPopMatrix()
		
		glTranslate(-0.25, 0, 0)
		glPushMatrix()
			glPushMatrix()
				glRotate(-135, 0, 0, 1)
				glScale(scale, scale, 1)
				DrawCurved()
			glPopMatrix()
			for i = 1, 4 do
				glTranslate(0, 0.25, 0)
				glPushMatrix()
					glRotate(-45, 0, 0, 1)
					glScale(scale, scale, 1)
					DrawStraight()
				glPopMatrix()
			end
			glTranslate(0, 0.25, 0)
			glPushMatrix()
				glRotate(45, 0, 0, 1)
				glScale(scale, scale, 1)
				DrawStraight()
			glPopMatrix()
		glPopMatrix()
	glPopMatrix()
	
	--button
	glPushMatrix()
		glTranslate(0, 0.625, 0)
		glScale(0.25, 0.25, 0.25)
		DrawCircle(color, highlightColor, 16)
	glPopMatrix()
end

----------------------------------------------------------------
--lists
----------------------------------------------------------------

local function CreateUSLists()
	local color = {1, 1, 0.25}
	local highlightColor = {1, 1, 0.5}
	local function PrivateFirstClass()
		DrawTopChevron(color, highlightColor)
	end
	
	local function Corporal()
		PrivateFirstClass()
		glPushMatrix()
			glTranslate(0, 0.375, 0)
			PrivateFirstClass()
		glPopMatrix()
	end
	
	local function Sergeant()
		Corporal()
		glPushMatrix()
			glTranslate(0, 0.75, 0)
			PrivateFirstClass()
		glPopMatrix()
	end
	
	local function StaffSergeant()
		Sergeant()
		DrawBottomChevron()
	end
	
	local function TechnicalSergeant()
		StaffSergeant()
		glPushMatrix()
			glTranslate(0, -0.375, 0)
			DrawBottomChevron()
		glPopMatrix()
	end
	
	local function MasterSergeant()
		TechnicalSergeant()
		glPushMatrix()
			glTranslate(0, -0.75, 0)
			DrawBottomChevron()
		glPopMatrix()
	end
	
	local function FirstSergeant()
		MasterSergeant()
		DrawLozenge()
	end
	
	local function SecondLieutenant()
		glPushMatrix()
			glScale(1.25, 1.25, 1.25)
			DrawVerticalBar({1, 1, 0.25}, {1, 1, 0.75})
		glPopMatrix()
	end
	
	local function FirstLieutenant()
		glPushMatrix()
			glScale(1.25, 1.25, 1.25)
			DrawVerticalBar({0.5, 0.5, 0.5}, {1, 1, 1})
		glPopMatrix()
	end
	
	local function Captain()
		glPushMatrix()
			glTranslate(-0.75, 0, 0)
			FirstLieutenant()
			glTranslate(1.5, 0, 0)
			FirstLieutenant()
		glPopMatrix()
	end
	
	local function Major()
		glColor(1, 1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "USMajor.png")
		glTexRect(-2, -2, 2, 2)
		glTexture(false)
	end
	
	local function LieutenantColonel()
		glColor(1, 1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "USLtColonel.png")
		glTexRect(-2, -2, 2, 2)
		glTexture(false)
	end
	
	local function Colonel()
		glColor(1, 1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "USColonel.png")
		glTexRect(-2, -2, 2, 2)
		glTexture(false)
	end
	
	local function BrigadierGeneral()
		DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
	end
	
	local function MajorGeneral()
		glPushMatrix()
			glTranslate(-sin(rad(72)), 0, 0)
			BrigadierGeneral()
			glTranslate(sin(rad(72)) * 2, 0, 0)
			BrigadierGeneral()
		glPopMatrix()
	end
	
	local function LieutenantGeneral()
		glPushMatrix()
			glTranslate(0, 1, 0)
			BrigadierGeneral()
			glTranslate(0, -2, 0)
			MajorGeneral()
		glPopMatrix()
	end
	
	local function General()
		glPushMatrix()
			glTranslate(0, 1, 0)
			MajorGeneral()
			glTranslate(0, -2, 0)
			MajorGeneral()
		glPopMatrix()
	end
	
	local function GeneralOfTheArmy()
		local radius = (1 + sin(rad(18))) / sin(rad(126))
		glPushMatrix()
			for i=1,5 do
				glPushMatrix()
					glTranslate(0, radius, 0)
					DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
				glPopMatrix()
				glRotate(72, 0, 0, 1)
			end
		glPopMatrix()
	end
	
	usRanks = {
		{0.2, glCreateList(PrivateFirstClass)},
		{0.5, glCreateList(Corporal)},
		{0.75, glCreateList(Sergeant)},
		{1, glCreateList(StaffSergeant)},
		{1.5, glCreateList(TechnicalSergeant)},
		{2, glCreateList(MasterSergeant)},
		{3, glCreateList(FirstSergeant)},
		{5, glCreateList(SecondLieutenant)},
		{8, glCreateList(FirstLieutenant)},
		{12, glCreateList(Captain)},
		{20, 0, Major},
		{25, 0, LieutenantColonel},
		{30, 0, Colonel},
		{40, glCreateList(BrigadierGeneral)},
		{50, glCreateList(MajorGeneral)},
		{60, glCreateList(LieutenantGeneral)},
		{80, glCreateList(General)},
		{100, glCreateList(GeneralOfTheArmy)},
	}
end

local function CreateRULists()
	local darkRed = {0.75, 0, 0}
	local red = {1, 0, 0}
	local redHighlight = {1, 0.5, 0.5}
	local function OneLine()
		glPushMatrix()
			glScale(1, 2, 1)
			DrawVerticalLine(red, redHighlight)
		glPopMatrix()
	end
	
	local function TwoLines()
		glPushMatrix()
			glScale(1, 2, 1)
			glTranslate(-0.25, 0, 0)
			DrawVerticalLine(red, redHighlight)
			glTranslate(0.5, 0, 0)
			DrawVerticalLine(red, redHighlight)
		glPopMatrix()
	end
	
	local function SmallStar()
		glPushMatrix()
			glScale(0.5, 0.5, 0.5)
			DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
		glPopMatrix()
	end
	
	local function MediumStar()
		DrawStar(darkRed, red)
	end
	
	local function LargeStar()
		glPushMatrix()
			glScale(3, 3, 3)
			DrawStar(darkRed, red)
		glPopMatrix()
	end
	
	local function Corporal()
		DrawHorizontalLine(red, redHighlight)
	end
	
	local function JuniorSergeant()
		Corporal()
		glPushMatrix()
			glTranslate(0, -0.375, 0)
			Corporal()
		glPopMatrix()
	end
	
	local function Sergeant()
		JuniorSergeant()
		glPushMatrix()
			glTranslate(0, -0.75, 0)
			Corporal()
		glPopMatrix()
	end
	
	local function SeniorSergeant()
		Sergeant()
		glPushMatrix()
			glTranslate(0, -0.75, 0)
			Corporal()
		glPopMatrix()
	end
	
	local function SergeantMajor()
		SeniorSergeant()
		glPushMatrix()
			glTranslate(0, -2, 0)
			DrawVerticalLine(red, redHighlight)
		glPopMatrix()
	end
	
	local function JuniorLieutenant()
		OneLine()
		SmallStar()
	end
	
	local function Lieutenant()
		OneLine()
		
		glPushMatrix()
			glTranslate(-0.75, 0, 0)
			SmallStar()
			glTranslate(1.5, 0, 0)
			SmallStar()
		glPopMatrix()
	end
	
	local function SeniorLieutenant()
		OneLine()
		glPushMatrix()
			glTranslate(0, 0.5, 0)
			SmallStar()
			glTranslate(-0.75, -1, 0)
			SmallStar()
			glTranslate(1.5, 0, 0)
			SmallStar()
		glPopMatrix()
	end
	
	local function Captain()
		OneLine()
		glPushMatrix()
			glTranslate(0, 0, 0)
			SmallStar()
			glTranslate(0, 1, 0)
			SmallStar()
			glTranslate(-0.75, -2, 0)
			SmallStar()
			glTranslate(1.5, 0, 0)
			SmallStar()
		glPopMatrix()
	end
	
	local function Major()
		TwoLines()
		SmallStar()
	end
	
	local function LieutenantColonel()
		TwoLines()
		
		glPushMatrix()
			glTranslate(-0.75, 0, 0)
			SmallStar()
			glTranslate(1.5, 0, 0)
			SmallStar()
		glPopMatrix()
	end
	
	local function Colonel()
		TwoLines()
		
		glPushMatrix()
			glTranslate(0, 0.5, 0)
			SmallStar()
			glTranslate(-0.75, -1, 0)
			SmallStar()
			glTranslate(1.5, 0, 0)
			SmallStar()
		glPopMatrix()
	end
	
	local function MajorGeneral()
		MediumStar()
	end
	
	local function LieutenantGeneral()
		glPushMatrix()
			glTranslate(0, -1, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
		glPopMatrix()
	end
	
	local function ColonelGeneral()
		glPushMatrix()
			glTranslate(0, -2, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
		glPopMatrix()
	end
	
	local function GeneralOfTheArmy()
		glPushMatrix()
			glTranslate(0, -3, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
			glTranslate(0, 2, 0)
			MediumStar()
		glPopMatrix()
	end
	
	local function Marshal()
		LargeStar()
	end
	
	local function ChiefMarshal()
		glColor(1, 1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "RUWreath.png")
		glTexRect(-3, -3, 3, 3)
		glTexture(false)
		LargeStar()
	end
	
	local function MarshalOfTheSovietUnion()
		glColor(1, 1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "RUMarshal.png")
		glTexRect(-3, -3, 3, 3)
		glTexture(false)
	end
	
	ruRanks = {
		{0.2, glCreateList(Corporal)},
		{0.5, glCreateList(JuniorSergeant)},
		{0.75, glCreateList(Sergeant)},
		{1, glCreateList(SeniorSergeant)},
		{1.5, glCreateList(SergeantMajor)},
		{2, glCreateList(JuniorLieutenant)},
		{3, glCreateList(Lieutenant)},
		{5, glCreateList(SeniorLieutenant)},
		{8, glCreateList(Captain)},
		{12, glCreateList(Major)},
		{20, glCreateList(LieutenantColonel)},
		{25, glCreateList(Colonel)},
		{30, glCreateList(MajorGeneral)},
		{35, glCreateList(LieutenantGeneral)},
		{40, glCreateList(ColonelGeneral)},
		{50, glCreateList(GeneralOfTheArmy)},
		{60, glCreateList(Marshal)},
		{80, 0, ChiefMarshal},
		{100, 0, MarshalOfTheSovietUnion},
	}
end

local function CreateGBLists()
	local color = {0.25, 0.5, 0}
	local highlightColor = {0.375, 0.75, 0}
	local gold = {0.75, 0.75, 0}
	local highlightGold = {1, 1, 0}
	
	local function DrawGoldOrder()
		glPushMatrix()
			glScale(0.75, 0.75, 0.75)
			DrawOrderOfBath(gold, highlightGold)
		glPopMatrix()
	end
	
	local function LanceCorporal()
		glPushMatrix()
			glRotate(180, 0, 0, 1)
			DrawTopChevron(color, highlightColor)
		glPopMatrix()
	end
	
	local function Corporal()
		LanceCorporal()
		glPushMatrix()
			glTranslate(0, 0.375, 0)
			LanceCorporal()
		glPopMatrix()
	end
	
	local function Sergeant()
		Corporal()
		glPushMatrix()
			glTranslate(0, 0.75, 0)
			LanceCorporal()
		glPopMatrix()
	end
	
	local function StaffSergeant()
		Sergeant()
		glPushMatrix()
			glTranslate(0, 0.75, 0)
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBCrown.png")
			glTexRect(-0.5, -0.5, 0.5, 0.5)
			glTexture(false)
		glPopMatrix()
	end
	
	local function SecondLieutenant()
		glPushMatrix()
			glScale(0.75, 0.75, 0.75)
			DrawOrderOfBath(color, highlightColor)
		glPopMatrix()
	end
	
	local function Lieutenant()
		SecondLieutenant()
		glPushMatrix()
			glTranslate(0, 1.5, 0)
			SecondLieutenant()
		glPopMatrix()
	end
	
	local function Captain()
		Lieutenant()
		glPushMatrix()
			glTranslate(0, 3, 0)
			SecondLieutenant()
		glPopMatrix()
	end
	
	local function Major()
		glColor(1, 1, 1)
		glTexture(IMAGE_DIRNAME .. "GBCrown.png")
		glTexRect(-1, -1, 1, 1)
		glTexture(false)
	end
	
	local function LieutenantColonel()
		DrawGoldOrder()
		
		glPushMatrix()
			glTranslate(0, 1.5, 0)
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBCrown.png")
			glTexRect(-0.75, -0.75, 0.75, 0.75)
			glTexture(false)
		glPopMatrix()
	end
	
	local function Colonel()
		DrawGoldOrder()
		
		glPushMatrix()
			glTranslate(0, 1.5, 0)
			LieutenantColonel()
		glPopMatrix()
	end
	
	local function Brigadier()
		glPushMatrix()
			glTranslate(0, 1, 0)
			LieutenantColonel()
			glTranslate(-1, -1, 0)
			DrawGoldOrder()
			glTranslate(2, 0, 0)
			DrawGoldOrder()
		glPopMatrix()
	end
	
	local function MajorGeneral()
		glPushMatrix()
			glTranslate(0, 0.75, 0)
			DrawGoldOrder()
			glTranslate(0, -1.5, 0)
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
			glTexRect(-1, -1, 1, 1)
			glTexture(false)
		glPopMatrix()
	end
	
	local function LieutenantGeneral()
		glPushMatrix()
			glColor(1, 1, 1)
			glTranslate(0, 0.75, 0)
			glTexture(IMAGE_DIRNAME .. "GBCrown.png")
			glTexRect(-1, -1, 1, 1)
			glTexture(false)
			glTranslate(0, -1.5, 0)
			glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
			glTexRect(-1, -1, 1, 1)
			glTexture(false)
		glPopMatrix()
	end
	
	local function General()
		glPushMatrix()
			glTranslate(0, 2, 0)
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBCrown.png")
			glTexRect(-1, -1, 1, 1)
			glTexture(false)
			glTranslate(0, -2, 0)
			DrawGoldOrder()
			glTranslate(0, -1.5, 0)
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
			glTexRect(-1, -1, 1, 1)
			glTexture(false)
		glPopMatrix()
	end
	
	local function FieldMarshal()
		glPushMatrix()
			glColor(1, 1, 1)
			glTexture(IMAGE_DIRNAME .. "GBBatLau.png")
			glTexRect(-2, -2, 2, 2)
			glTexture(false)
			glTranslate(0, 4, 0)
			glTexture(IMAGE_DIRNAME .. "GBCrown.png")
			glTexRect(-2, -2, 2, 2)
			glTexture(false)
		glPopMatrix()
	end
	
	gbRanks = {
		{0.2, glCreateList(LanceCorporal)},
		{0.5, glCreateList(Corporal)},
		{0.75, glCreateList(Sergeant)},
		{1, 0, StaffSergeant},
		{1.5, glCreateList(SecondLieutenant)},
		{2, glCreateList(Lieutenant)},
		{3, glCreateList(Captain)},
		{5, 0, Major},
		{8, 0, LieutenantColonel},
		{12, 0, Colonel},
		{20, 0, Brigadier},
		{25, 0, MajorGeneral},
		{30, 0, LieutenantGeneral},
		{50, 0, General},
		{100, 0, FieldMarshal},
	}
end

local function CreateGELists()
	local darkColor = {0.5, 0.5, 0.5}
	local color = {0.75, 0.75, 0.75}
	local highlightColor = {1, 1, 1}
	local gold = {0.75, 0.75, 0}
	local highlightGold = {1, 1, 0}
	
	local function SmallPip(color, highlightColor)
		glPushMatrix()
			glScale(0.25, 0.25, 0.25)
			DrawGEPip(color, highlightColor)
		glPopMatrix()
	end
	
	local function MediumPip(color, highlightColor)
		glPushMatrix()
			glScale(0.375, 0.375, 0.375)
			DrawGEPip(color, highlightColor)
		glPopMatrix()
	end
	
	local function LargePip(color, highlightColor)
		glPushMatrix()
			glScale(0.5, 0.5, 0.5)
			DrawGEPip(color, highlightColor)
		glPopMatrix()
	end
	
	local function Obershutze()
		LargePip(darkColor, highlightColor)
	end
	
	local function Gefreiter()
		
		local quadVertices = {
			{v = {-1, 1, 0}, c = color},
			{v = {-0.75, 1, 0}, c = color},
			{v = {0, -1, 0}, c = highlightColor},
			{v = {0, -0.5, 0}, c = highlightColor},
			{v = {1, 1, 0}, c = color},
			{v = {0.75, 1, 0}, c = color},
		}
		
		local lineVertices = {
			{v = {-1, 1, 0}},
			{v = {0, -1, 0}},
			{v = {1, 1, 0}},
			{v = {0.75, 1, 0}},
			{v = {0, -0.5, 0}},
			{v = {-0.75, 1, 0}},
		}
		
		glShape(GL_QUAD_STRIP, quadVertices)
		glColor(0, 0, 0, 1)
		glShape(GL_LINE_LOOP, lineVertices)
	end
	
	local function Obergefreiter()
		Gefreiter()
		
		local quadVertices = {
			{v = {-0.625, 1, 0}, c = color},
			{v = {-0.375, 1, 0}, c = color},
			{v = {0, -0.25, 0}, c = highlightColor},
			{v = {0, 0.25, 0}, c = highlightColor},
			{v = {0.625, 1, 0}, c = color},
			{v = {0.375, 1, 0}, c = color},
		}
		
		local lineVertices = {
			{v = {-0.625, 1, 0}},
			{v = {0, -0.25, 0}},
			{v = {0.625, 1, 0}},
			{v = {0.375, 1, 0}},
			{v = {0, 0.25, 0}},
			{v = {-0.375, 1, 0}},
		}
		
		glShape(GL_QUAD_STRIP, quadVertices)
		glColor(0, 0, 0, 1)
		glShape(GL_LINE_LOOP, lineVertices)
	end
	
	local function Stabsgefreiter()
		Obergefreiter()
		glPushMatrix()
			glTranslate(0, 1, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function Unteroffizer()
		glPushMatrix()
			glScale(2, 2, 2)
			DrawShoulder(color, highlightColor)
		glPopMatrix()
	end
	
	local function Unterfeldwebel()
		glPushMatrix()
			glScale(2, 2, 2)
			DrawShoulder(color, highlightColor)
			DrawShoulderBottom(color, highlightColor)
		glPopMatrix()
	end
	
	local function Feldwebel()
		Unterfeldwebel()
		glPushMatrix()
			glTranslate(0, -0.5, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function Oberfeldwebel()
		Unterfeldwebel()
		glPushMatrix()
			SmallPip(darkColor, highlightColor)
			glTranslate(0, -1, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function Stabsfeldwebel()
		Unterfeldwebel()
		glPushMatrix()
			SmallPip(darkColor, highlightColor)
			glTranslate(-0.375, -1, 0)
			SmallPip(darkColor, highlightColor)
			glTranslate(0.75, 0, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function Leutnant()
		glPushMatrix()
			glScale(2, 2, 2)
			DrawShoulderFull(color, highlightColor)
		glPopMatrix()
	end
	
	local function Oberleutnant()
		Leutnant()
		glPushMatrix()
			glTranslate(0, -0.5, 0)
			MediumPip(gold, highlightGold)
		glPopMatrix()
	end
	
	local function Hauptman()
		Leutnant()
		glPushMatrix()
			MediumPip(gold, highlightGold)
			glTranslate(0, -1, 0)
			MediumPip(gold, highlightGold)
		glPopMatrix()
	end
	
	local function Major()
		glPushMatrix()
			glScale(2, 2, 2)
			DrawEpaulette(color, highlightColor, color, highlightColor, 8)
		glPopMatrix()
	end
	
	local function Oberstleutnant()
		Major()
		glPushMatrix()
			glTranslate(0, -0.25, 0)
			SmallPip(gold, highlightGold)
		glPopMatrix()
	end
	
	local function Oberst()
		Major()
		glPushMatrix()
			glTranslate(0, -0.75, 0)
			SmallPip(gold, highlightGold)
			glTranslate(0, 1, 0)
			SmallPip(gold, highlightGold)
		glPopMatrix()
	end
	
	local function Generalmajor()
		glPushMatrix()
			glScale(2, 2, 2)
			DrawEpaulette(gold, highlightGold, color, highlightColor, 8)
		glPopMatrix()
	end
	
	local function Generalleutnant()
		Generalmajor()
		glPushMatrix()
			glTranslate(0, -0.25, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function General()
		Generalmajor()
		glPushMatrix()
			glTranslate(0, -0.75, 0)
			SmallPip(darkColor, highlightColor)
			glTranslate(0, 1, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	local function Generaloberst()
		Generalmajor()
		glPushMatrix()
			glTranslate(0, 0.25, 0)
			SmallPip(darkColor, highlightColor)
			glTranslate(-0.25, -1, 0)
			SmallPip(darkColor, highlightColor)
			glTranslate(0.5, 0, 0)
			SmallPip(darkColor, highlightColor)
		glPopMatrix()
	end
	
	geRanks = {
		{0.2, glCreateList(Obershutze)},
		{0.5, glCreateList(Gefreiter)},
		{0.75, glCreateList(Obergefreiter)},
		{1, glCreateList(Stabsgefreiter)},
		{1.5, glCreateList(Unteroffizer)},
		{2, glCreateList(Unterfeldwebel)},
		{3, glCreateList(Feldwebel)},
		{5, glCreateList(Oberfeldwebel)},
		{8, glCreateList(Stabsfeldwebel)},
		{12, glCreateList(Leutnant)},
		{20, glCreateList(Oberleutnant)},
		{25, glCreateList(Hauptman)},
		{30, glCreateList(Major)},
		{35, glCreateList(Oberstleutnant)},
		{40, glCreateList(Oberst)},
		{45, glCreateList(Generalmajor)},
		{50, glCreateList(Generalleutnant)},
		{60, glCreateList(General)},
		{80, glCreateList(Generaloberst)},
		--{100, glCreateList(Generalfeldmarschall)},
	}
end

local function CreateLists()
	CreateUSLists()
	CreateRULists()
	CreateGBLists()
	CreateGELists()
end

local function DeleteLists()
	for i=1, #usRanks do
		glDeleteList(usRanks[i][2])
	end
	for i=1, #ruRanks do
		glDeleteList(ruRanks[i][2])
	end
	for i=1, #gbRanks do
		glDeleteList(gbRanks[i][2])
	end
	for i=1, #geRanks do
		glDeleteList(geRanks[i][2])
	end
end

----------------------------------------------------------------
--helpers
----------------------------------------------------------------

local function GetRank(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local unitDef = UnitDefs[unitDefID]
	
	if not unitDef then return end
	
	local power = unitDef.power
	local xp = GetUnitExperience(unitID)
	
	if not xp then return end
	
	local name = unitDef.name
	local prefix = strSub(name, 1, 2)
	
	return xp * sqrt(power * 0.01), prefix
end

local function GetRankList(rank, prefix)
	local list, nonList = nil, nil
	local rankTable = defaultRanks
	
	if prefix == "ru" then
		rankTable = ruRanks
	elseif prefix == "gb" then
		rankTable = gbRanks
	elseif prefix == "ge" then
		rankTable = geRanks
	elseif prefix == "us" then
		rankTable = usRanks
	else
		-- generic option = US to have at least something
		rankTable = usRanks
	end
	
	for i = 1,#rankTable do
		local info = rankTable[i]
		if rank < info[1] then
			return list, nonList
		else
			list, nonList = info[2], info[3]
		end
	end
	
	return list, nonList
end

local function DrawRankIcon(unitID)
	local rank, prefix = GetRank(unitID)
	
	if not rank then return end
	
	local list, nonList = GetRankList(rank, prefix)
	
	if not list then return end
	
	local x, y, z = GetUnitPosition(unitID)
	local radius = GetUnitRadius(unitID)
	
	local scale = radius * iconSize
	if scale > maxScale then
		scale = maxScale
	end
	
	local minHeight = scale + 0.5 * radius + 8
	
	local height = GetUnitHeight(unitID)
	if height < minHeight then
		height = minHeight
	end
	
	glPushMatrix()
		glTranslate(x, y + height, z)
		glBillboard()
		glScale(scale, scale, scale)
		glCallList(list)
		if nonList then
			nonList()
		end
	glPopMatrix()
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function widget:Initialize()
	CreateLists()
end

function widget:Shutdown()
	DeleteLists()
end

function widget:DrawWorld()
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	glLineWidth(lineWidth)
	local visibleUnits = GetVisibleUnits(-1, 0, false)
	if not visibleUnits then return end
	local ValidUnitID = Spring.ValidUnitID
	for i=1,#visibleUnits do
		local unitID = visibleUnits[i]
		if ValidUnitID(unitID) then
			DrawRankIcon(unitID)
		end
	end
	glLineWidth(1)
end
