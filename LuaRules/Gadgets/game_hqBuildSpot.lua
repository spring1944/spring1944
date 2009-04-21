function gadget:GetInfo()
	return {
		name      = "HQ unit ID informer",
		desc      = "Tells HQ scripts which build platter to use",
		author    = "Nemo/B.Tyler",
		date      = "14th April, 2009",
		license   = "PD",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end
if (gadgetHandler:IsSyncedCode()) then
	function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
		local ud = UnitDefs[unitDefID]
		if builderID then
			local builderDefID = Spring.GetUnitDefID(builderID)
			local bud = UnitDefs[builderDefID]
			local buildPlace
			if (bud.customParams.separatebuildspot) then
				if (ud.customParams.buildoutside) then
					buildPlace = 1
				else
					buildPlace = 0
				end
			Spring.CallCOBScript(builderID, "pickPlace", 0, buildPlace)
			end
		else
			return
		end
	end	
else
end
