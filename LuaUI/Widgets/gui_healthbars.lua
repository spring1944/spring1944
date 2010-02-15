-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  author:  jK
--
--  Copyright (C) 2007,2008,2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--  Ammo support and alignment correction by Ralith
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "HealthBars",
    desc      = "Gives various informations about units in form of bars.",
    author    = "jK, Ralith",
    date      = "Jun, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = -10,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local barHeight = 3
local barWidth  = 14  --// (barWidth)x2 total width!!!
local barAlpha  = 0.9

local featureBarHeight = 3
local featureBarWidth  = 10
local featureBarAlpha  = 0.6

local drawBarTitles = true
local titlesAlpha   = 0.3*barAlpha

local drawFullHealthBars = false

local drawFeatureHealth  = true
local featureTitlesAlpha = featureBarAlpha * titlesAlpha/barAlpha
local featureHpThreshold = 0.85

local infoDistance = 700000

local minReloadTime = 4 --// in seconds

local drawStunnedOverlay = true
local drawUnitsOnFire    = Spring.GetGameRulesParam("unitsOnFire")
local drawJumpJet        = Spring.GetGameRulesParam("jumpJets")

--// this table is used to shows the hp of perimeter defence, and filter it for default wreckages
local walls = {dragonsteeth=true,dragonsteeth_core=true,fortification=true,fortification_core=true,spike=true,floatingteeth=true,floatingteeth_core=true,spike=true}

local stockpileH = 24
local stockpileW = 12

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--// colors

local bkBottom   = { 0.40,0.40,0.40,barAlpha }
local bkTop      = { 0.10,0.10,0.10,barAlpha }
local hpcolormap = { {0.8, 0.0, 0.0, barAlpha},  {0.8, 0.6, 0.0, barAlpha}, {0.0,0.70,0.0,barAlpha} }
local empcolor   = { 0.50,0.50,1.00,barAlpha }
local empcolor_p = { 0.40,0.40,0.80,barAlpha }
local empcolor_b = { 0.60,0.60,0.90,barAlpha }
local capcolor   = { 1.00,0.50,0.00,barAlpha }
local buildcolor = { 0.75,0.75,0.75,barAlpha }
local stockcolor = { 0.50,0.50,0.50,barAlpha }
local reloadcolor= { 0.00,0.60,0.60,barAlpha }
local jumpcolor  = { 0.00,0.60,0.60,barAlpha }
local shieldcolor= { 0.20,0.60,0.60,barAlpha }
local ammocolor  = { 0.55,0.47,0.00,barAlpha }

local fbkBottom   = { 0.40,0.40,0.40,featureBarAlpha }
local fbkTop      = { 0.06,0.06,0.06,featureBarAlpha }
local fhpcolormap = { {0.8, 0.0, 0.0, featureBarAlpha},  {0.8, 0.6, 0.0, featureBarAlpha}, {0.0,0.70,0.0,featureBarAlpha} }
local rescolor    = { 1.00,0.50,0.00,featureBarAlpha }
local reccolor    = { 0.75,0.75,0.75,featureBarAlpha }

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local blink = false;
local gameFrame = 0;

local empDecline = 32/30/40;

local bfcolormap = {}; --// a buffered list for hpcolormap

local UnitDefsCount;
local tmpUpdate;

local UnitMorphs = {};

local cx, cy, cz = 0,0,0;  --// camera pos
local paraUnits   = {};
local onFireUnits = {};

local barShader;
local barColorLoc;
local barEnabledLoc;
local barProgressLoc;
local barOffsetLoc;
local barDList;
local barFeatureDList;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- speed-ups

Spring.GetTeamColor = Spring.GetTeamColor or function(teamID) local _,_,_,_,_,_,r,g,b = Spring.GetTeamInfo(teamID); return r,g,b end

