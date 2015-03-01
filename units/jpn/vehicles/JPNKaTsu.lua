local JPNKaTsu = HalfTrack:New(Amphibian):New{
	name					= "Type 4 Ka-Tsu",
	buildCostMetal			= 1100,
	acceleration			= 0.051,
	brakeRate				= 0.195,
	maxDamage				= 1600,
	maxReverseVelocity		= 0.95,
	maxVelocity				= 2,
	trackOffset				= 10,
	trackWidth				= 20,
	turnRate				= 400,
	
	customParams = {
		armor_front				= 12,
		armor_rear				= 10,
		armor_side				= 10,
		armor_top				= 10,
		transportsquad			= "jpn_platoon_amph",
	},
	
	weapons = {
		[1] = {
			name					= "Type93HMG",
			mainDir					= [[1 0 0]],
			maxAngleDif				= 200,
		},
		[2] = {
			name					= "Type93HMG",
			mainDir					= [[-1 0 0]],
			maxAngleDif				= 200,
		},
	},
}

return lowerkeys({
	["JPNKaTsu"] = JPNKaTsu,
})
