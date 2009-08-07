--//=============================================================================

Label = Control:Inherit{
  classname= "label",

  width = 70,
  height = 20,

  autosize = false,

  align    = "left",
  valign   = "center",
  caption  = "no text",
}

local this = Label

--//=============================================================================

function Label:New(obj)
  obj = (this.inherited).New(self,obj)
  obj:SetCaption(obj.caption)
  return obj
end

--//=============================================================================

function Label:SetCaption(newcaption)
  self.caption = newcaption
  if (self.autosize) then
    --self.width = 
  else
    local _caption = self.caption
    self._caption  = _caption
    if (fh.GetTextWidth(_caption,self.fontsize) > self.width) then
      while (fh.GetTextWidth(_caption .. '...',self.fontsize) > self.width) do
        _caption = _caption:sub(1,-2)
      end
      self._caption = _caption .. '...'
    end
  end
end

--//=============================================================================

local TextDraw            = fh.Draw
local TextDrawCentered    = fh.DrawCentered
local TextDrawRight       = fh.DrawRight
local UseFont             = fh.UseFont

--//=============================================================================

function Label:Draw()
  gl.Color(self.textColor)
  UseFont(self.font)

  local tx, ty = 0,0
	
  if self.valign == "bottom" then
    ty = self.y + self.fontsize/2
  elseif self.valign == "top" then
    ty = self.y + self.height - self.fontsize
  elseif self.valign == "center" then
    ty = self.y + self.height/2
  end
	
  if self.align == "left" then
    TextDraw(self._caption, self.x, ty, self.fontsize)
  elseif self.align == "right" then
    TextDrawRight(self._caption, self.x + self.width, ty, self.fontsize)
  elseif self.align == "center" then
    TextDrawCentered(self._caption, self.x + self.width / 2, ty, self.fontsize)
  end
end

--//=============================================================================