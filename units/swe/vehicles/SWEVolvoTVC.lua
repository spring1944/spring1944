Unit('SWE_VolvoTVC'):Extends('Truck'):Attrs{
	name					= "Volvo TVC m/42",
	buildCostMetal			= 1800,
	mass					= 600, -- 2x default truck
	maxDamage 				= 600, -- 2x default truck
	trackOffset				= 25,
	trackWidth				= 17,
	-- make it less mobile than transport trucks
	turnRate				= 330,
	
	customParams = {
		dontCount				= false, -- override truck as TVC can be a factory!
		maxvelocitykmh			= 52,
	}
}

