local RUS_ZiS5 = TransportTruck:New{
	name					= "ZiS-5",
	trackOffset				= 10,
	trackWidth				= 13,
}

local RUS_SupplyTruck = Truck:New{
	name					= "ZiS-5 Supply Storage Truck",
	description				= "Deploys Into Storage Shed",
	energyStorage			= 1040,
	explodeAs				= "Massive_Explosion", -- hehe
	iconType				= "truck_ammo",
	idleAutoHeal			= 2,
	idleTime				= 1000,
}

return lowerkeys({
	["RUSZiS5"] = RUS_ZiS5,
	["RUSSupplyTruck"] = RUS_SupplyTruck,
})
