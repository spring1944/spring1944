Unit('GER_OpelBlitzBase'):Extends('Truck'):Attrs{
	name					= "Opel Blitz",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GER_OpelBlitz'):Extends('GER_OpelBlitzBase'):Extends('TransportTruck')
Unit('GER_PontoonTruck'):Extends('GER_OpelBlitzBase'):Extends('PontoonTruck') -- name append

