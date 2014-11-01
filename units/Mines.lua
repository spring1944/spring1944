local GBRSatchelCharge = Mine:New{
	name						= "Satchel Charge",
	description					= "Anti-Building Demolitions Pack",
	buildTime					= 750,
	explodeAs					= "SatchelCharge",
	maxSlope					= 80,
	minCloakDistance			= 20,
	selfDestructAs				= "SatchelCharge",
	selfDestructCountdown		= 10,
	sightDistance				= 1,
	useBuildingGroundDecal		= false,
	customParams = {
		candetonate 				= true,
	},
}

-- Mines --
local APMine = Mine:New{
	name						= "Anti-Personnel Mine",
	buildingGroundDecalSizeX	= 1,
	buildingGroundDecalSizeY	= 1,
	explodeAs					= "APMine",
	selfDestructAs				= "APMine",
	weapons = {
		[1] = {
			name					= "APMine",
			onlyTargetCategory		= "MINETRIGGER",
		}
	},
}

local ATMine = Mine:New{
	name						= "Anti-Tank Mine",
	buildingGroundDecalSizeX	= 2,
	buildingGroundDecalSizeY	= 2,
	explodeAs					= "ATMine",
	selfDestructAs				= "ATMine",
	weapons = {
		[1] = {
			name					= "ATMine",
			badTargetCategory		= "SOFTVEH",
			onlyTargetCategory		= "SOFTVEH OPENVEH HARDVEH",
		}
	},
}

-- Mine Signs --
local APMineSign = MineSign:New{
	name						= "AP Minefield",
	description					= "Warning! AP Mines!",
	maxSlope				= 3,
	customParams = {
		minetype				= "apminesign",
	},
}

local ATMineSign = MineSign:New{
	name						= "AT Minefield",
	description					= "Warning! AT Mines!",
	maxSlope				= 15,
	customParams = {
		minetype				= "atminesign",
	},
}

local units = {
	APMine = APMine,
	ATMine = ATMine,
	GBRSatchelCharge = GBRSatchelCharge,
}

for _, side in pairs(Sides) do
	units[side .. "apminesign"] = APMineSign:New{}
	units[side .. "atminesign"] = ATMineSign:New{}
	-- tank trap just uses plain base class for now...
	-- .. may do side specific models later
	units[side .. "tankobstacle"] = TankObstacle:New{} 
end

return lowerkeys(units)