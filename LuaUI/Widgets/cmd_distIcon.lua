function widget:GetInfo()
	return {
		name = "1944 Icon Distance",
		desc = "Sets Icon Distance to a suitable level for Spring: 1944",
		author = "Craig Lawrence",
		date = "09-12-2008",
		license = "Public Domain",
		layer = 1,
		enabled = false
	}
end

function widget:Initialize()
	Spring.SendCommands("disticon 200")
end
