unitDef = {
  unitname            = "chicken",
  name                = "Chicken",
  description         = "Brrk Brrk",
  acceleration        = 0.36,
  badTargetCategory   = "VTOL",
  bmcode              = "1",
  brakeRate           = 0.2,
  buildCostEnergy     = 300,
  buildCostMetal      = 40,
  builder             = false,
  buildPic            = "GBRRifle",
  buildTime           = 600,
  canAttack           = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canstop             = "1",
  category            = "NFLAGNAIR NFLAG INFTARG",
  corpse              = "DEAD",

  customParams        = {
    helptext = "YOU'RE NOT SUPPOSE TO BE IN HERE",
  },

  defaultmissiontype  = "Standby",
  explodeAs           = "resourceboom",
  floater             = true,
  footprintX          = 2,
  footprintZ          = 2,
  iconType            = "recon",
  idleAutoHeal        = 20,
  idleTime            = 300,
  leaveTracks         = false,
  maneuverleashlength = "640",
  mass                = 30,
  maxDamage           = 270,
  maxSlope            = 17,
  maxVelocity         = 3.2,
  maxWaterDepth       = 15,
  movementClass       = "KBOT_Infantry",
  noAutoFire          = false,
  noChaseCategory     = "VTOL",
  objectName          = "chicken.s3o",
  seismicSignature    = 4,
  selfDestructAs      = "resourceboom",

  sfxtypes            = {

 },

  side                = "Germany",
  sightDistance       = 256,
  smoothAnim          = true,
  steeringmode        = "2",
  TEDClass            = "KBOT",
  trackOffset         = 0,
  trackStrength       = 8,
  trackStretch        = 1,
  --trackType           = "ComTrack",
  trackWidth          = 18,
  turnRate            = 768,
  upright             = false,
  waterline           = 8,
  workerTime          = 0,

  weapons             = {

    {
      def               = "WEAPON",
      mainDir           = "0 0 1",
      maxAngleDif       = 120,
      badTargetCategory = "VTOL",
    },

  },


  weaponDefs          = {

    WEAPON = {
      name                    = "Claws",
      alphaDecay              = 0.1,
      areaOfEffect            = 8,
      colormap                = "1 0.95 0.4 1   1 0.95 0.4 1    0 0 0 0.01    1 0.7 0.2 1",
      craterBoost             = 1,
      craterMult              = 1,

      damage                  = {
        default = 80,
      },

      endsmoke                = "0",
      explosionGenerator      = "custom:nothing",
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      intensity               = 0.7,
      interceptedByShieldType = 0,
      lineOfSight             = true,
      noGap                   = false,
      noSelfDamage            = true,
      range                   = 100,
      reloadtime              = 1.2,
      renderType              = 4,
      rgbColor                = "1 0.95 0.4",
      separation              = 1.5,
      size                    = 1.75,
      sizeDecay               = 0,
     -- soundStart              = "chickenscream",
      sprayAngle              = 1180,
      stages                  = 10,
      startsmoke              = "0",
      targetborder            = 1,
      tolerance               = 5000,
      turret                  = true,
      weaponTimer             = 0.1,
      weaponVelocity          = 500,
    },

  },


  featureDefs         = {

    DEAD = {
    },


    HEAP = {
    },

  },

}

return lowerkeys({ chicken = unitDef })
