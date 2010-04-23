--//=============================================================================

Object = {
  classname = 'object',
  x         = 0,
  y         = 0,
  width     = 10,
  height    = 10,

  children  = {},
  childrenByKeys = {},
  childrenByKeysInverse = {},

  OnClick     = {},
  OnDblClick  = {},
  OnMouseDown = {},
  OnMouseUp   = {},
  OnMouseMove = {},
}

local this = Object

--//=============================================================================

function Object:New(obj)
  obj = obj or {}
  local t
  for i,v in pairs(self) do
    if (not obj[i])and(i ~= "inherited") then
      t = type(v)
      if (t == "table") --[[or(t=="metatable")--]] then
        obj[i] = table.shallowcopy(v)
      end
    end
  end
  setmetatable(obj,{__index = self})
  local parent = obj.parent
  local cn = obj.children
  obj.children = {}
  for i=1,#cn do
    obj:AddChild(cn[i],true)
  end
  if (parent) then
    parent:AddChild(obj)
  end
  TaskHandler.AddObject(obj)
  return obj
end


-- calling this releases unmanaged resources like display lists and disposes of the object
-- children are disposed too
-- todo: use scream, in case the user forgets
-- nil -> nil
function Object:Dispose()
  if (self.parent) then
    (self.parent):RemoveChild(self)
  end
  -- todo: kill display list
  self:CallChildren("Dispose")
end


function Object:clone()
  local newinst = {}
   -- FIXME
  return newinst
end


function Object:Inherit(class)
  class.inherited = self

  for i,v in pairs(self) do
    if (not class[i])and(i ~= "inherited") then
      t = type(v)
      if (t == "table") --[[or(t=="metatable")--]] then
        class[i] = table.shallowcopy(v)
      else
        class[i] = v
      end
    end
  end

  --setmetatable(class,{__index=self})

  return class
end

--//=============================================================================

function Object:SetParent(obj)
  self.parent = obj
end


