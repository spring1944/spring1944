local HUN40MNimrod = ArmouredCarAA:New{
	name				= "40.M Nimrod",
	corpse				= "HUN40MNimrod_Burning",
	buildCostMetal			= 1912,
	maxDamage			= 1050,
	movementClass		= "TANK_Light",
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[3] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
		[1] = { -- AP
			name				= "bofors40mmap",
		},
	},
	customParams = {
		hasturnbutton		= true,
		damageGroup		= "lightTanks",
		armour = {
			base = {
				front = {
					thickness		= 12,
					slope			= 60,
				},
				rear = {
					thickness		= 12,
					slope			= -33,
				},
				side = {
					thickness 		= 13,
					slope			= -15,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 10,
					slope			= 24,
				},
				rear = {
					thickness		= 10,
					slope			= 24,
				},
				side = {
					thickness 		= 10,
					slope			= 24,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		piecehitvols		= {
			turret = {
				scale = {1, 0.35, 1}, -- radio mast
				offset = {0, -1.5, 0},
			},
		},
		maxammo				= 19,
		maxvelocitykmh		= 50,
		weapontoggle		= "priorityAPHE",
		nomoveandfire		= true,
	}
}

local HUN43MLehel = HalfTrack:New{
	name					= "43.M Lehel",
	buildCostMetal			= 900,
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
