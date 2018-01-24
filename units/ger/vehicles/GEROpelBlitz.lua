local GER_OpelBlitzBase = Truck:New{
	name					= "Opel Blitz",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local GER_OpelBlitz = GER_OpelBlitzBase:New(TransportTruck)
local GER_PontoonTruck = GER_OpelBlitzBase:New(PontoonTruck, true)

return lowerkeys({
	["GEROpelBlitz"] = GER_OpelBlitz,
	["GERPontoonTruck"] = GER_PontoonTruck,
})
