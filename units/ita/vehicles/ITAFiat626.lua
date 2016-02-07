Unit('ITA_Fiat626Base'):Extends('Truck'):Attrs{
	name					= "Fiat 626",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('ITA_Fiat626'):Extends('ITA_Fiat626Base'):Extends('TransportTruck')
Unit('ITA_PontoonTruck'):Extends('ITA_Fiat626Base'):Extends('PontoonTruck') -- name append

