--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

spawnSquare          = 100       -- size of the chicken spawn square centered on the burrow
spawnSquareIncrement = 1         -- square size increase for each unit spawned
targetComm           = false     -- if not, chicken attack a random unit
techTime             = math.huge -- time between automatic tech level inceases
burrowName           = "roost"   -- burrow unit name
playerMalus          = 0.5       -- how much harder it becomes for each additional player
maxChicken           = 300
lagTrigger           = 0.5       -- average cpu usage after which lag prevention mode triggers
triggerTolerance     = 0.05      -- increase if lag prevention mode switches on and off too fast
idleKillTime         = 60        -- idle time after which the chicken are automatically killed
guardianRatio        = 0.2       -- percent of defender chicken
maxAge               = 120       -- chicken die at this age

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[[
Notes: 

 * spawnNumber = firstSpawnSize*(1+spawnGrowthFactor)^age + spawnGrowthIncrease*age + techLevel*techSpawnBonus
   where age is the age of the burrow

 * chanceIncrease = how much the chance of appearing increases per tech level
]]

easy = {
  alwaysVisible        = false,      -- chicken and burrows always visible?
  burrowSpawnRate      = 120,       -- reduced in big games
  firstSpawnSize       = 3,
  spawnGrowthFactor    = 0,
  spawnGrowthIncrease  = 1/240,
  chickenSpawnRate     = 60, 
  techSpawnBonus       = 0.25,
  units = {
    chicken  =  {tech =  0, initialChance = 10, chanceIncrease = 0   },
    chickena =  {tech =  5, initialChance = 1,  chanceIncrease = 0.25},
    chickenf =  {tech = 15, initialChance = 2,  chanceIncrease = 0.5 },
    chickenr =  {tech = 20, initialChance = 1,  chanceIncrease = 0.5 },
  }
}

normal = {
  alwaysVisible        = false,
  burrowSpawnRate      = 120,
  firstSpawnSize       = 3,
  spawnGrowthFactor    = 0,
  spawnGrowthIncrease  = 1/120,
  chickenSpawnRate     = 30,
  techSpawnBonus       = 0.125,
  units = {
    chicken  =  {tech =  0,   initialChance = 10, chanceIncrease = 0   },
    chickena =  {tech =  1.5, initialChance = 1,  chanceIncrease = 0.25},
    chickenf =  {tech =  6,   initialChance = 2,  chanceIncrease = 0.5 },
    chickenr =  {tech =  10,  initialChance = 1,  chanceIncrease = 0.5  },
  }
}

hard = {
  alwaysVisible        = false,
  burrowSpawnRate      = 120,
  firstSpawnSize       = 1,
  spawnGrowthFactor    = 0,
  spawnGrowthIncrease  = 1/60,
  chickenSpawnRate     = 30,
  techSpawnBonus       = 0.3,
  units = {
    chicken  =  {tech =  0,   initialChance = 10, chanceIncrease = 0   },
    chickena =  {tech =  1.5, initialChance = 1,  chanceIncrease = 0.25},
    chickenf =  {tech =  6,   initialChance = 2,  chanceIncrease = 0.5 },
    chickenr =  {tech =  10,  initialChance = 1,  chanceIncrease = 0.5  },
  }
}

defaultDifficulty = "normal"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------