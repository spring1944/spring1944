--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utility
--
if (modOptions.unit_los_mult) then
	for name, ud in pairs(UnitDefs) do
		if (ud.sightdistance) then
		ud.sightdistance = (modOptions.unit_los_mult * ud.sightdistance)
		end
	end
end
