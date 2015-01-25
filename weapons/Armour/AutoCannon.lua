-- Artillery - Auto Cannon (Light AA Guns)
-- Implementations

-- FlaK 38 20mm (GER)
local FlaK3820mm = AutoCannon:New{
  accuracy           = 255,
  burst              = 3,
  burstRate          = 0.16,
  name               = [[2cm FlaK 38]],
  range              = 730,
  reloadTime         = 3,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 1800,
  damage = {
    default            = 110,
  },
}

local FlaK3820mmAA = FlaK3820mm:New(AutoCannonAA, true):New{
  burst              = 5,
  burstRate          = 0.13,
  range              = 1910,
}
local FlaK3820mmHE = FlaK3820mm:New(AutoCannonHE, true)
local FlaK3820mmAP = FlaK3820mm:New(AutoCannonAP, true):New{
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 9,
    armor_penetration_100m  = 20,
  },
  damage = {
    default            = 385,
  },
}

-- Flakvierling
-- derives from the above, only with 1/4 the burstrate and 4x burst
local FlakVierling20mmAA = FlaK3820mmAA:New({
  burst              = 16,
  --burstrate          = 0.035, -- force to at least 1 frame
  --reloadTime         = 1.2,
  name               = [[(Quad)]],
}, true)
local FlakVierling20mmHE = FlaK3820mmHE:New({
  burst              = 16,
  --burstrate          = 0.033,
  --reloadTime         = 1.2,
  name               = [[(Quad)]],
}, true)

-- Oerlikon/Polsten 20mm (GBR)
local Oerlikon20mm = AutoCannon:New{
  accuracy           = 255,
  burst              = 3,
  burstRate          = 0.16,
  name               = [[20mm Oerlikon]],
  range              = 750,
  reloadTime         = 1.5,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 475,
  weaponVelocity     = 1640,
  damage = {
    default            = 110, -- copy from FlaK / TNSh
  },
}

local Oerlikon20mmAA = Oerlikon20mm:New(AutoCannonAA, true):New{
  burst              = 5,
  range              = 1950,
}
local Oerlikon20mmHE = Oerlikon20mm:New(AutoCannonHE, true)
local Twin_Oerlikon20mmAA = Oerlikon20mmAA:New({
  name               = [[(Twin)]],
  reloadTime         = 0.75,
}, true)

-- TNSh 20mm (RUS)
local TNSh20mm = AutoCannon:New{
  accuracy           = 300,
  burst              = 3,
  burstRate          = 0.1,
  name               = [[20mm TNSh]],
  range              = 675,
  reloadTime         = 4.5,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 444,
  weaponVelocity     = 1600,
  damage = {
    default            = 110,
  },
}

local TNSh20mmHE = TNSh20mm:New(AutoCannonHE, true)
local TNSh20mmAP = TNSh20mm:New(AutoCannonAP, true):New{
  weaponVelocity     = 1500,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m  = 35,
  },
  damage = {
    default            = 310,
  },
}

-- Breda M35 20mm (ITA)
local BredaM3520mm = AutoCannon:New{
  accuracy           = 100, --Why not 255 like the rest?
  burst              = 4,
  burstRate          = 0.261,
  name               = [[Breda Model 35]],
  range              = 730,
  reloadTime         = 1.6,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 300,
  weaponVelocity     = 2000,
  damage = {
    default            = 41,
  },
}

local BredaM3520mmAA = BredaM3520mm:New(AutoCannonAA, true):New{
  range              = 1950,
  sprayAngle         = 475,
  customparams = {
    fearaoe            = 400,
  },
}

local TwinBredaM3520mmAA = BredaM3520mmAA:New{
  burst              = 8,
  burstRate          = 0.13,
}

local BredaM3520mmHE = BredaM3520mm:New(AutoCannonHE, true):New{
  customparams = {
    fearaoe            = 30,
  },
}

local BredaM3520mmAP = BredaM3520mm:New(AutoCannonAP, true):New{
  sprayAngle         = 400,
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 6,
    armor_penetration_100m  = 29,
  },
  damage = {
    default            = 345,
  },
}

-- Type 98 20mm (JPN)
local Type9820mm = AutoCannon:New{
  accuracy           = 255,
  areaOfEffect       = 15,
  burst              = 4,
  burstRate          = 0.2,
  name               = [[Type 98 20mm]],
  range              = 730,
  reloadTime         = 2,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 52,
  },
}

local Type9820mmAA = Type9820mm:New(AutoCannonAA, true):New{
  range              = 1950,
}

local Type9820mmHE = Type9820mm:New(AutoCannonHE, true)

-- Type 96 25mm (JPN)
local Type9625mm = AutoCannon:New{
  accuracy           = 255,
  areaOfEffect       = 15, --if this is changed, change AA and HE aoe and fearaoe accordingly
  burst              = 5,
  burstRate          = 0.231,
  name               = [[Type 98 20mm]],
  range              = 780,
  reloadTime         = 2.7,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 45,
  },
}

local Type9625mmAA = Type9625mm:New(AutoCannonAA, true):New{
  range              = 1950,
  damage = {
    default            = 55,
  },
}

local TwinType9625mmAA = Type9625mmAA:New{
	burst            = 36,
	burstrate        = 0.12,
    reloadtime       = 6.5,
}

local Type9625mmHE = Type9625mm:New(AutoCannonHE, true)

local TwinType9625mmHE = Type9625mmHE:New{
	burst            = 36,
	burstrate        = 0.12,
    reloadtime       = 6.5,
}


-- Return only the full weapons
return lowerkeys({
  -- FlaK 38
  FlaK3820mmAA = FlaK3820mmAA,
  FlaK3820mmHE = FlaK3820mmHE,
  FlaK3820mmAP = FlaK3820mmAP,
  FlakVierling20mmAA = FlakVierling20mmAA,
  FlakVierling20mmHE = FlakVierling20mmHE,
  -- Oerlikon
  Oerlikon20mmAA = Oerlikon20mmAA,
  Oerlikon20mmHE = Oerlikon20mmHE,
  Twin_Oerlikon20mmAA = Twin_Oerlikon20mmAA,
  -- TNSh
  TNSh20mmHE = TNSh20mmHE,
  TNSh20mmAP = TNSh20mmAP,
  -- Breda M30
  BredaM3520mmAA = BredaM3520mmAA,
  TwinBredaM3520mmAA = TwinBredaM3520mmAA,
  BredaM3520mmHE = BredaM3520mmHE,
  BredaM3520mmAP = BredaM3520mmAP,
  -- Type 98
  Type9820mmAA = Type9820mmAA,
  Type9820mmHE = Type9820mmHE,
  -- Type 96
  Type9625mmAA = Type9625mmAA,
  TwinType9625mmAA = TwinType9625mmAA,
  Type9625mmHE = Type9625mmHE,
  TwinType9625mmHE = TwinType9625mmHE,
})
