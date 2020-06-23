function widget:GetInfo()
    return {
        name = "lobby2game",
        desc = "Controls lobby-game interoperatibility",
        author = "Jose Luis Cercos-Pita",
        date = "2020-06-01",
        license = "GPL v2",
        layer = 0,
        experimental = false,
        enabled = true,
    }
end 

WG.LOBBY2GAME = {
    -- We assume the game has been launched as standalone, in the traditional
    -- springlobby way
    launched_by_lobby = false,
}

function widget:GetConfigData()
    return {
        -- No matters what the configuration says, we want to reset the variable
        -- to its original false state
        launched_by_lobby = WG.LOBBY2GAME.launched_by_lobby,
    }
end

function widget:SetConfigData(data)
    if data.launched_by_lobby ~= nil then
        WG.LOBBY2GAME.launched_by_lobby = data.launched_by_lobby
    end
end
