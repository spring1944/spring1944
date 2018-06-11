-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local SHADER_DIR = "ModelMaterials/Shaders/"

if not Script.IsEngineMinVersion or not Script.IsEngineMinVersion(101,0,0) then
    -- Too old engine, ignore it
    return {}, {}
elseif Script.IsEngineMinVersion(104,0,1) then
    -- GL 4.X
    SHADER_DIR = "ModelMaterials/Shaders/GL4.X"
    return {}, {}
else
    -- GL 3.X
    SHADER_DIR = "ModelMaterials/Shaders/GL3.X"
end

local materials = {
   normalMappedS3o = {
       shaderDefinitions = {
         "#define use_perspective_correct_shadows",
         "#define use_normalmapping",
         "#define deferred_mode 0",
         "#define SPECULARMULT 1.0",
         --"#define flip_normalmap",
       },
       deferredDefinitions = {
         "#define use_perspective_correct_shadows",
         "#define use_normalmapping",
         "#define deferred_mode 1",
         "#define SPECULARMULT 1.0",
       },
       shader    = include(SHADER_DIR .. "default.lua"),
       deferred  = include(SHADER_DIR .. "default.lua"), 
       usecamera = false,
       culling   = GL.BACK,
       predl  = nil,
       postdl = nil,
       feature = true,
       texunits  = {
         [0] = '%%FEATUREDEFID:0',
         [1] = '%%FEATUREDEFID:1',
         [2] = '$shadow',
         [3] = '$specular',
         [4] = '$reflection',
         [5] = '%NORMALTEX',
       },
   },
   normalModelledS3o = {
       shaderDefinitions = {
         "#define use_perspective_correct_shadows",
         --"#define use_normalmapping",
         "#define deferred_mode 0",
         "#define SPECULARMULT 1.0",
         --"#define flip_normalmap",
       },
       deferredDefinitions = {
         "#define use_perspective_correct_shadows",
         --"#define use_normalmapping",
         "#define deferred_mode 1",
         "#define SPECULARMULT 1.0",
       },
       shader    = include(SHADER_DIR .. "default.lua"),
       deferred  = include(SHADER_DIR .. "default.lua"), 
       usecamera = false,
       culling   = GL.BACK,
       predl  = nil,
       postdl = nil,
       feature = true,
       texunits  = {
         [0] = '%%FEATUREDEFID:0',
         [1] = '%%FEATUREDEFID:1',
         [2] = '$shadow',
         [3] = '$specular',
         [4] = '$reflection',
       },
   },
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Automated normalmap detection

local unitMaterials = {}

local function FindNormalmap(tex1, tex2)
  local normaltex

  --// check if there is a corresponding _normals.dds file
  if (VFS.FileExists(tex1)) then
    local basefilename = tex1:gsub("%....","")
    --[[if (tonumber(basefilename:sub(-1,-1))) then
      basefilename = basefilename:sub(1,-2)
    end]]-- -- This code removes trailing numbers, but many S44 units end in a number, e.g. SU-76
    if (basefilename:sub(-1,-1) == "_") then
       basefilename = basefilename:sub(1,-2)
    end
    normaltex = basefilename .. "_normals.dds"
    if (not VFS.FileExists(normaltex)) then
      normaltex = nil
    end
  end --if FileExists

  --[[if (not normaltex) and tex2 and (VFS.FileExists(tex2)) then
    local basefilename = tex2:gsub("%....","")
    if (tonumber(basefilename:sub(-1,-1))) then
      basefilename = basefilename:sub(1,-2)
    end
    if (basefilename:sub(-1,-1) == "_") then
      basefilename = basefilename:sub(1,-2)
    end
    normaltex = basefilename .. "_normals.dds"
    if (not VFS.FileExists(normaltex)) then
      normaltex = nil
    end
  end --if FileExists ]] -- disable tex2 detection for S44

  return normaltex
end



for i, udef in pairs(FeatureDefs) do
  local modeltype = udef.modeltype or udef.model.type
  if (udef.customParams.normaltex and VFS.FileExists(udef.customParams.normaltex)) then
    unitMaterials[udef.name] = {"normalMappedS3o", NORMALTEX = udef.customParams.normaltex}

  elseif (udef.customParams.normaltex == "") then
    unitMaterials[udef.name] = {"normalModelledS3o"}

  elseif (modeltype == "s3o") then
    local modelpath = udef.modelpath or udef.model.path
    if (modelpath and VFS.FileExists(modelpath)) then
      --// udef.model.textures is empty at gamestart, so read the texture filenames from the s3o directly

      local rawstr = VFS.LoadFile(modelpath)
      local header = rawstr:sub(1,60)
      local texPtrs = VFS.UnpackU32(header, 45, 2)
      local tex1,tex2
      if (texPtrs[2] > 0)
        then tex2 = "unittextures/" .. rawstr:sub(texPtrs[2]+1, rawstr:len()-1)
        else texPtrs[2] = rawstr:len() end
      if (texPtrs[1] > 0)
        then tex1 = "unittextures/" .. rawstr:sub(texPtrs[1]+1, texPtrs[2]-1) end

      -- output units without tex2
      --[[if not tex2 then
        Spring.Echo("CustomUnitShaders: " .. udef.name .. " no tex2")
      end]]

      local normaltex = FindNormalmap(tex1,tex2)
      if (normaltex and not unitMaterials[udef.name]) then
        Spring.Log('Custom Unit Shaders',
          LOG.WARNING,
          'Please, manually set the attribute customParams.normaltex="' .. normaltex .. '" to feature ' .. udef.name)
        unitMaterials[udef.name] = {"normalMappedS3o", NORMALTEX = normaltex}
      else
        Spring.Log('Custom Unit Shaders',
          LOG.WARNING,
          'Please, manually set the attribute customParams.normaltex="" to feature ' .. udef.name)
        unitMaterials[udef.name] = {"normalModelledS3o"}
      end
    end --if model

  elseif (modeltype == "obj") then
    local modelinfopath = udef.modelpath or udef.model.path
    if (modelinfopath) then
      modelinfopath = modelinfopath .. ".lua"

      if (VFS.FileExists(modelinfopath)) then
        local infoTbl = Include(modelinfopath)
        if (infoTbl) then
          local tex1 = "unittextures/" .. (infoTbl.tex1 or "")
          local tex2 = "unittextures/" .. (infoTbl.tex2 or "")

          -- output units without tex2
          --[[if not tex2 then
            Spring.Echo("CustomUnitShaders: " .. udef.name .. " no tex2")
          end]]

          local normaltex = FindNormalmap(tex1,tex2)
          if (normaltex and not unitMaterials[udef.name]) then
            Spring.Log('Custom Unit Shaders',
              LOG.WARNING,
              'Please, manually set the attribute customParams.normaltex="' .. normaltex .. '" to feature ' .. udef.name)
            unitMaterials[udef.name] = {"normalMappedS3o", NORMALTEX = normaltex}
          else
            Spring.Log('Custom Unit Shaders',
              LOG.WARNING,
              'Please, manually set the attribute customParams.normaltex="" to feature ' .. udef.name)
            unitMaterials[udef.name] = {"normalModelledS3o"}
          end
        end
      end
    end

  end --elseif
end --for

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return materials, unitMaterials

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
