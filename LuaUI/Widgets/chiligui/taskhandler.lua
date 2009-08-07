--//=============================================================================
--// TaskHandler

TaskHandler = {}

local objects = {}
local objectsCount = 0

TaskHandler.objects = objects
TaskHandler.objectsCount = objectsCount

--//=============================================================================

function TaskHandler.AddObject(obj)
  objectsCount = objectsCount + 1
  objects[objectsCount] = obj
end


function TaskHandler.RemoveObject(obj)
  for i=1,numobjs do
    if (objects[i]==obj) then
      objects[i] = objects[objectsCount]
      objects[objectsCount] = nil
      objectsCount = objectsCount - 1
      return true
    end
  end
  return false
end

--//=============================================================================

function TaskHandler.Update()
  local obj,objUpdate
  for i=1,objectsCount do
    obj = objects[i]
    objUpdate = obj.Update
    if (objUpdate) then
      objUpdate(obj)
    end
  end
end

--//=============================================================================