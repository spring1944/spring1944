-- Aircraft - Parachute Drops

-- ParaDrop Base Class
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
  ParaDropClass = ParaDropClass,
}
