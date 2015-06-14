local itaDefs = {
	 -----------------------------
	 -- ITA Platoons and Squads --
	 -----------------------------

	["ita_platoon_hq"] =
	{
		members = {
			"itarifle",
			"itam38",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
		},
		name = "Rifle Squad",
		description = "5 x Carcano M91 Rifle, 1 x M38 SMG: Small Combat Squad",
		buildCostMetal = 580,
		buildPic = "ITARifle.png",
		buildTime = 580,
		side = "ITA",
	},

	["ita_platoon_rifle"] =
	{
		members = {
			"itasoloat",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
			"itarifle",
			"itabreda30",
		},
		name = "Carcano Rifle Platoon",
		description = "8 x Carcano M91 Rifle, 1 x Solothurn Anti-Tank, 1 x Breda 30 Light Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1410,
		buildPic = "ITARifle.png",
		buildTime = 1410,
		side = "ITA",
	},

	["ita_platoon_assault"] =
	{
		members = {
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itam38",
			"itasoloat",
		},
		name = "Assault Platoon",
		description = "9 x M38 SMG, 1 x Solothurn Anti-Tank: Close-Quarters Assault Infantry",
		buildCostMetal = 1400,
		buildPic = "ITAM38.png",
		buildTime = 1400,
		side = "ITA",
	},

	["ita_platoon_mg"] =
	{
		members = {
			"itamg",
			"itamg",
			"itabreda30",
			"itaobserv",
		},
		name = "Machinegun Squad",
		description = "2 x M37 Machinegun, 1 x Breda 30 Light Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1200,
		buildPic = "ITAM37.png",
		buildTime = 1200,
		side = "ITA",
	},

	["ita_platoon_sniper"] =
	{
		members = {
			"itasniper",
			"itaobserv",
		},
		name = "Sniper Team",
		description = "1 x Carcano M91 Sniper, 1 x Spotter: Long-Range Fire Support",
		buildCostMetal = 1140,
		buildPic = "ITASniper.png",
		buildTime = 1140,
		side = "ITA",
	},

	["ita_platoon_mortar"] =
	{
		members = {
			"itamortar",
			"itaobserv",
			"itamortar",
			"itamortar",
		},
		name = "Mortar Team",
		description = "3 x 81/14 Mortar, 1 x Spotter: Heavy Infantry Fire Support",
		buildCostMetal = 1580,
		buildPic = "ITAMortar.png",
		buildTime = 1580,
		side = "ITA",
	},
	
	["ita_platoon_at"] =
	{
		members = {
			"itapanzerfaust",
			"itapanzerfaust",
			"itasoloat",
			"itasoloat",
		},
		name = "Anti-Tank Squad",
		description = "2 x Panzerfaust, 2 x Solothurn: Anti-Tank Infantry",
		buildCostMetal = 450,
		buildPic = "ITAPanzerfaust.png",
		buildTime = 450,
		side = "ITA",
	},
	
	-- ["ita_platoon_at"] =
	-- {
		-- members = {
			-- "itasoloat",
			-- "itasoloat",
			-- "itasoloat",
			-- "itaelitesoloat",
		-- },
		-- name = "Anti-Tank Squad",
		-- description = "3 x Solothurn + 1 x Elitesolothurn  : Anti-Tank Infantry",
		-- buildCostMetal = 800,
		-- buildPic = "ITASolothurn.png",
		-- buildTime = 900,
		-- side = "ITA",
	-- },
	
	["ita_platoon_infgun"] =
	{
		members = {
			"itacannone65",
			"itaobserv",
		},
		name = "Infantry Gun Team",
		description = "1 x Cannone da 65/17, 1 x Spotter: Long-Range Fire Support",
		buildCostMetal = 950,
		buildPic = "ITACannone65.png",
		buildTime = 950,
		side = "ITA",
	},
	["ita_platoon_bersaglieri"] =
	{
		members = {
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglierim38",
			"itabersaglierim38",
			"itaelitesoloat",
			"itabreda30",
			"itaobserv",
		},
		name = "Bersaglieri Combat Platoon",
		description = "8 x Bersaglieri Rifles, 2 x Bersaglieri SMG Troopers, 1 x Elitesolothurn, 1 x Bersaglieri Machinegunner, 1 x Bersaglieri Scout: Bersaglieri Assault Marksmen",
		buildCostMetal = 1900,
		buildPic = "ITAbersaglieri.png",
		buildTime = 1900,
		side = "ITA",
	},
	["ita_platoon_carabinieri"] =
	{
		members = {
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
			"itacarabinieri",
		},
		name = "Black Brigade Anti-Partisan Platoon",
		description = "10 x Carabinieri: Anti-Partisan Platoon",
		buildCostMetal = 1500,
		buildPic = "ITARifle.png",
		buildTime = 800,
		side = "ITA",
	},
	["ita_platoon_alpini"] =
	{
		members = {
			"itaalpinirifle",
			"itaalpinirifle",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinifnab43",
			"itaalpinimortar",
			"itaalpinirifle",
			"itaalpinirifle",
			"itaalpiniobserv",
		},
		name = "Alpini Mountain Division",
		description = "4 x Alpini Rifles, 8 x Alpini SMG Troopers, 1 x Alpini Mortar , 1 x Alpini Scout: Alpini Mountain Squad",
		buildCostMetal = 4000,
		buildPic = "itaalpini.png",
		buildTime = 4000,
		side = "ITA",
	},

	["ita_platoon_lct"] =
	{
		members = {
			"itam1542",
			"itam1542",
			"itasemovente75_18",
		},
	},
	["ita_platoon_landing"] =
	{
		members = {
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglierim38",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglieririfle",
			"itabersaglierim38",
			"itabersaglierim38",
			"itaelitesoloat",
			"itabreda30",
			"itaobserv",
			"itaelitesoloat",
			"itabreda30",
			"itaobserv",
		},
        buildCostMetal = 3200,
		-- other fields not needed for transport squads
	},
}

return itaDefs
