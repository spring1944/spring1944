function widget:GetInfo() 
	return {
		name = "Automatically enable los",
		desc = "Make sure we can see what's going on",
		author = "ashdnazg",
		date = "19 May 21015",
		license = "GNU GPL, v2 or later",
		layer = 1,
		enabled = true
	}
end

function widget:GameFrame()
	if Spring.GetMapDrawMode() ~= "los" then
		Spring.SendCommands('togglelos')
	end
	WG.RemoveWidget(self)
end
