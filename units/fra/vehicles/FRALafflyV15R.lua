local FRALafflyV15R = ScoutCar:New{
	corpse				= "FRALafflyV15_Burning",
	name				= "Laffly V15R",
	trackOffset			= 4,
	trackWidth			= 15,
	objectName			= "FRA/FRALafflyV15R.s3o",

	customParams = {
		normaltex = "unittextures/FRALafflyV15_normals.png",
	},
}

return lowerkeys({
	["FRALafflyV15R"] = FRALafflyV15R,
})
