function gadget:GetInfo()
	return {
		name = "Increasing Flag Returns",
		desc = "Increases the output of metal extractors according to how long they've been alive",
		author = "Nemo (B. Tyler)",
		date = "2008-03-06",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local flags = {}

local function OutputCalc(lifespan, defaultOutput)
	output = (defaultOutput * 1.1^lifespan)
		print("output", output)
	return output
end

function gadget:GameFrame(t)

	if (((t+250) % 31) < 0.1) then
		for u in pairs(flags) do
		local defaultOutput = tonumber(flags[u].defaultOutput)
		local lifespan = flags[u].lifespan
		print("defaultOutput", defaultOutput)
		lifespan = lifespan + 1
		print("lifespan", lifespan)
		--call a local function to determine output
		OutputCalc(lifespan, defaultOutput)

			if (output < 3*(defaultOutput)) then
			Spring.SetUnitMetalExtraction (u, output)	
			end
		flags[u].lifespan = lifespan
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local u = unitID
	local ud = UnitDefs[unitDefID]
	if (ud.customParams.flag == '1') then
	print("add flag")
	flags[u] = {
      lifespan = 0,
	  defaultOutput = ud.extractsMetal 
    }
	end
end


function gadget:UnitDestroyed(u) -- you can omit unneeded arguments if they
  flags[u] = nil              -- are at the end
end

else

--UNSYNCED

return false
end
