local RUS_K31 = EngineerVehicle:New{
	name					= "K-31 Crane",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "unittextures/RUSK31_normals.png",
	},
}

return lowerkeys({
	["RUSK31"] = RUS_K31,
})
