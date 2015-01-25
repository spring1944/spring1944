-- Aircraft - Aircraft Anti-Tank Cannon

-- Implementations

-- Bordkanone BK 37 (GER)
local BK37mmAP = AirATGun:New{
  areaOfEffect       = 12,
  --burst              = 1,
  --burstrate          = 0.375,
  name               = [[BK-37 37mm Semi-Automatic Cannon]],
  range              = 950,
  reloadtime         = 0.4,
  soundStart         = [[US_37mm]],
  weaponVelocity     = 1768,
  customparams = {
    --constant penetration since aircraft engagement range can't be realistically controlled
    armor_penetration_1000m = 60,
    armor_penetration_100m = 60,
  },
  damage = {
    default            = 825,
  },
}

-- Ho-401 57mm HEAT (JPN)
local Ho40157mm = AirATGun:New{
  areaOfEffect       = 12,
  name               = [[Ho-401 57 mm HEAT]],
  range              = 760,
  reloadTime         = 0.95,
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 918,
  customparams = {
    armor_penetration  = 55,
    damagetype         = [[shapedcharge]],
  },
  damage = {
    default            = 1341,
	cegflare           = "MEDIUM_MUZZLEFLASH",
  },
}

-- Return only the full weapons
return lowerkeys({
  BK37mmAP = BK37mmAP,
  Ho40157mm = Ho40157mm,
})
