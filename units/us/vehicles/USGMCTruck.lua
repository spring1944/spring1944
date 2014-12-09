local US_GMCTruckBase = Truck:New{
	name					= "GMC 2.5t Truck",
	trackOffset				= 10,
	trackWidth				= 13,
}

local US_GMCTruck = US_GMCTruckBase:New(TransportTruck)
local US_PontoonTruck = US_GMCTruckBase:New(PontoonTruck, true)

local US_DUKW = US_GMCTruck:New{
	name					= "DUKW",
	description				= "Amphibious Transport Truck",
	buildCostMetal			= 500,
	canHover				= true, --TODO: required?
	collisionVolumeScales	= [[16 15 57]],
	collisionVolumeOffsets	= [[0 -3 0]],
	corpse					= "usgmctruck_destroyed", -- TODO: DUKW corpse
	maxDamage				= 650,
	movementClass			= "HOVER_AmphibTruck",
	script					= "<NAME>.cob", -- overwrite transporttruck.cob
}

return lowerkeys({
	["USGMCTruck"] = US_GMCTruck,
	["USPontoonTruck"] = US_PontoonTruck,
	["USDUKW"] = US_DUKW,
})
