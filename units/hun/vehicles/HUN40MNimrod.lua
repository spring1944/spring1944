local HUN40MNimrod = ArmouredCarAA:New{
	name				= "40.M Nimrod",
	corpse				= "HUN40MNimrod_Burning",
	buildCostMetal			= 1912,
	maxDamage			= 1050,
	movementClass		= "TANK_Light",
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
	customParams = {
		hasturnbutton		= true,
		damageGroup		= "lightTanks",
		armor_front			= 13,
		armor_rear			= 6,
		armor_side			= 10,
		armor_top			= 0,
		maxammo				= 19,
		maxvelocitykmh		= 50,

	}
}

local HUN43MLehel = HalfTrack:New{
	name					= "43.M Lehel",
	buildCostMetal			= 1100,
	corpse				= "HUN43MLehel_Abandoned",
	maxDamage				= 1020,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 13,
		armor_rear				= 8,
		armor_side				= 13,
		armor_top				= 0,
		maxvelocitykmh			= 50,

	},
}

return lowerkeys({
	["HUN40MNimrod"] = HUN40MNimrod,
	["HUN43MLehel"] = HUN43MLehel,
})
