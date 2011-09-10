-- Aircraft - Parachute Drops

-- ParaDrop Base Class
local ParaDropClass = Weapon:New{
  areaOfEffect       = 1, -- needed?
  collideFriendly    = false,
  commandfire        = true,
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
    damagetype         = [[none]],
    paratrooper        = 1,
  },
  damage = {
    default            = 0,
  },
}

-- Implementations

-- US 101st Paratrooper (USA)
local US_Paratrooper = ParaDropClass:New{
  burst              = 18,
  burstrate          = 0.15,
  name               = [[Paratroops]],
}

-- Partisan Supply Drop (RUS)
local RUS_PartisanDrop = ParaDropClass:New{
  name               = [[Partisan Supply Drop]],
}

-- Return only the full weapons
return lowerkeys({
  US_Paratrooper = US_Paratrooper,
  RUS_PartisanDrop = RUS_PartisanDrop,
})
