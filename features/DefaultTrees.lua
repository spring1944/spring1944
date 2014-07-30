-- Default Spring Treedef

local DRAWTYPE = { NONE = -1, MODEL = 0, TREE = 1 }

local treeDefs = {}

local function CreateTreeDef(typeNum)
  treeDefs["treetype" .. typeNum] = {
     description = [[Tree]],
     blocking    = true,
     burnable    = true,
     reclaimable = true,
     energy      = 0,
     damage      = 5,
     metal       = 0,
     reclaimTime = 25,
     mass        = 20,
     drawType    = DRAWTYPE.TREE + typeNum,
     footprintX  = 1,
     footprintZ  = 1,
     collisionVolumeTest = 1,
     collisionVolumeType = [[CylY]],
	 collisionVolumeScales = [[3 50 3]],
     customParams = {
       mod = true,
     },
  }
end

for i=0,20 do
  CreateTreeDef(i)
end

return lowerkeys( treeDefs )