local hunDefs = {
	hunhmg =
	{
		into = 'hunsandbagmg',
		tech = 0,
		time = 25,
		metal = 0,
		energy = 0,
		directional = true,
	},
	
	hunsandbagmg =
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

}

return hunDefs