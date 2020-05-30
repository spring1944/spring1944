local JPNType5NaTo = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Type 5 Na-To",
	description			= "Heavily Armed Tank Destroyer",
	buildCostMetal		= 2550,
	maxDamage			= 1700,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "Type575mmL56AP",
			maxAngleDif			= 40,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 12,
					slope			= 25,
				},
				rear = {
					thickness		= 4,
					slope			= 1,
				},
				side = {
					thickness 		= 12,
				},
				top = {
					thickness		= 0,
				},
			},
			turret = {
				front = {
					thickness		= 12,
					slope			= 21,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 12,
					slope			= 26,
				},
				top = {
					thickness		= 12,
				},
			},
		},
		
		maxammo				= 6,
		maxvelocitykmh		= 40,
		exhaust_fx_name		= "diesel_exhaust",
		customanims			= "type5nato",
		piecehitvols		= {
			base = {
				scale = {1, 0.6, 1},
				offset = {0, -2.5, 0},
			},
			turret = {
				scale = {1, 0.41, 0.6},
				offset = {0, 4, 2},
			},
		}
	},
}

return lowerkeys({
	["JPNType5NaTo"] = JPNType5NaTo,
})
