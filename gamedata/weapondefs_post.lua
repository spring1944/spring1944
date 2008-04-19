--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Range Multiplier
--

if (modOptions and modOptions.weapon_range_mult) then
	local totalWeapons
	totalWeapons = 0
	local rangeCoeff
	rangeCoeff = modOptions.weapon_range_mult
	Spring.Echo("Starting weapon range multiplying, coefficient: "..rangeCoeff)
	for name in pairs(WeaponDefs) do
		local curRange = WeaponDefs[name].range
		if (curRange) then
			WeaponDefs[name].range = curRange * rangeCoeff
			totalWeapons = totalWeapons + 1
		end
	end
	Spring.Echo("Done with the ranges, "..totalWeapons.." weapons processed.")
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
