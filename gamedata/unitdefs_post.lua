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
--[[
	if (modOptions.unit_buildable_airfields == 0) then
		disableunits({usairfield", "gbrairfield", "gerairfield", "RUSAirfield"})
	end

	if (modOptions.unit_hq_platoon == 1) then
		disableunits({"us_platoon_hq", "us_platoon_rifle", "us_platoon_assault", "gbr_platoon_hq", "gbr_platoon_rifle", "gbr_platoon_assault", "ger_platoon_hq", "ger_platoon_rifle", "ger_platoon_assault", "rus_platoon_rifle", "rus_platoon_assault"})
	end

	if (modOptions.unit_hq_platoon == 0) then
		disableunits({"us_platoon_hq_rifle", "us_platoon_hq_assault", "gbr_platoon_hq_rifle", "gbr_platoon_hq_assault", "ger_platoon_hq_rifle", "ger_platoon_hq_assault", "rus_platoon_big_rifle", "rus_platoon_big_assault"})
	end
	
	
if modOptions and (unit_buildable_airfields == 1) then
	        for name, ud in pairs(UnitDefs) do
	            local unitname = ud.unitname
	                if unitname == "USgmcengvehicle" then
	                    table.insert(ud.buildoptions, 1, "usairfield")
	                end    
					if unitname == "rusk31" then
	                    table.insert(ud.buildoptions, 1, "rusairfield")
	                end  
					if unitname == "gersdkfz9" then
	                    table.insert(ud.buildoptions, 1, "gerairfield")
	                end  
					if unitname == "GBRMatadorEngVehicle" then
	                    table.insert(ud.buildoptions, 1, "GBRAirfield")
	                end  
            end
end]]--
	