local GL_QUADS = GL.QUADS
local GL_TEXTURE_GEN_MODE = GL.TEXTURE_GEN_MODE
local GL_EYE_PLANE  = GL.EYE_PLANE
local GL_EYE_LINEAR = GL.EYE_LINEAR
local GL_T   = GL.T
local GL_S   = GL.S
local GL_ONE = GL.ONE
local GL_SRC_ALPHA           = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local glVertex        = gl.Vertex
local glBeginEnd      = gl.BeginEnd 
local glTexRect       = gl.TexRect
local glTranslate     = gl.Translate
local glColor         = gl.Color
local glDrawFuncAtUnit= gl.DrawFuncAtUnit
local glFog           = gl.Fog
local glDepthTest     = gl.DepthTest
local glTranslate     = gl.Translate
local glTexture       = gl.Texture
local glText          = gl.Text
local glPushMatrix    = gl.PushMatrix
local glPopMatrix     = gl.PopMatrix
local glBillboard     = gl.Billboard
local glDepthMask     = gl.DepthMask
local glBlending      = gl.Blending
local glTexCoord      = gl.TexCoord
local glUnit          = gl.Unit
local glTexGen        = gl.TexGen
local glPolygonOffset = gl.PolygonOffset
local glDepthTest     = gl.DepthTest
local max,min,abs     = math.max,math.min,math.abs
local ceil,floor      = math.ceil,math.floor
local insert          = table.insert
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetUnitIsStunned     = Spring.GetUnitIsStunned
local GetUnitHealth        = Spring.GetUnitHealth
local GetFeatureHealth     = Spring.GetFeatureHealth
local GetFeatureResources  = Spring.GetFeatureResources
local GetCameraPosition    = Spring.GetCameraPosition
local GetCameraVectors     = Spring.GetCameraVectors
local GetUnitWeaponState   = Spring.GetUnitWeaponState
local GetUnitShieldState   = Spring.GetUnitShieldState
local GetTeamList          = Spring.GetTeamList
local GetTeamUnits         = Spring.GetTeamUnits
local IsUnitInView         = Spring.IsUnitInView
local GetUnitViewPosition  = Spring.GetUnitViewPosition
local GetUnitStockpile     = Spring.GetUnitStockpile
local IsSphereInView       = Spring.IsSphereInView
local GetAllFeatures       = Spring.GetAllFeatures
local GetFeatureDefID      = Spring.GetFeatureDefID
local GetFeaturePosition   = Spring.GetFeaturePosition
local GetGameFrame         = Spring.GetGameFrame
local GetUnitDefID         = Spring.GetUnitDefID
local GetVisibleUnits      = Spring.GetVisibleUnits
local GetUnitRulesParam    = Spring.GetUnitRulesParam
local ALL_UNITS            = Spring.ALL_UNITS

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local deactivated = false
function showhealthbars(cmd, line, words)
  if ((words[1])and(words[1]~="0"))or(deactivated) then
    widgetHandler:UpdateCallIn('DrawWorld')
    deactivated = false
  else
    widgetHandler:RemoveCallIn('DrawWorld')
    deactivated = true
  end
end


