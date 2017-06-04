-- Aircraft - Aircraft Automatic Cannons

-- Implementations

-- Hispano HS.404 20mm (GBR)
local HS40420mm = AutoCannonHE:New(AirAutoCannon, true):New{
  areaOfEffect       = 10,
  burst              = 3,
  burstrate          = 0.1,
  name               = [[Hispano HS.404 20mm Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1.1,
  soundStart         = [[GBR_20mmAir]],
  weaponVelocity     = 2700,
  damage = {
    default            = 88,
  },
}

-- Mk. 108 30mm (GER)
local Mk10830mm = AutoCannonHE:New(AirAutoCannon, true):New{
  areaOfEffect       = 25,
  burst              = 3,
  burstRate          = 0.25,
  name               = [[30mm Mk 108 Aircraft Cannon]],
  range              = 700,
  reloadtime         = 3,
  soundStart         = [[GER_30mmAir]],
  sprayAngle         = 1400, -- overrides deafult
  weaponVelocity     = 1750,
  damage = {
    default            = 182,
  },
}

-- MG151/20 20mm (GER)
local MG15120mm = AutoCannonHE:New(AirAutoCannon, true):New{
  areaOfEffect       = 15,
  burst              = 6,
  burstRate          = 0.095,
  name               = [[20mm MG 151/20 Aircraft Cannon]],
  range              = 850,
  reloadtime         = 1.75,
  soundStart         = [[GER_20mmAir]],
  damage = {
    default            = 52,
  },
}

-- MG151/15 15mm (GER)
local MG15115mm = AutoCannonHE:New(AirAutoCannon, true):New{
  burst              = 6,
  areaOfEffect       = 8,
  burstRate          = 0.08,
  range              = 900,
  weaponVelocity     = 2100,
  explosionGenerator = [[custom:Bullet]],
  name               = [[15mm MG 151/15 Aircraft Cannon]],  
  reloadTime         = 1.2, 
  soundStart         = [[GER_15mmAir]],
  damage = {
    default            = 40,
  },
} 

local MG13113mm = AutoCannonHE:New(AirAutoCannon, true):New{
  burst              = 7,
  areaOfEffect       = 8,
  burstRate          = 0.08,
  explosionGenerator = [[custom:Bullet]],
  name               = [[13mm MG 131/13 Aircraft Cannon]],  
  reloadTime         = 1.3, 
  soundStart         = [[GER_15mmAir]],
  damage = {
    default            = 30,
  },
} 

-- ShVAK 20mm (RUS)
local ShVAK20mm = AutoCannonHE:New(AirAutoCannon, true):New{
  areaOfEffect       = 10,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[20mm ShVAK Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 67,
  },
}

-- VYa 23mm (RUS)
local VYa23mm = AutoCannonHE:New(AirAutoCannon, true):New{
  areaOfEffect       = 14,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[23mm VYa Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 110,
  },
}

-- Ho-5 20mm AP (JPN)
local Ho520mmAP = AutoCannonAP:New(AirAutoCannon, true):New{
  burst              = 5,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon AP]],
  range              = 830,
  reloadTime         = 1.2,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  customparams = {
    armor_penetration_1000m  = 6,
    armor_penetration_100m   = 28,
		badtargetcategory  = "INFANTRY SOFTVEH OPENVEH SHIP LARGESHIP DEPLOYED TURRETS",
		onlytargetcategory = "INFANTRY SOFTVEH AIR OPENVEH SHIP HARDVEH LARGESHIP DEPLOYED TURRETS",
  },
  damage = {
    default            = 305,
  },
}

-- Ho-5 20mm HE (JPN) 
local Ho520mmHE = AutoCannonHE:New(AirAutoCannon, true):New{
  burst              = 5,
  areaOfEffect       = 6,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon HE]],
  range              = 830,
  reloadTime         = 1.2,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  damage = {
    default            = 54,
  },
}

-- Return only the full weapons
return lowerkeys({
  HS40420mm = HS40420mm,
  Mk10830mm = Mk10830mm,
  MG15120mm = MG15120mm,
  MG15115mm = MG15115mm,
  MG13113mm = MG13113mm,
  ShVAK20mm = ShVAK20mm,
  VYa23mm = VYa23mm,
  Ho520mmAP = Ho520mmAP,
  Ho520mmHE = Ho520mmHE,
})
