unitDef = {
  unitname            = "chickenr",
  name                = "Chicken Artillery",
  description         = "Brrk Brrk",
  acceleration        = 0.36,
  badTargetCategory   = "VTOL",
  bmcode              = "1",
  brakeRate           = 0.2,
  buildCostEnergy     = 3200,
  buildCostMetal      = 400,
  builder             = false,
  buildPic            = "GBRRifle.png",
  buildTime           = 4800,
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
  explodeAs           = "small_explosion",
  footprintX          = 2,
  footprintZ          = 2,
  highTrajectory      = 1,
  iconType            = "selfprop",
  idleAutoHeal        = 20,
  idleTime            = 300,
  leaveTracks         = false,
  maneuverleashlength = "640",
  mass                = 60,
  maxDamage           = 600,
  maxSlope            = 17,
  maxVelocity         = 1.8,
  maxWaterDepth       = 15,
  movementClass       = "KBOT_Infantry",
  noAutoFire          = false,
  noChaseCategory     = "VTOL",
  objectName          = "chickenr.s3o",
  seismicSignature    = 4,
  selfDestructAs      = "small_explosion",

  sfxtypes            = {

  },

  side                = "Germany",
  sightDistance       = 512,
  smoothAnim          = true,
  sonarDistance       = 450,
  steeringmode        = "2",
  TEDClass            = "KBOT",
  trackOffset         = 0,
  trackStrength       = 8,
  trackStretch        = 1,
  trackType           = "ComTrack",
  trackWidth          = 18,
  turnRate            = 768,
  upright             = false,
  workerTime          = 0,

  weapons             = {

    {
      def               = "WEAPON",
      mainDir           = "0 0 1",
      maxAngleDif       = 120,
      onlyTargetCategory = "NOTAIR",
    },
    
    {
      def               = "TORPEDO",
      mainDir           = "0 0 1",
      maxAngleDif       = 120,
    },

  },


  weaponDefs          = {

    WEAPON = {
      name                    = "Blob",
      areaOfEffect            = 128,
      burst                   = 4,
      burstrate               = 0.01,
      craterBoost             = 1,
      craterMult              = 1,

      damage                  = {
        default = 80,
        planes  = 80,
        subs    = 6,
      },

      endsmoke                = "0",
      explosionGenerator      = "custom:BulletImpact",
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      intensity               = 0.7,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      noSelfDamage            = true,
      range                   = 1000,
      reloadtime              = 6,
      renderType              = 4,
      rgbColor                = "0.0 0.6 0.6",
      size                    = 8,
      sizeDecay               = 0,
     -- soundStart              = "flashemg",
      sprayAngle              = 512,
      startsmoke              = "0",
      tolerance               = 5000,
      turret                  = true,
      weaponTimer             = 0.2,
      weaponVelocity          = 400,
    },
    
    TORPEDO = {
      name                    = "Torpedo",
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 1,
      craterMult              = 1,

      damage                  = {
        default = 600,
        planes  = 120,
        subs    = "150",
      },

      explosionGenerator      = "custom:Weapon_Explosion_Small",
      guidance                = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 0,
      lineOfSight             = true,
      model                   = "spike.s3o",
      noSelfDamage            = true,
      propeller               = "1",
      range                   = 500,
      reloadtime              = 2.5,
      renderType              = 1,
      selfprop                = true,
     -- soundHit                = "xplodep1",
    --  soundStart              = "torpedo1",
      startVelocity           = 100,
      tolerance               = 42767,
      turnRate                = 8000,
      turret                  = false,
      waterWeapon             = true,
      weaponAcceleration      = 15,
      weaponTimer             = 3,
      weaponVelocity          = 160,
    },

  },


  featureDefs         = {

    DEAD = {
    },


    HEAP = {
    },

  },

}

return lowerkeys({ chickenr = unitDef })
