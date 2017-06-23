local SWE_ScaniaVabisF11Base = Truck:New{
	name					= "Scania Vabis F11 Truck",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local SWE_ScaniaVabisF11 = SWE_ScaniaVabisF11Base:New(TransportTruck)
local SWE_PontoonTruck = SWE_ScaniaVabisF11Base:New(PontoonTruck, true)

local SWE_BarracksTruck = SWE_ScaniaVabisF11Base:New{
	buildpic	= "swescaniavabisf11.png",
	buildCostMetal				= 1500,
	description	= "Mobile Barracks",
	iconType		= "truck_barracks",
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["SWEScaniaVabisF11"] = SWE_ScaniaVabisF11,
	["SWEPontoonTruck"] = SWE_PontoonTruck,
	["SWEScaniaVabisF11_barracks"] = SWE_BarracksTruck,
})
