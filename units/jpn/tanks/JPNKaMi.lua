local JPNKaMi = LightTank:New(Amphibian):New{
	name				= "Type 2 Ka-Mi",
	description			= "Amphibious Light Tank",
	buildCostMetal		= 1150,
	maxDamage			= 1250,
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
		[4] = {
			name				= "Type97MG",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 12,
					slope			= 29,
				},
				rear = {
					thickness		= 10,
					slope			= 13,
				},
				side = {
					thickness 		= 10,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 12, -- not mantlet
					slope			= 7,
				},
				rear = {
					thickness		= 12,
					slope			= 14,
				},
				side = {
					thickness 		= 12,
					slope			= 10,
				},
				top = {
					thickness		= 6,
				},
			},
		},
		maxammo				= 15,
		maxvelocitykmh		= 37,
		exhaust_fx_name			= "diesel_exhaust",
		flagCapRate			= 0.5,
		flagCapType			= 'buoy',
		normaltex			= "unittextures/JPNKaMi_normals.png",
	},
}

return lowerkeys({
	["JPNKaMi"] = JPNKaMi,
})
