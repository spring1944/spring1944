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

local function copytable(input, output)
	for k,v in pairs(input) do
		if type(v) == "table" then
			output[k] = {}
			copytable(v, output[k])
		else
			output[k] = v
		end
	end
end

--process ALL the units!

local GMBuildOptions = {}
local GM_UD

VFS.Include("gamedata/unitdefs_autogen.lua")

local sides = VFS.DirList("luarules/configs/side_squad_defs", "*.lua")

local ATMineSign = UnitDefs["atminesign"]
local APMineSign = UnitDefs["apminesign"]
local TankObstacle = UnitDefs["tankobstacle"]

for _, sideFile in pairs(sides) do
	local side = sideFile:sub(string.len("luarules/configs/side_squad_defs/")+1, -5)
	UnitDefs[side .. "atminesign"] = {}
	copytable(ATMineSign, UnitDefs[side .. "atminesign"])
	UnitDefs[side .. "apminesign"] = {}
	copytable(APMineSign, UnitDefs[side .. "apminesign"])
	UnitDefs[side .. "tankobstacle"] = {}
	copytable(TankObstacle, UnitDefs[side .. "tankobstacle"])
end

-- have to implement squad file preloading here, because it's needed for transport stuff
local squadDefs = VFS.Include("luarules/configs/squad_defs_loader.lua")

for name, ud in pairs(UnitDefs) do
	--MODOPTION CONTROLS
	if (modOptions) then	
		if (modOptions.scoremode) then
			if (modOptions.scoremode ~= 'disabled') then
				if (ud.customparams) then
					if (not ud.customparams.flagcaprate) then
						if (not ud.customparams.flag and ud.weapons ~= nil) then
							ud.customparams.flagcaprate = 1
						end
					end
				end
			end
		end		
		
		if (modOptions.command_mult) then
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

		if (modOptions.command_storage and (tonumber(modOptions.command_storage) > 0)) then
			if (ud.metalstorage) then
				ud.metalstorage = 0
			end
		end
	end

		--none of these have mod options that link to them atm
		--[[
		if (modOptions.maxammo_mult) then
			if (ud.customparams) then
				if (ud.customparams.maxammo) and (ud.weapons) then
					ud.customparams.maxammo = (modOptions.maxammo_mult * ud.customparams.maxammo)
				end
			end
		end

		if (modOptions.flankingmax_mult) then
			if (ud.flankingbonusmax) then
				ud.flankingbonusmax = (modOptions.flankingmax_mult * ud.flankingbonusmax)
			end
		end
		
		if (modOptions.flankingmin_mult) then
			if (ud.flankingbonusmin) then
				ud.flankingbonusmin = (modOptions.flankingmin_mult * ud.flankingbonusmin)
			end
		end
		
		if (modOptions.flankingmobility_mult) then
			if (ud.flankingbonusmobilityadd) then
				ud.flankingbonusmobilityadd = (modOptions.flankingmobility_mult * ud.flankingbonusmobilityadd)
			end
		end

		if (modOptions.unit_speed_mult) then
			if (ud.maxvelocity) then
				ud.maxvelocity = (modOptions.unit_speed_mult * ud.maxvelocity)
				ud.acceleration = (modOptions.unit_speed_mult * ud.acceleration)
			end
		end
		if (modOptions.unit_metal_mult) then
			if (ud.extractsmetal) then
				ud.extractsmetal = (modOptions.unit_metal_mult * ud.extractsmetal)
			end
		end
		]]--

 --END MODOPTION CONTROLS
 
 --BEGIN UNIT PROCESSING	
	local LoSMult = 0.6
    local decloakDistMult = 0.6
    local infSpeedMult = 0.5

    --sets base values for detection radii
    --index 1 = los, 2 = airlos, 3 = radar, 4 = seismic
    local detection = {
        INFANTRY    = {650, 2000, 650, 1400},
        SOFTVEH     = {300, 2000, 950, 0},
        OPENVEH     = {300, 2000, 1250, 0},
        HARDVEH     = {150, 1000, 650, 0},
        SHIP        = {400, 2500, 950, 0},
        DEPLOYED    = {650, 2000, 650, 1400},
    }

    --set detection values per unit category (with some special casing for
    --cloaked inf)
    ud.activatewhenbuilt = true
    for category, detectValues in pairs(detection) do
        local catStart, catEnd = string.find(ud.category, category);
        if catStart ~= nil then
            local cat = string.sub(ud.category, catStart, catEnd)
            if detection[cat] then
                ud.sightdistance = detection[cat][1] * LoSMult
                ud.airsightdistance = detection[cat][2] * LoSMult
                ud.radardistance = detection[cat][3] * LoSMult
                ud.seismicdistance = detection[cat][4] * LoSMult
                if ud.cloakcost then
                    ud.sightdistance = ud.sightdistance * 0.5
                    ud.radardistance = 0
                end
            end
        end
    end
    

	if ud.customparams then
		if ud.customparams.feartarget then
			if (ud.maxvelocity) then
				ud.maxvelocity = ud.maxvelocity * infSpeedMult
			end
		end
	end
	if ud.mincloakdistance then
		ud.mincloakdistance = ud.mincloakdistance * decloakDistMult
	end


	--new sensor stuff!
    --set radar/LoS for infantry (the only units with seismic distances)
    --[[
	if (ud.seismicdistance) and (tonumber(ud.seismicdistance) > 0) then
		if tonumber(ud.sightdistance ) > 600 then
			ud.sightdistance = 650 * LoSMult
			ud.radardistance = 950 * LoSMult
		else
			ud.radardistance = 800 * LoSMult
		end
		ud.seismicdistance = 1400 * LoSMult
		--slightly hackish; works out so that all cloaked units don't get radar
		--but observs get it while decloaked.
		if ud.cloakcost == nil then
			ud.activatewhenbuilt = true
		end

	end

    ]]--
	--end first chunk of new sensor stuff!
	
	--more new sensor stuff
    --decide if stationary units should be stealth or not
	if not ud.maxvelocity then
		ud.stealth = false
		if (ud.customparams) then
			if (ud.customparams.hiddenbuilding == '1') then
			    ud.stealth = true
			end
		end
	end
	--end more new sensor stuff
	
    --ship things
	if ud.floater then
		ud.turninplace = false
		ud.turninplacespeedlimit = (tonumber(ud.maxvelocity) or 0) * 0.5
		--new sensor stuff
		ud.stealth = false
		--end new sensor stuff
	end
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
	-- ammo users, add ammo-related description
	if (ud.customparams) then
		if (ud.customparams.weaponcost) and (ud.customparams.maxammo) then
			local newDescrLine = "max. ammo: "..ud.customparams.maxammo..", log. per shot: "..ud.customparams.weaponcost..", total: "..(ud.customparams.weaponcost*ud.customparams.maxammo)
			if not (ud.description) then
				ud.description = newDescrLine
			end
			ud.description = ud.description.." ("..newDescrLine..")"
			
		end
		if ud.customparams.armor_front and (tonumber(ud.maxvelocity) or 0) > 0 then
			ud.usepiececollisionvolumes = true
		end
	end
	-- Make all vehicles push resistant, except con vehicles, so they vacate build spots
	if tonumber(ud.maxvelocity or 0) > 0 and (not ud.canfly) and tonumber(ud.footprintx) > 1 and (not ud.builder) then
		ud.pushresistant = true
		--new sensor stuff
		ud.stealth = false
		ud.activatewhenbuilt = true
		--end new sensor stuff
		
		--local seisSig = tonumber(ud.mass) / 1000 -- 10x smaller than default
		--if seisSig < 1 then seisSig = 1 end
		ud.seismicsignature = 1 --seisSig
		
		--set health
		local powerBase = modOptions.power_base or 3.25
		local scaleFactor = modOptions.scale_factor or 50
		local logMass = math.log10(ud.mass) or 999 --a crazy default value so we see it when it happens
		ud.maxdamage = (powerBase ^ logMass)*scaleFactor
		--Spring.Echo(name, "changed health to", ud.maxdamage)
	end

	if (modOptions.unit_los_mult) then
		if ud.sightdistance then
			ud.sightdistance = (modOptions.unit_los_mult * ud.sightdistance)
		end
