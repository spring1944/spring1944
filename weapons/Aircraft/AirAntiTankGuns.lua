-- Aircraft - Aircraft Anti-Tank Cannon

-- Implementations

-- Bordkanone BK 37 (GER)
local BK37mmAP = AirATGun:New{
  --burst              = 1,
  --burstrate          = 0.375,
  name               = [[BK-37 37mm Semi-Automatic Cannon]],
  range              = 950,
  reloadtime         = 1,
  soundStart         = [[US_37mm]],
  weaponVelocity     = 1768,
  customparams = {
    armor_penetration = 60,
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
-- 57mm bofors (SWE)
local bofors57mmAP = BK37mmAP:New{
  name               = [[57mm Bofors Cannon]],
  reloadtime         = 1.2,
  range              = 1150,
  soundStart         = [[PVKAN_M_43]],
  damage = {
    default            = 1425,
	cegflare           = "MEDIUM_MUZZLEFLASH",
  },
}

-- Return only the full weapons
return lowerkeys({
  BK37mmAP = BK37mmAP,
  bofors57mmAP = bofors57mmAP,
  Ho40157mm = Ho40157mm,
})
