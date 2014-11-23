local GBR_BedfordTruck = TransportTruck:New(SFX_GBR_Vehicle):New{
	name					= "Bedford QL",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["GBRBedfordTruck"] = GBR_BedfordTruck,
})
