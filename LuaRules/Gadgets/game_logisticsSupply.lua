function gadget:GetInfo()
	return {
		name = "Logistics Supply",
		desc = "Adds supplies to a team on a fixed schedule",
		author = "Nemo (B. Tyler)",
		date = "2008-03-07",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local hq = {}


function gadget:GameFrame(t)
    if (t % (5*30) < 0.1) then
	 for u in pairs(hq) do
	 local arrivalGap = tonumber(hq[u].arrivalGap)
	 	 if (t % (arrivalGap*30) < 0.1) then
			 local refillAmount = tonumber(hq[u].refillAmount)
			 local teamID = hq[u].teamID
			 print("refillAmount gameframe:", refillAmount)
			 print("arrivalGap gameframe:", arrivalGap)
			 Spring.AddTeamResource (teamID, 'e', refillAmount)
		 end
	 end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local u = unitID
	local ud = UnitDefs[unitDefID]
	if (ud.customParams.hq == '1') then
	print("add HQ", ud.customParams.hq, u)
	hq[u] = {
      refillAmount = ud.customParams.refillamount,
	  arrivalGap = ud.customParams.arrivalgap, 	
	  teamID = Spring.GetUnitTeam(u)	  
    }
	print("refillAmount spawn:", hq[u].refillAmount)
	print("arrivalGap spawn:", hq[u].arrivalGap)
	end
end


function gadget:UnitDestroyed(u) -- you can omit unneeded arguments if they
       hq[u] = nil       -- are at the end
end

else

--UNSYNCED

return false
end
