-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  author:  jK
--
--  Copyright (C) 2008,2009,2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "CustomUnitShaders",
    desc      = "allows to override the engine unit shader",
    author    = "jK",
    date      = "2008,2009,2010",
    license   = "GNU GPL, v2 or later",
    layer     = 1,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Synced
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if (gadgetHandler:IsSyncedCode()) then

  function gadget:UnitFinished(unitID,unitDefID,teamID)
    SendToUnsynced("unitshaders_finished", unitID, unitDefID,teamID)
  end

  function gadget:UnitDestroyed(unitID,unitDefID,teamID)
    SendToUnsynced("unitshaders_destroyed", unitID, unitDefID,teamID)
  end

  function gadget:UnitReverseBuild(unitID,unitDefID,teamID)
    SendToUnsynced("unitshaders_reverse", unitID, unitDefID,teamID)
  end

  function gadget:UnitCloaked(unitID,unitDefID,teamID)
    SendToUnsynced("unitshaders_cloak", unitID, unitDefID,teamID)
  end

  function gadget:UnitDecloaked(unitID,unitDefID,teamID)
    SendToUnsynced("unitshaders_decloak", unitID, unitDefID,teamID)
  end

  --// block first try, so we have enough time to disable the lua UnitRendering
  --// else the model would be invisible for 1 gameframe
  local blockFirst = {}
  function gadget:AllowUnitBuildStep(builderID, builderTeam, unitID, unitDefID, part)
    if (part < 0) then
      local inbuild = not select(3,Spring.GetUnitIsStunned(unitID))
      if (not inbuild) then
        gadget:UnitReverseBuild(unitID,unitDefID,Spring.GetUnitTeam(unitID))
        if (not blockFirst[unitID]) then
          blockFirst[unitID] = true
          return false
        end
      end
    else
      blockFirst[unitID] = nil
    end
    return true
  end

  function gadget:GameFrame()
    for i,uid in ipairs(Spring.GetAllUnits()) do
      if not select(3,Spring.GetUnitIsStunned(uid)) then --// inbuild?
        gadget:UnitFinished(uid,Spring.GetUnitDefID(uid),Spring.GetUnitTeam(uid))
      end
    end
    gadgetHandler:RemoveCallIn('GameFrame')
  end

  return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Unsynced
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

VFS.Include("LuaRules/UnitRendering.lua")

if (not gl.CreateShader) then
  return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local shadows = false
local advShading = false
local normalmapping = false

local drawUnitList = {}
local unitMaterialInfos,bufMaterials = {},{}
local materialDefs = {}
local loadedTextures = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function CompileShader(shader,definitions)
  --// append definitions at top of the shader code
  --// (this way we can modularize a shader and enable/disable features in it)
  if (definitions or shadows) then
    shader.vertexOrig   = shader.vertex
    shader.fragmentOrig = shader.fragment
    shader.geometryOrig = shader.geometry

    definitions = definitions or {}
    definitions = table.concat(definitions, "\n")
    if (shadows) then
      definitions = definitions .. "\n" .. "#define use_shadows" .. "\n"
    end
    if (shader.vertex)
      then shader.vertex = definitions .. shader.vertex; end
    if (shader.fragment)
      then shader.fragment = definitions .. shader.fragment; end
    if (shader.geometry)
      then shader.geometry = definitions .. shader.geometry; end
  end

  local GLSLshader = gl.CreateShader(shader)
  Spring.Echo(gl.GetShaderLog())

  if (definitions or shadows) then
    shader.vertex   = shader.vertexOrig
    shader.fragment = shader.fragmentOrig
    shader.geometry = shader.geometryOrig
  end

  return GLSLshader
end


