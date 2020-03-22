local RUS_KomsMTB = ArmedBoat:New{
	name					= "Komsomolets (Pr. 123) Class",
	description				= "Motor Torpedo Boat",
	movementClass			= "BOAT_MotorTorpedo",
	acceleration			= 0.1,
	brakeRate				= 0.05,
	buildCostMetal			= 1350,
	collisionVolumeOffsets	= [[0.0 -9.0 0.0]],
	collisionVolumeScales	= [[24.0 24.0 110.0]],
	maxDamage				= 2090,
	maxReverseVelocity		= 2.4,
	maxVelocity				= 5.78, -- 48kn
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 105,	
	weapons = {	
		[1] = {
			name				= "dshk",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 270,
		},
	},
	customparams = {
		soundCategory			= "RUS/Boat",
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		children = {
			"RUSKomsMTB_Turret_DShK", 
			"RUSKomsMTB_Turret_DShK", 
		},
		deathanim = {
			["z"] = {angle = 15, speed = 10},
		},
		-- TODO: implement 'cruise mode' too

	},
}

local RUS_KomsMTB_Turret_DShK = OpenBoatTurret:New{
	name					= "Twin DShK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "dshk",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
	},
	customparams = {
		turretturnspeed			= 30,
		elevationspeed			= 45,
		facing					= 2,
		defaultheading1		= math.rad(180),
	},
}

return lowerkeys({
	["RUSKomsMTB"] = RUS_KomsMTB,
	["RUSKomsMTB_Turret_DShK"] = RUS_KomsMTB_Turret_DShK,
})
