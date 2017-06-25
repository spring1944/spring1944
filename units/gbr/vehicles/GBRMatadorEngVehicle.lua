local GBR_MatadorEngVehicle = EngineerVehicle:New{
	name					= "AEC Matador w/Coles Crane",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["GBRMatadorEngVehicle"] = GBR_MatadorEngVehicle,
})
