unitDef = {
  unitname            = "chickens",
  name                = "Chicken Skirm",
  description         = "Brrk Brrk",
  acceleration        = 0.36,
  bmcode              = "1",
  brakeRate           = 0.2,
  buildCostEnergy     = 1200,
  buildCostMetal      = 150,
  builder             = false,
  buildPic            = "armpw2.png",
  buildTime           = 1800,
  canAttack           = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canstop             = "1",
  category            = "ARM NOTWATER NOTFLOAT MOBILE NOTAIR LEVEL1 ALL",
  corpse              = "DEAD",

  customParams        = {
    helptext = "YOU'RE NOT SUPPOSE TO BE IN HERE",
  },

  defaultmissiontype  = "Standby",
  explodeAs           = "SMALL_UNITEX",
  floater             = true,
  footprintX          = 2,
  footprintZ          = 2,
  iconType            = "kbot",
  idleAutoHeal        = 20,
  idleTime            = 300,
  leaveTracks         = true,
  maneuverleashlength = "640",
  mass                = 60,
  maxDamage           = 400,
  maxSlope            = 17,
  maxVelocity         = 2.0,
  maxWaterDepth       = 15,
  movementClass       = "HOVER3",
  noAutoFire          = false,
  objectName          = "chickens.s3o",
  seismicSignature    = 4,
  selfDestructAs      = "SMALL_UNIT",

  sfxtypes            = {

    explosiongenerators = {
      "custom:emg_shells_l",
      "custom:flashmuzzle1",
      "custom:dirt",
    },

  },

  side                = "ARM",
  sightDistance       = 384,
  smoothAnim          = true,
  sonarDistance       = 400,
  steeringmode        = "2",
  TEDClass            = "KBOT",
  trackOffset         = 0,
  trackStrength       = 8,
  trackStretch        = 1,
  trackType           = "ComTrack",
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
    },
    
  },


  weaponDefs          = {

    WEAPON = {
      name                    = "Spike",
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 1,
      craterMult              = 1,

      damage                  = {
        default = 80,
      },

      explosionGenerator      = "custom:nothing",
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      model                   = "spike.s3o",
      noSelfDamage            = true,
      propeller               = "1",
      range                   = 400,
      reloadtime              = 1.5,
      renderType              = 1,
      selfprop                = true,
      soundHit                = "chickenscream",
      soundStart              = "chickenscream",
      startVelocity           = 800,
      subMissile              =	1,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 100,
      weaponTimer             = 1,
      weaponVelocity          = 800,
    },
},

  featureDefs         = {

    DEAD = {
    },


    HEAP = {
    },

  },

}

return lowerkeys({ chickens = unitDef })
