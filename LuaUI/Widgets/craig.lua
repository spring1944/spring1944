function widget:GetInfo()
    return {
        name = "C.R.A.I.G.",
        desc = "Helpr for C.R.A.I.G. AI to can save configurations",
        author = "Jose Luis Cercos-Pita",
        date = "18/11/2020",
        license = "GNU LGPL, v2.1 or later",
        layer = 1,
        enabled = true,
    }
end

local function CraigGetConfigData(folder, fname, data)
    if Spring.CreateDir(folder) == false then
        Spring.Log("C.R.A.I.G.", LOG.WARNING, "Failure creating '" .. folder .. "' folder")
    end

    local fname = folder .. "/" .. fname
    local out = io.open(fname, "w")
    if out == nil then
        Spring.Log("C.R.A.I.G.", LOG.ERROR, "Failure writing '" .. fname .. "' folder")
        return
    end
    out:write("return " .. data)
    out:close()
end

function widget:Initialize()
   widgetHandler:RegisterGlobal("CraigGetConfigData", CraigGetConfigData)
end
