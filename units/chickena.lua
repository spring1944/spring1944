unitDef = {
  unitname            = "chickena",
  name                = "Chicken Assault",
  description         = "Brrk Brrk",
  acceleration        = 0.36,
  badTargetCategory   = "VTOL",
  bmcode              = "1",
  brakeRate           = 0.2,
  buildCostEnergy     = 1200,
  buildCostMetal      = 150,
  builder             = false,
  buildPic            = "GBRRifle.png",
  buildTime           = 1800,
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
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = "assault",
  idleAutoHeal        = 20,
  idleTime            = 300,
  leaveTracks         = false,
  maneuverleashlength = "640",
  mass                = 90,
  maxDamage           = 1200,
  maxSlope            = 17,
  maxVelocity         = 2.1,
  maxWaterDepth       = 15,
  movementClass       = "KBOT_Infantry",
  noAutoFire          = false,
  noChaseCategory     = "VTOL",
  objectName          = "chickena.s3o",
  seismicSignature    = 4,
  selfDestructAs      = "resourceboom",

  sfxtypes            = {

    explosiongenerators = {
      "custom:emg_shells_l",
      "custom:flashmuzzle1",
      "custom:dirt",
    },

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
        default = 60,
      },

      endsmoke                = "0",
      explosionGenerator      = "custom:Weapon_Explosion_Small",
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      intensity               = 0.7,
      interceptedByShieldType = 0,
      lineOfSight             = true,
      noGap                   = false,
      noSelfDamage            = true,
      range                   = 130,
      reloadtime              = 0.4,
      renderType              = 4,
      rgbColor                = "1 0.95 0.4",
      separation              = 1.5,
      size                    = 1.75,
      sizeDecay               = 0,
    -- soundStart              = "flashemg",
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

return lowerkeys({ chickena = unitDef })
