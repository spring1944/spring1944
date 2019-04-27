function widget:GetInfo()
	return {
		name = "Engine compatibility",
		desc = "Exits if Spring engine version used is not supported",
		author = "raaar, adapted for s44 by ThinkSome",
		version   = "1.0",
		date = "20190428",
		license = "PD",
		layer = 999999,
		enabled = true,
	}
end


local allowedEngineVersion = "103"
local allowedEngineVersionDesc = "Spring 103 (103.0)"
local countdown = 10


local currentEngineVersion = "???"
local isAllowedEngineVersion = false


function widget:Initialize()
	if Engine and Engine.version then
		currentEngineVersion = Engine.version
	elseif Game and Game.version then
		currentEngineVersion = Game.version
	end

	if currentEngineVersion == allowedEngineVersion then
		isAllowedEngineVersion = true
	end
end


function widget:GameFrame(n)
	if n % 60 == 8 then
		if isAllowedEngineVersion then
			widgetHandler:RemoveWidget()
		else
			Spring.Echo("Error: unsupported Spring Engine version detected (" .. currentEngineVersion
			  .. "). Please use " .. allowedEngineVersionDesc .. " instead.")
			countdown = countdown - 1
			Spring.Echo("Exiting in " .. countdown .. "...")
			if countdown == 0 then
				Spring.SendCommands("QuitForce")
			end
		end
	end
end
