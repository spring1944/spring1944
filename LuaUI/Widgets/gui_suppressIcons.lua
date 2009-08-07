-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "1944 Suppression Icons",
    desc      = "Shows a suppression icon next to units",
    author    = "FLOZi, adapted from code by trepan (idea quantum,jK)",
    date      = "May, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  -- loaded by default?
  }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- speed-ups
local GetUnitDefID         = Spring.GetUnitDefID
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
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
local suppressIcons = { [0] = {}, [1] = {}, [2] = {} }

local myAllyTeamID = 666

local iconsize   = 8 --16
local iconoffset = 6
local suppressTexBase = 'LuaUI/Images/Suppress/'
local suppressTextures = {
  [0] = nil,
  [1] = suppressTexBase .. 'suppress1.png',
  [2] = suppressTexBase .. 'suppress2.png'
}

local pinnedThreshold = 20

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:Initialize()
  for _,unitID in pairs( GetAllUnits() ) do
    SetUnitsuppressIcon(unitID)
  end
end

function widget:Shutdown()
  for _,suppressTexture in ipairs(suppressTextures) do
    gl.DeleteTexture(suppressTexture)
  end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function SetUnitsuppressIcon(unitID)
  local ud = UnitDefs[GetUnitDefID(unitID)]
  if (ud == nil) then
    unitHeights[unitID] = nil
    return
  end

	local suppressLevel = GetUnitRulesParam(unitID, "suppress",  suppressLevel)
	
	if (not suppressLevel) then
	  unitHeights[unitID] = nil
    return
  end
	
	local suppressIconType = 0
	if (suppressLevel == 0) then -- No suppression ^_^
		suppressIconType = 0
	elseif (suppressLevel < pinnedThreshold) then -- suppressed, not pinned O_O
		suppressIconType = 1
	else -- pinned! ;_;
		suppressIconType = 2
	end	
	unitHeights[unitID] = ud.height + iconoffset
	
	for i = 1, 2 do
		suppressIcons[i][unitID] = nil
	end
	suppressIcons[suppressIconType][unitID] = true
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


function widget:GameFrame(n)
	if (n % (3*30) < 0.1) then
		-- just update the units
		for unitID in pairs(unitHeights) do
			SetUnitsuppressIcon(unitID)
		end
	end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


function widget:UnitCreated(unitID, unitDefID, unitTeam)
  if (IsUnitAllied(unitID)or(GetSpectatingState())) then
    SetUnitsuppressIcon(unitID)
  end
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  unitHeights[unitID] = nil
  suppressIcons[1][unitID] = nil
  suppressIcons[2][unitID] = nil
end


function widget:UnitGiven(unitID, unitDefID, oldTeam, newTeam)
  if (not IsUnitAllied(unitID))and(not GetSpectatingState())  then
    unitHeights[unitID] = nil
    suppressIcons[1][unitID] = nil
    suppressIcons[2][unitID] = nil
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function DrawUnitFunc(yshift)
	if yshift then -- hack to fix a bug i don't understand
		glTranslate(0,yshift,0)
	end
  glBillboard()
	glTexRect(-iconsize-10.5, -9, -10.5, iconsize-9)
end


function widget:DrawWorld()
  if (next(unitHeights) == nil) then
    return -- avoid unnecessary GL calls
  end

  glDepthMask(true)
  glDepthTest(true)
  glAlphaTest(GL_GREATER, 0.001)
	
  if (suppressIcons[1] ~= nil) then
      glTexture( suppressTextures[1] )
      for unitID,_ in pairs(suppressIcons[1]) do
        glDrawFuncAtUnit(unitID, false, DrawUnitFunc, unitHeights[unitID])
      end
  end
  
  if (suppressIcons[2] ~= nil) then
      glTexture( suppressTextures[2] )
      for unitID,_ in pairs(suppressIcons[2]) do
        glDrawFuncAtUnit(unitID, false, DrawUnitFunc, unitHeights[unitID])
      end
  end
	
	--[[for i = 1, 4 do
		--if (next(suppressIcons[i])) then
		if (suppressIcons[i] ~= nil) then
			glTexture( suppressTextures[i] )
			for unitID,_ in pairs(suppressIcons[i]) do
				glDrawFuncAtUnit(unitID, false, DrawUnitFunc, unitHeights[unitID])
			end
		end	
	end]]
	
  glTexture(false)

  glAlphaTest(false)
  glDepthTest(false)
  glDepthMask(false)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
