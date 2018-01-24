local RUS_ZiS5Base = Truck:New{
	name					= "ZiS-5",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local RUS_ZiS5 = RUS_ZiS5Base:New(TransportTruck)
local RUS_PontoonTruck = RUS_ZiS5Base:New(PontoonTruck, true)

local RUS_SupplyTruck = RUS_ZiS5Base:New{
	name					= "ZiS-5 Supply Storage Truck",
	description				= "Deploys Into Storage Shed",
	energyStorage			= 1040,
	explodeAs				= "Massive_Explosion", -- hehe
	iconType				= "truck_ammo",
	idleAutoHeal			= 2,
	idleTime				= 1000,
	customParams = {

	},
}

return lowerkeys({
	["RUSZiS5"] = RUS_ZiS5,
	["RUSPontoonTruck"] = RUS_PontoonTruck,
	["RUSSupplyTruck"] = RUS_SupplyTruck,
})
