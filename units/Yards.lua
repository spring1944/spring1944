local units = {}

-- Radars have slightly more specific names
local radarNames = {
	GBR = "AA No4 Mk3(P) Light Warning Set",
	GER = "Freya Air Control Station",
	ITA = "Freya Air Control Station",
	JPN = "Type 1 Model 2 'Mobile Matress' Radar",
	RUS = "RUS-2 Air Control Station",
	US = "AN/TPS-3 (SCR-602-T8) Light Aircraft Detector"
}

for _, side in pairs(Sides) do
	-- Yards
	Unit(side .. "BoatYard"):Extends('BoatYard')
	Unit(side .. "BoatYardLarge"):Extends('BoatYardLarge')
	Unit(side .. "GunYard"):Extends('GunYard')
	Unit(side .. "SPYard"):Extends('SPYard')

	Unit(side .. "VehicleYard"):Extends('VehicleYard')
	Unit(side .. "TankYard"):Extends('TankYard')
	Unit(side .. "TankYard1"):Extends('TankYard1')

	-- Logistics
	Unit(side .. "SupplyDepot"):Extends('SupplyDepot')
	Unit(side .. "TruckSupplies"):Extends('Supplies')

	-- differentiating
	-- US has no TD yard TODO: Add M18 and M36, hurr hurr
	if side ~= "US" then
		Unit(side .. "SPYard1"):Extends('SPYard1')
	end

	local advVeh = Unit(side .. "VehicleYard1"):Extends('VehicleYard1')
	local heavyTanks = Unit(side .. "TankYard2"):Extends('TankYard2')
	local radar = Unit(side .. "Radar"):Extends('Radar')
	local storage = Unit(side .. "Storage"):Extends('Storage'):Attrs{
		objectName				= "GEN/Storage.S3O",
	}

	if radarNames[side] then
		radar:Attrs{
			name = radarNames[side]
		}
	end

	-- JPN Upgrades are a bit different
	if side == 'JPN' then
		heavyTanks:Attrs{
			name = "Support Tank Depot",
			description = "Support Armour Prep. Facility",
		}
		advVeh:Attrs{
			name = "Light Vehicle & Amphibian Yard",
			description = "Light Vehicle & Amphibian Prep. Facility",
		}
		storage:Attrs{
			objectname = "jpn/jpnstorage.s3o"
		}
	end
end

-- Extra units
Unit("USDUKWSupplies"):Extends("Supplies")
Unit("GBRGliderSupplies"):Extends('SuppliesSmall')
Unit("RUSPartisanSupplies"):Extends('SuppliesSmall'):Attrs{
    customParams = {
		spawnsunit = "RUSPartisanRifle",
    },
}


