-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Ammo Icons",
    desc      = "Shows a ammo icon next to units",
    author    = "FLOZi, adapted from code by trepan (idea quantum,jK)",
    date      = "May, 2008",
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
--local GetUnitExperience    = Spring.GetUnitExperience
local GetTeamList          = Spring.GetTeamList
local GetTeamUnits         = Spring.GetTeamUnits
local GetAllUnits          = Spring.GetAllUnits
local GetMyAllyTeamID      = Spring.GetMyAllyTeamID
local IsUnitAllied         = Spring.IsUnitAllied
local GetSpectatingState   = Spring.GetSpectatingState
local GetUnitRulesParam    = Spring.GetUnitRulesParam

local glDepthTest      = gl.DepthTest
local glDepthMask      = gl.DepthMask
local glAlphaTest      = gl.AlphaTest
local glTexture        = gl.Texture
local glTexRect        = gl.TexRect
local glTranslate      = gl.Translate
local glBillboard      = gl.Billboard
local glDrawFuncAtUnit = gl.DrawFuncAtUnit

local GL_GREATER = GL.GREATER

local min   = math.min
local floor = math.floor

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local unitHeights  = {}
local ammoIcons = { [0] = {}, [1] = {}, [2] = {}, [3] = {} }

local myAllyTeamID = 666

local iconsize   = 33
local iconoffset = 14

local ammoTexBase = 'LuaUI/Images/Ammo/'
local ammoTextures = {
  [0] = nil,
  [1] = ammoTexBase .. 'ammo1.png',
  [2] = ammoTexBase .. 'ammo2.png',
  [3] = ammoTexBase .. 'ammo3.png'
}

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:Initialize()
  --[[for udid, ud in pairs(UnitDefs) do
    -- 0.15+2/(1.2+math.exp(Unit.power/1000))
    ud.power_xp_coeffient  = ((ud.power / 1000) ^ -0.2) / 6  -- dark magic
  end--]]

  for _,unitID in pairs( GetAllUnits() ) do
    SetUnitAmmoIcon(unitID)
  end
end

function widget:Shutdown()
  for _,ammoTexture in ipairs(ammoTextures) do
    gl.DeleteTexture(ammoTexture)
  end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function SetUnitAmmoIcon(unitID)
  local ud = UnitDefs[GetUnitDefID(unitID)]
  if (ud == nil) then
    unitHeights[unitID] = nil
    return
  end

  --[[local xp = GetUnitExperience(unitID)
  if (not xp) then
    unitHeights[unitID] = nil
    return
  end
  xp = min(floor(xp / ud.power_xp_coeffient),4)

  unitHeights[unitID] = ud.height + iconoffset
  if (xp>0) then
    ranks[xp][unitID] = true
  end--]]
	local ammoLevel = GetUnitRulesParam(unitID, "ammo",  ammoLevel)
	Spring.Echo(ammoLevel)
	if (not ammoLevel) then
	  unitHeights[unitID] = nil
    return
  end
	
	local ammoIconType = 0
	if (ammoLevel > 5) then -- Normal ammo
		ammoIconType = 1
	end
	if (ammoLevel <= 5 and ammoLevel > 0) then -- reduced ammo
		ammoIconType = 2
	end
	if (ammoLevel == 0) then -- no ammo
		ammoIconType = 3
	end
	Spring.Echo(ammoIconType)
	unitHeights[unitID] = ud.height + iconoffset
	ammoIcons[ammoIconType][unitID] = true
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local timeCounter = math.huge -- force the first update

function widget:Update(deltaTime)
  --[[if (timeCounter < update) then
    timeCounter = timeCounter + deltaTime
    return
  end

  timeCounter = 0--]]

  -- just update the units
  for unitID in pairs(unitHeights) do
    SetUnitAmmoIcon(unitID)
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--[[function widget:UnitExperience(unitID,unitDefID,unitTeam, xp, oldXP)
  local ud = UnitDefs[unitDefID]
  if (ud == nil) then
    unitHeights[unitID] = nil
    return
  end
  if (not unitHeights[unitID]) then
    unitHeights[unitID] = { nil, ud.height + iconoffset}
  end

  local rank    = min(floor(xp / ud.power_xp_coeffient),4)
  local oldRank = min(floor(oldXP / ud.power_xp_coeffient),4)

  if (rank~=oldRank) then
    unitHeights[unitID] = ud.height + iconoffset
    for i=0,rank-1 do ranks[i][unitID] = nil end
    ranks[rank][unitID] = true
  end
end--]]


function widget:UnitCreated(unitID, unitDefID, unitTeam)
  if (IsUnitAllied(unitID)or(GetSpectatingState())) then
    SetUnitAmmoIcon(unitID)
  end
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  unitHeights[unitID] = nil
  ammoIcons[1][unitID] = nil
  ammoIcons[2][unitID] = nil
  ammoIcons[3][unitID] = nil
end


function widget:UnitGiven(unitID, unitDefID, oldTeam, newTeam)
  if (not IsUnitAllied(unitID))and(not GetSpectatingState())  then
    unitHeights[unitID] = nil
    ammoIcons[1][unitID] = nil
    ammoIcons[2][unitID] = nil
    ammoIcons[3][unitID] = nil
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function DrawUnitFunc(yshift)
  glTranslate(0,yshift,0)
  glBillboard()
  glTexRect(-iconsize+10.5, -9, 10.5, iconsize-9)
end


function widget:DrawWorld()
  if (next(unitHeights) == nil) then
    return -- avoid unnecessary GL calls
  end

  glDepthMask(true)
  glDepthTest(true)
  glAlphaTest(GL_GREATER, 0.001)

  for i=1,3 do
    if (next(ammoIcons[i])) then
      glTexture( ammoTextures[i] )

      for unitID,_ in pairs(ammoIcons[i]) do
        glDrawFuncAtUnit(unitID, false, DrawUnitFunc, unitHeights[unitID])
      end
    end
  end
  glTexture(false)

  glAlphaTest(false)
  glDepthTest(false)
  glDepthMask(false)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
