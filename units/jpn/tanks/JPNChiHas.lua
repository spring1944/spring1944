Unit('ChiHaBase'):Extends('LightTank'):Attrs{
	maxDamage			= 1580,
	trackOffset			= 5,
	trackWidth			= 14,
	
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 11,
		maxvelocitykmh		= 38,
	},
}
	
Unit('JPNChiHa'):Extends('ChiHaBase'):Attrs{
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
            maxAngleDif			= 50,
		},
		[4] = { -- rear turret MG
			name				= "Type97MG",
            mainDir				= [[0 16 -1]],
            maxAngleDif			= 210,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	
	customParams = {
		maxammo				= 20,
	},
}	

Unit('JPNChiHa120mm'):Extends('ChiHaBase'):Attrs{
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
	},
}

Unit('JPNShinhotoChiHa'):Extends('JPNChiHa'):Attrs{ -- just change the gun
	name				= "Type 97 Shinhoto Chi-Ha",
	description			= "Upgunned Medium Tank",
	buildCostMetal		= 1750,
	
	weapons = {
		[1] = {
			name				= "Type147mmAP",
		},
		[2] = {
			name				= "Type147mmHE",
		},
	},
	
	customParams = {
		maxammo				= 15,
	},
}	

