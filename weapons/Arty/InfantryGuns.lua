-- Artillery - Infantry Guns

-- Implementations

-- LeIG 18 (GER)
local LeIG18HE = InfGun:New{
  areaOfEffect       = 88,
  name               = [[75mm LeIG 18 HE Shell]],
  soundStart         = [[GER_75mm]],
  damage = {
    default            = 1340,
  },
}

-- M8 Pack Howitzer (USA)
local M875mmHE = InfGun:New{
  areaOfEffect       = 94,
  name               = [[M8 75mm Pack Howitzer HE Shell]],
  soundStart         = [[short_75mm]],
  damage = {
    default            = 1620,
  },
}

-- Cannone da 65/17 (ITA)
local Cannone65L17HE = InfGun:New{
  areaOfEffect       = 68,
  name               = [[Cannone da 65/17 HE Shell]],
  range              = 1010,
  reloadtime         = 6.25,
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 420,
  damage = {
    default            = 900,
	cegflare           = "MEDIUMSMALL_MUZZLEFLASH", -- 65mm
  },
}

local Cannone65L17HEAT = InfGun:New{ -- TODO: make a HEAT base class and inherit from Cannone65
  areaOfEffect       = 8,
  accuracy           = 500,
  predictBoost	     = 0.2,
  explosionGenerator = [[custom:EP_medium]],
  name               = [[Cannone da 65/17 HEAT Shell]],
  reloadtime         = 6.25,
  soundHitDry        = [[GEN_Explo_2]],
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 400,
  customparams = {
    armor_penetration  = 85,
    damagetype         = [[shapedcharge]],
    fearaoe            = nil,
    fearid             = nil,
	cegflare           = "MEDIUMSMALL_MUZZLEFLASH",
  },
  damage = {
    default            = 2056,
  },
}

-- Return only the full weapons
return lowerkeys({
  LeIG18HE = LeIG18HE,
  M875mmHE = M875mmHE,
  Cannone65L17HE = Cannone65L17HE,
  Cannone65L17HEAT = Cannone65L17HEAT,
})
