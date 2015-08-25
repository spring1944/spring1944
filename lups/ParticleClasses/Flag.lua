-- $Id: gimmick1.lua 3171 2008-11-06 09:06:29Z det $
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local Flag = {}
Flag.__index = Flag

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Flag.GetInfo()
  return {
    name      = "Flag",
    backup    = "", --// backup class, if this class doesn't work (old cards,ati's,etc.)
    desc      = "",

    layer     = -24, --// extreme simply z-ordering :x

    --// gfx requirement
    fbo       = false,
    shader    = false,
    rtt       = false,
    ctt       = false,
  }
end

Flag.Default = {
  pos        = {0,0,0}, -- start pos
  emitVector = {0.25,1,0},
  layer      = -24,

  life       = math.huge,

  height     = 10,
  width      = 4,
  ballSize   = 0.9,

  color      = {1, 0, 0, 1},

  repeatEffect = true,
}

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Flag:BeginDraw()
  gl.DepthMask(true)
  gl.Lighting(true)
  gl.Light(0, true )
  gl.Light(0, GL.POSITION, gl.GetSun() )
  gl.Light(0, GL.AMBIENT, gl.GetSun("ambient","unit") )
  gl.Light(0, GL.DIFFUSE, gl.GetSun("diffuse","unit") )
  gl.Light(0, GL.SPECULAR, gl.GetSun("specular") )
  --gl.Culling(GL.BACK)
end

function Flag:EndDraw()
  gl.DepthMask(false)
  gl.Lighting(false)
  gl.Light(0, false )
  --gl.Culling(false)
end

function Flag:Draw()
  --gl.Color(self.color)
  local color = self.color
  gl.Material({
    ambient   = {color[1]*0.5,color[2]*0.5,color[3]*0.5,color[4]},
    diffuse   = color,
    specular  = {1,1,1,1},
    shininess = 65,
  })

  gl.PushMatrix()
  local pos  = self.pos
  local emit = self.emitVector
  gl.Translate(pos[1],pos[2],pos[3])
  gl.Rotate(90,emit[1],emit[2],emit[3])

  gl.PushMatrix()
  gl.Scale(self.width,self.height,self.width)
  gl.CallList(self.CylinderList)
  gl.PopMatrix()

  gl.Color(1,1,1,1)
  gl.Material({
    ambient   = {0.5,0.5,0.5,1},
    diffuse   = {1,1,1,1},
    specular  = {1,1,1,1},
    shininess = 120,
  })

  gl.PushMatrix()
  gl.Translate(0,self.height,0)
  gl.Scale(self.ballSize,self.ballSize,self.ballSize)
  gl.CallList(self.BallList)
  gl.PopMatrix()
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Flag:Initialize()
  Flag.BallList  = gl.CreateList(DrawSphere,0,0,0,1,14)
  Flag.CylinderList  = gl.CreateList(DrawCylinder,0,0,0,1,40,1)
end

function Flag:Finalize()
  gl.DeleteList(Flag.BallList)
  gl.DeleteList(Flag.CylinderList)
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Flag:CreateParticle()
  self.firstGameFrame = Spring.GetGameFrame()
  self.dieGameFrame   = self.firstGameFrame + self.life
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Flag:Update()
end

-- used if repeatEffect=true;
function Flag:ReInitialize()
  self.dieGameFrame = self.dieGameFrame + self.life
end

function Flag.Create(Options)
  local newObject = MergeTable(Options, Flag.Default)
  setmetatable(newObject,Flag)  -- make handle lookup
  newObject:CreateParticle()
  return newObject
end

function Flag:Destroy()
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

return Flag