local japDefs = {
  -- japan
  jappontoontruck =
  {
    into = 'japboatyard',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
	facing = true,
  },

  japisuzutx40 =
  {
    into = 'japtrucksupplies',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  
  japtrucksupplies=
  {
    into = 'japisuzutx40',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  japtype98_20mm_truck =
  {
    into = 'japtype98_20mm_stationary',
    tech = 0,
    time = 35,
    metal = 0,
    energy = 0,
  },
  
  japtype98_20mm_stationary =
  {
    into = 'japtype98_20mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  japtype1_47mm_truck =
  {
    into = 'japtype1_47mm_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  japtype1_47mm_stationary =
  {
    into = 'japtype1_47mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  japtype90_75mm_truck =
  {
    into = 'japtype90_75mm_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  japtype90_75mm_stationary =
  {
    into = 'japtype90_75mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
  japtype91_105mm_truck =
  {
    into = 'japtype91_105mm_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },
  
  japtype91_105mm_stationary =
  {
    into = 'japtype91_105mm_truck',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
    japtype92hmg =
  {
    into = 'japtype92hmg_dugin',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  japtype92hmg_dugin =
  {
    into = 'japtype92hmg',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },
    japtype4mortar_mobile =
  {
    into = 'japtype4mortar_stationary',
    tech = 0,
    time = 25,
    metal = 0,
    energy = 0,
    directional = true,
  },

  japtype4mortar_stationary =
  {
    into = 'japtype4mortar_mobile',
    tech = 0,
    time = 20,
    metal = 0,
    energy = 0,
  },

}

return japDefs
