-- Aircraft - Aircraft Anti-Tank Cannon

-- AirAntiTankGun Base Class
-- Currently assumes that we would not want to give such weapons HE
local AirATGunClass = Weapon:New{
  accuracy           = 100,
  canattackground    = false,
  collisionSize      = 4,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Small]],
  explosionSpeed     = 100,
  gravityaffected    = true,
  impactonly         = 1,
  impulseFactor      = 0,
  intensity          = 0.25, -- probably not used with a colormap
  noSelfDamage       = true,
  rgbColor           = [[1.0 0.0 0.0]],
  separation         = 2,
  size               = 1,
  soundHitDry        = [[GEN_Explo_1]],
  stages             = 50,
  targetMoveError    = 0.1,
  tolerance          = 600,
  turret             = true,
  dynDamageInverted  = true,
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
    armor_hit_side     = [[top]],
    damagetype         = [[kinetic]],
    cegflare           = "SMALL_MUZZLEFLASH",
  },
}


return {
  AirATGunClass = AirATGunClass,
}
