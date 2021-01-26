local units = {}

for _, side in pairs(Sides) do
	-- Yards
	units[side .. "boatyard"] = BoatYard:New{}
	units[side .. "boatyardlarge"] = BoatYardLarge:New{}
	units[side .. "gunyard"] = GunYard:New{}
	units[side .. "gunyard2"] = GunYardLongRange:New{}
	units[side .. "spyard"] = GunYardSP:New{} -- TODO: change unitnames too
	units[side .. "spyard1"] = GunYardTD:New{} 
	units[side .. "vehicleyard"] = VehicleYard:New{}
	units[side .. "vehicleyard1"] = VehicleYardArmour:New{}
	units[side .. "tankyard"] = TankYard:New{}
	units[side .. "tankyard1"] = TankYardAdv:New{}
	units[side .. "tankyard2"] = TankYardHeavy:New{}
	units[side .. "radar"] = Radar:New{}
	units[side .. "supplydepot"] = SupplyDepot:New{}
	-- Logistics
	units[side .. "storage"] = Storage:New{	
		objectName				= "GEN/Storage.S3O",
		customParams = {
			normaltex			= "unittextures/LogisticsLarge_normals.dds",
		},
	}
	units[side .. "trucksupplies"] = Supplies:New{}
end

-- JPN Upgrades are a bit different
units["jpntankyard2"].name = "Support Tank Depot"
units["jpntankyard2"].description = "Support Armour Prep. Facility"
units["jpnvehicleyard2"] = VehicleYardArmour:New{
	name = "Light Vehicle & Amphibian Yard",
	description = "Light Vehicle & Amphibian Prep. Facility",
}

-- US has a second type of vehicles yard
units["usvehicleyard2"] = VehicleYardArmour:New{}
units["usvehicleyard2"].name = "Uppgunned Light Vehicle & Armour Yard"
units["usvehicleyard2"].description = "Uppgunned Light Vehicle & Armour Prep. Facility"

-- Side-specific storages
units["jpnstorage"] = Storage:New{	
	objectName				= "jpn/jpnstorage.s3o",
	customParams = {
		normaltex			= "unittextures/JPNStorage_normals.png",
	},
}
units["hunstorage"] = Storage:New{	
	objectName				= "hun/hunstorage.s3o",
	customParams = {
		normaltex			= "unittextures/HUNStorage_normals.png",
	},
}

--units["usspyard1"] = nil

-- SWE supply depot looks different
units["swesupplydepot"].objectname = "swe/swesupplydepot.s3o"

-- Extra units
units["usdukwsupplies"] = Supplies:New{}
units["gbrglidersupplies"] = SuppliesSmall:New{}
units["ruspartisansupplies"] = SuppliesSmall:New{
    customParams = {
		spawnsunit = "ruspartisanrifle",
    },
}

-- Radars have slightly more specific names
units["gbrradar"].name = "AA No4 Mk3(P) Light Warning Set"
units["gerradar"].name = "Freya Air Control Station"
units["itaradar"].name = "Freya Air Control Station"
units["jpnradar"].name = "Type 1 Model 2 'Mobile Matress' Radar"
units["rusradar"].name = "RUS-2 Air Control Station"
units["usradar"].name = "AN/TPS-3 (SCR-602-T8) Light Aircraft Detector"
units["hunradar"].name = "SAS Air Control Station"
units["hunradar"].corpse = "hunradar_destroyed"
units["sweradar"].name = "Acoustic Airplane Locator"

return lowerkeys(units)
