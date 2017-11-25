local GBR_BedfordBase = Truck:New{
	name					= "Bedford QL",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local GBR_BedfordTruck = GBR_BedfordBase:New(TransportTruck)
local GBR_PontoonTruck = GBR_BedfordBase:New(PontoonTruck, true)

return lowerkeys({
	["GBRBedfordTruck"] = GBR_BedfordTruck,
	["GBRPontoonTruck"] = GBR_PontoonTruck,
})
