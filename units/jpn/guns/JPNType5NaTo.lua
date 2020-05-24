local JPNType5NaTo = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Type 5 Na-To",
	description			= "Heavily Armed Tank Destroyer",
	buildCostMetal		= 2550,
	maxDamage			= 1700,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "Type575mmL56AP",
			maxAngleDif			= 40,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 12,
		armor_rear			= 4,
		armor_side			= 12,
		armor_top			= 0,
		slope_front			= 25,
		slope_rear			= 1,
		
		maxammo				= 6,
		maxvelocitykmh		= 40,
		exhaust_fx_name		= "diesel_exhaust",
		customanims			= "type5nato",

	},
}

return lowerkeys({
	["JPNType5NaTo"] = JPNType5NaTo,
})
