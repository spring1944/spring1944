local SWE_VolvoTVC = Truck:New{
	name					= "Volvo TVC m/42",
	buildCostMetal			= 1800,
	mass					= 600, -- 2x default truck
	maxDamage 				= 600, -- 2x default truck
	trackOffset				= 25,
	trackWidth				= 17,
	-- make it less mobile than transport trucks
	maxReverseVelocity		= 1.125,
	maxVelocity				= 2.25,
	turnRate				= 330,
	
	customParams = {
		dontCount				= false, -- override truck as TVC can be a factory!
	}
}

return lowerkeys({
	["SWEVolvoTVC"] = SWE_VolvoTVC,
})
