local US_GMCTruckBase = Truck:New{
	name					= "GMC 2.5t Truck",
	trackOffset				= 10,
	trackWidth				= 13,
}

local US_GMCTruck = US_GMCTruckBase:New(TransportTruck)
local US_PontoonTruck = US_GMCTruckBase:New(PontoonTruck, true)

return lowerkeys({
	["USGMCTruck"] = US_GMCTruck,
	["USPontoonTruck"] = US_PontoonTruck,
})
