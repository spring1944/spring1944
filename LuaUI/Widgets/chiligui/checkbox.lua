--//=============================================================================

Checkbox = Control:Inherit{
  classname = "checkbox",
  checked   = true,
  caption   = "text",
  textalign = "left",
  boxalign  = "right",
  boxsize   = {10,10},

  textColor = {0,0,0,1},
  
  width     = 70,
  height    = 18,

  OnChange = {}
}

local this = Checkbox

--//=============================================================================

function Checkbox:Toggle()
  self:CallListeners(self.OnChange,not self.checked)
  self.checked = not self.checked
  self:Invalidate()
end

--//=============================================================================

local GL_LINE_LOOP  = GL.LINE_LOOP
local GL_LINE_STRIP = GL.LINE_STRIP
local glPushMatrix  = gl.PushMatrix
local glPopMatrix   = gl.PopMatrix
local glTranslate   = gl.Translate
local glVertex      = gl.Vertex
local glRect        = gl.Rect
local glColor       = gl.Color
local glBeginEnd    = gl.BeginEnd

local function DrawRect(rect)
  glVertex(rect[1],rect[2])
  glVertex(rect[1],rect[4])
  glVertex(rect[3],rect[4])
  glVertex(rect[3],rect[2])
end

function Checkbox:Draw()
  local vc = self.height*0.5 --//verticale center
  local tx,ty = 0, vc - self.fontsize*0.5

  local box  = self.boxsize
  local rect = {self.width-box[1],vc-box[1]*0.5,box[1],box[1]}

  gl.PushMatrix()
  gl.Translate(self.x,self.y,0)

  fh.UseFont(self.font)
  glColor(self.textColor)
  fh.Draw(self.caption,tx,ty,self.fontsize)

  theme.DrawCheckbox(self, rect, self.checked)

  glPopMatrix()
end

--//=============================================================================

function Checkbox:HitTest()
  return self
end

function Checkbox:MouseDown()
  self:Toggle()
  return self
end

--//=============================================================================