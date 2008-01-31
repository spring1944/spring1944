-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Rank Icons",
    desc      = "Shows a rank icon depending on experience next to allied units",
    author    = "quantum",
    date      = "22 June 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = false  -- loaded by default?
  }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- speed-ups

local GetUnitDefID         = Spring.GetUnitDefID
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetUnitExperience    = Spring.GetUnitExperience
local GetTeamList          = Spring.GetTeamList
local GetTeamUnits         = Spring.GetTeamUnits
local GetMyAllyTeamID      = Spring.GetMyAllyTeamID

local glDepthTest      = gl.DepthTest
local glDepthMask      = gl.DepthMask
local glAlphaTest      = gl.AlphaTest
local glTexture        = gl.Texture
local glTexRect        = gl.TexRect
local glTranslate      = gl.Translate
local glBillboard      = gl.Billboard
local glDrawFuncAtUnit = gl.DrawFuncAtUnit

local GL_GREATER = GL.GREATER


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local update = 2.0

local alliedUnits  = {}

local myAllyTeamID = 666

local iconsize   = 30
local iconhsize  = iconsize * 0.5
local iconoffset = 4

local rankTexBase = 'LuaUI/Images/Ranks/'
local rankTextures = {
  [1] = rankTexBase .. 'rank1.png',
  [2] = rankTexBase .. 'rank2.png',
  [3] = rankTexBase .. 'rank3.png',
  [4] = rankTexBase .. 'star.png',
}


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:Initialize()
  for udid, ud in ipairs(UnitDefs) do
    -- 0.15+2/(1.2+math.exp(Unit.power/1000))
    ud.power_xp_coeffient  = ((ud.power / 1000) ^ -0.2) / 6  -- dark magic
    -- this cause a lag on loading, but it is a huge performance improvment!
    if (ud.height == nil) then
      ud.height = GetUnitDefDimensions(udid).height
    end
  end

  widget:Update(0)
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function SetUnitRank(unitID)
  local ud = UnitDefs[GetUnitDefID(unitID)]
  if (ud == nil) then
    alliedUnits[unitID] = nil
    return
  end

  local xp = GetUnitExperience(unitID)
  if (not xp) then
    alliedUnits[unitID] = nil
    return
  end
  xp = math.min(math.floor(xp / ud.power_xp_coeffient),4)

  local rankTex = rankTextures[xp]

  alliedUnits[unitID] = { rankTex, ud.height + iconoffset }
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local timeCounter = math.huge -- force the first update


function widget:Update(deltaTime)
  if (timeCounter < update) then
    timeCounter = timeCounter + deltaTime
    return
  end

  timeCounter = 0

  local newAllyTeamID = GetMyAllyTeamID()
  if (newAllyTeamID == myAllyTeamID) then
    -- just update the units
    for unitID in pairs(alliedUnits) do
      SetUnitRank(unitID)
    end
  else
    -- re-create the allied unit list
    alliedUnits = {}
    myAllyTeamID = newAllyTeamID
    for _,teamID in ipairs(GetTeamList(myAllyTeamID) ) do
      for _,unitID in ipairs(GetTeamUnits(teamID)) do
        SetUnitRank(unitID)
      end
    end
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  if (Spring.IsUnitAllied(unitID)) then
    SetUnitRank(unitID)
  end
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  alliedUnits[unitID] = nil
end


function widget:UnitGiven(unitID, unitDefID, oldTeam, newTeam)
  if (Spring.IsUnitAllied(unitID)) then
    SetUnitRank(unitID)
  else
    alliedUnits[unitID] = nil
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function DrawUnitFunc(yshift)
  glTranslate(0, yshift, 0)
  glBillboard()
  glTexRect(-iconhsize, 0, iconhsize, iconsize)
end


function widget:DrawWorld()
  if (next(alliedUnits) == nil) then
    return -- avoid unnecessary GL calls
  end
  
  glDepthMask(true)
  glDepthTest(true)
  glAlphaTest(GL_GREATER, 0.01)

  for unitID, rankTexHeight in pairs(alliedUnits) do
    if (rankTexHeight[1]) then
      glTexture(rankTexHeight[1])
      glDrawFuncAtUnit(unitID, false, DrawUnitFunc, rankTexHeight[2])
    end
  end
  glTexture(false)

  glAlphaTest(false)
  glDepthTest(false)
  glDepthMask(false)
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
