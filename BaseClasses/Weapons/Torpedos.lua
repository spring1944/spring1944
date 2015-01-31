-- Misc - Tracers

-- Torpedo Base Class
local TorpedoClass = Weapon:New{
  areaOfEffect       = 32,  -- *
  avoidFriendly      = true,
  burnblow           = true,
  canAttackGround	 = false,
  edgeEffectiveness  = 0.5,
  explosionSpeed     = 30,
  --explosionGenerator = [[custom:nothing]],
  noSelfDamage       = true,
  reloadTime         = 300, -- still needed so e.g. each of the 4 fairmile tubes can only fire once
  rgbColor           = [[1.0 0.75 0.0]],
  soundHit           = "gen_explo_11",
  soundStart         = "watersplash",
  tolerance          = 9000, -- TODO: too high?
  tracks             = true,
  turnRate           = 50000, -- too high?
  turret             = true, -- TODO: needed? certainly for gabi
  waterWeapon        = true,
  weaponType         = "TorpedoLauncher",
  customparams = {
    damagetype         = "shapedcharge",
	minrange           = 400, -- *
	onlytargetcategory = "LARGESHIP",
  },
}

return {
  TorpedoClass = TorpedoClass,
}
