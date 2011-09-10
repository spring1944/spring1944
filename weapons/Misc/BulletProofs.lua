-- Misc - Bulletproofs

-- Bulletproofs Base Class
local BulletProofClass = Weapon:New{
  exteriorShield     = true,
  isShield           = true,
  shieldEnergyUse    = 0,
  shieldForce        = 500,
  shieldMaxSpeed     = 900,
  shieldRepulser     = true,
  weaponType         = [[Shield]],
}

-- Implementations

-- .30cal proof
local Bounce30cal = BulletProofClass:New{
  shieldInterceptType = 16,
  shieldRadius       = 35,
}

-- .50cal proof
local Bounce50cal = BulletProofClass:New{
  shieldInterceptType = 24,
  shieldRadius       = 40,
}

-- Return only the full weapons
return lowerkeys({
  [".30calproof"] = Bounce30cal,
  [".50calproof"] = Bounce50cal,
})