--		if ud.radardistance then
--			ud.radardistance = (modOptions.unit_los_mult * ud.radardistance)
--		end
		if ud.seismicdistance then
			ud.seismicdistance = (modOptions.unit_los_mult * ud.seismicdistance)
		end			
	end
	if (modOptions.unit_radar_mult) then
		if ud.radardistance then
			ud.radardistance = (modOptions.unit_radar_mult * ud.radardistance)
		end
	end
	
	ud.transportbyenemy = false
	ud.collisionvolumetest = 1

	-- transport squad stuff
	-- units which bring other units into game with them should have their cost and buildtime increased accordingly
	if ud.customparams and ud.customparams.transportsquad then
		--Spring.Echo("Unit with built-in cargo squad: "..ud.name)
		local squadName = ud.customparams.transportsquad
		if squadName then
			local squadDef = squadDefs[squadName]
			if squadDef then
				local addedCost = 0
				for i, unitName in ipairs(squadDef.members) do
					local newUD = UnitDefs[unitName]
					if newUD then
						addedCost = addedCost + newUD.buildcostmetal
					end
				end
				--Spring.Echo("Total squad cost: "..addedCost)
				if addedCost > 0 then
					ud.buildcostmetal = ud.buildcostmetal + addedCost
					ud.buildtime = ud.buildcostmetal
					Spring.Echo("Added cargo cost to transport: "..ud.name.." +"..addedCost)
				end
			else
				Spring.Echo("Squad def name not found in loaded table: "..squadName)
			end
		else
			Spring.Echo("Squad unit not found in squad def files: "..squadName)
		end
	end
	
	-- add the unit to gamemaster buildoptions
	GMBuildOptions[#GMBuildOptions + 1] = name
	if name == "gmtoolbox" then GM_UD = ud end
end

GM_UD["buildoptions"] = GMBuildOptions

VFS.Include("gamedata/unitdefs_post_dependency.lua")
