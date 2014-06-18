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
	local cp = ud.customParams
	if cp and cp.minetype then
		local x, y, z = Spring.GetUnitPosition(unitID)
		local warning = cp.minetype == "apminesign" and "AP Minefield!" or "AT Minefield!"
		Spring.MarkerAddPoint(x, y, z, warning)
	end
end
