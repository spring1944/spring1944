function widget:GetInfo()
	return {
		name = "1944 Anti-spam",
		desc = "Filters out 'can't reach destination' messages",
		author = "B. Tyler",
		date = "29 January 2009",
		license = "CC-BY-NC",
		layer = 1,
		enabled = true
	}
end

function widget:GameStart()
	Spring.SendCommands("movewarnings 0")
end