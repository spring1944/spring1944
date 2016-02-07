Unit('RUS_ZiS5Base'):Extends('Truck'):Attrs{
	name					= "ZiS-5",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('RUS_ZiS5'):Extends('RUS_ZiS5Base'):Extends('TransportTruck')
Unit('RUS_PontoonTruck'):Extends('RUS_ZiS5Base'):Extends('PontoonTruck') -- name append

Unit('RUS_SupplyTruck'):Extends('RUS_ZiS5Base'):Attrs{
	name					= "ZiS-5 Supply Storage Truck",
	description				= "Deploys Into Storage Shed",
	energyStorage			= 1040,
	explodeAs				= "Massive_Explosion", -- hehe
	iconType				= "truck_ammo",
	idleAutoHeal			= 2,
	idleTime				= 1000,
}

