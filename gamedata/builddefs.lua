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
--    "usflag",
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
--    "usflag",
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
    "uspontoontruck",
    "usgmctruck",
    "usm3halftrack",
    "usdukw",
    "usm8greyhound",
    "usm8scott",
  },
  
  usvehicleyard1 =
  {
    "usgmcengvehicle",
    "uspontoontruck",
    "usgmctruck",
    "usm3halftrack",
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
  usboatyard =
  {
    "rubberdingy",
    "pontoonraft",
    "usdukw",
    "uslcvp",
    "uspt103-bofors",
  },
  usboatyardlarge =
  {
    "rubberdingy",
    "pontoonraft",
    "usdukw",
    "uslcvp",
    "uspt103-bofors",
    "uslct",
    "uslcsl",
  },

        --------------------
        -- german units   --
        --------------------

  gerhqbunker =
  {
    "gerhqengineer",
    --"gerairengineer",
    "ger_platoon_hq",
    --"ger_platoon_hq_rifle",
    --"ger_platoon_hq_assault",
  },

  gerhqengineer =
  {
    "gerbarracks",
--    "gerflag",
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
--    "gerflag",
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
    "gerpontoontruck",
    "geropelblitz",
    "gersdkfz250",
    "gersdkfz251",
    --"gersdkfz10",
    "germarder",
  },
  
  gervehicleyard1 =
  {
    "gersdkfz9",
    "gerpontoontruck",
    "geropelblitz",
    "gersdkfz250",
    "gersdkfz251",
    --"gersdkfz10",
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
    "tankobstacle",
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
  
  gerboatyard =
  {
    "gersturmboot",
    "gerschsturmboot",
    "pontoonraft",
    "gerrboot",
    "gersboot",
  },
  gerboatyardlarge =
  {
    "gersturmboot",
    "pontoonraft",
    "gerrboot",
    "gersboot",
    "germfp",
    "gerafp",
  },

        ----------------------
        ----/british units----
        ----------------------

  gbrhq =
  {
    "gbrhqengineer",
    --"usairengineer",
    "gbr_platoon_hq",
    --"gbr_platoon_hq_rifle",
    --"gbr_platoon_hq_assault",
  },

  gbrhqengineer =
  {
    "gbrbarracks",
--    "gbrflag",
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
    "pontoonraft",

  },

  gbrvehicleyard =
  {
    "gbrmatadorengvehicle",
    "gbrpontoontruck",
    "gbrbedfordtruck",
    "gbrm5halftrack",
    "gbrdaimler",
    "gbrkangaroo",
    "gbrwasp",
  },
  
  gbrvehicleyard1 =
  {
    "gbrmatadorengvehicle",
    "gbrpontoontruck",
    "gbrbedfordtruck",
    "gbrm5halftrack",
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

  gbrairfield =
  {
    "gbrauster",
    "gbrspitfiremkxiv",
    "gbrtyphoon",
    "gbrspitfiremkix",
  },
  
  gbrboatyard =
  {
    "rubberdingy",
    "pontoonraft",
    "gbrlca",
    "gbrfairmiled",
  },
  gbrboatyardlarge =
  {
    "rubberdingy",
    "pontoonraft",
    "gbrlca",
    "gbrfairmiled",
    "gbrlct",
    "gbrlcg",
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
--    "rusflag",
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
    "ruspontoontruck",
    "ruszis5",
    "rusba64",
    "rusm5halftrack",
    --"rusgazaaa",
    "rust60",
    "russu76",
  },

  rusvehicleyard1 =
  {
    "rusk31",
    "ruspontoontruck",
    "ruszis5",
    "rusba64",
    "rusm5halftrack",
    --"rusgazaaa",
    "rust60",
    "russu76",
    "rust70",
  },

  rusgunyard =
  {
    "rusk31",
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
  rusboatyard =
  {
    "ruspg117",
    "pontoonraft",
    "rustender15t",
    "rusbka-1125",
    "rusbmo",
    "ruskomsmtb",
  },
  rusboatyardlarge =
  {
    "ruspg117",
    "pontoonraft",
    "rustender15t",
    "rusbka-1125",
    "rusbmo",
    "ruskomsmtb",
    "ruslct",
    "rusmonitor",
  },
  
  ---GAME MASTER TOOLBOX
  gmtoolbox = 
  {
      "gerhqbunker",
      "gerbarracks",
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
        "germarder",
        "gerleig18",
        "gerpak40_truck",
        "gerlefh18_truck",
        "gernebelwerfer_truck",
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
        "gbrkangaroo",
        "gbr17pdr_truck",
        "gbr25pdr_truck",
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
        "russu76",
        "ruszis3_truck",
        "ruszis2_truck",
        "rusm30_truck",
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
        "usm8scott",
        "usm8gun_bax",
        "usm5gun_truck",
        "usm2gun_truck",
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
