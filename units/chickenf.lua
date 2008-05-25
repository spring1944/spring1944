unitDef = {
  unitname            = "chickenf",
  name                = "Chicken Flyer",
  description         = "Brrk Brrk",
  acceleration        = 0.8,
  amphibious          = true,
  airHoverFactor      = 0,
  bmcode              = "1",
  brakeRate           = 0.4,
  buildCostEnergy     = 4500,
  buildCostMetal      = 150,
  builder             = false,
  buildPic            = "GBRRifle.png",
  buildTime           = 9000,
  canAttack           = true,
  canFly              = true,
  canGuard            = true,
  canLand             = true,
  canMove             = true,
  canPatrol           = true,
  canstop             = "1",
  canSubmerge         = true,
  category            = "NFLAGNAIR NFLAG INFTARG",
  corpse              = "DEAD",
  cruiseAlt           = 150,

  customParams        = {
    helptext = "YOU'RE NOT SUPPOSE TO BE IN HERE",
  },

  defaultmissiontype  = "Standby",
  explodeAs           = "resourceboom",
  floater             = true,
  footprintX          = 2,
  footprintZ          = 2,
  iconType            = "fighter",
  idleAutoHeal        = 20,
  idleTime            = 300,
  leaveTracks         = false,
  maneuverleashlength = "64000",
  mass                = 60,
  maxDamage           = 700,
  maxSlope            = 17,
  maxVelocity         = 10.0,
  maxWaterDepth       = 255,
  moverate1           = "32",
  noAutoFire          = false,
  objectName          = "chickenf.s3o",
  seismicSignature    = 4,
  selfDestructAs      = "resourceboom",
  separation          = "0.2",

  sfxtypes            = {

  },

  side                = "Germany",
  sightDistance       = 512,
  smoothAnim          = true,
  steeringmode        = "2",
  TEDClass            = "VTOL",
  turnRate            = 6000,
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
      range                   = 800,
      reloadtime              = 1.5,
      renderType              = 1,
      selfprop                = true,
    --  soundHit                = "chickenscream",
    --  soundStart              = "chickenscream",
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

return lowerkeys({ chickenf = unitDef })
