local SWE_VolvoTVC = Truck:New{
	name					= "Volvo TVC m/42",
	buildCostMetal			= 1800,
	description			= "Heavy truck - deploys into assembly yards",
	iconType				= "truck_factory",
	mass					= 600, -- 2x default truck
	maxDamage 				= 600, -- 2x default truck
	trackOffset				= 25,
	trackWidth				= 17,
	-- make it less mobile than transport trucks
	turnRate				= 330,
	
	customParams = {
		dontCount				= false, -- override truck as TVC can be a factory!
		maxvelocitykmh			= 52,
		normaltex			= "",
	}
}

SWEVolvoTVC_swevehicleyard = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swevehicleyard1 = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swegunyard = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swegunyard2 = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swespyard = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swespyard1 = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swetankyard = SWE_VolvoTVC:Clone("swevolvotvc")
SWEVolvoTVC_swetankyard1 = SWE_VolvoTVC:Clone("swevolvotvc")

SWEVolvoTVC_swevehicleyard.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swevehicleyard1.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swegunyard.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swegunyard2.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swespyard.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swespyard1.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swetankyard.buildpic = 'swevolvotvc.png'
SWEVolvoTVC_swetankyard1.buildpic = 'swevolvotvc.png'

return lowerkeys({
	["SWEVolvoTVC"] = SWE_VolvoTVC,
	["SWEVolvoTVC_swevehicleyard"] = SWEVolvoTVC_swevehicleyard,
	["SWEVolvoTVC_swevehicleyard1"] = SWEVolvoTVC_swevehicleyard1,
	["SWEVolvoTVC_swegunyard"] = SWEVolvoTVC_swegunyard,
	["SWEVolvoTVC_swegunyard2"] = SWEVolvoTVC_swegunyard2,
	["SWEVolvoTVC_swespyard"] = SWEVolvoTVC_swespyard,
	["SWEVolvoTVC_swespyard1"] = SWEVolvoTVC_swespyard1,
	["SWEVolvoTVC_swetankyard"] = SWEVolvoTVC_swetankyard,
	["SWEVolvoTVC_swetankyard1"] = SWEVolvoTVC_swetankyard1,
})
