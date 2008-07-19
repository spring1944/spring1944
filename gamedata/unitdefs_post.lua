--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function disableunits(unitlist)
	for name, ud in pairs(UnitDefs) do
	    if (ud.buildoptions) then
	      for _, toremovename in ipairs(unitlist) do
	        for index, unitname in pairs(ud.buildoptions) do
	          if (unitname == toremovename) then
	            table.remove(ud.buildoptions, index)
	          end
	        end
	      end
	    end	
	end
end

if (modOptions.unit_los_mult) then
	for name, ud in pairs(UnitDefs) do
		if (ud.sightdistance) then
		ud.sightdistance = (modOptions.unit_los_mult * ud.sightdistance)
		end
	end
end

if (modOptions.unit_buildable_airfields == 1) then
	disableunits({"usairfield", "gbrairfield", "gerairfield", "rusairfield"})
end
--