-- Misc - Tracers

-- Tracer Base Class
local TracerClass = Weapon:New{
  areaOfEffect       = 1,
  burnblow           = true,
  explosionGenerator = [[custom:nothing]],
  id                 = 666, -- needed?
  noSelfDamage       = true,
  range              = 1000,
  reloadtime         = 0.1,
  rgbColor           = [[1.0 0.75 0.0]],
  tolerance          = 600,
  turret             = true,
  customparams = {
    damagetype         = [[none]],
  },
  damage = {
    default            = 0,
  },
}

local MGTracerClass = TracerClass:New{
  avoidFriendly      = false,
  collideFriendly    = false,
  coreThickness      = 0.15,
  duration           = 0.01,
  intensity          = 0.7,
  interceptedByShieldType = 8,
  laserFlareSize     = 0.0001,
  thickness          = 0.45,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
}

local GreenTracerClass = Weapon:New{
  rgbColor           = [[0.0 0.7 0.0]],  
}

-- Implementations

-- Small Tracer (8mm MG)
local Small_Tracer = MGTracerClass:New{
  name               = [[Tracer for standard small-arms fire]],
  size               = 2.5, -- does this do anything for lasercannon?
}
local Small_Tracer_Green = Small_Tracer:New(GreenTracerClass)

-- Medium Tracer (12.7 - 15mm MG)
local Medium_Tracer = MGTracerClass:New{
  name               = [[Tracer for HMGs and 15mm cannons, etc]],
  size               = 4, -- does this do anything for lasercannon?
  sprayAngle         = 410,
}
local Medium_Tracer_Green = Medium_Tracer:New(GreenTracerClass)

-- Large Tracer (20mm AutoCannon)
local Large_Tracer = TracerClass:New{
  collisionSize      = 2,
  intensity          = 0.1,
  name               = [[Tracer for light automatic cannons]],
  range              = 2000, -- overrides default
  separation         = 2,
  size               = 1,
  sprayAngle         = 250,
  stages             = 50,
  weaponType         = [[Cannon]],
  weaponVelocity     = 2100,
}
local Large_Tracer_Green = Large_Tracer:New(GreenTracerClass)

-- Return only the full weapons
return lowerkeys({
  Small_Tracer = Small_Tracer,
  Small_Tracer_Green = Small_Tracer_Green,
  Medium_Tracer = Medium_Tracer,
  Medium_Tracer_Green = Medium_Tracer_Green,
  Large_Tracer = Large_Tracer,
  Large_Tracer_Green = Large_Tracer_Green,
})
