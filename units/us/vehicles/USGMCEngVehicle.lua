local US_GMCEngVehicle = EngineerVehicle:New{
	name					= "CCKW-353 Engineer Vehicle",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["USGMCEngVehicle"] = US_GMCEngVehicle,
})
