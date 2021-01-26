local RUSPDrop = Null:New{
	name						= "Partisan Supplies",
	description					= "Partisan Supply Drop",
	category					= "AIR PARA",
	iconType					= "paratrooper",
	maxDamage					= 1500,
	customParams = {
		normaltex			= "unittextures/RUSPDrop_normals.png",
	},
}

return lowerkeys({
	["RUSPDrop"] = RUSPDrop,
})
