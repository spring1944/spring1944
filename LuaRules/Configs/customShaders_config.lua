-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local GADGET_DIR = "LuaRules/Configs/"
local materials = {
   copyEngineS3o = {
      shader = include(GADGET_DIR .. "UnitShaders/default.lua"),
      usecamera   = false,
      culling     = GL.BACK,
      texunits    = {
        [0] = '%%UNITDEFID:0',
        [1] = '%%UNITDEFID:1',
        [2] = '$shadow',
        [3] = '$specular',
        [4] = '$reflection',
      },
   },
   normalMappedS3o = {
      shaderDefinitions = {
        "#define use_normalmapping",
        --"#define flip_normalmap",
      },
      shader = include(GADGET_DIR .. "UnitShaders/default.lua"),
      usecamera   = false,
      culling     = GL.BACK,
      texunits    = {
        [0] = '%%UNITDEFID:0',
        [1] = '%%UNITDEFID:1',
        [2] = '$shadow',
        [3] = '$specular',
        [4] = '$reflection',
        [5] = '%NORMALTEX',
      },
   },
}

local unitMaterials = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Automated normalmap detection

for i=1,#UnitDefs do
  local udef = UnitDefs[i]

  if (udef.customParams.normaltex and VFS.FileExists(udef.customParams.normaltex)) then
    unitMaterials[udef.name] = {"normalMappedS3o", NORMALTEX = udef.customParams.normaltex}

  elseif (udef.model.type == "s3o") then
    local model = udef.model.path
    if (model) then
      --// udef.model.textures is empty, so read the texture filenames from the s3o directly
      --// some s3o data struct info:
      --// the texture informations is saved right at the end of the file, in the form:
      --// ...\000texture1_filename\000texture2_filename\000EOF

      local rawstr = VFS.LoadFile(udef.model.path)
      local header = rawstr:sub(1,60)
      local texPtrs = VFS.UnpackU32(header, 45, 2)
      local tex1,tex2
      if (texPtrs[1] > 0)
        then tex1 = "unittextures/" .. rawstr:sub(texPtrs[1]+1) end
      if (texPtrs[2] > 0)
        then tex2 = "unittextures/" .. rawstr:sub(texPtrs[2]+1) end

      --// check if there is a corresponding _normals.dds file for tex1, original CA gadget checks for tex2 if none found for tex1
      if (VFS.FileExists(tex1)) then
	    -- strip non-printable chars (and tex2 filename!) off the string
		tex1 = tex1:sub(1,tex1:find("[^%w%p]") - 1)
        local basefilename = tex1:sub(1,-5)--:gsub("%....","")
        if (tonumber(basefilename:sub(-1,-1))) then
          basefilename = basefilename:sub(1,-2)
        end
        if (basefilename:sub(-1,-1) == "_") then
          basefilename = basefilename:sub(1,-2)
        end
        local normaltex = basefilename .. "_normals.dds"
        if (VFS.FileExists(normaltex)) then
          unitMaterials[udef.name] = {"normalMappedS3o", NORMALTEX = normaltex}
		  --Spring.Echo("Normal map '".. normaltex .. "' found for " ..udef.name)
        end
      end --if FileExists
    end --if model
  end --elseif
end --for

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return materials, unitMaterials

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
