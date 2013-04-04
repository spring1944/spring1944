local function TableConcat(t1,t2)
	--[[
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
	]]--
	local tmpCount = 0
	for tmpName, tmpValue in pairs(t2) do
		t1[tmpName] = tmpValue
		tmpCount = tmpCount + 1
	end
    return t1, tmpCount
end

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

buildoptions = 
{
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
      "ruspr161",
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
  },
}

-- let's append all the side's units to the list
-- first find all the subtables
Spring.Echo("Loading side build tables...")
local SideFiles = VFS.DirList("gamedata/side_units", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		buildoptions, tmpCount = TableConcat(buildoptions, tmpTable)
		Spring.Echo(" -- Added "..tmpCount.." entries")
		tmpTable = nil
	end
end

if (modOptions) then
	if (modOptions.navies) then
		local tmpNavies = tonumber(modOptions.navies)
		if tmpNavies > 0 then
			-- add Light ships
			table.insert(buildoptions.rusboatyardlarge, "ruspr161")
			table.insert(buildoptions.rusboatyardlarge, "ruspr7")
			
			table.insert(buildoptions.gerboatyardlarge, "gerflottentorpboot")
			table.insert(buildoptions.gerboatyardlarge, "gertype1934")	
			
			table.insert(buildoptions.gbrboatyardlarge, "gbrhuntii")
			table.insert(buildoptions.gbrboatyardlarge, "gbroclass")

			table.insert(buildoptions.usboatyardlarge, "ustacoma")
			table.insert(buildoptions.usboatyardlarge, "usfletcher")
		end
	end
end

return buildoptions
