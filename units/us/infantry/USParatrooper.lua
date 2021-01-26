local USParatrooper = Null:New{
	iconType					= "paratrooper",
	category					= "AIR PARA",
	maxDamage					= 60,
	objectName					= "US/USParatrooper.s3o",
	customParams = {
		damageGroup			= "infantry",
		normaltex			= "unittextures/USParatrooperchute_normals.png",
	},
}

return lowerkeys({
	["USParatrooper"] = USParatrooper,
})
