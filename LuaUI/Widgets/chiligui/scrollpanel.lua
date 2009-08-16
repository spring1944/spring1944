--//=============================================================================

ScrollPanel = Control:Inherit{
  classname     = "scrollpanel",
  padding       = {0,0,0,0},
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

local function GetMinBottomRight(c)
  local canchors = c.anchors

  local right
  local bottom

  if (canchors.top and not canchors.bottom) then
    bottom = c.y + c.height
  elseif (canchors.bottom and not canchors.top) then
    bottom = c.height + 0 --c.border.bottom
  else
    bottom = c.y + --[[c.minHeight + --]] c.height --c.border.bottom
  end

  if (canchors.left and not canchors.right) then
    right = c.x + c.width
  elseif (canchors.right and not canchors.left) then
    right = c.width + 0 --c.border.right
  else
    right = c.x + --[[c.minWidth + --]] c.width --c.border.right
  end

  return bottom, right
end

function ScrollPanel:_DetermineContentArea()
  local maxRight  = 0
  local maxBottom = 0
  local cn = self.children
  for i=1,#cn do
    local bottom,right = GetMinBottomRight(cn[i])
    if (right > maxRight) then maxRight = right end
    if (bottom > maxBottom) then maxBottom = bottom end
  end

  if (self.verticalScrollbar and maxBottom > self.height) then
    local clientAreaWidth = self.width - self.scrollbarSize
    if (maxRight < clientAreaWidth) then
      maxRight = clientAreaWidth
    end
  elseif (maxRight < self.width) then
    maxRight = self.width
  end
  if (self.horizontalScrollbar and maxRight > self.width) then
    local clientAreaHeight = self.height - self.scrollbarSize
    if (maxBottom < clientAreaHeight) then
      maxBottom = clientAreaHeight
    end
  elseif (maxBottom < self.height) then
    maxBottom = self.height
  end

  self.contentArea = {
    0,
    0,
    maxRight,
    maxBottom,
  }

  local contentArea = self.contentArea
  local clientArea = self.clientArea

  if (self.verticalScrollbar) then
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
  end

  if (self.horizontalScrollbar) then
    if (contentArea[3]>clientArea[3]) then
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
  end

  self:UpdateClientArea()
end

--//=============================================================================

function ScrollPanel:UpdateLayout()
  self:_DetermineContentArea()
  self:RealignChildren()
  self:_DetermineContentArea()

  self.scrollPosX = clamp(0, self.contentArea[3] - self.clientArea[3], self.scrollPosX)
  self.scrollPosY = clamp(0, self.contentArea[4] - self.clientArea[4], self.scrollPosY)

  return true;
end

--//=============================================================================

function ScrollPanel:DrawControl()
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

  gl.PopMatrix()
end


function ScrollPanel:DrawChildren()
  local clientX,clientY,clientWidth,clientHeight = unpack4(self.clientArea)

  gl.PushMatrix()
  gl.Translate(-self.scrollPosX, -self.scrollPosY, 0)

  local sx,sy = self:LocalToScreen(clientX,clientY)
  sy = select(2,gl.GetViewSizes()) - (sy + clientHeight)
  gl.Scissor(sx,sy,clientWidth,clientHeight)

  gl.Translate(self.x + self.clientArea[1],self.y + self.clientArea[2],0)
  self:CallChildrenInverse('Draw')

  gl.Scissor(false)
  gl.PopMatrix()
end


function ScrollPanel:DrawChildrenForList()
  local clientX,clientY,clientWidth,clientHeight = unpack4(self.clientArea)

  gl.PushMatrix()
  gl.Translate(-self.scrollPosX, -self.scrollPosY, 0)

  local sx,sy = self:LocalToScreen(clientX,clientY)
  sy = select(2,gl.GetViewSizes()) - (sy + clientHeight)
  gl.Scissor(sx,sy,clientWidth,clientHeight)

  gl.Translate(self.x + self.clientArea[1],self.y + self.clientArea[2],0)
  self:CallChildrenInverse('DrawForList',true)

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
    self.scrollPosY = clamp(0, self.contentArea[4] - clientArea[4], self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self:IsAboveHScrollbars(x,y) then
    self._hscrolling  = true
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0, self.contentArea[3] - clientArea[3], self.scrollPosX)
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
    self.scrollPosY = clamp(0, self.contentArea[4] - clientArea[4], self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self._hscrolling then
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0, self.contentArea[3] - clientArea[3], self.scrollPosX)
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
    self.scrollPosY = clamp(0, self.contentArea[4] - clientArea[4], self.scrollPosY)
    self:Invalidate()
    return self
  end
  if self._hscrolling then
    self._hscrolling = nil
    local clientArea = self.clientArea
    local cx = x - clientArea[1]
    self.scrollPosX = (cx/clientArea[3])*self.contentArea[3] - 0.5*clientArea[3]
    self.scrollPosX = clamp(0, self.contentArea[3] - clientArea[3], self.scrollPosX)
    self:Invalidate()
    return self
  end

  return this.inherited.MouseUp(self, x, y, ...)
end
