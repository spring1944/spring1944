--//=============================================================================

Trackbar = Control:Inherit{
  classname = "trackbar",
  value     = 50,
  min       = 0,
  max       = 100,
  step      = 1,

  width     = 90,
  height    = 20,

  trackColor = {0,0,0,1},
  
  OnChange = {},
}

local this = Trackbar

--//=============================================================================

function Trackbar:SetValue(v)
  local r = v % self.step
  v = v - r
  if (r >= self.step*0.5) then
    v = v + self.step
  end

  self:CallListeners(self.OnChange,v)
  self.value = v
  self:Invalidate()
end

--//=============================================================================

function Trackbar:DrawControl()
  local percent = (self.value-self.min)/(self.max-self.min)
  theme.DrawTrackbar(self.x,self.y,self.width,self.height,percent,self.state,self.trackColor)
end

--//=============================================================================

function Trackbar:HitTest()
  return self
end

function Trackbar:MouseDown(x,y)
  self:SetValue(self.min + (x/self.width)*(self.max-self.min))
  return self
end

function Trackbar:MouseMove(x,y,dx,dy,button)
  if (button==1) then
    self:SetValue(self.min + (x/self.width)*(self.max-self.min))
    return self
  end
end

--//=============================================================================
