-- Misc - Deaths

-- Implementations

-- Tiny Explosion (Used for Infantry Guns currently)
Weapon('Tiny_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 64,
  impulseFactor      = 0,
  soundHitDry        = [[GEN_Explo_1]],
  damage = {
    default            = 10,
  }
}

-- VEHICLES
-- Vehicle Explosion - Small
Weapon('Vehicle_Explosion_Sm'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 64,
  soundHitDry        = [[GEN_Explo_Vehicle1]],
  damage = {
    default            = 10,
  }
}

-- Vehicle Explosion - medium
Weapon('Vehicle_Explosion_Med'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 96,
  soundHitDry        = [[GEN_Explo_Vehicle2]],
  damage = {
    default            = 15,
  }
}

-- Vehicle Explosion - Large
Weapon('Vehicle_Explosion_Large'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 120,
  soundHitDry        = [[GEN_Explo_Vehicle3]],
  damage = {
    default            = 23,
  }
}

-- BUILDINGS

-- Building Explosion - Small
Weapon('Small_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 65,
  soundHitDry        = [[GEN_Explo_2]],
  damage = {
    default            = 25,
  }
}

-- Building Explosion - Medium
Weapon('Med_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 112,
  explosionGenerator = [[custom:ROACHPLOSION]],
  soundHitDry        = [[GEN_Explo_3]],
  damage = {
    default            = 40,
  }
}

-- Building Explosion - Large
Weapon('Large_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 112,
  explosionGenerator = [[custom:HE_Large]],
  impulseFactor      = 2,
  soundHitDry        = [[GEN_Explo_5]],
  damage = {
    default            = 1000,
  }
}

-- Building Explosion - Huge
Weapon('Huge_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 250,
  explosionGenerator = [[custom:HE_XLarge]],
  impulseFactor      = 2,
  soundHitDry        = [[GEN_Explo_10]],
  damage = {
    default            = 2500,
  }
}

-- Building Explosion - Massive
Weapon('Massive_Explosion'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 300,
  explosionGenerator = [[custom:HE_XXLarge]],
  explosionSpeed     = 2.5, -- overrides default
  impulseFactor      = 3,
  soundHitDry        = [[GEN_Explo_11]],
  damage = {
    default            = 3000,
  }
}

-- Resource Boom - doesn't really fit in with the established hierarchy :(
Weapon('ResourceBoom'):Extends('DeathClass'):Attrs{
  areaOfEffect       = 120,
  explosionGenerator = [[custom:SmallBuildingDeath]],
  impulseFactor      = 2,
  soundHitDry        = [[GEN_Explo_3]],
  damage = {
    default            = 80,
  }
}

-- Return only the full weapons
