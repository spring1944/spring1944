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
local timeLeft = 0

function gadget:GameFrame(t)
	if (t % (5*30) < 0.1) then
		for u in pairs(hq) do
			local arrivalGap = tonumber(hq[u].arrivalGap)
			if (t % (arrivalGap*30) < 0.1) then
				local refillAmount = tonumber(hq[u].refillAmount)
				local teamID = hq[u].teamID
				--print("refillAmount gameframe:", refillAmount)
				--print("arrivalGap gameframe:", arrivalGap)
				Spring.AddTeamResource (teamID, 'e', refillAmount)
				timeLeft = arrivalGap
			end
		end
	end
	if (t % 30 == 0) then
		if timeLeft > 0 then
			timeLeft = timeLeft - 1
		end
		SendToUnsynced(timeLeft)
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

local floor = math.floor

local uTimeLeft = 0
local vsx, vsy = gadgetHandler:GetViewSizes()

-- the 'f' suffixes are fractions  (and can be nil)
local color  = { 1.0, 1.0, 0.25 }
local xposf  = 0.5 --0.99
local xpos   = xposf * vsx
local yposf  = 0.010 --0.048 --0.032
local ypos   = yposf * vsy
local sizef  = 0.03 --0.015
local size   = sizef * vsy

function gadget:DrawScreen()
  gl.Color(color)
	local minutes = floor(uTimeLeft / 60)
	local seconds = uTimeLeft % 60
	local timeString = string.format('Resupply in: %02i:%02i', minutes, seconds)

	vsx, vsy = gl.GetViewSizes()
	xpos   = xposf * vsx
	ypos   = yposf * vsy
	size   = sizef * vsy
	gl.Text(timeString, xpos, ypos, size, "ocn")
end

function RecvFromSynced(...)
	uTimeLeft = arg[2]
end

--return false
end