function Object:AddChild(obj, dontUpdate)
  local childrenByKeys = self.childrenByKeys

  if (not obj.parent) then
    obj:SetParent(self)
  end

  if (not childrenByKeys[obj]) then
    local children = self.children
    children[#children+1] = obj

    --//FIXME: sort by layer!
    childrenByKeys[obj] = obj
    self.childrenByKeysInverse[obj] = obj

    self:Invalidate()
  else
    Spring.Echo("ChiliUI: tried to readd a child-object")
  end
end


function Object:RemoveChild(child)
  local childrenByKeys = self.childrenByKeys
  if (childrenByKeys[child]) then
    if (child.parent == self) then
      child:SetParent(nil)
    end

    self.childrenByKeys[child] = nil
    self.childrenByKeysInverse[child] = nil

    local children = self.children
    local cn = #children
    --// todo: add a new tag to keep children order! (and then use table.remove if needed)
    for i=1,cn do
      if (child == children[i]) then
        children[i] = children[cn]
        children[cn] = nil
        self:Invalidate()
        return true
      end
    end
  end
  return false
end


function Object:GetChild(name)
  local cn = self.children
  for i=1,#cn do
    if (name == cn[i].name) then
      return cn[i]
    end
  end
end

--//=============================================================================

function Object:Inherited(method,...)
  --FIXME: this isn't the correct class/object!
  this.inherited[method](self,...)
end


function Object:InheritsFrom(classname)
  if (self.classname == classname) then
    return true
  elseif not self.inherited then
    return false
  else
    return self.inherited.InheritsFrom(self.inherited,classname)
  end
end


-- Climbs the family tree and returns the first parent that satisfies a 
-- predicate function or inherites the given class.
-- Returns nil if not found.
function Object:FindParent(predicate)
  if not self.parent then
    return -- not parent with such class name found, return nil
  elseif (type(predicate) == "string" and (self.parent):InheritsFrom(predicate)) or
         (type(predicate) == "function" and predicate(self.parent)) then 
    return self.parent
  else
    return self.parent:FindParent(predicate)
  end
end


function Object:CallListeners(listeners, ...)
  for i=1,#listeners do
    local eventListener = listeners[i]
    if eventListener(self, ...) then
      return true
    end
  end
end


function Object:CallListenersInverse(listeners, ...)
  for i=#listeners,1,-1 do
    local eventListener = listeners[i]
    if eventListener(self, ...) then
      return true
    end
  end
end


function Object:CallChildren(eventname, ...)
  local childrenByKeys = self.childrenByKeys
  for child in pairs(childrenByKeys) do
    local obj = child[eventname](child, ...)
    if (obj) then
      return obj
    end
  end

--[[
  local children = self.children
  for i=1,#children do
    local child = children[i]
    local obj = child[eventname](child, ...)
    if (obj) then
      return obj
    end
  end
--]]
end


function Object:CallChildrenInverse(eventname, ...)
  local childrenByKeysInverse = self.childrenByKeysInverse
  for child in pairs(childrenByKeysInverse) do
    local obj = child[eventname](child, ...)
    if (obj) then
      return obj
    end
  end

--[[
  local children = self.children
  for i=#children,1,-1 do
    local child = children[i]
    local obj = child[eventname](child, ...)
    if (obj) then
      return obj
    end
  end
--]]
end


local function InLocalRect(cx,cy,w,h)
  return (cx>=0)and(cy>=0)and(cx<=w)and(cy<=h)
end


function Object:CallChildrenHT(eventname, x, y, ...)
  local childrenByKeys = self.childrenByKeys
  for c in pairs(childrenByKeys) do
    local cx,cy = c:ParentToLocal(x,y)
    if InLocalRect(cx,cy,c.width,c.height) and c:HitTest(cx,cy) then
      local obj = c[eventname](c, cx, cy, ...)
      if (obj) then
        return obj
      end
    end
  end
end


--//=============================================================================

function Object:Invalidate()
  --FIXME should be Control only
end


function Object:Draw()
  self:CallChildrenInverse('Draw')
end

--//=============================================================================

function Object:LocalToParent(x,y)
  return x + self.x, y + self.y
end


function Object:ParentToLocal(x,y)
  return x - self.x, y - self.y
end


Object.ParentToClient = Object.ParentToLocal
Object.ClientToParent = Object.LocalToParent


function Object:LocalToClient(x,y)
  return x,y
end


function Object:LocalToScreen(x,y)
  if self.parent then
    return (self.parent):ClientToScreen(self:LocalToParent(x,y))
  else
    return -1,-1
  end
end


function Object:ClientToScreen(x,y)
  return (self.parent):ScreenToClient(self:ClientToParent(x,y))
end


function Object:ScreenToLocal(x,y)
  return self:ParentToLocal((self.parent):ScreenToClient(x,y))
end


function Object:ScreenToClient(x,y)
  return self:ParentToClient((self.parent):ScreenToClient(x,y))
end

--//=============================================================================


function Object:HitTest(x,y)
  local childrenByKeys = self.childrenByKeys
  for c in pairs(childrenByKeys) do
    local cx,cy = c:ParentToLocal(x,y)
    if InLocalRect(cx,cy,c.width,c.height) then
      local obj = c:HitTest(cx,cy)
      if (obj) then
        return obj
      end
    end
  end

  return false
end


function Object:IsAbove(x, y, ...)
  return self:HitTest(x,y)
end


function Object:MouseDown(x, y, ...)
  if (self:CallListeners(self.OnMouseDown, x, y, ...)) then
    return self
  end

  return self:CallChildrenHT('MouseDown', x, y, ...)
end


function Object:MouseMove(x, y, ...)
  if (self:CallListeners(self.OnMouseMove, x, y, ...)) then
    return self
  end

  return self:CallChildrenHT('MouseMove', x, y, ...)
end


function Object:MouseUp(x, y, ...)
  if (self:CallListeners(self.OnMouseUp, x, y, ...)) then
    return self
  end

  return self:CallChildrenHT('MouseUp', x, y, ...)
end


function Object:MouseClick(x, y, ...)
  if (self:CallListeners(self.OnClick, x, y, ...)) then
    return self
  end

  return self:CallChildrenHT('MouseClick', x, y, ...)
end


function Object:MouseDblClick(x, y, ...)
  if (self:CallListeners(self.OnDblClick, x, y, ...)) then
    return self
  end

  return self:CallChildrenHT('MouseDblClick', x, y, ...)
end

--//=============================================================================

return Object