function widget:Initialize()
  --// catch f9
  Spring.SendCommands({"showhealthbars 0"})
  widgetHandler:AddAction("showhealthbars", showhealthbars)
  Spring.SendCommands({"unbind f9 showhealthbars"})
  Spring.SendCommands({"bind f9 luaui showhealthbars"})

  --// find real primary weapon and its reloadtime
  for _,ud in pairs(UnitDefs) do
    ud.reloadTime    = 0;
    ud.primaryWeapon = 0;
    ud.shieldPower   = 0;

    for i=1,ud.weapons.n do
      local WeaponDefID = ud.weapons[i].weaponDef;
      local WeaponDef   = WeaponDefs[ WeaponDefID ];
      if (WeaponDef.reload>ud.reloadTime) then
        ud.reloadTime    = WeaponDef.reload;
        ud.primaryWeapon = i;
      end
    end
    local shieldDefID = ud.shieldWeaponDef
    ud.shieldPower = ((shieldDefID)and(WeaponDefs[shieldDefID].shieldPower))or(-1)
  end

  --// wow, using a buffered list can give 1-2 frames in extreme(!) situations :p
  for hp=0,100 do
    bfcolormap[hp] = {GetColor(hpcolormap,hp*0.01)}
  end

  --// link morph callins
  widgetHandler:RegisterGlobal('MorphUpdate', MorphUpdate)
  widgetHandler:RegisterGlobal('MorphFinished', MorphFinished)
  widgetHandler:RegisterGlobal('MorphStart', MorphStart)
  widgetHandler:RegisterGlobal('MorphStop', MorphStop)

  --// deactivate cheesy progress text
  widgetHandler:RegisterGlobal('MorphDrawProgress', function() return true end)

  --// create bar shader
  if (gl.CreateShader) then
    barShader = gl.CreateShader({
      vertex = [[
        uniform vec4  barColor;
        uniform float offset;
        uniform float progress;
        uniform bool  enabled;

        void main()
        {
           if (!enabled) {
             gl_TexCoord[0]= gl_TextureMatrix[0]*gl_MultiTexCoord0;
             gl_FrontColor = gl_Color;
             gl_Position   = ftransform();
             return;
           }
           if (gl_Vertex.w>0) {
             gl_FrontColor = gl_Color;
             if (gl_Vertex.z>0.0) {
               gl_Vertex.x -= (1.0-progress)*gl_Vertex.z;
               gl_Vertex.z  = 0.0;
             }
           }else{
             if (gl_Vertex.y>0.0) {
               gl_FrontColor = vec4(barColor.rgb*1.5,barColor.a);
             }else{
               gl_FrontColor = barColor;
             }
             if (gl_Vertex.z>1.0) {
               gl_Vertex.x += progress*gl_Vertex.z;
               gl_Vertex.z  = 0.0;
             }
             gl_Vertex.w  = 1.0;
           }

           gl_Vertex.y += offset;
           gl_Position  = gl_ModelViewProjectionMatrix*gl_Vertex;
         }
      ]],
      uniformInt = {enabled = 1}
    });

    if (barShader) then
      barColorLoc    = gl.GetUniformLocation(barShader,"barColor")
      barOffsetLoc   = gl.GetUniformLocation(barShader,"offset")
      barProgressLoc = gl.GetUniformLocation(barShader,"progress")
      barEnabledLoc  = gl.GetUniformLocation(barShader,"enabled")

      barDList = gl.CreateList(function()
        glBeginEnd(GL_QUADS,function()
          glVertex(-barWidth,0,        0,0);
          glVertex(-barWidth,0,        barWidth*2,0);
          glVertex(-barWidth,barHeight,barWidth*2,0);
          glVertex(-barWidth,barHeight,0,0);

          glColor(bkBottom);
          glVertex(barWidth,0,        0,         1);
          glVertex(barWidth,0,        barWidth*2,1);
          glColor(bkTop);
          glVertex(barWidth,barHeight,barWidth*2,1);
          glVertex(barWidth,barHeight,0,         1);
        end)
      end)

      barFeatureDList = gl.CreateList(function()
        glBeginEnd(GL_QUADS,function()
          glVertex(-featureBarWidth,0,               0,0);
          glVertex(-featureBarWidth,0,               featureBarWidth*2,0);
          glVertex(-featureBarWidth,featureBarHeight,featureBarWidth*2,0);
          glVertex(-featureBarWidth,featureBarHeight,0,0);

          glColor(fbkBottom);
          glVertex(featureBarWidth,0,               0,         1);
          glVertex(featureBarWidth,0,               featureBarWidth*2,1);
          glColor(fbkTop);
          glVertex(featureBarWidth,featureBarHeight,featureBarWidth*2,1);
          glVertex(featureBarWidth,featureBarHeight,0,         1);
        end)
      end)
    end
  end

end

function widget:Shutdown()
  --// catch f9
  widgetHandler:RemoveAction("showhealthbars", showhealthbars)
  Spring.SendCommands({"unbind f9 luaui"})
  Spring.SendCommands({"bind f9 showhealthbars"})
  Spring.SendCommands({"showhealthbars 1"})

  widgetHandler:DeregisterGlobal('MorphUpdate', MorphUpdate)
  widgetHandler:DeregisterGlobal('MorphFinished', MorphFinished)
  widgetHandler:DeregisterGlobal('MorphStart', MorphStart)
  widgetHandler:DeregisterGlobal('MorphStop', MorphStop)

  widgetHandler:DeregisterGlobal('MorphDrawProgress')

  if (barShader) then
    gl.DeleteShader(barShader)
  end
  if (barDList) then
    gl.DeleteList(barDList)
    gl.DeleteList(barFeatureDList)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function GetColor(colormap,slider)
  local coln = #colormap
  if (slider>=1) then
    local col = colormap[coln]
    return col[1],col[2],col[3],col[4]
  end
  if (slider<0) then slider=0 elseif(slider>1) then slider=1 end
  local posn  = 1+(coln-1) * slider
  local iposn = floor(posn)
  local aa    = posn - iposn
  local ia    = 1-aa

  local col1,col2 = colormap[iposn],colormap[iposn+1]

  return col1[1]*ia + col2[1]*aa, col1[2]*ia + col2[2]*aa,
         col1[3]*ia + col2[3]*aa, col1[4]*ia + col2[4]*aa
