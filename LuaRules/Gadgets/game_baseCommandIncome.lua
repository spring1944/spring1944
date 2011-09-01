function gadget:GetInfo()
  return {
    name      = "Base Command Income",
    desc      = "Provides a base level of income for all teams",
    author    = "Nemo (B. Tyler",
    date      = "April 26th, 2009",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if (gadgetHandler:IsSyncedCode()) then

local team = {}

function gadget:Initialize()
	for _, teamID in ipairs(Spring.GetTeamList()) do
		team[teamID] = true
	end
end

function gadget:GameFrame(n)
	if (n % (1*32) < 0.1) then
		for teamID, someThing in pairs(team) do
			Spring.AddTeamResource(teamID, "m", 20)
		end
	end
end

else

end


