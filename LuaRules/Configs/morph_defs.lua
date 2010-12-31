--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local devolution = (-1 > 0)


local morphDefs = {
  -- Upgrade Defs
 	rusvehicleyard = {
		{
			into = 'rusvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	
	usvehicleyard = {
		{
			into = 'usvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	
	gervehicleyard = {
		{
			into = 'gervehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	
	gbrvehicleyard = {
		{
			into = 'gbrvehicleyard1',
			metal = 2000,
			energy = 0,
			time = 65,
			name = '  Light  \n  Armor  ',
			text = 'Makes Light Armor available in this yard',
			facing = true,
		},
	},
	
	rusgunyard = {
		{
			into = 'russpyard',
			metal = 3500,
			energy = 0,
			time = 100,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'russpyard1',
			metal = 5700,
			energy = 0,
			time = 165,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},
	
	usgunyard = {
		{
			into = 'usspyard',
			metal = 4500,
			energy = 0,
			time = 130,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
	},
	
	gergunyard = {
		{
			into = 'gerspyard',
			metal = 3000,
			energy = 0,
			time = 85,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'gerspyard1',
			metal = 5700,
			energy = 0,
			time = 165,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},	
	
	gbrgunyard = {
		{
			into = 'gbrspyard',
			metal = 3000,
			energy = 0,
			time = 85,
			name = '  Self  \n  Propelled  ',
			text = 'Makes Self-Propelled Artillery available in this yard',
			facing = true,
		},
		{
			into = 'gbrspyard1',
			metal = 5700,
			energy = 0,
			time = 165,
			name = '  Tank  \n  Destroyers  ',
			text = 'Makes Tank Destroyers available in this yard',
			facing = true,
		},
	},	
	
	rustankyard = {
		{
			into = 'rustankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
		{
			into = 'rustankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	
	ustankyard = {
		{
			into = 'ustankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
		{
			into = 'ustankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	
	gertankyard = {
		{
			into = 'gertankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},

		{
			into = 'gertankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	
	gbrtankyard = {
		{
			into = 'gbrtankyard1',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Advanced  \n  Mediums  ',
			text = 'Makes Advanced Medium Armor available in this yard',
			facing = true,
		},
	
		{
			into = 'gbrtankyard2',
			metal = 4500,
			energy = 0,
			time = 60,
			name = '  Heavy  \n  Armor  ',
			text = 'Makes Heavy Armor available in this yard',
			facing = true,
		},
	},
	
	gbrboatyard = {
		{
			into = 'gbrboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing \n Fire \n Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	
	gerboatyard = {
		{
			into = 'gerboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing \n Fire \n Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	
	rusboatyard = {
		{
			into = 'rusboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing \n Fire \n Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	
	usboatyard = {
		{
			into = 'usboatyardlarge',
			metal = 6000,
			energy = 0,
			time = 80,
			name = '  Landing \n Fire \n Support  ',
			text = 'Makes Landing Fire Support Craft available in this yard',
			facing = true,
		},
	},
	
	
  -- Machineguns
  
    gbrlz =
  {
    into = 'gbr_platoon_commando_lz',
    tech = 0,
    time = 12,
    metal = 1200,
    energy = 0,
  },
  
  gbrvickers =
  {
    into = 'gbrvickers_sandbag',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gbrvickers_sandbag =
  {
    into = 'gbrvickers',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  germg42 =
  {
    into = 'germg42_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },

  germg42_sandbag =
  {
    into = 'germg42',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
  
  rusmaxim =
  {
    into = 'rusmaxim_sandbag',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  rusmaxim_sandbag =
  {
    into = 'rusmaxim',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  usgimg =
  {
    into = 'usgimg_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },
  

  usgimg_sandbag =
  {
    into = 'usgimg',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },

  us101stmg =
  {
    into = 'us101stmg_sandbag',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
    us101stmg_sandbag =
  {
    into = 'us101stmg',
    tech = 0,
    time = 12,
    metal = 0,
    energy = 0,
  },
  
  -- Towed Guns
  
  gbr17pdr_truck = 
  {
    into = 'gbr17pdr_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },

  gbr17pdr_stationary = 
  {
    into = 'gbr17pdr_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  gbr25pdr_truck = 
  {
    into = 'gbr25pdr_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },

  gbr25pdr_stationary = 
  {
    into = 'gbr25pdr_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  gbrbofors_truck =
  {
    into = 'gbrbofors_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  gbrbofors_stationary =
  {
    into = 'gbrbofors_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  gerflak38_truck =
  {
    into = 'gerflak38_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  gerflak38_stationary =
  {
    into = 'gerflak38_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  gerpak40_truck = 
  {
    into = 'gerpak40_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gerpak40_stationary = 
  {
    into = 'gerpak40_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  gerlefh18_truck = 
  {
    into = 'gerlefh18_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gerlefh18_stationary = 
  {
    into = 'gerlefh18_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	gernebelwerfer_truck = 
  {
    into = 'gernebelwerfer_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gernebelwerfer_stationary = 
  {
    into = 'gernebelwerfer_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
	
  rus61k_truck = 
  {
    into = 'rus61k_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  rus61k_stationary = 
  {
    into = 'rus61k_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  ruszis2_truck = 
  {
    into = 'ruszis2_stationary',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  ruszis2_stationary = 
  {
    into = 'ruszis2_truck',
    tech = 0,
    time = 5,
    metal = 0,
    energy = 0,
  },
  
  ruszis3_truck = 
  {
    into = 'ruszis3_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  ruszis3_stationary = 
  {
    into = 'ruszis3_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  rusm30_truck = 
  {
    into = 'rusm30_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  rusm30_stationary = 
  {
    into = 'rusm30_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  usm5gun_truck = 
  {
    into = 'usm5gun_stationary',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  usm5gun_stationary = 
  {
    into = 'usm5gun_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  usm2gun_truck = 
  {
    into = 'usm2gun_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  usm2gun_stationary = 
  {
    into = 'usm2gun_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
 
     usm1bofors_truck = 
  {
    into = 'usm1bofors_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
    usm1bofors_stationary = 
  {
    into = 'usm1bofors_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
-- Halftracks / Resource Piles

--[[	gbrm5halftrack =
  {
    into = 'gbrresource',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
  },
	
	gbrresource =
  {
    into = 'gbrm5halftrack',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
	
   gersdkfz251 =
  {
    into = 'gerresource',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
  },
	
	gerresource =
  {
    into = 'gersdkfz251',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
	
    rusm5halftrack =
  {
    into = 'rusresource',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
  }, 
	
  rusresource =
  {
    into = 'rusm5halftrack',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
	
  usm3halftrack =
  {
    into = 'usresource',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
  },
	
  usresource =
  {
    into = 'usm3halftrack',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },]]--
  
  -- Trucks / Trucksupplies
  geropelblitz =
  {
    into = 'gertrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

  gertrucksupplies =
  {
    into = 'geropelblitz',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
  
  gbrbedfordtruck =
  {
    into = 'gbrtrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
	
  gbrtrucksupplies =
  {
    into = 'gbrbedfordtruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },    
  
   ruszis5 =
  {
    into = 'rustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	rustrucksupplies=
  {
    into = 'ruszis5',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  usgmctruck =
  {
    into = 'ustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	ustrucksupplies =
  {
    into = 'usgmctruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
    usdukw =
  {
    into = 'usdukwsupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  	usdukwsupplies =
  {
    into = 'usdukw',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	-- Pontoon trucks
	ruspontoontruck =
  {
    into = 'rusboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

    uspontoontruck =
  {
    into = 'usboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

    gerpontoontruck =
  {
    into = 'gerboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
    gbrpontoontruck =
  {
    into = 'gbrboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
  
  --the Soviet supply storage truck they get at spawn
     russupplytruck =
  {
    into = 'russtorage',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },
  
}
--
-- Here's an example of why active configuration
-- scripts are better then static TDF files...
--

--
-- devolution, babe  (useful for testing)
--
if (devolution) then
  local devoDefs = {}
  for src,data in pairs(morphDefs) do
    devoDefs[data.into] = { into = src, time = 10, metal = 1, energy = 1 }
  end
  for src,data in pairs(devoDefs) do
    morphDefs[src] = data
  end
end


return morphDefs

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
