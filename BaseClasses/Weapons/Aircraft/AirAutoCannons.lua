-- Aircraft - Aircraft Automatic Cannons

-- AirAutoCannon Base Class
local AirACClass = Weapon:New{
  burnblow           = true,
  collisionSize      = 2,
  collisionvolumetest = 1,
  fireStarter        = 10,
  impactonly         = 1,
  interceptedByShieldType = 8,
  predictBoost       = 0.5,
  size               = 1e-13, -- visuals done with tracers
  sprayAngle         = 250,
  soundHitDry        = [[GEN_Explo_1]],
  soundTrigger       = true,
  tolerance          = 600,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    armor_hit_side     = [[top]],
    no_range_adjust    = true,
  },
}

local AirACHEClass = Weapon:New{
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  areaOfEffect       = 4,
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 45,
    fearid             = 301,
  },
}

local AirACAPClass = Weapon:New{
  areaOfEffect       = 2,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  explosionGenerator = [[custom:AP_XSmall]],
  intensity          = 0.1,
  name               = [[AP Shell]],
  separation         = 2,
  size               = 1,  
  stages             = 50,
  customparams = {
    damagetype         = [[kinetic]],
  },  
  
}

-- Return only the full weapons
return lowerkeys({
  AirACClass = AirACClass,
  AirACHEClass = AirACHEClass,
  AirACAPClass = AirACAPClass,
})
