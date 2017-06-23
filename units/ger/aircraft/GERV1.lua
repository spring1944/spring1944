local GER_V1 = CruiseMissile:New{
	name			= "V-1 (Fi-103)",
	maxDamage		= 400,
	explodeAs		= "v1",
	script			= "<NAME>.lua"
	customParams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["GERV1"] = GER_V1,
})
