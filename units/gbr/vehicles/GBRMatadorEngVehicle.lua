local GBR_MatadorEngVehicle = EngineerVehicle:New{
	name					= "AEC Matador w/Coles Crane",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "unittextures/GBRMatador_normals.png",
	},
}

return lowerkeys({
	["GBRMatadorEngVehicle"] = GBR_MatadorEngVehicle,
})
