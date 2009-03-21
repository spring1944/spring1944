local armorDefs = {
	infantry	=	{
		--**Germany**--
		"GERAirEngineer",
		"GERObserv",
		"GEREngineer",
		"GERGrW34",
		"GERHQEngineer",
		"GERLabourer",
		"GERMG42",
		"GERMP40",
		"GERPanzerfaust",
		"GERPanzerschrek",
		"GERRifle",
		"GERSniper",

		--US--
		"USAirEngineer",
		"USEngineer",
		"USGIBAR",
		"USGIBazooka",
		"USGIFlamethrower",
		"USGIMG",
		"USGIRifle",
		"USGISniper",
		"USGIThompson",
		"USHQEngineer",
		"USM1Mortar",
		"USObserv",

		--USSR--
		"RUSCommander",
		"AI_RUSCommander",
		"RUSEngineer",
		"RUSRifle",
		"RUSPPsh",
		"RUSDP",
		"RUSPTRD",
		"RUSMaxim",
		"RUSRPG43",
		"RUSObserv",
		"RUSMortar",
		"RUSMaxim",
		"RUSSniper",
		"RUSPartisanRifle",
		"RUSCommissar",
		"AI_RUSCommissar",

		--Britain--
		"GBRHQEngineer",
		"GBREngineer",
		"GBRRifle",
		"GBRSTEN",
		"GBRBren",
		"GBRVickers",
		"GBRObserv",
		"GBRSniper",
		"GBR3inMortar",
		"GBRPIAT",
		"GBRCommandoC",
		"GBRCommando",
	},
	
	guns	=	{
		--**Germany**--
		"GERleIG18_bax",
		"GERleIG18_gunyard",
		"GERFlaK38",
		"GERPaK40",
		"GERleFH18",
		"GERleFH18_Stationary",
		"germg42_sandbag",
		"GERPaK40_Stationary",
		"GERFlak38_Stationary",
		"GERNebelwerfer",
		"GERNebelwerfer_Stationary",

		--US--
		"USM8Gun_bax",
		"USM8Gun_gunyard",
		"USM2Gun",
		"USM2Gun_Stationary",
		"USM5Gun",
		"usgimg_sandbag",
		"USM5Gun_Stationary",
		"USM1Bofors_Stationary",

		--USSR--
		"RUS61K",
		"RUSZiS2",
		"RUSZiS2_Stationary",
		"RUSZiS3",
		"RUSZiS3_Stationary",
		"rusmaxim_sandbag",
		"RUSM30",
		"RUSM30_Stationary",
		"RUS61K_Stationary",

		--Britain--
		"GBR25Pdr",
		"GBR25Pdr_Stationary",
		"GBR17Pdr",
		"gbrvickers_sandbag",
		"GBR17Pdr_Stationary",	
		"GBRBofors_Stationary",
	},

	lightBuildings	=	{
		--Germany--
		"GERBarracks",
		"GERVehicleYard",
		"GERResource",
		"GERStorage",
		"GERGunYard",
		"GERTankYard",
		"GERSupplyDepot",
		"GERTruckSupplies",
		"GERSPYard",

		--US--
		"USHQ",
		"AI_USHQ",
		"USCP",
		"USBarracks",
		"USVehicleYard",
		"USResource",
		"USStorage",
		"USGunYard",
		"USSupplyDepot",
		"USTruckSupplies",
		"USSPYard",

		--USSR--
		"RUSBarracks",
		"RUSVehicleYard",
		"RUSResource",
		"RUSStorage",
		"RUSGunYard",
		"RUSShack",
		"RUSPResource",
		"RUSSupplyDepot",
		"RUSTruckSupplies",
		"RUSSPYard",

		--Britain--
		"GBRResource",
		"GBRStorage",
		"GBRGunYard",
		"GBRVehicleYard",
		"GBRBarracks",
		"GBRLZ",
		"GBRHQ",
		"AI_GBRHQ",
		"GBRSupplyDepot",
		"GBRTruckSupplies",
		"GBRSPYard",
	},

	bunkers	=	{
		--**Germany**--
		"GERHQBunker",
		"AI_GERHQBunker",
	
		--US--

		--USSR--

		--Britain--
	
	},

	sandbags	=	{
			"Sandbags",
	},

	mines	=	{
		"APMine",
		"ATMine",
	},

	flag	=	{
		"GERflag",
		"USFlag",
		"RUSFlag",
		"GBRFlag",
		"flag",
	},

	tanks	=	{
		--**Germany**--
		"GERPanzerIII",
		"GERStuGIII",
		"GERPanzerIV",
		"GERPanther",
		"GERTiger",
		"GERTigerII",
		"GERJagdpanzerIV",

		--US--
		"USM4A4Sherman",
		"USM4A376Sherman",
		"USM4A3105Sherman",
		"USM5Stuart",

		--USSR--
		"RUSISU152",
		"RUST60",
		"RUST70",
		"RUST3485",
		"RUST3476",
		"RUSISU122",
		"RUSISU152",
		"RUSKV1",
		"RUSIS2",
		"RUSSU85",
		"RUSSU100",
		"RUSSU122",

		--Britain--

		"GBRShermanFirefly",
		"GBRCromwell",
		"GBRCromwellMkVI",
		"GBRChurchillMkVII",
		"GBRKangaroo",
	},

	armouredVehicles	=	{
		--**Germany**--
		"GERSdKfz250",
		"GERSdKfz251",
		"GERMarder",
		"GERWespe",

		--US--
		"USM8Greyhound",
		"USM3Halftrack",
		"USM7Priest",

		--USSR--
		"RUSBA64",
		"RUSM5Halftrack",
		"RUSSU76",

		--Britain--
		"GBRDaimler",
		"GBRM5Halftrack",
		"GBRAECMkIII",
		"GBRSexton",
	},

	unarmouredVehicles	=	{
		--**Germany**--
		"GEROpelBlitz",
		"GEROpelBlitz_Eng",
		"GERSupplyTruck",
		"GERFlaK38_Truck",
		"GERPaK40_Truck",
		"GERleFH18_Truck",
		"GERSdkfz10",
		"GERSdkfz9",

		--US--
		"USGMCTruck",
		"USGMCTruck_Eng",
		"USGMCEngVehicle",
		"USSupplyTruck",
		"usdukw",
		"USM1Bofors_Truck",
		"USM2Gun_Truck",
		"USM5Gun_Truck",

		--USSR--
		"RUSZiS5",
		"RUSZiS5_Eng",
		"RUSGAZAAA",
		"RUSBM13N",
		"RUSSupplyTruck",
		"RUSM30_Truck",
		"RUSZiS2_Truck",
		"RUSZiS3_Truck",

		--Britain--
		"GBRBedfordTruck",
		"GBRBedfordTruck_Eng",
		"GBRMatadorEngVehicle",
		"GBRSupplyTruck",
		"GBRBofors_Truck",
		"GBR17Pdr_Truck",
		"GBR25Pdr_Truck",

		--All--
		"RubberDingy",
		"PontoonRaft",
	},

	planes	=	{
		"GERFi156",
		"USL4",
		"RUSPo2",
		"GBRAuster",
		--**Germany**--
		"GERBf109",
		"GERFw190",
		"GERFw190G",
		"GERJu87G",
	
		--US--
		"USP47Thunderbolt",
		"USP51DMustang",
		"USP51DMustangGA",

		--USSR--
		"RUSYak3",
		"RUSIL2",

		--Britain--
		"GBRSpitfireMkXIV",
		"GBRSpitfireMkIX",
		"GBRTyphoon",
	},
	
	heavyPlanes	=	{
		--**Germany**--
	
		--US--

		--USSR--

		--Britain--

	},
		squadSpawners	=	{
	"gbr_platoon_assault",
	"gbr_platoon_rifle",
	"gbr_platoon_at",
	"gbr_platoon_commando",
	"gbr_platoon_commando_lz",
	"gbr_platoon_hq",
	"gbr_platoon_hq_assault",
	"gbr_platoon_hq_rifle",
	"gbr_platoon_mg",
	"gbr_platoon_mortar",
	"gbr_platoon_sniper",
	"gbr_platoon_scout",
	
	"ger_platoon_assault",
	"ger_platoon_rifle",
	"ger_platoon_at",
	"ger_platoon_hq",
	"ger_platoon_hq_assault",
	"ger_platoon_hq_rifle",
	"ger_platoon_mg",
	"ger_platoon_mortar",
	"ger_platoon_sniper",
	"ger_platoon_scout",
	
	"rus_platoon_assault",
	"rus_platoon_rifle",
	"rus_platoon_atlight",
	"rus_platoon_atheavy",
	"rus_platoon_big_rifle",
	"rus_platoon_big_assault",
	"rus_platoon_mg",
	"rus_platoon_mortar",
	"rus_platoon_sniper",
	"rus_platoon_scout",
	"rus_platoon_partisan",

	"us_platoon_assault",
	"us_platoon_rifle",
	"us_platoon_at",
	"us_platoon_hq",
	"us_platoon_hq_assault",
	"us_platoon_hq_rifle",
	"us_platoon_mg",
	"us_platoon_mortar",
	"us_platoon_sniper",
	"us_platoon_scout",
	"us_platoon_flame",
	},
}

-- convert to named maps  (trepan is a noob)
for categoryName, categoryTable in pairs(armorDefs) do
	local t = {}
	for _, unitName in pairs(categoryTable) do
		t[unitName] = 1
	end
	armorDefs[categoryName] = t
end

local system = VFS.Include('gamedata/system.lua')	

return system.lowerkeys(armorDefs)

--	Infantry=;
--	Guns=;
--	LightBuildings=;
--	Bunkers=;
--	Sandbags=;
--	Mines=;
--	Flags=;
--	Tanks=;
--	ArmouredVehicles=;
--	UnarmouredVehicles=; 
