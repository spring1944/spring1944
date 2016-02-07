-- Smallarms - Machineguns

-- Implementations
-- Rifle Calibre (~8mm) MG's
-- BESA
Weapon('BESA'):Extends('MGClass'):Attrs{
  burst              = 8,
  burstRate          = 0.109,
  movingAccuracy     = 7111,
  name               = [[BESA]],
  range              = 900,
  reloadTime         = 2.8,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
  sprayAngle         = 410, --?
}

-- Bren Mk. 2 (GBR)
Weapon('Bren'):Extends('MGClass'):Attrs{
  burst              = 5,
  burstRate          = 0.109,
  movingAccuracy     = 7111,
  name               = [[Bren Gun]],
  range              = 735,
  reloadTime         = 2.5,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
}

-- MG34 (GER)
Weapon('MG34'):Extends('MGClass'):Attrs{
  accuracy           = 100, --?
  burst              = 10,
  burstRate          = 0.069,
  movingAccuracy     = 2666,
  name               = [[Maschinengewehr 34]],
  range              = 945,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG34]],
  sprayAngle         = 300, -- ?
}

-- MG42 (GER)
Weapon('MG42'):Extends('MGClass'):Attrs{
  accuracy           = 100, --?
  burst              = 11,
  burstRate          = 0.0175,
  movingAccuracy     = 7111,
  name               = [[Maschinengewehr 42]],
  range              = 850,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG42]],
  sprayAngle         = 530,
}
-- Deployed MG42
Weapon('MG42_Deployed'):Extends('MG42'):Attrs{
  range              = 1040,
  sprayAngle         = 360,
}
-- Anti Air MG42
Weapon('MG42AA'):Extends('MG42'):Extends('AAMG'):Attrs{
  range              = 1170,
  sprayAngle         = 460,
}

-- DP (RUS)
Weapon('DP'):Extends('MGClass'):Attrs{
  burst              = 5,
  burstRate          = 0.12,
  movingAccuracy     = 1777, -- this looks like backwards 7111?
  name               = [[DP]],
  range              = 700,
  reloadTime         = 2.25,
  soundStart         = [[RUS_DP]],
}
-- DT
Weapon('DT'):Extends('DP'):Attrs{
  movingAccuracy     = 300,
  range              = 910,
  reloadTime         = 3,
  sprayAngle         = 250,
}

-- Maxim (RUS)
Weapon('Maxim'):Extends('MGClass'):Attrs{
  burst              = 14,
  burstRate          = 0.115,
  name               = [[M1910 Maxim]],
  range              = 1270,
  reloadTime         = 2.7,
  soundStart         = [[RUS_Maxim]],
}
-- Maxim AA
Weapon('MaximAA'):Extends('Maxim'):Extends('AAMG'):Attrs{
  burst              = 7,
  burstRate          = 0.103,
  movingAccuracy     = 400,
  range              = 1050,
}
-- Vickers (GBR)
Weapon('Vickers'):Extends('Maxim'):Attrs{
  name               = [[Vickers, .303 Mark 1]],
  sprayAngle         = 300, -- ?
}

-- M1919 Browning (USA)
Weapon('M1919A4Browning'):Extends('MGClass'):Attrs{
  burst              = 7,
  burstRate          = 0.14,
  movingAccuracy     = 6222,
  name               = [[M1919A4 Browning .30 caliber machinegun]],
  range              = 820,
  reloadTime         = 3,
  soundStart         = [[US_30Cal]],
  sprayAngle         = 460,
}
-- Deployed Browning
Weapon('M1919A4Browning_Deployed'):Extends('M1919A4Browning'):Attrs{
  range              = 1020,
  sprayAngle         = 400,
}

-- Breda 30 (ITA)
Weapon('Breda30'):Extends('MGClass'):Attrs{
  burst              = 3,
  burstrate          = 0.1,
  movingAccuracy     = 2667,
  name               = [[Breda 30 Light Machine Gun]],
  range              = 675,
  reloadtime         = 2.6,
  soundStart         = [[ITA_Breda30]],
  sprayAngle         = 260,
}

-- Breda M37 (ITA)
Weapon('BredaM37'):Extends('MGClass'):Attrs{
  burst              = 8,
  burstRate          = 0.16,
  movingAccuracy     = 6222,
  name               = [[Breda M37 Heavy Machinegun]],
  range              = 1090,
  reloadTime         = 3.1,
  soundStart         = [[ITA_M37]],
  sprayAngle         = 260,
}

-- Breda M38 (ITA)
Weapon('BredaM38'):Extends('MGClass'):Attrs{
  burst              = 7,
  burstRate          = 0.16,
  movingAccuracy     = 6222,
  name               = [[Breda M38 mounted Machinegun]],
  range              = 870,
  reloadTime         = 3.2,
  soundStart         = [[ITA_M37]],
  sprayAngle         = 320,
}

-- 7.7mm Breda SAFAT Air MG (ITA)
Weapon('BredaSafat03'):Extends('MGClass'):Extends('AMG'):Attrs{
  burst				 = 6,
  burstRate          = 0.05,
  canAttackGround    = false,
  name               = [[7.7mm Breda SAFAT]],
  range              = 825,
  heightBoostFactor  = 0,
  reloadTime         = 0.55,
  soundStart         = [[ITA_Breda30]],
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
  }
}

-- Type 97, also used for Type 99 (JPN)
Weapon('Type97MG'):Extends('MGClass'):Attrs{
  burst              = 6,
  burstRate          = 0.1,
  movingAccuracy     = 6222,
  name               = [[Type 97 7.7mm Machinegun]],
  range              = 870,
  reloadTime         = 2.8,
  soundStart         = [[JPN_Type99_LMG]],
  sprayAngle         = 320,
}

