Unit('SWE_ScaniaVabisF11Base'):Extends('Truck'):Attrs{
	name					= "Scania Vabis F11 Truck",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('SWE_ScaniaVabisF11'):Extends('SWE_ScaniaVabisF11Base'):Extends('TransportTruck')
Unit('SWE_PontoonTruck'):Extends('SWE_ScaniaVabisF11Base'):Extends('PontoonTruck') -- name append

