local gerDefs = {
-- Upgrade Defs
   	gerstorage = {
		{
			into = 'gerstoragebunker',
			metal = 7500,
			energy = 0,
			time = 100,
			name = '  Bunker  ',
			text = 'Turns into a bunker.',
			facing = true,
		},
	},
	gervehicleyard = {
		{
			into = 'gervehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	gergunyard = {
		{
			into = 'gerspyard',
			metal = 3500,
			energy = 0,
			time = 100,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'gerspyard1',
			metal = 5250,
			energy = 0,
			time = 150,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},	
	gertankyard = {
		{
			into = 'gertankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},

		{
			into = 'gertankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	gerboatyard = {
		{
			into = 'gerboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing  \n  Fire  \n  Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	  -- Machineguns
  germg42 =
  {
    into = 'germg42_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },

  germg42_sandbag =
  {
    into = 'germg42',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
    -- Towed Guns
  gerflak38_truck =
  {
    into = 'gerflak38_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  gerflak38_stationary =
  {
    into = 'gerflak38_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  gerpak40_truck = 
  {
    into = 'gerpak40_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gerpak40_stationary = 
  {
    into = 'gerpak40_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  gerlefh18_truck = 
  {
    into = 'gerlefh18_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gerlefh18_stationary = 
  {
    into = 'gerlefh18_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	gernebelwerfer_truck = 
  {
    into = 'gernebelwerfer_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gernebelwerfer_stationary = 
  {
    into = 'gernebelwerfer_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  -- Trucks / Trucksupplies
  geropelblitz =
  {
    into = 'gertrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  gertrucksupplies =
  {
    into = 'geropelblitz',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
-- Pontoon trucks  
    gerpontoontruck =
  {
    into = 'gerboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

}

return gerDefs
