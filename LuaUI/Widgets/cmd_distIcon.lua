function widget:GetInfo()
	return {
		name = "1944 Icon Distance",
		desc = "Sets Icon Distance to a suitable level for Spring: 1944",
		author = "Craig Lawrence",
		date = "09-12-2008",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local unitIconDist = 0

function widget:Initialize()
	unitIconDist = Spring.GetConfigInt('UnitIconDist')
	Spring.SendCommands("disticon 250")
end

function widget:Shutdown()
	Spring.SetConfigInt('UnitIconDist', unitIconDist)
end
