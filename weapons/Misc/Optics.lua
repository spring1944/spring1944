-- Misc - Optics

-- Optics Base Class
local OpticClass = Weapon:New{
  areaOfEffect       = 0,
  avoidFeature       = false,
  avoidFriendly      = false,
  burnblow           = true,
  collideFeature     = false,
  collideFriendly    = false,
  collisionSize      = 0.000001,
  edgeEffectiveness  = 0,
  explosionGenerator = [[custom:nothing]],
  id                 = 999, -- not sure this is used anywhere?
  noSelfDamage       = true,
  reloadtime         = 2,
  size               = 1e-10,
  tolerance          = 600,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 1500,
  customparams = {
    binocs             = 1,
    damagetype         = [[none]],
  },
  damage = {
    default            = 0,
  },
}

-- Implementations

-- Binoculars
local Binocs = OpticClass:New{
  name               = [[Binoculars]],
  range              = 2000,
}


-- Return only the full weapons
return lowerkeys({
  Binocs = Binocs,
})
