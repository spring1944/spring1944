unitDef = {
  unitname          = "roost",
  name              = "Roost",
  description       = "Spawns Chicken",
  acceleration      = 0,
  activateWhenBuilt = true,
  bmcode            = "0",
  brakeRate         = 0,
  buildAngle        = 4096,
  buildCostEnergy   = 700,
  buildCostMetal    = 350,
  builder           = false,
  buildPic          = "GBRBarracks.png",
  buildTime         = 1750,
  category          = "NFLAGNAIR NFLAG",
  energyStorage     = 0,
  energyUse         = 0,
  explodeAs         = "NOWEAPON",
  footprintX        = 3,
  footprintZ        = 3,
  iconType          = "special",
  idleAutoHeal      = 0,
  idleTime          = 1800,
  mass              = 25,
  maxDamage         = 2000,
  maxSlope          = 10,
  maxVelocity       = 0,
  noAutoFire        = false,
  objectName        = "roost",
  seismicSignature  = 4,
  selfDestructAs    = "NOWEAPON",
  side              = "Germany",
  sightDistance     = 273,
  smoothAnim        = true,
  TEDClass          = "ENERGY",
  turnRate          = 0,
  workerTime        = 0,
  yardMap           = "ooooooooo",
  upright          = false,
  levelGround      = false,
  
  sfxtypes            = {

  },

  featureDefs       = {
  },

}

return lowerkeys({ roost = unitDef })
