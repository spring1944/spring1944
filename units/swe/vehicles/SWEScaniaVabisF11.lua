local SWE_ScaniaVabisF11Base = Truck:New{
	name					= "Scania Vabis F11 Truck",
	trackOffset				= 10,
	trackWidth				= 13,
}

local SWE_ScaniaVabisF11 = SWE_ScaniaVabisF11Base:New(TransportTruck)
local SWE_PontoonTruck = SWE_ScaniaVabisF11Base:New(PontoonTruck, true)

return lowerkeys({
	["SWEScaniaVabisF11"] = SWE_ScaniaVabisF11,
	["SWEPontoonTruck"] = SWE_PontoonTruck,
})
