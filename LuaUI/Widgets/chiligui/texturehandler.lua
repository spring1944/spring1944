--//=============================================================================

textureHandler = {}

--//=============================================================================

--//TWEAKING
local timeLimit = 0.2/15 --//time per second / desiredFPS

--//=============================================================================

local loaded = {}
local requested = {}

local placeholderFilename = theme.imageplaceholder
local placeholderDL = nil

--//=============================================================================

--// SpeedUp
local next = next
local spGetTimer = Spring.GetTimer
local spDiffTimers = Spring.DiffTimers
local glActiveTexture = gl.ActiveTexture
local glCallList = gl.CallList

--//=============================================================================

function textureHandler.Initialize()
  gl.Texture(placeholderFilename); gl.Texture(false);
  placeholderDL = gl.CreateList(gl.Texture,placeholderFilename)
end

--//=============================================================================

local function AddRequest(filename,obj)
  local req = requested
  if (req[filename]) then
    local t = req[filename]
    t[#t+1] = obj or -1
  else
    req[filename] = {obj}
  end
end

--//=============================================================================

function textureHandler.LoadTexture(arg1,arg2,arg3)
  local activeTexID,filename,obj
  if (type(arg1)=='number') then
     activeTexID,filename,obj = arg1,arg2,arg3
  else
     activeTexID,filename,obj = 0,arg1,arg2
  end

  if (not loaded[filename]) then
    AddRequest(filename,obj)
    glActiveTexture(activeTexID,glCallList,placeholderDL)
  else
    glActiveTexture(activeTexID,glCallList,loaded[filename].dl)
  end
end


function textureHandler.DeleteTexture(filename)
  local tex = loaded[filename]
  if (tex) then
    tex.references = tex.references - 1
    if (tex.references==0) then
      gl.DeleteList(tex.dl)
      gl.DeleteTexture(filename)
      loaded[filename] = nil
    end
  end
end

--//=============================================================================

local usedTime = 0
local lastCall = spGetTimer()

function textureHandler.Update()
  if (usedTime>0) then
    thisCall = spGetTimer()

    usedTime = usedTime - spDiffTimers(thisCall,lastCall)
    lastCall = thisCall

    if (usedTime<0) then usedTime = 0 end
  end

  if (not next(requested)) then return end

  local timerStart = spGetTimer()
  while (usedTime < timeLimit) do
    local filename,objs = next(requested)

    if (not filename) then return end

    local texture = {}
    gl.Texture(filename); gl.Texture(false);
    texture.dl = gl.CreateList(gl.Texture,filename)
    texture.references = #objs
    loaded[filename] = texture

    for i=1,#objs do
      if (objs[i]~=-1) then
        (objs[i]):Invalidate()
      end
    end

    requested[filename] = nil

    local timerEnd = spGetTimer()
    usedTime = usedTime + spDiffTimers(timerEnd,timerStart)
    timerStart = timerEnd
  end

  lastCall = spGetTimer()
end

--//=============================================================================