local fraDefs = {
	-- Trucks / Trucksupplies
	fracitroentype45 =
	{
		into = 'fratrucksupplies',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	fratrucksupplies =
	{
		into = 'fracitroentype45',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	fra25mmmle1934_truck =
	{
		into = 'fra25mmmle1934',
		tech = 0,
		time = 1,
		metal = 0,
		energy = 0,
		directional = true,
		text = 'Unload the gun and dismiss the truck',
	},

	fra25mmmle1934 =
	{
		into = 'fra25mmmle1934_stationary',
		tech = 0,
		time = 5,
		metal = 0,
		energy = 0,
	},

	fra25mmmle1934_stationary =
	{
		into = 'fra25mmmle1934',
		tech = 0,
		time = 5,
		metal = 0,
		energy = 0,
	},

	fra47mmat_truck =
	{
		into = 'fra47mmat',
		tech = 0,
		time = 1,
		metal = 0,
		energy = 0,
		directional = true,
		text = 'Unload the gun and dismiss the truck',
	},

	fra47mmat =
	{
		into = 'fra47mmat_stationary',
		tech = 0,
		time = 5,
		metal = 0,
		energy = 0,
	},

	fra47mmat_stationary =
	{
		into = 'fra47mmat',
		tech = 0,
		time = 5,
		metal = 0,
		energy = 0,
	},

	fra75mmmle1897 =
	{
		into = 'fra75mmmle1897_stationary',
		tech = 0,
		time = 10,
		metal = 0,
		energy = 0,
	},

	fra75mmmle1897_stationary =
	{
		into = 'fra75mmmle1897',
		tech = 0,
		time = 10,
		metal = 0,
		energy = 0,
	},	

	fra25mmaa_truck =
	{
		into = 'fra25mmaa_stationary',
		tech = 0,
		time = 35,
		metal = 0,
		energy = 0,
	},

	fra25mmaa_stationary =
	{
		into = 'fra25mmaa_truck',
		tech = 0,
		time = 20,
		metal = 0,
		energy = 0,
	},

	fra105mmmle1935b_truck =
	{
		into = 'fra105mmmle1935b',
		tech = 0,
		time = 35,
		metal = 0,
		energy = 0,
		directional = true,
		text = 'Unload the gun and dismiss the truck',
	},

    fra105mmmle1935b = 
    {
        into = 'fra105mmmle1935b_stationary',
        tech = 0,
        time = 35,
        metal = 0,
        energy = 0,
    },

    fra105mmmle1935b_stationary = 
    {
        into = 'fra105mmmle1935b',
        tech = 0,
        time = 20,
        metal = 0,
        energy = 0,
    },

}

return fraDefs
