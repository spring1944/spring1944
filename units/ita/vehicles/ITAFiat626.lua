local ITA_Fiat626Base = Truck:New{
	name					= "Fiat 626",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local ITA_Fiat626 = ITA_Fiat626Base:New(TransportTruck)
local ITA_PontoonTruck = ITA_Fiat626Base:New(PontoonTruck, true)

return lowerkeys({
	["ITAFiat626"] = ITA_Fiat626,
	["ITAPontoonTruck"] = ITA_PontoonTruck,
})
