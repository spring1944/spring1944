local ChiHaBase = MediumTank:New{
	acceleration		= 0.034,
	brakeRate			= 0.15,
	maxDamage			= 1580,
	trackOffset			= 5,
	trackWidth			= 14,
	trackType			= "T60-70-SU76",
	turnRate			= 280, -- FIXME: worth it?
	
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 11,
		maxvelocitykmh		= 38,
	},
}
	
local JPNChiHa = ChiHaBase:New{
	name				= "Type 97 Chi-Ha",
	buildCostMetal		= 1600,
	
	weapons = {
		[1] = {
			name				= "Type9757mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type9757mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
		},
		[4] = { -- rear turret MG
			name				= "Type97MG",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	
	customParams = {
		maxammo				= 20,
		weaponcost			= 9,
		
		cegpiece = {
			[3] = "bow_mg_flare",
			[4] = "turret_mg_flare",
		},
	},
}	

local JPNChiHa120mm = ChiHaBase:New{
	name				= "Type 97 Chi-Ha",
	description			= "Close Support Tank",
	buildCostMetal		= 2650,
	
	weapons = {
		[1] = {
			name				= "Short120mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = { -- bow MG
			name				= "Type97MG",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	
	customParams = {
		maxammo				= 5,
		weaponcost			= 16,
		weaponswithammo		= 1,
		
		cegpiece = {
			[2] = "bow_mg_flare",
		},
	},
}

local JPNShinhotoChiHa = JPNChiHa:New{ -- just change the gun
	name				= "Type 97 Shinhoto Chi-Ha",
	description			= "Upgunned Medium Tank",
	buildCostMetal		= 1750,
	
	weapons = {
		[1] = {
			name				= "Type14mmAP",
		},
		[2] = {
			name				= "Type14mmHE",
		},
	},
	
	customParams = {
		maxammo				= 15,
		weaponcost			= 8,
	},
}	

return lowerkeys({
	["JPNChiHa"] = JPNChiHa,
	["JPNChiHa120mm"] = JPNChiHa120mm,
	["JPNShinhotoChiHa"] = JPNShinhotoChiHa,
})
