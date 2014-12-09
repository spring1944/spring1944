local RUS_Pr161 = BoatMother:New{
	name					= "Pr.161 Armoured Boat",
	description				= "Sea-going armored gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 6500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "RUSPr161_dead",
	mass					= 15100,
	maxDamage				= 15100, --TODO: +10% because it has armor??
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 7, -- 7 x 1fpu turrets
	turnRate				= 150,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "S5385mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"RUSTurret_45mm_Front",
			"RUSPr161_Turret_85mm_Front",
			"RUSPr161_Turret_DshK",
			"RUSPr161_Turret_DshK",
			"RUSPr161_Turret_85mm_Rear",
			"RUSTurret_45mm_Rear",
			"RUSTurret_37mm_Rear", 
		},
		deathanim = {
			["x"] = {angle = -15, speed = 5},
		},
	},
}


local RUS_Pr161_Turret_DshK = BoatChild:New{
	name					= "DshK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 80,
		elevationspeed			= 45,
	},
}

local RUS_Pr161_Turret_85mm_Front = BoatChild:New{
	name					= "85mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/RUSPr161_Turret_85mm.s3o",
  	weapons = {	
		[1] = {
			name				= "S5385mmHE",
			maxAngleDif			= 300,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 22,
		weaponcost				= 17,
		weaponswithammo			= 1,
		barrelrecoildist		= 7.5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		feartarget				= false, -- fully enclosed
    },
}
local RUS_Pr161_Turret_85mm_Rear = RUS_Pr161_Turret_85mm_Front:New{
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,
    },
}

return lowerkeys({
	["RUSPr161"] = RUS_Pr161,
	["RUSPr161_Turret_DshK"] = RUS_Pr161_Turret_DshK,
	["RUSPr161_Turret_85mm_Front"] = RUS_Pr161_Turret_85mm_Front,
	["RUSPr161_Turret_85mm_Rear"] = RUS_Pr161_Turret_85mm_Rear,
})
