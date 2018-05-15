function widget:GetInfo()
  return {
    name      = "Camera Remember",
    desc      = "Remembers the camera mode",
    author    = "Silentwings",
    date      = "April 1st",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true,
  }
end

local camName
local defaultCamName = 'ta'

function GetModeFromName(name)
    local camNames = Spring.GetCameraNames()
    return camNames[name]
end

-- Apparently, the persistent camera view mode causes troubles. See
-- https://github.com/spring1944/spring1944/issues/305
-- So now we are just using the default taview camera. Not even considering to
-- save/load the setting
-- function widget:SetConfigData(data)
--     camName = data and data.name or defaultCamName
-- end
camName = defaultCamName

function widget:Initialize()
    --Spring.Echo("wanted", camName)
    if camName then
        local camState = Spring.GetCameraState()
        camState.name = camName
        camState.mode = GetModeFromName(camName)
        --Spring.Echo("set", camName, camState.mode)
        Spring.SetCameraState(camState, 0)
    end
end

-- function widget:GetConfigData()
--     local camState = Spring.GetCameraState()
--     local data = {}
--     data.name = camState.name
--     --Spring.Echo("saved", data.name, camState.mode)
--     return data
-- end

