local GERStuGIII = MediumTank:New(AssaultGun):New{
	name				= "SdKfz 142/1 StuG III Ausf. G",
	buildCostMetal		= 2475,
	maxDamage			= 2390,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "kwk75mml48AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "kwk75mml48HE",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 80,
					slope			= -19,
				},
				rear = {
					thickness		= 50,	
					slope			= 15,
				},
				side = {
					thickness 		= 35, -- with 5mm skirts
				},
				top = {
					thickness		= 16, -- engine deck
				},
			},
			super = {
				front = {
					thickness		= 80,
					slope			= 11,
				},
				rear = {
					thickness		= 30,
				},
				side = {
					thickness 		= 35, -- with 5mm skirts
					slope			= 10,
				},
				top = {
					thickness		= 11,
				},
			},
		},
		maxammo				= 11,
		soundcategory		= "GER/Tank/StuG",
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GERStuGIII_normals.png",
	},
}

return lowerkeys({
	["GERStuGIII"] = GERStuGIII,
})
