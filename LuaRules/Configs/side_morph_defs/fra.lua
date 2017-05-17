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
}

return fraDefs
