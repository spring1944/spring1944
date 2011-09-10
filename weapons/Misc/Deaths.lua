-- Misc - Deaths

-- Death Base Class
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

-- Implementations

-- Tiny Explosion (Used for Infantry Guns currently)
local Tiny_Explosion = DeathClass:New{
  areaOfEffect       = 64,
  impulseFactor      = 0,
  soundHit           = [[GEN_Explo_1]],
  damage = {
    default            = 10,
  }
}

-- VEHICLES
-- Vehicle Explosion - Small
local Vehicle_Explosion_Sm = DeathClass:New{
  areaOfEffect       = 64,
  soundHit           = [[GEN_Explo_Vehicle1]],
  damage = {
    default            = 10,
  }
}

-- Vehicle Explosion - medium
local Vehicle_Explosion_Med = DeathClass:New{
  areaOfEffect       = 96,
  soundHit           = [[GEN_Explo_Vehicle2]],
  damage = {
    default            = 15,
  }
}

-- Vehicle Explosion - Large
local Vehicle_Explosion_Large = DeathClass:New{
  areaOfEffect       = 120,
  soundHit           = [[GEN_Explo_Vehicle3]],
  damage = {
    default            = 23,
  }
}

-- BUILDINGS

-- Building Explosion - Small
local Small_Explosion = DeathClass:New{
  areaOfEffect       = 65,
  soundHit           = [[GEN_Explo_2]],
  damage = {
    default            = 25,
  }
}

-- Building Explosion - Medium
local Med_Explosion = DeathClass:New{
  areaOfEffect       = 112,
  explosionGenerator = [[custom:ROACHPLOSION]],
  soundHit           = [[GEN_Explo_3]],
  damage = {
    default            = 40,
  }
}

-- Building Explosion - Large
local Large_Explosion = DeathClass:New{
  areaOfEffect       = 112,
  explosionGenerator = [[custom:HE_Large]],
  impulseFactor      = 2,
  soundHit           = [[GEN_Explo_5]],
  damage = {
    default            = 1000,
  }
}

-- Building Explosion - Huge
local Huge_Explosion = DeathClass:New{
  areaOfEffect       = 250,
  explosionGenerator = [[custom:HE_XLarge]],
  impulseFactor      = 2,
  soundHit           = [[GEN_Explo_10]],
  damage = {
    default            = 2500,
  }
}

-- Building Explosion - Massive
local Massive_Explosion = DeathClass:New{
  areaOfEffect       = 300,
  explosionGenerator = [[custom:HE_XXLarge]],
  explosionSpeed     = 2.5, -- overrides default
  impulseFactor      = 3,
  soundHit           = [[GEN_Explo_11]],
  damage = {
    default            = 3000,
  }
}

-- Resource Boom - doesn't really fit in with the established hierarchy :(
local ResourceBoom = DeathClass:New{
  areaOfEffect       = 120,
  explosionGenerator = [[custom:SmallBuildingDeath]],
  impulseFactor      = 2,
  soundHit           = [[GEN_Explo_3]],
  damage = {
    default            = 80,
  }
}

-- Return only the full weapons
return lowerkeys({
  Tiny_Explosion = Tiny_Explosion,
  -- Vehicles
  Vehicle_Explosion_Sm = Vehicle_Explosion_Sm,
  Vehicle_Explosion_Med = Vehicle_Explosion_Med,
  Vehicle_Explosion_Large = Vehicle_Explosion_Large,
  -- Buildings
  Small_Explosion = Small_Explosion,
  Med_Explosion = Med_Explosion,
  Large_Explosion = Large_Explosion,
  Huge_Explosion = Huge_Explosion,
  Massive_Explosion = Massive_Explosion,
  ResourceBoom = ResourceBoom,
})
