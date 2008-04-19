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

if (modOptions) then
 if (modOptions.weapon_range_mult) then
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
  if (modOptions.weapon_reload_mult) then
	local totalWeapons
	totalWeapons = 0
	local reloadCoeff
	reloadCoeff = modOptions.weapon_reload_mult
	Spring.Echo("Starting weapon reload multiplying, coefficient: "..reloadCoeff)
	for name in pairs(WeaponDefs) do
		local curReload = WeaponDefs[name].reloadtime
		local id = WeaponDefs[name].id
		if (curReload) and (id > 9) and (id ~= 301) then
			WeaponDefs[name].reloadtime = curReload * reloadCoeff
			totalWeapons = totalWeapons + 1
		end
	end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------