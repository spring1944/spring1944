function widget:GetInfo()
	return {
		name = "Engine compatibility",
		desc = "Exits if Spring engine version used is not supported",
		author = "raaar, ThinkSome adapted for s44 and added Chili",
		version   = "1.0",
		date = "20190428",
		license = "GNU AGPLv3",
		layer = 999999,
		enabled = true,
	}
end


local allowedEngineVersion = "103"
local allowedEngineVersionDesc = "Spring 103 (103.0)"
local countdown = 10


local currentEngineVersion = "???"
local isAllowedEngineVersion = false
local Chili, Screen0
local errorWindow, errorLabel
local errorMessage


function widget:Initialize()
	if Engine and Engine.version then
		currentEngineVersion = Engine.version
	elseif Game and Game.version then
		currentEngineVersion = Game.version
	end

	if currentEngineVersion == allowedEngineVersion then
		isAllowedEngineVersion = true
	end

	if isAllowedEngineVersion then
		widgetHandler:RemoveWidget()
		return
	end

	errorMessage = "Error: unsupported Spring Engine version detected (" .. currentEngineVersion .. ").\n"
	             .. "Please use " .. allowedEngineVersionDesc .. " instead."

	if not WG.Chili then
		Spring.Echo("Error: Chili not found!")
		return
	end

	Chili = WG.Chili
	Screen0 = Chili.Screen0

	errorWindow = Chili.Window:New{
	  parent = Screen0,
	  x = '30%',
	  y = '20%',
	  width = '40%',
	  height = '10%',
	}

	errorLabel = Chili.Label:New{
	  parent = errorWindow,
	  width = '100%',
	  height = '100%',
	  caption = errorMessage,
	  font = {
	    size = 16,
	    color = {1,0.2,0.2,1},
	  }
	}
end


function widget:GameFrame(n)
	if n % 60 == 8 then
		countdown = countdown - 1
		local exitMessage = "Exiting in " .. countdown .. "..."

		Spring.Echo(errorMessage)
		Spring.Echo(exitMessage)
		if errorLabel then
			errorLabel:SetCaption(errorMessage .. "\n" .. exitMessage)
		end

		if countdown == 0 then
			Spring.SendCommands("QuitForce")
		end
	end
end