end

local function DrawGradient(left,top,right,bottom,topclr,bottomclr)
  glColor(bottomclr)
  glVertex(left,bottom)
  glVertex(right,bottom)
  glColor(topclr)
  glVertex(right,top)
  glVertex(left,top)
end

local brightClr = {}
local function DrawBar(offsetY,percent,color)
  if (barShader) then
    gl.Uniform(barColorLoc,color[1],color[2],color[3],color[4])
    gl.Uniform(barProgressLoc,percent)
    gl.Uniform(barOffsetLoc,offsetY)
    gl.CallList(barDList)
    return;
  end

  brightClr[1] = color[1]*1.5; brightClr[2] = color[2]*1.5; brightClr[3] = color[3]*1.5; brightClr[4] = color[4]
  local progress_pos= -barWidth+barWidth*2*percent
  local bar_Height  = barHeight+offsetY
  if percent<1 then glBeginEnd(GL_QUADS,DrawGradient,progress_pos, bar_Height, barWidth, offsetY, bkTop,bkBottom) end
  glBeginEnd(GL_QUADS,DrawGradient,-barWidth, bar_Height, progress_pos, offsetY,brightClr,color)
end

local function DrawFeatureBar(offsetY,percent,color)
  if (barShader) then
    gl.Uniform(barColorLoc,color[1],color[2],color[3],color[4])
    gl.Uniform(barProgressLoc,percent)
    gl.Uniform(barOffsetLoc,offsetY)
    gl.CallList(barFeatureDList)
    return;
  end

  brightClr[1] = color[1]*1.5; brightClr[2] = color[2]*1.5; brightClr[3] = color[3]*1.5; brightClr[4] = color[4]
  local progress_pos = -featureBarWidth+featureBarWidth*2*percent
  glBeginEnd(GL_QUADS,DrawGradient,progress_pos, featureBarHeight+offsetY, featureBarWidth, offsetY, fbkTop,fbkBottom)
  glBeginEnd(GL_QUADS,DrawGradient,-featureBarWidth, featureBarHeight+offsetY, progress_pos, offsetY, brightClr,color)
end

local function DrawStockpile(numStockpiled,numStockpileQued)
  --// DRAW STOCKPILED MISSLES
  glColor(1,1,1,1)
  glTexture("LuaUI/Images/nuke.png")
  local xoffset = barWidth+16
  for i=1,min(numStockpiled,3) do
    glTexRect(xoffset,-(11*barHeight-2)-stockpileH,xoffset-stockpileW,-(11*barHeight-2))
    xoffset = xoffset-8
  end
  glTexture(false)

  glText(numStockpiled..'/'..numStockpileQued,barWidth+1.7,-(11*barHeight-2)-16,6.5,"cno")
end

