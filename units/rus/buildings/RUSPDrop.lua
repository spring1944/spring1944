local RUSPDrop = Null:New{
	name						= "Partisan Supplies",
	description					= "Partisan Supply Drop",
	category					= "AIR PARA",
	iconType					= "paratrooper",
	maxDamage					= 1500,
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["RUSPDrop"] = RUSPDrop,
})
