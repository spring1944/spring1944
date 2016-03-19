local hunDefs = {
	hunhmg =
	{
		into = 'hunhmg_sandbags',
		tech = 0,
		time = 25,
		metal = 0,
		energy = 0,
		directional = true,
	},
	
	hunhmg_sandbags =
	{
		into = 'hunhmg',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	hun38mbotond =
	{
		into = 'huntrucksupplies',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
  
	huntrucksupplies =
	{
		into = 'hun38mbotond',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
	
	hunpak40_truck = 
	{
		into = 'hunpak40_stationary',
		tech = 0,
		time = 10,
		metal = 0,
		energy = 0,
		directional = true,
	},

	hunpak40_stationary = 
	{
		into = 'hunpak40_truck',
		tech = 0,
		time = 10,
		metal = 0,
		energy = 0,
	},
	hun36mbofors_truck = {
		{
			into = 'hun36mbofors_stationary',
			tech = 0,
			time = 35,
			metal = 0,
			energy = 0,
		},
	},
	hun36mbofors_stationary = {
		{
			into = 'hun36mbofors_truck',
			tech = 0,
			time = 20,
			metal = 0,
			energy = 0,
		},
	},
	hunlefh18_truck = 
	{
		into = 'hunlefh18_stationary',
		tech = 0,
		time = 35,
		metal = 0,
		energy = 0,
		directional = true,
	},

	hunlefh18_stationary = 
	{
		into = 'hunlefh18_truck',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	hun44mbuzoganyveto_truck =
	{
		into = 'hun44mbuzoganyveto_stationary',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	hun44mbuzoganyveto_stationary =
	{
		into = 'hun44mbuzoganyveto_truck',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},
	
	hungunyard = {
		{
			into = 'hunspyard',
			metal = 4025,
			energy = 0,
			time = 115,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'hunspyard1',
			metal = 5200,
			energy = 0,
			time = 150,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},
	hunvehicleyard = {
		{
			into = 'hunvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	huntankyard = {
		{
			into = 'huntankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},

		{
			into = 'huntankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	hunpontoontruck =
	{
		into = 'hunboatyard',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
		facing = true,
	},

	hunboatyard = {
		{
			into = 'hunboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing \n Fire \n Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},

}

return hunDefs