local teamColors = {}
local function SetTeamColor(teamID,a)
  local color = teamColors[teamID]
  if (color) then
    color[4]=a
    glColor(color)
    return
  end
  local r, g, b = Spring.GetTeamColor(teamID)
  if (r and g and b) then
    color = { r, g, b }
    teamColors[teamID] = color
    glColor(color)
    return
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function DrawUnitInfos(unitID,height,canStockpile,reloadTime,primaryWeapon,MaxShieldPower)
  local fullText = true
  local ux, uy, uz = GetUnitViewPosition(unitID)
  local dx, dy, dz = ux-cx, uy-cy, uz-cz
  dist = dx*dx + dy*dy + dz*dz
  if (dist>9000000) then
    return 
  elseif (dist > infoDistance) then
    fullText = false
  end

  --// GET UNIT INFORMATION
  local health,maxHealth,paralyzeDamage,capture,build = GetUnitHealth(unitID)
  --if (health==nil)    then health=-1   elseif(health<1)    then health=1    end
  if (maxHealth==nil)or(maxHealth<1) then maxHealth=1 end
  if (paralyzeDamage==nil) then paralyzeDamage=0 end
  if (capture==nil)   then capture=0 end 
  if (build==nil)     then build=1   end

  local emp = paralyzeDamage/(health or 1)
  if (emp>1) then emp=1 end
  local hp  = (health or 0)/maxHealth
  local shieldOn,shieldPower
  if (MaxShieldPower>0)  --//you can also add a shield with Lua, but as long as it isn't used we don't need to check it
     then shieldOn,shieldPower = GetUnitShieldState(unitID) end
  local morph = UnitMorphs[unitID]

  if (drawUnitsOnFire)and(GetUnitRulesParam(unitID,"on_fire")==1) then
    onFireUnits[#onFireUnits+1]=unitID
  end

  local ammoLevel = GetUnitRulesParam(unitID, "ammo",  ammoLevel)
  local ammoMax = tonumber(UnitDefs[GetUnitDefID(unitID)].customParams.maxammo)

  --// BARS //-----------------------------------------------------------------------------
  local bars = {}
  local n = 0

    --// Shield
    if (shieldOn)and(build==1)and(shieldPower<MaxShieldPower) then
      shieldPower = shieldPower / MaxShieldPower
      n=n+1
      bars[n]={title="shield",progress=shieldPower,color=shieldcolor,text=floor(shieldPower*100)..'%'}
    end

    --// HEALTH
    if (health)and( (build==1)or(build-hp>=0.01) ) then
      local hp100   = ceil(hp*100)
      if (hp100<0) then hp100=0 elseif (hp100>100) then hp100=100 end
      if (drawFullHealthBars)or(hp100<100) then
        local hpcolor = bfcolormap[hp100]
        n=n+1
        bars[n]={title="health",progress=hp,color=hpcolor,text=hp100..'%'}
      end
    end

    --// BUILD
    if (build<1) then
      n=n+1
      bars[n]={title="building",progress=build,color=buildcolor,text=floor(build*100)..'%'}
    end

    --// MORPHING
    if (morph) then
      local build = morph.progress
      n=n+1
      bars[n]={title="morph",progress=build,color=buildcolor,text=floor(build*100)..'%'}
    end

    --// STOCKPILE
    local numStockpiled,numStockpileQued,stockpileBuild;
    if canStockpile then
      numStockpiled,numStockpileQued,stockpileBuild = GetUnitStockpile(unitID)
      if numStockpiled then
        stockpileBuild = stockpileBuild or 0
        if (stockpileBuild>0) then
          n=n+1
          bars[n]={title="stockpile",progress=stockpileBuild,color=stockcolor,text=floor(stockpileBuild*100)..'%'}
        end
      end
    end

    --// PARALYZE
    if (emp>0.01)and(hp>0.01)and(not morph)and(emp<1e8) then 
      local stunned = GetUnitIsStunned(unitID)
      local infotext = ""
      if (stunned) then
        paraUnits[#paraUnits+1]=unitID
        --table.insert(paraUnits,unitID)
        infotext = floor((paralyzeDamage-health)/(maxHealth*empDecline)) .. 's'
        emp = 1
      else
        infotext = floor(emp*100)..'%'
      end
      local paracolor = (stunned and ((blink and empcolor_b) or empcolor_p)) or (empcolor)
      n=n+1
      bars[n]={title="paralyze",progress=emp,color=paracolor,text=infotext}
    end

    --// CAPTURE
    if (capture>0) then
      n=n+1
      bars[n]={title="capture",progress=capture,color=capcolor,text=floor(capture*100)..'%'}
    end

    --// RELOAD
    if (reloadTime>=minReloadTime) then
      local _,reloaded,reloadFrame = GetUnitWeaponState(unitID,primaryWeapon-1)
      if (reloaded==false) then
        local reload = max(0, 1 - ((reloadFrame-gameFrame)/30) / reloadTime);
        n=n+1
        bars[n]={title="reload",progress=reload,color=reloadcolor,text=floor(reload*100)..'%'}
      end
    end

    --// JUMPJET
    if (drawJumpJet) then
      local jumpReload = GetUnitRulesParam(unitID,"jumpReload")
      if (jumpReload and (jumpReload>0) and (jumpReload<1)) then
        n=n+1
        bars[n]={title="jump",progress=jumpReload,color=jumpcolor,text=floor(jumpReload*100)..'%'}
      end
    end

    --// AMMO
    if(ammoLevel and ammoMax and (ammoLevel < ammoMax)) then
      n=n+1
      bars[n]={title="ammo",progress=ammoLevel/ammoMax,color=ammocolor,text=ammoLevel.."/"..ammoMax}
    end

  if (n>0) then
    glPushMatrix()
    glTranslate(ux, uy+height, uz )
    glBillboard()

    --// STOCKPILE ICON
    if (numStockpiled) then
      if (barShader) then gl.UniformInt(barEnabledLoc,0) end
      DrawStockpile(numStockpiled,numStockpileQued)
      if (barShader) then gl.UniformInt(barEnabledLoc,1) end
    end

    --// DRAW BARS
    local yoffset = 0
    for i=1,n do
      local barInfo = bars[i]
      DrawBar(yoffset,barInfo.progress,barInfo.color)
      if (fullText) then
        if (barShader) then gl.UniformInt(barEnabledLoc,0) end
        glColor(1,1,1,barAlpha)
        glText(barInfo.text,-barWidth-1,yoffset,4,"rn")
        if (drawBarTitles) then
          glColor(1,1,1,titlesAlpha)
          glText(barInfo.title,0,yoffset+0.5,2.5,"cn")
        end
        if (barShader) then gl.UniformInt(barEnabledLoc,1) end
      end
      yoffset = yoffset - barHeight - 2
    end

    glPopMatrix()
  end
end



local function DrawFeatureInfos(featureID,height,fullText,fx,fy,fz)
  --// GET UNIT INFORMATION
  local featureDefID = GetFeatureDefID(featureID)
  local featureDef   = FeatureDefs[featureDefID or -1]

  local health,maxHealth,resurrect = GetFeatureHealth(featureID)
  local _,_,_,_,reclaimLeft        = GetFeatureResources(featureID)
  if (health==nil)      then health=1    end
  if (maxHealth==nil)   then maxHealth=1 end
  if (resurrect==nil)   then resurrect=0 end
  if (reclaimLeft==nil) then reclaimLeft=0 end
  local hp = health/maxHealth

  --// filter all none walls and none resurrecting features
  if (health==nil)or
     (featureDef==nil)or
     ( (resurrect==0)and(reclaimLeft==1)and
       ( (not walls[featureDef.name]) or (hp>featureHpThreshold) )
     )
  then return end

  --// BARS //-----------------------------------------------------------------------------
  local bars = {}
  local n = 0

    --// HEALTH
    if (hp<featureHpThreshold)and(drawFeatureHealth) then
      local hpcolor = {}
      hpcolor[1],hpcolor[2],hpcolor[3],hpcolor[4] = GetColor(fhpcolormap,hp)
      n=n+1
      bars[n]={title="health",progress=hp,color=hpcolor,text=floor(hp*100)..'%'}
    end

    --// RESURRECT
    if (resurrect>0) then
      n=n+1
      bars[n]={title="resurrect",progress=resurrect,color=rescolor,text=floor(resurrect*100)..'%'}
    end


    --// RECLAIMING
    if (reclaimLeft>0 and reclaimLeft<1) then
      n=n+1
      bars[n]={title="reclaim",progress=reclaimLeft,color=reccolor,text=floor(reclaimLeft*100)..'%'}
    end


  if (n>0) then
    glPushMatrix()
    glTranslate(fx,fy+featureDef.height+14,fz)
    glBillboard()

    --// DRAW BARS
    local yoffset = 0
    for i=1,n do
      local barInfo = bars[i]
      DrawFeatureBar(yoffset,barInfo.progress,barInfo.color)
      if (fullText) then
        if (barShader) then gl.UniformInt(barEnabledLoc,0) end
        glColor(1,1,1,featureBarAlpha)
        glText(barInfo.text,-featureBarWidth-1,yoffset,4,"rn")
        if (drawBarTitles) then
          glColor(1,1,1,featureTitlesAlpha)
          glText(barInfo.title,0,yoffset+0.5,2.5,"cn")
        end
        if (barShader) then gl.UniformInt(barEnabledLoc,1) end
      end
      yoffset = yoffset - featureBarHeight - 2
    end

    glPopMatrix()
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local featureList  = {}
local visibleUnits = {}
local videoFrame   = 0

function widget:DrawWorld()
  --glFog(false)
  --glDepthTest(true)
  glDepthMask(true)

  cx, cy, cz = GetCameraPosition()

  videoFrame = videoFrame+1
  if (videoFrame%4<1) then
    visibleUnits = GetVisibleUnits(ALL_UNITS,nil,true)
  end

  if (barShader) then gl.UseShader(barShader) end

  --// draw bars of units
  for i=1,#visibleUnits do
    local unitID    = visibleUnits[i]
    local unitDefID = GetUnitDefID(unitID)
    local unitDef   = UnitDefs[unitDefID or -1]
    if (unitDef) then
      local height         = unitDef.height+14
      local canStockpile   = unitDef.canStockpile
      local reloadTime     = unitDef.reloadTime
      local primaryWeapon  = unitDef.primaryWeapon
      local MaxShieldPower = unitDef.shieldPower
              
      --glDrawFuncAtUnit(unitID, true, DrawUnitInfos, unitID, height, canStockpile, reloadTime, primaryWeapon, MaxShieldPower)
      DrawUnitInfos(unitID, height, canStockpile, reloadTime, primaryWeapon, MaxShieldPower)
    end
  end


  --// draw bars for features
  for featureID,featurePos in pairs(featureList) do
    local wx, wy, wz = featurePos[1],featurePos[2],featurePos[3]
    local dx, dy, dz = wx-cx, wy-cy, wz-cz
    dist = dx*dx + dy*dy + dz*dz
    if (dist < 6000000)and(IsSphereInView(wx,wy,wz)) then
      if (dist < infoDistance) then
        DrawFeatureInfos(featureID, 70, true, wx,wy,wz)
      else
        DrawFeatureInfos(featureID, 70, false, wx,wy,wz)
      end
    end
  end


  if (barShader) then gl.UseShader(0) end
  glDepthMask(false)


  --// draw an overlay for stunned units
  if (drawStunnedOverlay)and(#paraUnits>0) then
    glDepthTest(true)
    glPolygonOffset(-2, -2)
    glBlending(GL_SRC_ALPHA, GL_ONE)

    local alpha = ((5.5 * widgetHandler:GetHourTimer()) % 2) - 0.7
    glColor(0,0.7,1,alpha/4)
    for i=1,#paraUnits do
      glUnit(paraUnits[i],true)
    end
    local shift = widgetHandler:GetHourTimer() / 20

    glTexCoord(0,0)
    glTexGen(GL_T, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR)
    local cvs = GetCameraVectors()
    local v = cvs.right
    glTexGen(GL_T, GL_EYE_PLANE, v[1]*0.008,v[2]*0.008,v[3]*0.008, shift)
    glTexGen(GL_S, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR)
    v = cvs.forward
    glTexGen(GL_S, GL_EYE_PLANE, v[1]*0.008,v[2]*0.008,v[3]*0.008, shift)
    glTexture("LuaUI/Images/paralyzed.png")

    glColor(0,1,1,alpha*1.1)
    for i=1,#paraUnits do
      glUnit(paraUnits[i],true)
    end

    glTexture(false)
    glTexGen(GL_T, false)
    glTexGen(GL_S, false)
    glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glPolygonOffset(false)
    glDepthTest(false)

    paraUnits = {}
  end

  --// overlay for units on fire
  if (drawUnitsOnFire)and(onFireUnits) then
    glDepthTest(true)
    glPolygonOffset(-2, -2)
    glBlending(GL_SRC_ALPHA, GL_ONE)

    local alpha = abs((widgetHandler:GetHourTimer() % 2)-1)
    glColor(1,0.3,0,alpha/4)
    for i=1,#onFireUnits do
      glUnit(onFireUnits[i],true)
    end

    glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glPolygonOffset(false)
    glDepthTest(false)

    onFireUnits = {}
  end

  glColor(1,1,1,1)
  --glDepthTest(false)
end


local sec = 0
function widget:Update(dt)
  sec=sec+dt
  blink = (sec%1)<0.5

  gameFrame = GetGameFrame()

  --// update feature list (huge speed improvement if we buffer it)
  if (((gameFrame+1)%180)<1) then
    featureList = {}
    local allFeatures = GetAllFeatures()
    for i=1,#allFeatures do
      local featureID    = allFeatures[i]
      local featureDefID = GetFeatureDefID(featureID) or -1
      local featureDef   = FeatureDefs[featureDefID]
      --// filter trees and none destructable features
      if (featureDef)and(featureDef.drawType~=1)and(featureDef.destructable) then
        featureList[featureID] = {GetFeaturePosition(featureID)}
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--// not 100% finished!

function MorphUpdate(morphTable)
  UnitMorphs = morphTable
end

function MorphStart(unitID,morphDef)
  --return false
end

function MorphStop(unitID)
  UnitMorphs[unitID] = nil
end

function MorphFinished(unitID)
  UnitMorphs[unitID] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------