local JPN_IsuzuTX40Base = TransportTruck:New{
	name					= "Type 97 Isuzu TX 40",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/JPNIsuzuType40_normals.png",
	},
}

local JPN_IsuzuTX40 = JPN_IsuzuTX40Base:New(TransportTruck)
local JPN_PontoonTruck = JPN_IsuzuTX40Base:New(PontoonTruck, true):New{
	customParams = {
		normaltex			= "unittextures/JPNPontoonTruck_normals.png",
	},
}

return lowerkeys({
	["JPNIsuzuTX40"] = JPN_IsuzuTX40,
	["JPNPontoonTruck"] = JPN_PontoonTruck,
})
