local jpnDefs = {
  -- japan
   	jpnstorage = {
		{
			into = 'jpnstoragetunnel',
			metal = 3000,
			energy = 0,
			time = 80,
			name = 'Upgrade',
			text = 'Upgrades into a tunnel exit.',
			facing = true,
		},
	},	
	jpngunyard = {
		{
			into = 'jpnspyard',
			metal = 3000,
			energy = 0,
			time = 85,
			name = 'Self\nPropelled',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'jpnspyard1',
			metal = 3000,
			energy = 0,
			time = 85,
			name = 'Tank\nDestroyers',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
		{
			into = 'jpngunyard2',
			metal = 5200,
			energy = 0,
			time = 150,
			name = 'Long\nRange\nArtillery',
			text = 'Makes Long Range Artillery available in this yard',
			facing = true,
		},
		
	},	
	jpnvehicleyard = {
		{
			into = 'jpnvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 85,
			name = 'Light\nTanks',
			text = 'Makes Light Tanks available in this yard',
			facing = true,
		},
		{
			into = 'jpnvehicleyard2',
			metal = 2000,
			energy = 0,
			time = 85,
			name = 'Landing\nCraft',
			text = 'Makes Landing Craft available in this yard',
			facing = true,
		},
	},
		jpnboatyard = {
		{
			into = 'jpnboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = 'Landing\nFire\nSupport',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},	
	jpntankyard = {
		{
			into = 'jpntankyard1',
			metal = 3000,
			energy = 0,
			time = 85,
			name = 'Medium\nTanks',
			text = 'Makes Improved Medium Tanks available in this yard',
			facing = true,
		},
		{
			into = 'jpntankyard2',
			metal = 6500,
			energy = 0,
			time = 185,
			name = 'Heavy\nSupport',
			text = 'Makes Heavy Support Tanks available in this yard',
			facing = true,
		},
	},	

  jpnpontoontruck =
  {
    into = 'jpnboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

  jpnisuzutx40 =
  {
    into = 'jpntrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  jpntrucksupplies=
  {
    into = 'jpnisuzutx40',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  jpntype98_20mm_truck =
  {
    into = 'jpntype98_20mm_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  jpntype98_20mm_stationary =
  {
    into = 'jpntype98_20mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  jpntype1_47mm_truck =
  {
    into = 'jpntype1_47mm_stationary',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  jpntype1_47mm_stationary =
  {
    into = 'jpntype1_47mm_truck',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
  },
  jpntype90_75mm_truck =
  {
    into = 'jpntype90_75mm_stationary',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  jpntype90_75mm_stationary =
  {
    into = 'jpntype90_75mm_truck',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
  jpntype91_105mm_truck =
  {
    into = 'jpntype91_105mm_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  jpntype91_105mm_stationary =
  {
    into = 'jpntype91_105mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  jpntype92_10cm_truck =
  {
    into = 'jpntype92_10cm_stationary',
    tech = 0,
    time = 60,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  jpntype92_10cm_stationary =
  {
    into = 'jpntype92_10cm_truck',
    tech = 0,
    time = 40,
    metal = 0,
    energy = 0,
  },  
    jpntype92hmg =
  {
    into = 'jpntype92hmg_dugin',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  jpntype92hmg_dugin =
  {
    into = 'jpntype92hmg',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
    jpntype4mortar_mobile =
  {
    into = 'jpntype4mortar_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  jpntype4mortar_stationary =
  {
    into = 'jpntype4mortar_mobile',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

}

return jpnDefs
