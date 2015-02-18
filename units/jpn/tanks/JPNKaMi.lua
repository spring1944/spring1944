local JPNKaMi = LightTank:New{
	name				= "Type 2 Ka-Mi",
	description			= "Amphibious Light Tank",
	acceleration		= 0.034,
	brakeRate			= 0.15,
	buildCostMetal		= 1150,
	maxDamage			= 1250,
	maxReverseVelocity	= 1.4,
	maxVelocity			= 2.8,
	movementClass		= "HOVER_AmphibTruck",
	trackOffset			= 7,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "Type137mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type137mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
			maxAngleDif			= 20,
		},
		[3] = { -- Rear Turret MG
			name				= "Type97MG",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 8,
		armor_side			= 14,
		armor_top			= 6,
		maxammo				= 15,
		weaponcost			= 8,
	},
}

return lowerkeys({
	["JPNKaMi"] = JPNKaMi,
})
