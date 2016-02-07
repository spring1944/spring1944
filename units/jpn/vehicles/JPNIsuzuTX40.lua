Unit('JPN_IsuzuTX40Base'):Extends('TransportTruck'):Attrs{
	name					= "Type 97 Isuzu TX 40",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('JPN_IsuzuTX40'):Extends('JPN_IsuzuTX40Base'):Extends('TransportTruck')
Unit('JPN_PontoonTruck'):Extends('JPN_IsuzuTX40Base'):Extends('PontoonTruck') -- name append

