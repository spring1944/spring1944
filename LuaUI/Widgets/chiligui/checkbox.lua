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

function Checkbox:DrawControl()
  local vc = self.height*0.5 --//verticale center
  local tx,ty = 0, vc - self.fontsize*0.5

  local box  = self.boxsize
  local rect = {self.width-box[1],vc-box[1]*0.5,box[1],box[1]}

  gl.PushMatrix()
  gl.Translate(self.x,self.y,0)

  fh.UseFont(self.font)
  gl.Color(self.textColor)
  fh.Draw(self.caption,tx,ty,self.fontsize)

  theme.DrawCheckbox(self, rect, self.checked)

  gl.PopMatrix()
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
