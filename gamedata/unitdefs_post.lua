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

local function tobool(val)
  local t = type(val)
  if (t == 'nil') then
    return false
  elseif (t == 'boolean') then
    return val
  elseif (t == 'number') then
    return (val ~= 0)
  elseif (t == 'string') then
    return ((val ~= '0') and (val ~= 'false'))
  end
  return false
end


	if (modOptions.unit_los_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.sightdistance) then
			ud.sightdistance = (modOptions.unit_los_mult * ud.sightdistance)
			end
		end
	end
	
		for name, ud in pairs(UnitDefs) do
			if (ud.customparams) then
				if (ud.customparams.weaponcost) then
				ud.customparams.weaponcost = (2 * ud.customparams.weaponcost)
				end
				if (ud.customparams.arrivalgap) then
				ud.customparams.arrivalgap = (0.5 * ud.customparams.arrivalgap)
				end
			end
		end
	
	if (modOptions.unit_speed_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.maxvelocity) then
			ud.maxvelocity = (modOptions.unit_speed_mult * ud.maxvelocity)
			ud.acceleration = (modOptions.unit_speed_mult * ud.acceleration)
			end
		end
	end
	
	if (modOptions.unit_metal_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.extractsmetal) then
			ud.extractsmetal = (modOptions.unit_metal_mult * ud.extractsmetal)
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
	