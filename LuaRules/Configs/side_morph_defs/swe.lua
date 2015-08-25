local sweDefs = {
-- Upgrade Defs
	swevolvotvc = {
		{
			into = 'swegunyard',
			tech = 0,
			time = 20,
			metal = 200,
			energy = 0,
			facing = true,
		},
		{
			into = 'swevehicleyard',
			tech = 0,
			time = 20,
			metal = 2800,
			energy = 0,
			facing = true,
		},
		{
			into = 'swetankyard',
			tech = 0,
			time = 40,
			metal = 6250,
			energy = 0,
			facing = true,
		},
	},
		--[[gbrstorage = {
		{
			into = 'gbrstoragecamo',
			metal = 1000,
			energy = 0,
			time = 25,
			name = '  Camo  ',
			text = 'Hides the storage shed from observation.',
			facing = true,
		},
	},	]]
	swevehicleyard = {
		{
			into = 'swevehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},
	swevehicleyard1 = {
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},
	swegunyard = {
		{
			into = 'swespyard',
			metal = 3000,
			energy = 0,
			time = 85,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'swespyard1',
			metal = 5250,
			energy = 0,
			time = 150,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},	
	swespyard = {
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},
	swespyard1 = {
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},
	swetankyard = {
		{
			into = 'swetankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},
	swetankyard1 = {
		{
			into = 'swevolvotvc',
			metal = 0,
			energy = 0,
			time = 20,
			name = '  Pack  \n  Up  ',
			facing = true,
		},
	},

	
	sweboatyard = {
		{
			into = 'sweboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing  \n  Fire  \n  Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	-- Machineguns
	
	swemg =
	{
		into = 'swemg_sandbag',
		tech = 0,
		time = 25,
		metal = 0,
		energy = 0,
		directional = true,
	},
	
	swemg_sandbag =
	{
		into = 'swemg',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
		-- Towed Guns
	swepvkanm43_truck = {
		{
			into = 'swepvkanm43_stationary',
			tech = 0,
			time = 5,
			metal = 0,
			energy = 0,
			directional = true,
		},
	},
	swepvkanm43_stationary = {
		{
			into = 'swepvkanm43_truck',
			tech = 0,
			time = 5,
			metal = 0,
			energy = 0,
		},
	},
	
	swekanonm02_33_truck =
	{
		into = 'swekanonm02_33_stationary',
		tech = 0,
		time = 25,
		metal = 0,
		energy = 0,
		directional = true,
	},
	swekanonm02_33_stationary =
	{
		into = 'swekanonm02_33_truck',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
  
	swehaubitsm39_truck = 
	{
		into = 'swehaubitsm39_stationary',
		tech = 0,
		time = 35,
		metal = 0,
		energy = 0,
		directional = true,
	},
	swehaubitsm39_stationary = 
	{
		into = 'swehaubitsm39_truck',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
	
	sweboforsm36_truck = {
		{
			into = 'sweboforsm36_stationary',
			tech = 0,
			time = 35,
			metal = 0,
			energy = 0,
		},
	},
	sweboforsm36_stationary = {
		{
			into = 'sweboforsm36_truck',
			tech = 0,
			time = 20,
			metal = 0,
			energy = 0,
		},
	},
	-- Trucks / Trucksupplies
	swescaniavabisf11 =
	{
		into = 'swetrucksupplies',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
		
	swetrucksupplies =
	{
		into = 'swescaniavabisf11',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
	-- Pontoon trucks  
		swepontoontruck =
	{
		into = 'sweboatyard',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
		facing = true,
	},
}
local newDefs = {}
for unitName, morphList in pairs(sweDefs) do
	for _, target in pairs(morphList) do
		if type(target) == "table" and target.into == "swevolvotvc" then
			local variantName = "swevolvotvc_" .. unitName
			target.into = variantName
			local variantMorphDef = {}
			local found = false
			for _, volvoTarget in pairs(sweDefs["swevolvotvc"]) do
				local variantTarget = {}
				for k, v in pairs(volvoTarget) do
					variantTarget[k] = v
				end
				if variantTarget.into == unitName then
					variantTarget.metal = 0
					variantTarget.time = 20
					found = true
				end
				table.insert(variantMorphDef, variantTarget)
			end
			if not found then
				table.insert(variantMorphDef, {
											into = unitName,
											tech = 0,
											time = 20,
											metal = 0,
											energy = 0,
											facing = true
										  })
			end
			newDefs[variantName] = variantMorphDef
		end
	end
end
for k, v in pairs(newDefs) do
	sweDefs[k] = v
end

return sweDefs
