function gadget:GetInfo()
  return {
    name = "Logistics Supply",
    desc = "Adds supplies to a team on a fixed schedule",
    author = "Nemo (B. Tyler)",
    date = "2008-03-07",
    license = "CC-BY-NC",
    layer = 1,
    enabled = true
  }
end

if not gadgetHandler:IsSyncedCode() then return end
--synced only

local modOptions = Spring.GetModOptions()
local resupplyPeriod = (tonumber(modOptions.logistics_period) or 450) * 30
Spring.SetGameRulesParam("resupplyPeriod", resupplyPeriod)

local AddTeamResource = Spring.AddTeamResource
local GetTeamList = Spring.GetTeamList

function gadget:GameFrame(n)
  if n % resupplyPeriod < 0.1 then
    local allTeams = GetTeamList()
    for i = 1, #allTeams do
      AddTeamResource(allTeams[i], "e", 1e6)
    end
  end
end
