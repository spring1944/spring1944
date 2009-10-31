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
    "us_sortie_recon",
    "ushqengineer",
    --"usairengineer",
    "us_platoon_hq",
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
    "usvehicleyard",
    "usgunyard",
    "usradar",
    --"uscp",
--    "usflag",
    "usstorage",
    --"usgmctruck",
    "atminesign",
    "apminesign",
    "tankobstacle",
    --"sandbags",
    "rubberdingy",
    --"pontoonraft",
  },

  usbarracks =
  {
    "ushqengineer",
    --"usengineer",
    "us_platoon_rifle",
    "us_platoon_assault",
    "us_platoon_mg",
    "us_platoon_at",
    --"us_platoon_scout",
    "us_platoon_sniper",
    "us_platoon_flame",
    "us_platoon_mortar",
    "usm8gun",
    "usgmctruck",
  },

  usengineer =
  {
    "usbarracks",
    "usvehicleyard",
    "usgunyard",
    "usradar",
    --"uscp",
--    "usflag",
    "usstorage",
    --"usgmctruck",
    "atminesign",
    "apminesign",
    "tankobstacle",
    --"sandbags",
    "rubberdingy",
    --"pontoonraft",

  },

  usvehicleyard =
  {
    "usgmcengvehicle",
    --"uspontoontruck",
    "usgmctruck",
    "usm3halftrack",
	"usm16mgmc",
    "usdukw",
    "usm8greyhound",
    "usm8scott",
  },
  
  usvehicleyard1 =
  {
    "usgmcengvehicle",
    --"uspontoontruck",
    "usgmctruck",
    "usm3halftrack",
		"usm16mgmc",
    "usdukw",
    "usm8greyhound",
    "usm8scott",
    "usm5stuart",
  },

  usgunyard =
  {
    "usgmcengvehicle",
    "usgmctruck",
    "usm8gun",
    "usm5gun_truck",
    "usm2gun_truck",
    "usm1bofors_truck",
  },

  usspyard =
  {
    "usgmcengvehicle",
    "usgmctruck",
    "usm8gun",
    "usm5gun_truck",
    "usm2gun_truck",
    "usm1bofors_truck",
    "usm8scott",
    "usm7priest",
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
    "usgmcengvehicle",
    "usm5stuart",
    "usm4a4sherman",
    "usm10wolverine",
  },
  
  ustankyard1 =
  {
    "usgmcengvehicle",
    "usm5stuart",
    "usm4a4sherman",
    "usm10wolverine",
    "usm4a3105sherman",
    "usm4a376sherman",
  },
  
  ustankyard2 =
  {
    "usgmcengvehicle",
    "usm5stuart",
    "usm4a4sherman",
    "usm10wolverine",
    "usm4a3105sherman",
    "usm4jumbo",
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
  
  usradar = {
    "us_sortie_recon",
    "us_sortie_interceptor",
    "us_sortie_fighter_bomber",
    "us_sortie_attack",
    "us_sortie_paratrooper",
  },
  
  usboatyard =
  {
    "rubberdingy",
    "pontoonraft",
    "usdukw",
    "uslcvp",
    -- "uspt103-bofors",
	-- "uslct",
--    "uslcsl",
  },
  usboatyardlarge =
  {
    "rubberdingy",
    "pontoonraft",
    "usdukw",
    "uslcvp",
  --  "uspt103-bofors",
    "uslct",
--    "uslcsl",
--	"ustacoma",
--	"usfletcher",
  },

        --------------------
        -- german units   --
        --------------------

  gerhqbunker =
  {
    "ger_sortie_recon",
    "gerhqengineer",
    --"gerairengineer",
    "ger_platoon_hq",
    --"ger_platoon_hq_rifle",
    --"ger_platoon_hq_assault",
  },

  gerhqengineer =
  {
    "gervehicleyard",
    "gerbarracks",
    "gergunyard",
    "gerradar",
--    "gerflag",
    "gerstorage",
    "atminesign",
    "apminesign",
    --"sandbags",
    "tankobstacle",
    --"geropelblitz",
    "gersturmboot",
    --"pontoonraft",
  },

  gerbarracks =
  {
    "gerhqengineer",
    --"gerengineer",
    "ger_platoon_rifle",
    "ger_platoon_assault",
    "ger_platoon_mg",
    --"ger_platoon_scout",
    "ger_platoon_at",
    "ger_platoon_sniper",
    "ger_platoon_mortar",
    "gerleig18",
    "geropelblitz",
  },

  gerbarracksvolkssturm =
  {
    "gerhqengineer",
    --"gerengineer",
	"ger_platoon_volkssturm",
    "ger_platoon_rifle",
    "ger_platoon_assault",
    "ger_platoon_mg",
    --"ger_platoon_scout",
    "ger_platoon_at",
    "ger_platoon_sniper",
    "ger_platoon_mortar",
    "gerleig18",
    "geropelblitz",
  },

  gerengineer =
  {
    "gervehicleyard",
    "gerbarracks",
    "gergunyard",
    "gerradar",
--    "gerflag",
    "gerstorage",
    "atminesign",
    "apminesign",
    --"sandbags",
    "tankobstacle",
    --"geropelblitz",
    "gersturmboot",
    --"pontoonraft",
  },

  gervehicleyard =
  {
    "gersdkfz9",
    --"gerpontoontruck",
    "geropelblitz",
    "gersdkfz250",
    "gersdkfz251",
    "gersdkfz10",
    "germarder",
  },
  
  gervehicleyard1 =
  {
    "gersdkfz9",
    --"gerpontoontruck",
    "geropelblitz",
    "gersdkfz250",
    "gersdkfz251",
    "gersdkfz10",
    "germarder",
    "gerpanzeriii",
  },

  gergunyard =
  {
    "gersdkfz9",
    "geropelblitz",
    "gerleig18",
    "gerpak40_truck",
    "gerlefh18_truck",
    "gernebelwerfer_truck",
    "gerflak38_truck",
  },
  
  gerspyard =
  {
    "gersdkfz9",
    "geropelblitz",
    "gerleig18",
    "gerpak40_truck",
    "gerlefh18_truck",
    "gernebelwerfer_truck",
    "gerflak38_truck",
    "gerwespe",
  },
  
  gerspyard1 =
  {
    "gersdkfz9",
    "geropelblitz",
    "gerleig18",
    "gerpak40_truck",
    "gerlefh18_truck",
    "gernebelwerfer_truck",
    "gerflak38_truck",
    "germarder",
    "gerjagdpanzeriv",
    "gerjagdpanther",
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
	"gerbarracksbunker",
	"gerstoragebunker",
    "tankobstacle",
  },

  gerbarracksbunker = 
  {
    "gerhqengineer",
    "ger_platoon_rifle",
    "ger_platoon_assault",
    "ger_platoon_mg",
    "ger_platoon_at",
    "ger_platoon_sniper",
    "ger_platoon_mortar",
    "gerleig18",
    "geropelblitz",
  },
  
  gertankyard =
  {
    "gersdkfz9",
    "gerpanzeriii",
    "gerstugiii",
    "gerpanzeriv",
    "gertiger",
  },
  
  gertankyard1 =
  {
    "gersdkfz9",
    "gerpanzeriii",
    "gerstugiii",
    "gerpanzeriv",
    "gertiger",
    "gerpanther",
  },
  
  gertankyard2 =
  {
    "gersdkfz9",
    "gerpanzeriii",
    "gerstugiii",
    "gerpanzeriv",
    "gertiger",
    "gertigerii",
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
  
  gerradar = {
    "ger_sortie_recon",
    "ger_sortie_interceptor",
    "ger_sortie_fighter",
    "ger_sortie_fighter_bomber",
    "ger_sortie_attack",
    "ger_sortie_flying_bomb",
  },
  
  gerboatyard =
  {
    "gersturmboot",
	"pontoonraft",
    "gerschsturmboot",
--    "gerrboot",
--    "gersboot",
  },
  gerboatyardlarge =
  {
    "gersturmboot",
    "pontoonraft",
  --  "gerrboot",
--    "gersboot",
    "germfp",
  --  "gerafp",
--	"gertype1934",
  },

        ----------------------
        ----/british units----
        ----------------------

  gbrhq =
  {
    "gbr_sortie_recon",
    "gbrhqengineer",
    --"usairengineer",
    "gbr_platoon_hq",
    --"gbr_platoon_hq_rifle",
    --"gbr_platoon_hq_assault",
  },

  gbrhqengineer =
  {
    "gbrbarracks",
    "gbrvehicleyard",
    "gbrgunyard",
    "gbrradar",
--    "gbrflag",
    "gbrstorage",
    "atminesign",
    "apminesign",
    --"sandbags",
    "tankobstacle",
    --"gbrstorage",
    --"gbrbedfordtruck",
    "rubberdingy",
    --"pontoonraft",
  },

  gbrbarracks =
  {
    "gbrhqengineer",
    --"gbrengineer",
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
    "gbrmatadorengvehicle",
    "gbrbedfordtruck",
    "gbr17pdr_truck",
    "gbr25pdr_truck",
    "gbrbofors_truck",
  },
  
  gbrspyard =
  {
    "gbrmatadorengvehicle",
    "gbrbedfordtruck",
    "gbr17pdr_truck",
    "gbr25pdr_truck",
    "gbrbofors_truck",
    "gbrsexton",
  },
  
  gbrspyard1 =
  {
    "gbrmatadorengvehicle",
    "gbrbedfordtruck",
    "gbr17pdr_truck",
    "gbr25pdr_truck",
    "gbrbofors_truck",
    "gbraecmkii",
    "gbrm10achilles",
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

  gbrengineer =
  {
    "gbrbarracks",
    "gbrvehicleyard",
    "gbrgunyard",
    "gbrradar",
--    "gbrflag",
    "gbrstorage",
    "atminesign",
    "apminesign",
    --"sandbags",
    "tankobstacle",
    --"gbrstorage",
    --"gbrbedfordtruck",
    "rubberdingy",
    --"pontoonraft",

  },

  gbrvehicleyard =
  {
    "gbrmatadorengvehicle",
    --"gbrpontoontruck",
    "gbrbedfordtruck",
    "gbrm5halftrack",
	"gbrstaghound",
    "gbrdaimler",
    "gbrkangaroo",
    "gbrwasp",
  },
  
  gbrvehicleyard1 =
  {
    "gbrmatadorengvehicle",
    --"gbrpontoontruck",
    "gbrbedfordtruck",
    "gbrm5halftrack",
		"gbrstaghound",
    "gbrdaimler",
    "gbrkangaroo",
    "gbraecmkii",
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
    "gbrmatadorengvehicle",
    "gbrkangaroo",
    "gbraecmkii",
    "gbrcromwell",
    "gbrcromwellmkvi",
  },
  
  gbrtankyard1 =
  {
    "gbrmatadorengvehicle",
    "gbrkangaroo",
    "gbraecmkii",
    "gbrcromwell",
    "gbrcromwellmkvi",
    "gbrshermanfirefly",
  },
  
  gbrtankyard2 =
  {
    "gbrmatadorengvehicle",
    "gbrkangaroo",
    "gbraecmkii",
    "gbrcromwell",
    "gbrcromwellmkvi",
    "gbrchurchillmkvii",
  },


  gbrsupplydepot =
  {
    "gbrm5halftrack",
  },
  
  gbrradar = {
    "gbr_sortie_recon",
    "gbr_sortie_interceptor",
    "gbr_sortie_fighter_bomber",
    "gbr_sortie_attack",
		"gbr_sortie_glider_horsa",
  },
  
  gbrboatyard =
  {
    "rubberdingy",
    "pontoonraft",
    "gbrlca",
--    "gbrfairmiled",
  },
  gbrboatyardlarge =
  {
    "rubberdingy",
    "pontoonraft",
    "gbrlca",
  --  "gbrfairmiled",
    "gbrlct",
--    "gbrlcg",
  },

        --------------------
        -- soviet units   --
        --------------------


  ruscommander =
  {
--    "rusflag",
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
    --"pontoonraft",
  },
  
  ruscommissar1 =
  {
    "ruspshack",
    "rusbarracks",
    "rusgunyard",
    "apminesign",
    "atminesign",
    "tankobstacle",
    "russtorage",
    --"sandbags",
    "ruspg117",
    --"pontoonraft",
  },
  ruspshack =
  {
    --"ruscommissar1",
    "rus_platoon_partisan",
  },


  rusbarracks =
  {
    "rus_sortie_recon",
    "rus_platoon_commissar",
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

  rusguardsbarracks =
  {
    "rus_sortie_recon",
    "rus_platoon_commissar",
    "rusengineer",
	"rus_platoon_guards",
    "rus_platoon_rifle",
    "rus_platoon_assault",
    "rus_platoon_mg",
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
--    "rusflag",
    --"rusresource",
    --"ruszis5",
    "apminesign",
    "atminesign",
    "tankobstacle",
    "russtorage",
    --"sandbags",
    "ruspg117",
    --"pontoonraft",
  },

  ruscommissar =
  {
--    "rusflag",
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
    --"pontoonraft",
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
    --"ruspontoontruck",
    "ruszis5",
    "rusba64",
    "rusm5halftrack",
    "rusgazaaa",
    "rust60",
    "russu76",
  },

  rusvehicleyard1 =
  {
    "rusk31",
    --"ruspontoontruck",
    "ruszis5",
    "rusba64",
    "rusm5halftrack",
    "rusgazaaa",
    "rust60",
    "russu76",
    "rust70",
  },

  rusgunyard =
  {
    "ruszis5",
    "ruszis2_truck",
    "ruszis3_truck",
    "rus61k_truck",
  },
  
  russpyard =
  {
    "rusk31",
    "ruszis5",
    "ruszis2_truck",
    "ruszis3_truck",
    "rusm30_truck",
    "rus61k_truck",
    "rusm30_truck",
    "russu76",
    "rusbm13n",
  },
  
  russpyard1 =
  {
    "rusk31",
    "ruszis5",
    "ruszis2_truck",
    "ruszis3_truck",
    "rusm30_truck",
    "rus61k_truck",
    "rusm30_truck",
    "russu85",
    "russu100",
  },

  rustankyard =
  {
    "rusk31",
    "rust70",
    "rust3476",
    "rusisu152",
  },
  
  rustankyard1 =
  {
    "rusk31",
    "rust70",
    "rust3476",
    "rusisu152",
    "rust3485",
  },
  
  rustankyard2 =
  {
    "rusk31",
    "rust70",
    "rust3476",
    "rusisu152",
    "rusis2",  
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
  
  rusradar = {
    "rus_sortie_recon",
    "rus_sortie_interceptor",
    "rus_sortie_fighter",
    "rus_sortie_attack",
  },
  
  rusboatyard =
  {
	"ruspg117",
	"pontoonraft",
    "rustender15t",
--    "ruslct",
--    "ruskomsmtb",
--    "rusbmo",
--    "rusbka-1125",
  },
  rusboatyardlarge =
  {
	"ruspg117",
	"pontoonraft",
    "rustender15t",
    "ruslct",
--    "ruskomsmtb",
--    "rusbmo",
--    "rusbka-1125",
--    "ruspsk",
--    "ruspr7",
  },
  
  ---GAME MASTER TOOLBOX
  gmtoolbox = 
  {
      "gerhqbunker",
	"gerstorage",
	"gerstoragebunker",
	"gersupplydepot",
      "gerbarracks",
	"gerbarracksbunker",
      "gergunyard",
      "gerspyard",
      "gerspyard1",
      "gervehicleyard",
      "gervehicleyard1",
      "gertankyard",
      "gertankyard1",
      "gertankyard1",
      "gerboatyard",
      "gerboatyardlarge",
      "gerradar",
        "ger_platoon_rifle",
        "ger_platoon_assault",
        "ger_platoon_mg",
        "ger_platoon_scout",
        "ger_platoon_at",
        "ger_platoon_sniper",
        "ger_platoon_mortar",
      "geropelblitz",
        "gersdkfz250",
        "gersdkfz251",
				"gersdkfz10",
        "germarder",
        "gerleig18",
        "gerpak40_truck",
        "gerlefh18_truck",
        "gernebelwerfer_truck",
	"gerflak38_truck",
        "gerpanzeriii",
        "gerpanzeriv",
        "gerstugiii",
        "gerjagdpanzeriv",
        "gerpanther",
        "gertiger",
        "gertigerii",
        "gersturmboot",
      "gerrboot",
      "gersboot",
      "germfp",
      "gerafp",
      "gervorpostenboot",
      "gersiebelfahre",
      "gerflottentorpboot",
      "gertype1934",
      "gerseehund",
      "gerfi156",
      "gerbf109",
      "gerfw190",
      "gerfw190g",
      "gerju87g",
      "gbrhq",
	"gbrstorage",
	"gbrsupplydepot",
      "gbrbarracks",
      "gbrgunyard",
      "gbrspyard",
      "gbrspyard1",
      "gbrvehicleyard",
      "gbrvehicleyard1",
      "gbrtankyard",
      "gbrtankyard1",
      "gbrtankyard1",
      "gbrboatyard",
      "gbrboatyardlarge",
      "gbrradar",
        "gbr_platoon_rifle",
        "gbr_platoon_assault",
        "gbr_platoon_mg",
        "gbr_platoon_scout",
        "gbr_platoon_at",
        "gbr_platoon_sniper",
        "gbr_platoon_mortar",
      "gbr_platoon_commando",
      "gbrbedfordtruck",
        "gbrdaimler",
        "gbrm5halftrack",
				"gbrstaghound",
        "gbrkangaroo",
        "gbr17pdr_truck",
        "gbr25pdr_truck",
	"gbrbofors_truck",
        "gbraecmkii",
        "gbrcromwell",
        "gbrshermanfirefly",
        "gbrcromwellmkvi",
        "gbrm10achilles",
        "gbrchurchillmkvii",
        "gbrsexton",
      "gbrfairmiled",
      "gbrlca",
      "gbrlct",
      "gbrflower",
      "gbrhuntii",
      "gbroclass",
      "gbrmonitor",
      "gbrauster",
      "gbrspitfiremkxiv",
      "gbrspitfiremkix",
      "gbrtyphoon",
      "ruscommander",
	"russtorage",
	"russupplydepot",
      "rusbarracks",
      "rusgunyard",
      "russpyard",
      "russpyard1",
      "rusvehicleyard",
      "rusvehicleyard1",
      "rustankyard",
      "rustankyard1",
      "rustankyard1",
      "rusboatyard",
      "rusboatyardlarge",
      "rusradar",
        "rus_platoon_rifle",
        "rus_platoon_assault",
        "rus_platoon_mg",
        "rus_platoon_scout",
        "rus_platoon_atlight",
      "rus_platoon_atheavy",
        "rus_platoon_sniper",
        "rus_platoon_mortar",
      "rus_platoon_partisan",
      "ruszis5",
      "rusba64",
        "rust60",
        "rusm5halftrack",
				"rusgazaaa",
        "russu76",
        "ruszis3_truck",
        "ruszis2_truck",
        "rusm30_truck",
	"rus61k_truck",
      "rusbm13n",
      "russu85",
      "russu100",
        "rust70",
        "rust3476",
        "rusisu152",
        "rust3485",
        "rusis2",
        "ruslighttender",
      "rustender15t",
      "rusbka-1125",
      "rusbmo",
      "ruskomsmtb",
      "ruslct",
      "ruspsk",
      "rusmonitor",
      "ruspr7",
      "rustypem",
      "ruspo2",
      "rusyak3",
      "rusla5fn",
      "rusil2",
      "ushq",
	"usstorage",
	"ussupplydepot",
      "usbarracks",
      "usgunyard",
      "usspyard",
      "usvehicleyard",
      "usvehicleyard1",
      "ustankyard",
      "ustankyard1",
      "ustankyard1",
      "usboatyard",
      "usboatyardlarge",
      "usradar",
        "us_platoon_rifle",
        "us_platoon_assault",
        "us_platoon_mg",
        "us_platoon_scout",
        "us_platoon_at",
        "us_platoon_sniper",
      "us_platoon_flame",
        "us_platoon_mortar",
      "usgmctruck",
        "usm8greyhound",
        "usm3halftrack",
				"usm16mgmc",
        "usm8scott",
        "usm8gun",
        "usm5gun_truck",
        "usm2gun_truck",
	"usm1bofors_truck",
      "usm7priest",
        "usm5stuart",
        "usm4a4sherman",
        "usm10wolverine",
        "usm4a376sherman",
        "usm4a3105sherman",
        "usm4jumbo",
      "usl4",
      "usp51dmustang",
      "usp47thunderbolt",
      "usp51dmustangga",
      "uspt103-bofors",
      "uslcvp",
      "uslvta4",
      "uslct",
      "uslcsl",
      "usbuckley",
      "ustacoma",
      "usfletcher",
        "rubberdingy",
      "pontoonraft",
      "tankobstacle",
      "atminesign",
      "apminesign",
  }
}
if (modOptions) then
  --[[if (modOptions.simple_tanks) then
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
    buildoptions.gertankyard1 = gertankyard1]]
	if (modOptions.navies) then
		local tmpNavies = tonumber(modOptions.navies)
		if tmpNavies > 0 then
			-- at least transports are available
			-- enable pontoon trucks
			table.insert(buildoptions.usvehicleyard, 2, "uspontoontruck")
			table.insert(buildoptions.usvehicleyard1, 2, "uspontoontruck")
			table.insert(buildoptions.gbrvehicleyard, 2, "gbrpontoontruck")
			table.insert(buildoptions.gbrvehicleyard1, 2, "gbrpontoontruck")
			table.insert(buildoptions.gervehicleyard, 2, "gerpontoontruck")
			table.insert(buildoptions.gervehicleyard1, 2, "gerpontoontruck")
			table.insert(buildoptions.rusvehicleyard, 2, "ruspontoontruck")
			table.insert(buildoptions.rusvehicleyard1, 2, "ruspontoontruck")
			-- transports are in list by default
		end
		if tmpNavies > 1 then
			-- add Light ships
			table.insert(buildoptions.rusboatyard, "ruskomsmtb")
			table.insert(buildoptions.rusboatyard, "rusbmo")
			table.insert(buildoptions.rusboatyard, "rusbka-1125")
			table.insert(buildoptions.rusboatyardlarge, "ruskomsmtb")
			table.insert(buildoptions.rusboatyardlarge, "rusbmo")
			table.insert(buildoptions.rusboatyardlarge, "rusbka-1125")

			table.insert(buildoptions.gerboatyard, "gerrboot")
			table.insert(buildoptions.gerboatyard, "gersboot")
			table.insert(buildoptions.gerboatyardlarge, "gerrboot")
			table.insert(buildoptions.gerboatyardlarge, "gersboot")

			table.insert(buildoptions.gbrboatyard, "gbrfairmiled")
			table.insert(buildoptions.gbrboatyardlarge, "gbrfairmiled")

			table.insert(buildoptions.usboatyard, "uspt103-bofors")
			table.insert(buildoptions.usboatyardlarge, "uspt103-bofors")
		end
		if tmpNavies > 2 then
			-- add Coastal Bombardment ships
			table.insert(buildoptions.rusboatyardlarge, "rusmonitor")

			table.insert(buildoptions.gerboatyardlarge, "gerafp")

			table.insert(buildoptions.gbrboatyardlarge, "gbrlcg")

			table.insert(buildoptions.usboatyardlarge, "uslcsl")
		end
	end
--[[
	if modOptions.navies == "1" then
		table.insert(buildoptions.usvehicleyard, 2, "uspontoontruck")
		table.insert(buildoptions.usvehicleyard1, 2, "uspontoontruck")
		table.insert(buildoptions.gbrvehicleyard, 2, "gbrpontoontruck")
		table.insert(buildoptions.gbrvehicleyard1, 2, "gbrpontoontruck")
		table.insert(buildoptions.gervehicleyard, 2, "gerpontoontruck")
		table.insert(buildoptions.gervehicleyard1, 2, "gerpontoontruck")
		table.insert(buildoptions.rusvehicleyard, 2, "ruspontoontruck")
		table.insert(buildoptions.rusvehicleyard1, 2, "ruspontoontruck")
	else
		-- make sure THERE IS A WAY TO GET VEHS ACROSS WATER damnit!
		table.insert(buildoptions.ushqengineer, "pontoonraft")
		table.insert(buildoptions.usengineer, "pontoonraft")
		table.insert(buildoptions.gerhqengineer, "pontoonraft")
		table.insert(buildoptions.gerengineer, "pontoonraft")
		table.insert(buildoptions.gbrhqengineer, "pontoonraft")
		table.insert(buildoptions.gbrengineer, "pontoonraft")
		table.insert(buildoptions.ruscommander, "pontoonraft")
		table.insert(buildoptions.ruscommissar1, "pontoonraft")
		table.insert(buildoptions.ruscommissar, "pontoonraft")
		table.insert(buildoptions.rusengineer, "pontoonraft")

	end
]]--
end

return buildoptions
