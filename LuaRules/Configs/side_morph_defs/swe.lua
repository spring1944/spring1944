local sweDefs = {
-- Upgrade Defs
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
	},	
	gbrvehicleyard = {
		{
			into = 'gbrvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	gbrgunyard = {
		{
			into = 'gbrspyard',
			metal = 3000,
			energy = 0,
			time = 85,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'gbrspyard1',
			metal = 5250,
			energy = 0,
			time = 150,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},	
	gbrtankyard = {
		{
			into = 'gbrtankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
	
		{
			into = 'gbrtankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	
	gbrboatyard = {
		{
			into = 'gbrboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing  \n  Fire  \n  Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	  -- Machineguns
  
  gbrvickers =
  {
    into = 'gbrvickers_sandbag',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gbrvickers_sandbag =
  {
    into = 'gbrvickers',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },]]
    -- Towed Guns
  swepvkanm43_truck = 
  {
    into = 'swepvkanm43_stationary',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
    directional = true,
  },

  swepvkanm43_stationary = 
  {
    into = 'swepvkanm43_truck',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
  },
  
  --[[gbr25pdr_truck = 
  {
    into = 'gbr25pdr_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },

  gbr25pdr_stationary = 
  {
    into = 'gbr25pdr_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },]]
  
  sweboforsm36_truck =
  {
    into = 'sweboforsm36_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  sweboforsm36_stationary =
  {
    into = 'sweboforsm36_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  -- Trucks / Trucksupplies
  --[[gbrbedfordtruck =
  {
    into = 'gbrtrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
	
  gbrtrucksupplies =
  {
    into = 'gbrbedfordtruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
-- Pontoon trucks  
    gbrpontoontruck =
  {
    into = 'gbrboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },]]
}

return sweDefs
