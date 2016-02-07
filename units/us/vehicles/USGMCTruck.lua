Unit('US_GMCTruckBase'):Extends('Truck'):Attrs{
	name					= "GMC 2.5t Truck",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('US_GMCTruck'):Extends('US_GMCTruckBase'):Extends('TransportTruck')
Unit('US_PontoonTruck'):Extends('US_GMCTruckBase'):Extends('PontoonTruck') -- name append

Unit('US_DUKW'):Extends('US_GMCTruck'):Extends('Amphibian'):Attrs{
	name					= "DUKW",
	description				= "Amphibious Transport Truck",
	buildCostMetal			= 500,
	collisionVolumeScales	= [[16 15 57]],
	collisionVolumeOffsets	= [[0 -3 0]],
	corpse					= "usgmctruck_destroyed", -- TODO: DUKW corpse
	maxDamage				= 650,
}

