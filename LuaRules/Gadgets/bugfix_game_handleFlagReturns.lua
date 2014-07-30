function gadget:GetInfo()
	return {
		name = "Flag Returns bugfix",
		desc = "Just an almost empty gadget that fix a bug in gadgets.lua",
		author = "Szunti",
		date = "2011-09-01",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

function gadget:GameStart()
	--Spring.Echo("You don't see it because of a bug in gadgets.lua affecting RemoveGadget") -- actually, you do see it unless map_command_per_player is set!
end

else
end
