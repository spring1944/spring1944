local SWE_T21 = ArmedBoat:New{
	name					= "T-21 torpedo boat",
	description				= "Motor Torpedo boat",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1000,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	maxDamage				= 2400,
	maxVelocity				= 4.3, -- 43 knots
	transportCapacity		= 1, -- 1 x 1fpu turrets
	turnRate				= 55,	
	weapons = {	
		[1] = {
			name				= "BredaM3520mmHE",
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		soundcategory		= "SWE/Boat",
		children = {
			"SWET21_Turret_20mm_Rear", 
		},
		deathanim = {
			["z"] = {angle = -20, speed = -10},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
		normaltex			= "",
	},
}

local SWE_T21_Turret_20mm_Rear = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/SWET21_Turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,
		maxammo					= 14,

		aaweapon				= 1,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		normaltex			= "",
    },
}

return lowerkeys({
	["SWET21"] = SWE_T21,
	["SWET21_Turret_20mm_Rear"] = SWE_T21_Turret_20mm_Rear,
})
