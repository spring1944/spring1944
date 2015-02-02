-- Misc 'Gameplay' related weapons

local BulletProofClass = Weapon:New{
  exteriorShield     = true,
  shieldEnergyUse    = 0,
  shieldForce        = 500,
  shieldMaxSpeed     = 900,
  shieldRepulser     = true,
  smartShield        = true,
  weaponType         = [[Shield]],
  
  --visibleShield = true,
  --VisibleShieldHitFrames = 10,
}

local DeathClass = Weapon:New{
  craterMult         = 0,
  explosionSpeed     = 30,
  customparams = {
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 33,
  },
}

local MineClass = Weapon:New{
  explosionGenerator = [[custom:HE_Large]],
  explosionSpeed     = 30,
  fireSubmersed      = true,
  soundHitDry        = [[GEN_Explo_4]],
  turret             = true,
  weaponVelocity     = 90,
  customparams = {
    no_range_adjust    = true,
    damagetype         = [[explosive]], 
  },
  damage = {
    mines              = 0,
  },
}

local OpticClass = Weapon:New{
  areaOfEffect       = 0,
  avoidFeature       = false,
  avoidFriendly      = false,
  avoidGround        = false,
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
    damagetype         = "none",
    onlytargetcategory = "NONE",
  },
  damage = {
    default            = 0,
  },
}

local ParaDropClass = Weapon:New{
  areaOfEffect       = 1, -- needed?
  collideFriendly    = false,
  explosionGenerator = [[custom:nothing]],
  impulseFactor      = 0,
  manualBombSettings = true,
  model              = [[Bomb_Tiny.S3O]], -- better way?
  myGravity          = 1,
  range              = 1000,
  reloadtime         = 600,
  tolerance          = 4000,
  turret             = true,
  weaponType         = [[AircraftBomb]],
  customparams = {
    no_range_adjust    = true,
    damagetype         = [[none]],
    paratrooper        = 1,
  },
  damage = {
    default            = 0,
  },
}

return {
  BulletProofClass = BulletProofClass,
  DeathClass = DeathClass,
  MineClass = MineClass,  
  ParaDropClass = ParaDropClass,
  OpticClass = OpticClass,
}
