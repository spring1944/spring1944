local RUSPDrop = Null:New{
	name						= "Partisan Supplies",
	description					= "Partisan Supply Drop",
	category					= "AIR PARA",
	iconType					= "paratrooper",
	maxDamage					= 1500,
	objectName					= "RUS/RUSPDrop.s3o",
}

return lowerkeys({
	["RUSPDrop"] = RUSPDrop,
})
