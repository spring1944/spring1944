local FRA_CitroenType45 = Truck:New{
	name					= "Citroen Type 45",
	trackOffset				= 10,
	trackWidth				= 16,
	objectName				= "FRA/FRACitroenType45.s3o",

	customParams = {
		normaltex = "unittextures/FRACitroenType45_normals.png",
	},
}

local FRA_TruckSupplies = Supplies:New{
	customParams = {
		normaltex = "unittextures/FRACitroenType45_normals.png",
	},
}

-- lowercase objectname!
FRA_TruckSupplies.objectname = "FRA/FRATruckSupplies.s3o"

return lowerkeys({
	["FRACitroenType45"] = FRA_CitroenType45,
	["FRATruckSupplies"] = FRA_TruckSupplies,
})
