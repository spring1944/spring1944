local JPN_BusouDaihatsu = ArmedBoat:New{
	name					= "Busou Daihatsu Artillery Craft",
	acceleration			= 0.09,
	brakeRate				= 0.5,
	buildCostMetal			= 2500,
	maxDamage				= 3000,
	iconType			= "artyboat",
	maxReverseVelocity		= 0.685,
	maxVelocity				= 1.7,
	transportMass			= 2100,
	transportSize			= 1,
	turnRate				= 50,	
	script					= "jpnbusoudaihatsu.lua",
	weapons = {	
		[1] = {
			name				= "Type4RocketMortarHE",
			maxAngleDif			= 30,
			mainDir				= [[0 0 1]],
		},
	},
	customparams = {
		deathanim = {
			["z"] = {angle = 30, speed = 10},
		},
		barrelrecoildist		= 0,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 5,
		elevationspeed			= 5,
		maxammo				= 4,

	},
}

return lowerkeys({
	["JPNBusouDaihatsu"] = JPN_BusouDaihatsu,
})
