Unit('GBRSatchelCharge'):Extends('Mine'):Attrs{
	name						= "Satchel Charge",
	description					= "Anti-Building Demolitions Pack",
	buildTime					= 750,
	explodeAs					= "SatchelCharge",
	maxSlope					= 80,
	minCloakDistance			= 20,
	selfDestructAs				= "SatchelCharge",
	selfDestructCountdown		= 10,
	sightDistance				= 1,
	useBuildingGroundDecal		= false,
	customparams = {
		candetonate 				= true,
	},
}

-- Mines --
Unit('APMine'):Extends('Mine'):Attrs{
	name						= "Anti-Personnel Mine",
	buildingGroundDecalSizeX	= 1,
	buildingGroundDecalSizeY	= 1,
	explodeAs					= "APMineExplosion",
	selfDestructAs				= "APMineExplosion",
	weapons = {
		[1] = {
			name					= "APMineExplosion",
		}
	},
}

Unit('ATMine'):Extends('Mine'):Attrs{
	name						= "Anti-Tank Mine",
	buildingGroundDecalSizeX	= 2,
	buildingGroundDecalSizeY	= 2,
	explodeAs					= "ATMineExplosion",
	selfDestructAs				= "ATMineExplosion",
	weapons = {
		[1] = {
			name					= "ATMineExplosion",
		}
	},
}

-- Mine Signs --
Unit('APMineSign'):Extends('MineSign'):Attrs{
	name						= "AP Minefield",
	description					= "Warning! AP Mines!",
	maxSlope					= 3,
	customparams = {
		minetype				= "apminesign",
	},
}

Unit('ATMineSign'):Extends('MineSign'):Attrs{
	buildCostMetal              = 180,
	buildTime				    = 180,
	name						= "AT Minefield",
	description					= "Warning! AT Mines!",
	maxSlope				= 15,
	customparams = {
		minetype				= "atminesign",
	},
}

for _, side in pairs(Sides) do
	Unit(side..'APMineSign'):Extends('APMineSign')
	Unit(side..'ATMineSign'):Extends('ATMineSign')
	-- tank trap just uses plain base class for now...
	-- .. may do side specific models later
	Unit(side..'tankobstacle'):Extends('TankObstacle')
end
