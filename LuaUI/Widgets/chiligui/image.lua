--//=============================================================================

Image = Button:Inherit{
  classname= "image",

  width  = 64,
  height = 64,
  padding = {0,0,0,0},

  file = theme.imageplaceholder,

  OnClick  = {},
}

local this = Image

--//=============================================================================

local GL_TRIANGLE_STRIP = GL.TRIANGLE_STRIP
local glPushMatrix = gl.PushMatrix
local glPopMatrix  = gl.PopMatrix
local glTranslate  = gl.Translate
local glColor      = gl.Color
local glBeginEnd   = gl.BeginEnd
local UseFont      = fh.UseFont
local DrawCentered = fh.DrawCentered

--//=============================================================================

function Image:Draw()
  gl.PushMatrix()
  gl.Translate(self.x,self.y,0)

  gl.Color(1,1,1,1)

  local clientArea = self.clientArea
  textureHandler.LoadTexture(self.file,self)
  gl.TexRect(clientArea[1],clientArea[2],clientArea[1]+clientArea[3],clientArea[2]+clientArea[4],false,true)
  gl.Texture(false)

  gl.PopMatrix()
end

--//=============================================================================

function Image:HitTest()
  --FIXME check if there are any eventhandlers linked (OnClick,OnMouseUp,...)
  return false
end

function Image:MouseDown(...)
  --// we don't use `this` here because it would call the eventhandler of the button class,
  --// which always returns true, but we just want to do so if a calllistener handled the event
  return Control.inherited.MouseDown(self, ...)
end

function Image:MouseUp(...)
  return Control.inherited.MouseUp(self, ...)
end

--//=============================================================================