local component = {}

--config: size as a proportion of the screen
local xSize = 0.2
local ySize = 0.25

function component:ViewResize()
  local xPixels = xSize * vsx
  local yPixels = ySize * vsy
  local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ
  local hScale = xPixels / mapSizeX
  local vScale = yPixels / mapSizeZ
  if hScale > vScale then
    gl.ConfigMiniMap(0, vsy - yPixels, yPixels * mapSizeX / mapSizeZ , yPixels)
  else
    yPixels = xPixels * mapSizeZ / mapSizeX
    gl.ConfigMiniMap(0, vsy - yPixels, xPixels, yPixels)
  end
end

return component