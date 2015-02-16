local JPN_RiKi = EngineerVehicle:New{
	name					= "Type 95 Crane Vehicle Ri-Ki",
	maxReverseVelocity		= 1.25,
	maxVelocity				= 2.5,
	movementClass			= "TANK_Medium",
	trackOffset				= 3,
	trackWidth				= 12,
}

return lowerkeys({
	["JPNRiKi"] = JPN_RiKi,
})
