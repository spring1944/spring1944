Unit('GBR_BedfordBase'):Extends('Truck'):Attrs{
	name					= "Bedford QL",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GBR_BedfordTruck'):Extends('GBR_BedfordBase'):Extends('TransportTruck')
Unit('GBR_PontoonTruck'):Extends('GBR_BedfordBase'):Extends('PontoonTruck') -- name append

