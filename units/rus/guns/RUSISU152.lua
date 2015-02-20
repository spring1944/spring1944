local RUSISU152 = OpenAssaultGun:New{
	name				= "ISU-152",
	description			= "Heavy Assault Gun",
	acceleration		= 0.048,
	brakeRate			= 0.105,
	buildCostMetal		= 5800,
	explodeAs			= "Vehicle_Explosion_Large",
	maxDamage			= 4180,
	maxReverseVelocity	= 1.37,
	maxVelocity			= 2.74,
	turnRate			= 160,
	trackOffset			= 5,
	trackWidth			= 22,

	weapons = {
		[1] = {
			name				= "ML20S152mmHE",
			maxAngleDif			= 25,
		},
		--[2] = {
			--name				= "ML20S152mmAP",
			--maxAngleDif			= 25,
		--},
		[9] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 90,
		armor_rear			= 80,
		armor_side			= 86,
		armor_top			= 30,
		maxammo				= 4,
		weaponcost			= 63,
		soundcategory		= "RUS/Tank/Zveroboy",
		weaponswithammo		= 1,
	},
}

return lowerkeys({
	["RUSISU152"] = RUSISU152,
})
