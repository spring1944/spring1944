local HUN39MCsaba = ArmouredCar:New{
	name				= "39.M Csaba",
	corpse				= "HUN39MCsaba_dead",
	buildCostMetal		= 750,
	maxDamage			= 595,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "Solothurn_36MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Solothurn_36MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 13,
		armor_rear			= 7,
		armor_side			= 7,
		armor_top			= 6,
		maxammo				= 24,
		reversemult			= 0.75,
		maxvelocitykmh			= 65,
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		normaltex			= "",
	}
}

return lowerkeys({
	["HUN39MCsaba"] = HUN39MCsaba,
})
