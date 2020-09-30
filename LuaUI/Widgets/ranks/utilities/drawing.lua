----------------------------------------------------------------
-- Speedups
----------------------------------------------------------------
local sin, cos, tan = math.sin, math.cos, math.tan
local sqrt = math.sqrt
local rad = math.rad
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate
local glColor = gl.Color
local glShape = gl.Shape

local GL_QUADS = GL.QUADS
local GL_QUAD_STRIP = GL.QUAD_STRIP
local GL_LINES = GL.LINES
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local GL_TRIANGLES = GL.TRIANGLES

----------------------------------------------------------------
-- utilities
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
-- Drawing functions
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

return {
    DrawCircle = DrawCircle,
    DrawTopChevron = DrawTopChevron,
    DrawBottomChevron = DrawBottomChevron,
    DrawLozenge = DrawLozenge,
    DrawVerticalBar = DrawVerticalBar,
    DrawHorizontalLine = DrawHorizontalLine,
    DrawVerticalLine = DrawVerticalLine,
    DrawStar = DrawStar,
    DrawOrderOfBath = DrawOrderOfBath,
    DrawGEPip = DrawGEPip,
    DrawShoulder = DrawShoulder,
    DrawShoulderBottom = DrawShoulderBottom,
    DrawShoulderFull = DrawShoulderFull,
    DrawEpaulette = DrawEpaulette,
}
