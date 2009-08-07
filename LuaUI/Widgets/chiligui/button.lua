--//=============================================================================

Button = Control:Inherit{
  classname= "button",
  caption  = 'button',
  width  = 70,
  height = 20,
}

local this = Button

--//=============================================================================

local GL_TRIANGLE_STRIP = GL.TRIANGLE_STRIP
local glBeginEnd   = gl.BeginEnd
local UseFont      = fh.UseFont
local DrawCentered = fh.DrawCentered
local glColor      = gl.Color

--//=============================================================================

function Button:Draw()
  local w,h = self.width, self.height
  
  local vc = h*0.5 --//verticale center
  local tx,ty = self.x + w * 0.5, self.y + vc - self.fontsize * 0.5

  local state = (self._down and 'pressed') or 'normal'
  glBeginEnd(GL_TRIANGLE_STRIP, theme.DrawBackground, self, state)
  glBeginEnd(GL_TRIANGLE_STRIP, theme.DrawBorder, self, state)
 
  glColor(self.textColor)
  UseFont(self.font)
  DrawCentered(self.caption, tx, ty, self.fontsize)
end

--//=============================================================================

function Button:HitTest(x,y)
  return self
end

function Button:MouseDown(...)
  self._down = true
  self:Invalidate()
  this.inherited.MouseDown(self, ...)
  self.captured = true
  return self
end

function Button:MouseUp(...)
  if (self._down) then
    self._down = false
    self:Invalidate()
    this.inherited.MouseUp(self, ...)
    return self
  end
end

--//=============================================================================