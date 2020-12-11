local usDefs = {
-- Upgrade Defs
   	usstorage = {
		{
			into = 'usstoragelarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = 'Upgrade',
			text = 'Upgrades into a large storage shed.',
			facing = true,
		},
	},	
	usvehicleyard = {
		{
			into = 'usvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = 'Light\nArmor',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	usgunyard = {
		{
			into = 'usspyard',
			metal = 3475,
			energy = 0,
			time = 85,
			name = 'Self\nPropelled',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'usspyard1',
			metal = 5200,
			energy = 0,
			time = 150,
			name = 'Tank\nDestroyers',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
		{
			into = 'usgunyard2',
			metal = 5200,
			energy = 0,
			time = 150,
			name = 'Long\nRange\nArtillery',
			text = 'Makes Long Range Artillery Artillery available in this yard',
			facing = true,
		},
		
	},
	ustankyard = {
		{
			into = 'ustankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = 'Advanced\nMediums',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
		{
			into = 'ustankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = 'Heavy\nArmor',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	usboatyard = {
		{
			into = 'usboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = 'Landing\nFire\nSupport',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	  -- Machineguns
  usmg =
  {
    into = 'usmg_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },
  

  usmg_sandbag =
  {
    into = 'usmg',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },

  usparamg =
  {
    into = 'usparamg_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
    usparamg_sandbag =
  {
    into = 'usparamg',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
    -- Towed Guns
  usm5gun = 
  {
    into = 'usm5gun_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  usm5gun_stationary = 
  {
    into = 'usm5gun',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  usm2gun_truck = 
  {
    into = 'usm2gun_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  usm2gun_stationary = 
  {
    into = 'usm2gun_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
 
  usm1_45ingun_truck = 
  {
    into = 'usm1_45ingun_stationary',
    tech = 0,
    time = 60,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  usm1_45ingun_stationary = 
  {
    into = 'usm1_45ingun_truck',
    tech = 0,
    time = 40,
    metal = 0,
    energy = 0,
  },

 usm1bofors_truck = 
  {
    into = 'usm1bofors_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
    usm1bofors_stationary = 
  {
    into = 'usm1bofors_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  -- Trucks / Trucksupplies
  usgmctruck =
  {
    into = 'ustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	ustrucksupplies =
  {
    into = 'usgmctruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
    usdukw =
  {
    into = 'usdukwsupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  	usdukwsupplies =
  {
    into = 'usdukw',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  -- Pontoon trucks
    uspontoontruck =
  {
    into = 'usboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

}

return usDefs
