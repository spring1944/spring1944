local USParatrooper = Null:New{
	iconType					= "paratrooper",
	category					= "AIR PARA",
	maxDamage					= 60,
	objectName					= "US/USParatrooper.s3o",
	customParams = {
		damageGroup			= "infantry",
	},
}

return lowerkeys({
	["USParatrooper"] = USParatrooper,
})
