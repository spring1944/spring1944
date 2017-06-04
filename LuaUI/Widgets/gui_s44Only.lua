function widget:GetInfo()
	return {
		name = "1944 Widgets Only",
		desc = "Turns off non-S44 widgets",
		author = "FLOZi (C. Lawrence)",
		date = "16 January 2012",
		license = "GNU GPL v2",
		layer = 1,
		enabled = false,
		handler = true,
	}
end

function widget:Initialize()
	Spring.Echo("S44 Widgets Only disabling non-S44 widgets...")
	for name,data in pairs(widgetHandler.knownWidgets) do
		if not data["fromZip"] then 
			widgetHandler:DisableWidget(name) 
		end
	end
end