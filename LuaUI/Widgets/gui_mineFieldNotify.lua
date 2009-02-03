function widget:GetInfo()
	return {
		name = "1944 Minefield Warning",
		desc = "Places a marker on friendly minefields",
		author = "B. Tyler",
		date = "2 Febuary 2009",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

function widget:UnitFinished(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	if (ud.name == "apminesign") then 
		local x, y, z = Spring.GetUnitPosition(unitID)
		Spring.MarkerAddPoint(x, y, z, "Anti-Personnel Minefield!")
	end
	if (ud.name == "atminesign") then 
		local x, y, z = Spring.GetUnitPosition(unitID)
		Spring.MarkerAddPoint(x, y, z, "Anti-Tank Minefield!")
	end
end
