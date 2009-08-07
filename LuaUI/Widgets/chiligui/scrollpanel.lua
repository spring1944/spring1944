--//=============================================================================

ScrollPanel = Control:Inherit{
  classname     = "scrollpanel",
  padding       = table.shallowcopy({0,0,0,0}),
  scrollbarSize = 12,
  scrollPosX    = 0,
  scrollPosY    = 0,
  verticalScrollbar      = true,
  horizontalScrollbar    = true,
}

local this = ScrollPanel

--//=============================================================================

function ScrollPanel:LocalToClient(x,y)
  local padding = self.padding
  return x - padding[1] + self.scrollPosX, y - padding[2] + self.scrollPosY
end


function ScrollPanel:ClientToLocal(x,y)
  local padding = self.padding
  return x + padding[1] - self.scrollPosX, y + padding[2] - self.scrollPosY
end


function ScrollPanel:ParentToClient(x,y)
  local padding = self.padding
  return x - self.x - padding[1] + self.scrollPosX, y - self.y - padding[2] + self.scrollPosY
end


function ScrollPanel:ClientToParent(x,y)
  local padding = self.padding
  return x + self.x + padding[1] - self.scrollPosX, y + self.y + padding[2] - self.scrollPosY
end

--//=============================================================================

function ScrollPanel:UpdateLayout()
  --self.scrollPosX = 0
  --self.scrollPosY = 0

  local maxRight, maxBottom = 0,0
  local padding = self.padding
  local cn = self.children
  for i=1,#cn do
    local c = cn[i]
    local right, bottom = c.x+c.width, c.y+c.height
    if self.horizontalScrollbar then 
      if (right > maxRight) then maxRight = right end
    else
      c.width = self.width + padding[3] - self.scrollbarSize
    end
    if self.verticalScrollbar then
      if (bottom > maxBottom) then maxBottom = bottom end
    else
      c.height = self.height + padding[4] - self.scrollbarSize
    end
  end


  self.contentArea = {
    padding[1],
    padding[2],
    (self.horizontalScrollbar and maxRight or self.width) + padding[3],
    (self.verticalScrollbar and maxBottom or self.height) + padding[4],
  }

  self:RealignChildren()

  local contentArea = self.contentArea
  local clientArea = self.clientArea

  if (contentArea[4]>clientArea[4]) then
    if (not self._vscrollbar) then
      self.padding[3] = self.padding[3] + self.scrollbarSize
    end
    self._vscrollbar = true
  else
    if (self._vscrollbar) then
      self.padding[3] = self.padding[3] - self.scrollbarSize
    end
    self._vscrollbar = false
  end

  if (contentArea[3]>clientArea[3] and self.horizontalScrollbar) then
    if (not self._hscrollbar) then
      self.padding[4] = self.padding[4] + self.scrollbarSize
    end
    self._hscrollbar = true
  else
    if (self._hscrollbar) then
      self.padding[4] = self.padding[4] - self.scrollbarSize
    end
    self._hscrollbar = false
  end
  self:UpdateClientArea()

  self:Invalidate()
end

--//=============================================================================

function ScrollPanel:Draw()
  local clientX,clientY,clientWidth,clientHeight = unpack4(self.clientArea)
  local contX,contY,contWidth,contHeight = unpack4(self.contentArea)

  gl.PushMatrix()
  gl.Translate(self.x + clientX,self.y + clientY,0)

  if self._vscrollbar then
    theme.DrawScrollbar('vertical', clientWidth,  0, self.scrollbarSize, clientHeight,
                        self.scrollPosY/contHeight, clientHeight/contHeight)
  end
  if self._hscrollbar then
    theme.DrawScrollbar('horizontal', 0, clientHeight, clientWidth, self.scrollbarSize, 
                        self.scrollPosX/contWidth, clientWidth/contWidth)
  end

  gl.Translate(-self.scrollPosX, -self.scrollPosY, 0)

  local sx,sy = self:LocalToScreen(clientX,clientY)
  sy = select(2,gl.GetViewSizes()) - (sy + clientHeight)
  gl.Scissor(sx,sy,clientWidth,clientHeight)

  self:DrawChildren()

  gl.Scissor(false)
  gl.PopMatrix()
end

--//=============================================================================

function ScrollPanel:IsAboveHScrollbars(x,y)
  if (not self._hscrollbar) then return false end
  local clientArea = self.clientArea
  return x>=clientArea[1] and y>clientArea[2]+clientArea[4] and x<=clientArea[1]+clientArea[3] and y<=clientArea[2]+clientArea[4]+self.scrollbarSize
end


function ScrollPanel:IsAboveVScrollbars(x,y)
  if (not self._vscrollbar) then return false end
  local clientArea = self.clientArea
  return y>=clientArea[2] and x>clientArea[1]+clientArea[3] and y<=clientArea[2]+clientArea[4] and x<=clientArea[1]+clientArea[3]+self.scrollbarSize
end


function ScrollPanel:HitTest(x, y)
  if self:IsAboveVScrollbars(x,y) then
    return self
  end
  if self:IsAboveHScrollbars(x,y) then
    return self
  end

  return this.inherited.HitTest(self, x, y)
end


function ScrollPanel:MouseDown(x, y, ...)
  if self:IsAboveVScrollbars(x,y) then
    self._vscrolling  = true
    local clientArea = self.clientArea
    local cy = y - clientArea[2]
    self.scrollPosY = (cy/clientArea[4])*self.contentArea[4] - 0.5*clientArea[4]
    self.scrollPosY = clamp(0,self.contentArea[4] -clientArea[4],self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self:IsAboveHScrollbars(x,y) then
    self._hscrolling  = true
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0,self.contentArea[3] - clientArea[3],self.scrollPosX)
    self:Invalidate()
    return self
  end

  return this.inherited.MouseDown(self, x, y, ...)
end


function ScrollPanel:MouseMove(x, y, dx, dy, ...)
  if self._vscrolling then
    local clientArea = self.clientArea
    local cy = y - clientArea[2]
    self.scrollPosY = (cy/clientArea[4])*self.contentArea[4] - 0.5*clientArea[4]
    self.scrollPosY = clamp(0,self.contentArea[4] - clientArea[4],self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self._hscrolling then
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0,self.contentArea[3] - clientArea[3],self.scrollPosX)
    self:Invalidate()
    return self
  end

  return this.inherited.MouseMove(self, x, y, dx, dy, ...)
end


function ScrollPanel:MouseUp(x, y, ...)
  if self._vscrolling then
    self._vscrolling = nil
    local clientArea = self.clientArea
    local cy = y - clientArea[2]
    self.scrollPosY = (cy/clientArea[4])*self.contentArea[4] - 0.5*clientArea[4]
    self.scrollPosY = clamp(0,self.contentArea[4] - clientArea[4],self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self._hscrolling then
    self._hscrolling = nil
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0,self.contentArea[3] - clientArea[3],self.scrollPosX)
    self:Invalidate()
    return self
  end

  return this.inherited.MouseUp(self, x, y, ...)
end
