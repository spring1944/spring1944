Window = Control:Inherit{
  classname = 'window',
  resizable = true,
  draggable = true,
}

local this = Window

--//=============================================================================
--[[
function Window:UpdateClientArea()
  this.inherited.UpdateClientArea(self)


  if (not WG['blur_api']) then return end

  if (self.blurId) then
    WG['blur_api'].RemoveBlurRect(self.blurId)
  end

  local screeny = select(2,gl.GetViewSizes()) - self.y

  self.blurId = WG['blur_api'].InsertBlurRect(self.x,screeny,self.x+self.width,screeny-self.height)
end
--]]
--//=============================================================================