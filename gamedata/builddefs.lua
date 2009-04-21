local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

buildoptions = 
{

				--------------------
				-- american units --
				--------------------

	ushq = 
	{
		"ushqengineer",
		--"usairengineer",
		"us_platoon_hq",
		"usgmctruck",
		--"us_platoon_hq_rifle",
		--"us_platoon_hq_assault",
	},

	uscp =
	{
		"ushqengineer",
		"usengineer",
		"usgmctruck",
		--"usjeep",
	},

	ushqengineer =
	{
		"usbarracks",
--		"usflag",
		"usstorage",
		--"usgmctruck",
		"apminesign",
		"atminesign",
		--"sandbags",
		"tankobstacle",
		"rubberdingy",
		"pontoonraft",
	},

	usbarracks =
	{
		"ushqengineer",
		"usengineer",
		"us_platoon_rifle",
		"us_platoon_assault",
		"us_platoon_mg",
		"us_platoon_at",
		--"us_platoon_scout",
		"us_platoon_sniper",
		"us_platoon_flame",
		"us_platoon_mortar",
		"usm8gun_bax",
		"usgmctruck",
	},

	usengineer =
	{
		"usvehicleyard",
		"usgunyard",
		"usradar",
		--"uscp",
--		"usflag",
		"usstorage",
		--"usgmctruck",
		"atminesign",
		"apminesign",
		"tankobstacle",
		--"sandbags",
		"rubberdingy",
		"pontoonraft",

	},

	usvehicleyard =
	{
		"usgmcengvehicle",
		"usm3halftrack",
		"usdukw",
		"usm8greyhound",
		"usm8scott",
	},

	usgunyard =
	{
		--"usgmctruck",
		"usm8gun_gunyard",
		"usm5gun_truck",
		"usm2gun_truck",
		"usm1bofors_truck",
	},


	usgmcengvehicle =
	{
		"usbarracks",
		"usgunyard",
		"usvehicleyard",
		"usradar",
		--"usspyard",
		"ustankyard",
		"usstorage",
		"ussupplydepot",
		"tankobstacle",
	},

	ustankyard =
	{
		"usm5stuart",
		"usm4a4sherman",
		"usm10wolverine",
	},
	
	ustankyard1 =
	{
		"usm4a376sherman",
		"usm4a3105sherman",
		"usm4jumbo",
	},

	usspyard =
	{
		"usm8scott",
		"usm4a3105sherman",
		"usm10wolverine",
		"usm7priest",
	},

	ussupplydepot =
	{
		"usm3halftrack",
	},

	usairfield =
	{
		"usl4",
		"usp51dmustang",
		"usp51dmustangga",
		"usp47thunderbolt",
	},

				--------------------
				-- german units   --
				--------------------

	gerhqbunker =
	{
		"gerhqengineer",
		--"gerairengineer",
		"ger_platoon_hq",
		"geropelblitz",
		--"ger_platoon_hq_rifle",
		--"ger_platoon_hq_assault",
	},

	gerhqengineer =
	{
		"gerbarracks",
--		"gerflag",
		"gerstorage",
		"apminesign",
		"atminesign",
		--"sandbags",
		"tankobstacle",
		--"geropelblitz",
		"gersturmboot",
		"pontoonraft",
	},

	gerbarracks =
	{
		"gerhqengineer",
		"gerengineer",
		"ger_platoon_rifle",
		"ger_platoon_assault",
		"ger_platoon_mg",
		--"ger_platoon_scout",
		"ger_platoon_at",
		"ger_platoon_sniper",
		"ger_platoon_mortar",
		"gerleig18_bax",
		"geropelblitz",
	},

	gerengineer =
	{
		"gervehicleyard",
		"gerbarracks",
		"gergunyard",
		"gerradar",
--		"gerflag",
		"gerstorage",
		"atminesign",
		"apminesign",
		--"sandbags",
		"tankobstacle",
		--"geropelblitz",
		"gersturmboot",
		"pontoonraft",
	},

	gervehicleyard =
	{
		"gersdkfz9",
		--"gersupplytruck",
		"gersdkfz250",
		"gersdkfz251",
		--"gersdkfz10",
		"germarder",
	},

	gergunyard =
	{
		--"geropelblitz",
		--"gerflak38_truck",
		"gerleig18_gunyard",
		"gerpak40_truck",
		"gerlefh18_truck",
		"gernebelwerfer_truck",
		"gerflak38_truck",
	},

	gersdkfz9 =
	{
		"gerbarracks",
		"gergunyard",
		"gervehicleyard",
		"gerradar",
		--"gerspyard",
		"gertankyard",
		--"gerairfield",
		"gerstorage",
		"gersupplydepot",
		"tankobstacle",
	},

	gertankyard =
	{
		"gerpanzeriii",
		"gerstugiii",
		"gertiger",
	},
	
	gertankyard1 =
	{
		"gerpanzeriv",
		"gerjagdpanzeriv",
		"gerwespe",
		"gertiger",
	},
	
	gertankyard2 =
	{
		"gerpanther",
		"gertigerii",
	},

	gerspyard =
	{
		"germarder",
		"gerstugiii",
		"gerjagdpanzeriv",
		"gerwespe",
	},

	gersupplydepot =
	{
		"gersdkfz251",
	},

	gerairfield =
	{
		"gerfi156",
		"gerbf109",
		"gerfw190",
		"gerju87g",
		"gerfw190g",
	},

				----------------------
				----/british units----
				----------------------

	gbrhq =
	{
		"gbrhqengineer",
		--"usairengineer",
		"gbr_platoon_hq",
		"gbrbedfordtruck",
		--"gbr_platoon_hq_rifle",
		--"gbr_platoon_hq_assault",
	},

	gbrhqengineer =
	{
		"gbrbarracks",
--		"gbrflag",
		--"gbrresource",
		"apminesign",
		"atminesign",
		--"sandbags",
		"tankobstacle",
		"gbrstorage",
		--"gbrbedfordtruck",
		"rubberdingy",
		"pontoonraft",
	},

	gbrbarracks =
	{
		"gbrhqengineer",
		"gbrengineer",
		"gbr_platoon_rifle",
		"gbr_platoon_assault",
		"gbr_platoon_mg",
		--"gbr_platoon_scout",
		"gbr_platoon_at",
		"gbr_platoon_sniper",
		"gbr_platoon_mortar",
		"gbr_platoon_commando",
		"gbrbedfordtruck",
	},

	gbrgunyard =
	{
		--"gbrbedfordtruck",
		"gbr17pdr_truck",
		"gbr25pdr_truck",
		"gbrbofors_truck",
	},

	gbrheavygunyard =
	{
		"gbrbedfordtruck",
		"gbr17pdr_truck",
		"gbr25pdr_truck",
	},

	
	gbrcommandoc =
	{
	"gbrsatchelcharge",
	"gbrlz",
	},

	gbrcommando =
	{
	"gbrsatchelcharge",
	},

	gbrlz =
	{
	"gbr_platoon_commando_lz",
	},

	gbrengineer =
	{
		"gbrvehicleyard",
		"gbrgunyard",
		"gbrradar",
--		"gbrflag",
		"gbrstorage",
		"atminesign",
		"apminesign",
		--"sandbags",
		"tankobstacle",
		--"gbrstorage",
		--"gbrbedfordtruck",
		"rubberdingy",
		"pontoonraft",

	},

	gbrvehicleyard =
	{
		"gbrmatadorengvehicle",
		--"gbrsupplytruck",
		"gbrm5halftrack",
		"gbrdaimler",
		"gbrkangaroo",
	},

	gbrmatadorengvehicle =
	{
		"gbrbarracks",
		"gbrgunyard",
		"gbrvehicleyard",
		"gbrradar",
		--"gbrspyard",
		"gbrtankyard",
		--"gbrairfield",
		"gbrstorage",
		"gbrsupplydepot",
		"tankobstacle",		
	},

	gbrtankyard =
	{
		"gbraecmkii",
		"gbrcromwell",
		"gbrcromwellmkvi",
		"gbrshermanfirefly",
	},
	
	gbrtankyard1 =
	{
		"gbrkangaroo",
		--"gbrshermanfirefly",
		"gbrsexton",
		"gbrm10achilles",
		"gbrchurchillmkvii",
	},

	gbrspyard =
	{
		"gbrm10achilles",
		"gbrsexton",
	},


	gbrsupplydepot =
	{
		"gbrm5halftrack",
	},

	gbrairfield =
	{
		"gbrauster",
		"gbrspitfiremkxiv",
		"gbrtyphoon",
		"gbrspitfiremkix",
	},

				--------------------
				-- soviet units   --
				--------------------


	ruscommander =
	{
--		"rusflag",
		--"rusresource",
		--"ruscommissar",
		"ruspshack",
		"rusbarracks",
		"rusgunyard",
		--"ruszis5",
		"apminesign",
		"atminesign",
		"tankobstacle",
		"russtorage",
		--"sandbags",
		"ruspg117",
		"pontoonraft",
	},

	ruspshack =
	{
		--"ruscommissar1",
		"rus_platoon_partisan",
	},


	rusbarracks =
	{
		"ruscommissar",
		"rusengineer",
		"rus_platoon_rifle",
		--"rus_platoon_big_rifle",
		"rus_platoon_assault",
		--"rus_platoon_big_assault",
		"rus_platoon_mg",
		--"rus_platoon_scout",
		--"rus_platoon_atlight",
		"rus_platoon_atheavy",
		"rus_platoon_sniper",
		"rus_platoon_mortar",
		"ruszis5",
	},

	rusengineer =
	{
		"rusvehicleyard",
		"rusgunyard",
		"rusradar",
--		"rusflag",
		--"rusresource",
		--"ruszis5",
		"apminesign",
		"atminesign",
		"tankobstacle",
		"russtorage",
		--"sandbags",
		"ruspg117",
		"pontoonraft",
	},

	ruscommissar =
	{
--		"rusflag",
		--"rusresource",
		--"ruscommissar",
		"ruspshack",
		"rusbarracks",
		"rusgunyard",
		--"ruszis5",
		"apminesign",
		"atminesign",
		"tankobstacle",
		--"sandbags",
		"russtorage",
		"ruspg117",
		"pontoonraft",
	},

	rusk31 =
	{
		"rusbarracks",
		"rusgunyard",
		"rusvehicleyard",
		"rusradar",
		--"russpyard",
		"rustankyard",
		--"rusairfield",
		"russtorage",
		"russupplydepot",
		"tankobstacle",		
	},

	rusvehicleyard =
	{
		"rusk31",
		--"russupplytruck",
		"rusba64",
		"rusm5halftrack",
		"rusgazaaa",
		"rust60",
		"russu76",
	},

	rusgunyard =
	{
		--"ruszis5",
		"ruszis2_truck",
		"ruszis3_truck",
		"rusm30_truck",
		"rus61k_truck",
	},

	rustankyard =
	{
		"rust70",
		"rust3476",
		"rusisu152",
	},
	
	rustankyard1 =
	{
		"rust3485",
		"russu100",
		"rusis2",
		"rusbm13n",
	},

	russpyard =
	{
		"russu76",
		"russu85",
		"russu100",
		--"russu122", 
		"rusbm13n",
		"rusisu152",
	},

	russupplydepot =
	{
		"rusm5halftrack",
	},
	
	rusairfield =
	{
		"ruspo2",
		"rusyak3",
		"rusil2",
	},
}
if (modOptions) then
	if (modOptions.simple_tanks) then
		local gertankyard = {
			"gerstugiii",
			"gerpanzeriv",
			"gerjagdpanzeriv",
			"gertiger",
			}
		local gertankyard1 = {
			"gerpanther",
			"gertigerii",
			"gerwespe",
		}
		buildoptions.gertankyard = gertankyard
		buildoptions.gertankyard1 = gertankyard1
	end
end

return buildoptions
