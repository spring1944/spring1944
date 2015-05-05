local RUSPDrop = Null:New{
	name						= "Partisan Supplies",
	description					= "Partisan Supply Drop",
	category					= "AIR PARA",
	iconType					= "paratrooper",
	maxDamage					= 1500,
	
	customparams = {
		spawnsunit = "ruspartisanrifle",
	},
}

return lowerkeys({
	["RUSPDrop"] = RUSPDrop,
})