-- Type 92 (JPN)
Weapon('Type92MG'):Extends('MGClass'):Attrs{
  burst              = 8,
  burstRate          = 0.073,
  movingAccuracy     = 6222,
  name               = [[Type 97 7.7mm Machinegun]],
  range              = 1100,
  reloadTime         = 2.8,
  soundStart         = [[JPN_Type98_HMG]],
  sprayAngle         = 320,
} 

-- 7.7mm TE-4 Air MG (JPN)
Weapon('TE4'):Extends('MGClass'):Extends('AAMG'):Attrs{
  burst				 = 6,
  burstRate          = 0.15,
  name               = [[7.7mm TE-4 Machinegun]],
  range              = 925,
  predictBoost       = 0.2,
  reloadTime         = 1.5,
  soundStart         = [[JPN_TE4_MG]],
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
    fearid             = 701,
  }
}


-- Large calibre (12.7mm) MG's
-- Vickers 50 cal (GBR)
Weapon('Twin05CalVickers'):Extends('HeavyMGClass'):Attrs{
  name               = [[Twin Vickers .50 Caliber Heavy Machine Gun]],
  range              = 875,
  reloadTime         = 2.2,
  soundStart         = [[US_50CAL]],
  customParams = {
	onlytargetcategory = "INFANTRY SOFTVEH DEPLOYED AIR", -- this is a bit of a special snowflake with target categories?
  },
}

-- DShK (RUS)
Weapon('DShK'):Extends('HeavyMGClass'):Attrs{
  name               = [[DShK 12.7mm Heavy Machine Gun]],
  range              = 875,
  reloadTime         = 3,
  soundStart         = [[RUS_DShK]],
}
-- Twin DShK
Weapon('Twin_DShK'):Extends('DShK'):Attrs{
  reloadTime         = 1.4, -- why not 1.5?
}

-- M2 Browning  (USA)
Weapon('M2Browning'):Extends('HeavyMGClass'):Attrs{
  name               = [[M2 Browning .50 Caliber Heavy Machine Gun]],
  burst				 = 3,
  range              = 880,
  reloadTime         = 2,
  soundStart         = [[US_50CAL]],
}
-- M2 Browning AA
Weapon('M2BrowningAA'):Extends('M2Browning'):Extends('AAMG'):Attrs{
  burst              = 3,
  movingAccuracy     = 200,
  range              = 1170,
  sprayAngle        = 250,
  reloadTime         = 0.375,
}
-- M2 Browning Aircraft
Weapon('M2BrowningAMG'):Extends('M2Browning'):Extends('AMG'):Attrs{
  burst             = 3,
  burstRate         = 0.085,
  range             = 900,
  heightBoostFactor = 0,
  reloadTime        = 0.3,
  soundStart        = [[US_50CALAir]],
  sprayAngle        = 1050,
  tolerance         = 1100, --?
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
	--onlytargetCategory = "AIR",
  }
}

-- Breda M1931 (ITA)
Weapon('BredaM1931'):Extends('HeavyMGClass'):Attrs{
  name               = [[Breda M1931 13mm Heavy Machine Gun]],
  range              = 880,
  reloadTime         = 4,
  soundStart         = [[US_50CAL]],
  sprayAngle         = 300,
}

--Breda M1931 AA
Weapon('BredaM1931AA'):Extends('BredaM1931'):Attrs{
  accuracy	     = 200,
  burst              = 6,
  burstRate          = 0.109,
  canAttackGround    = false,
  movingAccuracy     = 400,
  predictBoost       = 0.25,
  range              = 1300,
  reloadTime         = 1.5,
  sprayAngle         = 300,
  customparams = {
    no_range_adjust    = true,
    fearid             = 701,
  }
}

-- .50 Caliber Breda SAFAT Air MG (ITA)
Weapon('BredaSafat05'):Extends('HeavyMGClass'):Extends('AMG'):Attrs{
  burst				 = 6,
  burstRate          = 0.125,
  canAttackGround    = false,
  name               = [[.50 Caliber Breda SAFAT]],
  range              = 900,
  heightBoostFactor  = 0,
  reloadTime         = 1.2,
  soundStart         = [[ITA_breda12_7mm]],
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
  }
}


-- Type 93 (JPN)
Weapon('Type93HMG'):Extends('HeavyMGClass'):Attrs{
  name               = [[Type 93 13mm Heavy Machine Gun]],
  range              = 880,
  reloadTime         = 4,
  soundStart         = [[US_50CAL]],
  sprayAngle         = 300,
}

-- Type 93 AA
Weapon('Type93AA'):Extends('Type93HMG'):Attrs{
  accuracy	     = 200,
  burst              = 6,
  burstRate          = 0.109,
  movingAccuracy     = 400,
  predictBoost       = 0.25,
  range              = 1300,
  reloadTime         = 1.5,
  sprayAngle         = 300,
  customparams = {
    no_range_adjust    = true,
    fearid             = 701,
  }
}

-- Type 1 Ho-103 12.7mm Air MG (JPN)
Weapon('Type1Ho103'):Extends('HeavyMGClass'):Attrs{
  burst			= 8,
  burstRate          = 0.085,
  canAttackGround    = false,
  name               = [[Type1 Ho-103 12.7mm]],
  range              = 800,
  heightBoostFactor  = 0,
  reloadTime         = 0.8,
  soundStart         = [[US_50CALAir]],
  sprayAngle         = 300,
  weaponType         = [[Cannon]],
  customparams = {
    no_range_adjust    = true,
  }
}




-- Return only the full weapons
