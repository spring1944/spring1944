-- Misc - Tracers

-- Implementations

-- Small Tracer (8mm MG)
local Small_Tracer = MGTracerClass:New{
  interceptedByShieldType = 8,
  name               = [[Tracer for standard small-arms fire]],
  size               = 2.5, -- does this do anything for lasercannon?
}
local Small_Tracer_Green = Small_Tracer:New(GreenTracerClass)

-- Medium Tracer (12.7 - 15mm MG)
local Medium_Tracer = MGTracerClass:New{
  interceptedByShieldType = 16,
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
