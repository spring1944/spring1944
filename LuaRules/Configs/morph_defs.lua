--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local devolution = (-1 > 0)


local morphDefs = {

  --[[armdecom = {
    into = 'acom',
    time   = 200,    -- game seconds
    metal  = 10000, -- metal cost
    energy = 60000, -- energy cost
      tech = 2,            -- tech level
      xp = 0.5,            -- required unit XP
  },

  cordecom = {
    into = 'ccom',
    time   = 200,    -- game seconds
    metal  = 10000, -- metal cost
    energy = 60000, -- energy cost
      tech = 2,            -- tech level
  },]]--

  -- Machineguns
  
  gbrvickers =
  {
    into = 'gbrvickers_sandbag',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  gbrvickers_sandbag =
  {
    into = 'gbrvickers',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  germg42 =
  {
    into = 'germg42_sandbag',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
    directional = true,
  },

  germg42_sandbag =
  {
    into = 'germg42',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  rusmaxim =
  {
    into = 'rusmaxim_sandbag',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
    directional = true,
  },

  rusmaxim_sandbag =
  {
    into = 'rusmaxim',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  usgimg =
  {
    into = 'usgimg_sandbag',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
    directional = true,
  },

  usgimg_sandbag =
  {
    into = 'usgimg',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  -- Towed Guns
  
  gbr17pdr_truck = 
  {
    into = 'gbr17pdr_stationary',
    tech = 0,
    time = 15,
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
    time = 10,
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
    time = 10,
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
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  gerpak40_truck = 
  {
    into = 'gerpak40_stationary',
    tech = 0,
    time = 15,
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
    time = 10,
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
    time = 10,
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
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  ruszis2_truck = 
  {
    into = 'ruszis2_stationary',
    tech = 0,
    time = 15,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  ruszis2_stationary = 
  {
    into = 'ruszis2_truck',
    tech = 0,
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  ruszis3_truck = 
  {
    into = 'ruszis3_stationary',
    tech = 0,
    time = 15,
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
    time = 10,
    metal = 0,
    energy = 0,
  },
  
  usm5gun_truck = 
  {
    into = 'usm5gun_stationary',
    tech = 0,
    time = 15,
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
    time = 10,
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
    time = 10,
    metal = 0,
    energy = 0,
  },
  
-- Resource Trucks

	gbrm5halftrack =
  {
    into = 'gbrtrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
    gbrtrucksupplies =
  {
    into = 'gbrm5halftrack',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
    gersdkfz251 =
  {
    into = 'gertrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
    gertrucksupplies =
  {
    into = 'gersdkfz251',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
    rusm5halftrack =
  {
    into = 'rustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  }, 
    rustrucksupplies =
  {
    into = 'rusm5halftrack',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },  
    usm3halftrack =
  {
    into = 'ustrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
    ustrucksupplies =
  {
    into = 'usm3halftrack',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  --regular trucks and tiny supplies
    geropelblitz =
  {
    into = 'gerresource',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	gerresource =
  {
    into = 'geropelblitz',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
      gbrbedfordtruck =
  {
    into = 'gbrresource',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	gbrresource =
  {
    into = 'gbrbedfordtruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
    ruszis5 =
  {
    into = 'rusresource',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	rusresource =
  {
    into = 'ruszis5',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
    usgmctruck =
  {
    into = 'usresource',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
	usresource =
  {
    into = 'usgmctruck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
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
