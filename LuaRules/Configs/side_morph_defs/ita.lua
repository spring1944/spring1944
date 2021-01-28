local itaDefs = {
  -- italy
   	itastorage = {
		{
			into = 'itastoragesupply',
			metal = 1500,
			energy = 0,
			time = 40,
			name = 'Upgrade',
			text = 'Upgrades into a Supply Center.',
			facing = true,
		},
	},	

     itafiat626 =
  {
    into = 'itatrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	itatrucksupplies=
  {
    into = 'itafiat626',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
   itabreda20_truck =
  {
    into = 'itabreda20_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  itabreda20_stationary =
  {
    into = 'itabreda20_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  itacannone47_truck =
  {
    into = 'itacannone47',
    tech = 0,
    time = 1,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  itacannone47 =
  {
    into = 'itacannone47_stationary',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
  },  
  itacannone47_stationary =
  {
    into = 'itacannone47',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
  },

  itacannone75 =
  {
    into = 'itacannone75_stationary',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
  },
  itacannone75_stationary =
  {
    into = 'itacannone75',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },

  itaobice100_truck =
  {
    into = 'itaobice100',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  itaobice100 =
  {
    into = 'itaobice100_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },  
  itaobice100_stationary =
  {
    into = 'itaobice100',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  itacannone105_32_truck =
  {
    into = 'itacannone105_32',
    tech = 0,
    time = 40,
    metal = 0,
    energy = 0,
    directional = true,
    text = 'Unload the gun and dismiss the truck',
  },
  itacannone105_32 =
  {
    into = 'itacannone105_32_stationary',
    tech = 0,
    time = 60,
    metal = 0,
    energy = 0,
  },
  itacannone105_32_stationary =
  {
    into = 'itacannone105_32',
    tech = 0,
    time = 40,
    metal = 0,
    energy = 0,
  },  
  
    itamg =
  {
    into = 'itamg_dugin',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  itamg_dugin =
  {
    into = 'itamg',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  itapontoontruck =
  {
    into = 'itaboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

		itaboatyard = {
		{
			into = 'itaboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = 'Landing\nFire\nSupport',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
		itabarracks = {
		{
			into = 'itaelitebarracks',
			metal = 2000,
			energy = 0,
			time = 65,
			buttonname = 'Upg: Elite',
			name = 'Elite\nTroops',
			text = 'Makes Elite Infantry available in this barracks',
			--notext = true,
		},
	},
	itagunyard = {
		{
			into = 'itaspyard',
			metal = 3500,
			energy = 0,
			time = 60,
			name = 'Self\nPropelled',
			text = 'Makes Self-Propelled Artillery  available in this yard',
			facing = true,
		},
		{
			into = 'itagunyard2',
			metal = 5000,
			energy = 0,
			time = 140,
			name = 'Long\nRange\nArtillery',
			text = 'Makes Long Range Artillery  available in this yard',
			facing = true,
		},
	},
	itatankyard = {
		{
			into = 'itatankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = 'Advanced\ntanks',
			text = 'Makes heavier armament and armor available in this yard',
			facing = true,
		},
		{
			into = 'itatankyard2',
			metal = 6000,
			energy = 0,
			time = 120,
			name = 'Advanced\nassault\nguns',
			text = 'Makes advanced heavy armor available in this yard',
			facing = true,
		},
	},

	itavehicleyard = {
		{
			into = 'itavehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = 'Light\nArtillery',
			text = 'Makes light self-propelled artillery available in this yard',
			facing = true,
		},
	},

}

return itaDefs