local function CompileMaterialShaders()
  for _,mat_src in pairs(materialDefs) do
    if (mat_src.shaderSource) then
      local GLSLshader = CompileShader(mat_src.shaderSource, mat_src.shaderDefinitions)

      if (GLSLshader) then
        if (mat_src.shader) then
          gl.DeleteShader(mat_src.shader)
        end
        mat_src.shader          = GLSLshader
        mat_src.cameraLoc       = gl.GetUniformLocation(GLSLshader,"camera")
        mat_src.cameraInvLoc    = gl.GetUniformLocation(GLSLshader,"cameraInv")
        mat_src.cameraPosLoc    = gl.GetUniformLocation(GLSLshader,"cameraPos")
        mat_src.shadowMatrixLoc = gl.GetUniformLocation(GLSLshader,"shadowMatrix")
        mat_src.shadowParamsLoc = gl.GetUniformLocation(GLSLshader,"shadowParams")
        mat_src.sunLoc          = gl.GetUniformLocation(GLSLshader,"sunPos")
        mat_src.frameLoc        = gl.GetUniformLocation(GLSLshader,"frame2")
        mat_src.speedLoc        = gl.GetUniformLocation(GLSLshader,"speed")
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function GetUnitMaterial(unitDefID)
  local mat = bufMaterials[unitDefID]
  if (mat) then
    return mat
  end

  local matInfo = unitMaterialInfos[unitDefID]
  local mat = materialDefs[matInfo[1]]

  matInfo.UNITDEFID = unitDefID

  --// find unitdef tex keyword and replace it
  --// (a shader can be just for multiple unitdefs, so we support this keywords)
  local texUnits = {}
  for texid,tex in pairs(mat.texunits or {}) do
    local tex_ = tex
    for varname,value in pairs(matInfo) do
      tex_ = tex_:gsub("%%"..tostring(varname),value)
    end
    texUnits[texid] = {tex=tex_, enable=false}
  end

  --// materials don't load those textures themselves
  if (texUnits[1]) then
    local texdl = gl.CreateList(function()
    for _,tex in pairs(texUnits) do
      local prefix = tex.tex:sub(1,1)
      if   (prefix~="%") 
        and(prefix~="#")
        and(prefix~="!")
        and(prefix~="$")
      then
        gl.Texture(tex.tex)
        loadedTextures[#loadedTextures+1] = tex.tex
      end
    end
    end)
    gl.DeleteList(texdl)
  end

  local luaMat = Spring.UnitRendering.GetMaterial("opaque",{
                   shader          = mat.shader,
                   cameraposloc    = mat.cameraPosLoc,
                   cameraloc       = mat.cameraLoc,
                   camerainvloc    = mat.cameraInvLoc,
                   shadowloc       = mat.shadowMatrixLoc,
                   shadowparamsloc = mat.shadowParamsLoc,
                   usecamera       = mat.usecamera,
                   culling         = mat.culling,
                   texunits        = texUnits,
                   prelist         = mat.predl,
                   postlist        = mat.postdl,
                 })

  bufMaterials[unitDefID] = luaMat

  return luaMat
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function ToggleShadows()
  shadows = Spring.HaveShadows()

  CompileMaterialShaders()

  bufMaterials = {}

  local units = Spring.GetAllUnits()
  for _,unitID in pairs(units) do
    local unitDefID = Spring.GetUnitDefID(unitID)
    local teamID    = Spring.GetUnitTeam(unitID)
    UnitDestroyed(nil,unitID)
    Spring.UnitRendering.DeactivateMaterial(unitID,3)
    if not select(3,Spring.GetUnitIsStunned(unitID)) then --// inbuild?
      UnitFinished(nil,unitID,unitDefID,teamID)
    end
  end
end


function ToggleAdvShading()
  advShading = Spring.HaveAdvShading()

  if (not advShading) then
    --// unload all materials
    drawUnitList = {}

    local units = Spring.GetAllUnits()
    for _,unitID in pairs(units) do
      Spring.UnitRendering.DeactivateMaterial(unitID,3)
    end
  elseif (normalmapping) then
    --// reinitializes all shaders
    ToggleShadows()
  end
end


function ToggleNormalmapping(_,_,_, playerID)
  if (playerID ~= Spring.GetMyPlayerID()) then
    return
  end

  normalmapping = not normalmapping
  Spring.SetConfigInt("NormalMapping", (normalmapping and 1) or 0)
  Spring.Echo("Set NormalMapping to " .. tostring((normalmapping and 1) or 0))

  if (not normalmapping) then
    --// unload all materials
    drawUnitList = {}

    local units = Spring.GetAllUnits()
    for _,unitID in pairs(units) do
      Spring.UnitRendering.DeactivateMaterial(unitID,3)
    end
  elseif (advShading) then
    --// reinitializes all shaders
    ToggleShadows()
  end
end


local n = 0
function gadget:Update()
  if (n<Spring.GetDrawFrame()) then
    n = Spring.GetDrawFrame() + Spring.GetFPS()

    if (advShading ~= Spring.HaveAdvShading()) then
      ToggleAdvShading()
    elseif (advShading)and(normalmapping)and(shadows ~= Spring.HaveShadows()) then
      ToggleShadows()
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitFinished(unitID,unitDefID,teamID)
  local unitMat = unitMaterialInfos[unitDefID]
  if (unitMat and (normalmapping or unitMat.force)) then
    Spring.UnitRendering.ActivateMaterial(unitID,3)
    Spring.UnitRendering.SetMaterial(unitID,3,"opaque",GetUnitMaterial(unitDefID))
    for pieceID in ipairs(Spring.GetUnitPieceList(unitID) or {}) do
      Spring.UnitRendering.SetPieceList(unitID,3,pieceID)
    end

    local mat = bufMaterials[unitDefID]
    if (mat.DrawUnit) then
      Spring.UnitRendering.SetUnitLuaDraw(unitID,true)
      drawUnitList[unitID] = mat
    end
  end
end


function gadget:UnitReverseBuild(unitID)
  drawUnitList[unitID] = nil
  Spring.UnitRendering.DeactivateMaterial(unitID,3)
end


function gadget:UnitDestroyed(unitID)
  drawUnitList[unitID] = nil
end


function gadget:DrawUnit(unitID)
  local mat = drawUnitList[unitID]
  if (mat) then
    return mat.DrawUnit(unitID, mat)
  end
end

function gadget:UnitCloaked(unitID)
  drawUnitList[unitID] = nil
  Spring.UnitRendering.DeactivateMaterial(unitID,3)
end

function gadget:UnitDecloaked(...)
  gadget:UnitFinished(...)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--// Workaround: unsynced LuaRules doesn't receive Shutdown events
Shutdown = Script.CreateScream()
Shutdown.func = function()
  for i=1,#loadedTextures do
    gl.DeleteTexture(loadedTextures[i])
  end
end


function gadget:Initialize()
  shadows = Spring.HaveShadows()
  advShading = Spring.HaveAdvShading()
  normalmapping = (Spring.GetConfigInt("NormalMapping", 1)>0)

  local unitNameDef
  materialDefs,unitNameDef = include("LuaRules/Configs/customShaders_config.lua")

  for _,mat_src in pairs(materialDefs) do
    if (mat_src.shader)and
       (mat_src.shader ~= "3do")and(mat_src.shader ~= "s3o")
    then
      mat_src.shaderSource = mat_src.shader
      mat_src.shader = nil
    end
  end

  CompileMaterialShaders()

  for unitName,materialInfo in pairs(unitNameDef) do
    if (type(materialInfo) ~= "table") then
      materialInfo = {materialInfo}
    end
    unitMaterialInfos[(UnitDefNames[unitName] or {id=-1}).id] = materialInfo
  end

  gadgetHandler:AddSyncAction("unitshaders_finished", UnitFinished)
  gadgetHandler:AddSyncAction("unitshaders_destroyed", UnitDestroyed)
  gadgetHandler:AddSyncAction("unitshaders_reverse", UnitReverseBuild)
  gadgetHandler:AddSyncAction("unitshaders_cloak", UnitCloaked)
  gadgetHandler:AddSyncAction("unitshaders_decloak", UnitDecloaked)

  gadgetHandler:AddChatAction("normalmapping", ToggleNormalmapping)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
