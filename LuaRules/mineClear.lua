function ClearMines(unitID, unitDefID, teamID, radius)
	-- disarm all the mines in a given radius from the calling unit
	local x, y, z
	local tmpNearbyUnits={}
	x, y, z = Spring.GetUnitPosition(unitID)
	tmpNearbyUnits = Spring.GetUnitsInSphere(x, y, z, radius)
	for _, tmpUnitID in pairs(tmpNearbyUnits) do
		-- check if that is a mine
		local tmpUD
		tmpUD = Spring.GetUnitDefID(tmpUnitID)
		tmpUnitDef=UnitDefs[tmpUD]
		if tmpUnitDef then
			if tmpUnitDef.customParams then
				if tonumber(UnitDefs[tmpUD].customParams.ismine) == 1 then
					-- remove this unit (maybe needs a special anim?)
					local px, py, pz = Spring.GetUnitPosition(tmpUnitID)
					Spring.DestroyUnit(tmpUnitID, false, true)
					Spring.SpawnCEG("HE_Small", px, py, pz)
					Spring.RemoveBuildingDecal(tmpUnitID)
				end
			end
		end
	end
end
