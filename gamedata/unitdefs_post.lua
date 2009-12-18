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

if (modOptions and (modOptions.gametype == "1")) then
  -- remove all build options
  Game = { gameSpeed = 30 };  --  required by tactics.lua
  local options = VFS.Include("LuaRules/Configs/tactics.lua")
  local customBuilds = options.customBuilds
  for name, ud in pairs(UnitDefs) do
    if tobool(ud.commander) then
      ud.buildoptions = (customBuilds[name] or {}).allow or {}
    else
      ud.buildoptions = {}
    end
  end
end

	--[[if (modOptions and modOptions.unit_los_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.sightdistance) then
			ud.sightdistance = (modOptions.unit_los_mult * ud.sightdistance)
			end
		end
	end]]--

	if (modOptions and modOptions.maxammo_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.customparams) then
				if (ud.customparams.maxammo) and (ud.weapons) then
				ud.customparams.maxammo = (modOptions.maxammo_mult * ud.customparams.maxammo)
				end
			end
		end
	end

	if (modOptions and modOptions.flankingmax_mult) then
		for name, ud in pairs(UnitDefs) do
				if (ud.flankingbonusmax) then
				ud.flankingbonusmax = (modOptions.flankingmax_mult * ud.flankingbonusmax)
				end
		end
	end
	
	if (modOptions and modOptions.flankingmin_mult) then
		for name, ud in pairs(UnitDefs) do
				if (ud.flankingbonusmin) then
				ud.flankingbonusmin = (modOptions.flankingmin_mult * ud.flankingbonusmin)
				end
		end
	end
	
	if (modOptions and modOptions.flankingmobility_mult) then
		for name, ud in pairs(UnitDefs) do
				if (ud.flankingbonusmobilityadd) then
				ud.flankingbonusmobilityadd = (modOptions.flankingmobility_mult * ud.flankingbonusmobilityadd)
				end
		end
	end
	--[[	for name, ud in pairs(UnitDefs) do
			if (ud.customparams) then
				if (ud.customparams.weaponcost) then
				ud.customparams.weaponcost = (2 * ud.customparams.weaponcost)
				end
			end
		end]]--

	--[[if (modOptions and modOptions.unit_speed_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.maxvelocity) then
			ud.maxvelocity = (modOptions.unit_speed_mult * ud.maxvelocity)
			ud.acceleration = (modOptions.unit_speed_mult * ud.acceleration)
			end
		end
	end]]--

	if (modOptions and modOptions.command_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.extractsmetal) then
				if (modOptions.command_mult == '0') then --Very Low Command
				ud.extractsmetal = (0.25 * ud.extractsmetal)
				end
				if (modOptions.command_mult == '1') then --Low Command
				ud.extractsmetal = (0.5 * ud.extractsmetal)
				end
				if (modOptions.command_mult == '2') then --Normal Command
				ud.extractsmetal = (1 * ud.extractsmetal)
				end
				if (modOptions.command_mult == '3') then --High Command
				ud.extractsmetal = (1.5 * ud.extractsmetal)
				end
				if (modOptions.command_mult == '4') then --Very High Command
				ud.extractsmetal = (2.5 * ud.extractsmetal)
				end
			end
		end
	end

	--[[if (modOptions and modOptions.unit_metal_mult) then
		for name, ud in pairs(UnitDefs) do
			if (ud.extractsmetal) then
			ud.extractsmetal = (modOptions.unit_metal_mult * ud.extractsmetal)
			end
		end
	end]]--

	if (modOptions and modOptions.command_storage and (tonumber(modOptions.command_storage) > 0)) then
		for name, ud in pairs(UnitDefs) do
			if (ud.metalstorage) then
				ud.metalstorage = 0
			end
		end
	end

--[[
	if (modOptions and (modOptions.unit_buildable_airfields == 0)) then
		disableunits({usairfield", "gbrairfield", "gerairfield", "RUSAirfield"})
	end

	if (modOptions and (modOptions.unit_hq_platoon == 1)) then
		disableunits({"us_platoon_hq", "us_platoon_rifle", "us_platoon_assault", "gbr_platoon_hq", "gbr_platoon_rifle", "gbr_platoon_assault", "ger_platoon_hq", "ger_platoon_rifle", "ger_platoon_assault", "rus_platoon_rifle", "rus_platoon_assault"})
	end

	if (modOptions and (modOptions.unit_hq_platoon == 0)) then
		disableunits({"us_platoon_hq_rifle", "us_platoon_hq_assault", "gbr_platoon_hq_rifle", "gbr_platoon_hq_assault", "ger_platoon_hq_rifle", "ger_platoon_hq_assault", "rus_platoon_big_rifle", "rus_platoon_big_assault"})
	end


if (modOptions and (unit_buildable_airfields == 1)) then
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

-- adjust descriptions
for name, ud in pairs(UnitDefs) do
	-- ammo storage
	if (ud.energystorage) then
		-- this is to exclude things like builders having 0.01 storage
		if tonumber(ud.energystorage)>1 then
			if not (ud.description) then
				ud.description = "log. storage: "..ud.energystorage
			end
			ud.description = ud.description.." (log. storage: "..ud.energystorage..")"
		end
	end
	-- ammo users
	if (ud.customparams) then
		if (ud.customparams.weaponcost) and (ud.customparams.maxammo) then
			local newDescrLine = "max. ammo: "..ud.customparams.maxammo..", log. per shot: "..ud.customparams.weaponcost..", total: "..(ud.customparams.weaponcost*ud.customparams.maxammo)
			if not (ud.description) then
				ud.description = newDescrLine
			end
			ud.description = ud.description.." ("..newDescrLine..")"
			
		end
	end
end