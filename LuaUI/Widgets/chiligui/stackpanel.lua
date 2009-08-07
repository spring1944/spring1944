--//=============================================================================

StackPanel = LayoutPanel:Inherit{
  classname = "stackpanel",
  orientation = "vertical",
  resizeItems = true,
  itemPadding = {0, 0, 0, 0},
  itemMargin  = {5, 5, 5, 5},
}

local this = StackPanel

--//=============================================================================

function StackPanel:New(obj)
  if (obj.orientation=="horizontal") then
    obj.rows,obj.columns = 1,nil
  else
    obj.rows,obj.columns = nil,1
  end
  obj = (this.inherited).New(self,obj)
  return obj
end

--//=============================================================================

function StackPanel:SetOrientation(orientation)
  if (orientation == "horizontal") then
    self.rows,self.columns = 1,nil
  else
    self.rows,self.columns = nil,1
  end

  this.inherited.SetOrientation(self,orientation)
end

--//=============================================================================