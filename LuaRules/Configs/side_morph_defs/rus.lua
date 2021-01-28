local rusDefs = {
-- Upgrade Defs
 	rusvehicleyard = {
		{
			into = 'rusvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = 'Light\nArmor',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	rusgunyard = {
		{
			into = 'russpyard',
			metal = 4025,
			energy = 0,
			time = 115,
			name = 'Self\nPropelled',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'russpyard1',
			metal = 5200,
			energy = 0,
			time = 150,
			name = 'Tank\nDestroyers',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
		{
			into = 'rusgunyard2',
			metal = 5500,
			energy = 0,
			time = 155,
			name = 'Long\nRange\nArtillery',
			text = 'Makes Long Range Artillery available in this yard',
			facing = true,
		},
	},
	rustankyard = {
		{
			into = 'rustankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = 'Advanced\nMediums',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
		{
			into = 'rustankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = 'Heavy\nArmor',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	rusboatyard = {
		{
			into = 'rusboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = 'Landing\nFire\nSupport',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},

  -- Machineguns
  rusmaxim =
  {
    into = 'rusmaxim_sandbag',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  rusmaxim_sandbag =
  {
    into = 'rusmaxim',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  -- Towed Guns
  rus61k_truck = 
  {
    into = 'rus61k_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  rus61k_stationary = 
  {
    into = 'rus61k_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  ruszis2_truck = 
  {
    into = 'ruszis2',
    tech = 0,
    time = 1,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  ruszis2 = 
  {
    into = 'ruszis2_stationary',
    tech = 0,
    time = 7,
    metal = 0,
    energy = 0,
  },
  ruszis2_stationary = 
  {
    into = 'ruszis2',
    tech = 0,
    time = 7,
    metal = 0,
    energy = 0,
  },
  
  ruszis3 = 
  {
    into = 'ruszis3_stationary',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
  ruszis3_stationary = 
  {
    into = 'ruszis3',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
  
  rusm30_truck = 
  {
    into = 'rusm30',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  rusm30 = 
  {
    into = 'rusm30_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  rusm30_stationary = 
  {
    into = 'rusm30',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  rusa19_truck = 
  {
    into = 'rusa19',
    tech = 0,
    time = 45,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  rusa19 = 
  {
    into = 'rusa19_stationary',
    tech = 0,
    time = 70,
    metal = 0,
    energy = 0,
  },
  rusa19_stationary = 
  {
    into = 'rusa19',
    tech = 0,
    time = 45,
    metal = 0,
    energy = 0,
  },

  -- Trucks / Trucksupplies
   ruszis5 =
  {
    into = 'rustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	rustrucksupplies=
  {
    into = 'ruszis5',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  -- Pontoon trucks
	ruspontoontruck =
  {
    into = 'rusboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
  --the Soviet supply storage truck they get at spawn
     russupplytruck =
  {
    into = 'russtorage',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
     russtorage =
  {
    into = 'russupplytruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
  rusbt7 =
  {
    into = 'rusbt7_wheeled',
    tech = 0,
    time = 30,
    metal = 0,
    energy = 0,    
  },
  rusbt7_wheeled =
  {
    into = 'rusbt7',
    tech = 0,
    time = 30,
    metal = 0,
    energy = 0,    
  },
}

return rusDefs
