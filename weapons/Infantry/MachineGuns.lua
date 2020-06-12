-- Smallarms - Machineguns

-- Implementations
-- Rifle Calibre (~8mm) MG's
-- BESA
local BESA = MGClass:New{
  burst              = 8,
  burstRate          = 0.109,
  name               = [[BESA]],
  range              = 900,
  reloadTime         = 2.8,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
  sprayAngle         = 410, --?
}

-- Bren Mk. 2 (GBR)
local Bren = MGClass:New{
  burst              = 5,
  burstRate          = 0.109,
  name               = [[Bren Gun]],
  range              = 735,
  reloadTime         = 2.5,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
}

-- MG34 (GER)
local MG34 = MGClass:New{
  accuracy           = 100, --?
  burst              = 10,
  burstRate          = 0.069,
  name               = [[Maschinengewehr 34]],
  range              = 945,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG34]],
  sprayAngle         = 300, -- ?
}

-- MG42 (GER)
local MG42 = MGClass:New{
  accuracy           = 100, --?
  burst              = 11,
  burstRate          = 0.0175,
  name               = [[Maschinengewehr 42]],
  range              = 850,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG42]],
  sprayAngle         = 530,
}
-- Deployed MG42
local MG42_Deployed = MG42:New{
  range              = 1040,
  sprayAngle         = 360,
}
-- Anti Air MG42
local MG42AA = MG42:New(AAMG):New{
  range              = 1170,
  sprayAngle         = 460,
}

-- remote-controlled MG42 - really crappy accuracy as the gunner doesn't really see what he's shooting
local mg42remote = MG42:New{
	accuracy		= 5000,
	movingAccuracy	= 9000,
	sprayAngle		= 1000,
}

-- DP (RUS)
local DP = MGClass:New{
  burst              = 5,
  burstRate          = 0.12,
  name               = [[DP]],
  range              = 700,
  reloadTime         = 2.25,
  soundStart         = [[RUS_DP]],
}
-- DT
local DT = DP:New{
  range              = 910,
  reloadTime         = 3,
  sprayAngle         = 250,
  soundStart         = [[RUSDT_5]],
}

-- Maxim (RUS)
local Maxim = MGClass:New{
  burst              = 14,
  burstRate          = 0.115,
  name               = [[M1910 Maxim]],
  range              = 1270,
  reloadTime         = 2.7,
  soundStart         = [[RUS_Maxim]],
}
-- Maxim AA
local MaximAA = Maxim:New(AAMG):New{
  burst              = 7,
  burstRate          = 0.103,
  range              = 1250,
  customparams = {
    no_range_adjust    = true,
  }
}
-- ShKAS1941 (RUS)
local ShKAS1941 = MGClass:New(AMG):New{
  burst              = 9,
  burstRate          = 0.09,
  name               = [[ShKAS1941]],
  range              = 870,
  sprayAngle         = 1260,
  reloadTime         = 2.2,
  soundStart         = [[RUS_DP]],
  customparams = {
    no_range_adjust    = true,
  }
}
-- Vickers (GBR)
local Vickers = Maxim:New{
  name               = [[Vickers, .303 Mark 1]],
  sprayAngle         = 300, -- ?
}

-- M1919 Browning (USA)
local M1919A4Browning = MGClass:New{
  burst              = 7,
  burstRate          = 0.14,
  name               = [[M1919A4 Browning .30 caliber machinegun]],
  range              = 820,
  reloadTime         = 3,
  soundStart         = [[US_30Cal]],
  sprayAngle         = 460,
}
-- Deployed Browning
local M1919A4Browning_Deployed = M1919A4Browning:New{
  range              = 1020,
  sprayAngle         = 400,
}
-- Swedish version
local ksp_m1936 = M1919A4Browning:New{
	name		= "Kulspruta m/36",
	soundStart	= "KSP_M_36",
	burstRate          = 0.086,	-- sync with sound
}

local ksp_m1936_deployed = M1919A4Browning_Deployed:New{
	name		= "Kulspruta m/36",
	soundStart	= "KSP_M_36",
	burstRate          = 0.086,	-- sync with sound
}

-- Swedish tank version (later tanks only)
local ksp_m1939 = M1919A4Browning:New{
	name		= "Kulspruta m/39",
	soundStart	= "KSP_M_39",
	burst				= 5,
	burstRate          = 0.072,	-- sync with sound
}
local ksp_m1936AMG = ksp_m1936:New(AMG):New{
  range              = 880,
  customparams = {
    no_range_adjust    = true,
	--onlytargetCategory = "AIR",
  }
}

local ksp_m1936AA = ksp_m1936:New(AAMG):New{
  range              = 1126,
}

-- Breda 30 (ITA)
local Breda30 = MGClass:New{
  burst              = 3,
  burstrate          = 0.1,
  name               = [[Breda 30 Light Machine Gun]],
  range              = 675,
  reloadtime         = 2.6,
  soundStart         = [[ITA_Breda30]],
  sprayAngle         = 260,
}

-- Breda M37 (ITA)
local BredaM37 = MGClass:New{
  burst              = 8,
  burstRate          = 0.16,
  name               = [[Breda M37 Heavy Machinegun]],
  range              = 1110,
  reloadTime         = 2.8,
  soundStart         = [[ITA_M37]],
  sprayAngle         = 260,
}

-- Breda M38 (ITA)
local BredaM38 = MGClass:New{
  burst              = 7,
  burstRate          = 0.16,
  name               = [[Breda M38 mounted Machinegun]],
  range              = 870,
  reloadTime         = 3.2,
  soundStart         = [[ITA_M37]],
  sprayAngle         = 320,
}

-- 7.7mm Breda SAFAT Air MG (ITA)
local BredaSafat03 = MGClass:New(AMG):New{
  burst				 = 6,
  burstRate          = 0.05,
  name               = [[7.7mm Breda SAFAT]],
  range              = 825,
  heightBoostFactor  = 0,
  reloadTime         = 0.55,
  soundStart         = [[ITA_Breda30]],
  customparams = {
    no_range_adjust    = true,
  }
}

-- Type 97, also used for Type 99 (JPN)
local Type97MG = MGClass:New{
  burst              = 6,
  burstRate          = 0.1,
  name               = [[Type 97 7.7mm Machinegun]],
  range              = 870,
  reloadTime         = 2.8,
  soundStart         = [[JPN_Type99_LMG]],
  sprayAngle         = 320,
}

-- Type 92 (JPN)
local Type92MG = MGClass:New{
  burst              = 8,
  burstRate          = 0.073,
  name               = [[Type 97 7.7mm Machinegun]],
  range              = 1100,
  reloadTime         = 2.8,
  soundStart         = [[JPN_Type98_HMG]],
  sprayAngle         = 320,
} 

-- 7.7mm TE-4 Air MG (JPN)
local TE4 = MGClass:New(AAMG):New{
  burst				 = 6,
  burstRate          = 0.15,
  name               = [[7.7mm TE-4 Machinegun]],
  range              = 1025,
  predictBoost       = 0.2,
  reloadTime         = 1.5,
  soundStart         = [[JPN_TE4_MG]],
}

-- Large calibre (12.7mm) MG's
-- Vickers 50 cal (GBR)
local Twin05CalVickers = HeavyMGClass:New{
  name               = [[Twin Vickers .50 Caliber Heavy Machine Gun]],
  range              = 875,
  reloadTime         = 2.2,
  soundStart         = [[US_50CAL]],
  customParams = {
    onlyTargetCategory = SmallArm.customparams.onlytargetcategory .. " AIR", -- TODO: fudge as these can target air too
  },
}

-- DShK (RUS)
local DShK = HeavyMGClass:New{
  name               = [[DShK 12.7mm Heavy Machine Gun]],
  range              = 875,
  reloadTime         = 3,
  soundStart         = [[RUS_DShK]],
}
-- Twin DShK
local Twin_DShK = DShK:New{
  reloadTime         = 1.4, -- why not 1.5?
}
-- BeresinUBS
local BeresinUBS = HeavyMGClass:New(AMG):New{
  reloadTime         = 0.7,
  name               = [[BeresinUBS 12.7mm Machine Gun]],
  burst             = 6,
  range             = 890,
  burstRate         = 0.088,
  soundStart         = [[RUS_BeresinUBS]],
  customparams = {
    no_range_adjust    = true,
  }
}
-- M2 Browning  (USA)
local M2Browning = HeavyMGClass:New{
  name               = [[M2 Browning .50 Caliber Heavy Machine Gun]],
  burst				 = 3,
  range              = 880,
  reloadTime         = 2,
  soundStart         = [[US_50CAL]],
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 29,
  },
}
-- M2 Browning AA
local M2BrowningAA = M2Browning:New(AAMG):New{
  burst              = 4,
  range              = 1170,
  sprayAngle        = 250,
  reloadTime         = 0.75,
}
-- M2 Browning Aircraft
local M2BrowningAMG = M2Browning:New(AMG):New{
  burst             = 6,
  burstRate         = 0.085,
  range             = 900,
  heightBoostFactor = 0,
  reloadTime        = 0.65,
  soundStart        = [[US_50CALAir]],
  tolerance         = 1100, --?
  customparams = {
    no_range_adjust    = true,
	--onlytargetCategory = "AIR",
  }
}

-- Breda M1931 (ITA)
local BredaM1931 = HeavyMGClass:New{
  name               = [[Breda M1931 13mm Heavy Machine Gun]],
  range              = 880,
  reloadTime         = 4,
  soundStart         = [[US_50CAL]],
  sprayAngle         = 300,
}

--Breda M1931 AA
local BredaM1931AA = BredaM1931:New(AAMG):New{
  range              = 1080,
  accuracy	     = 200,
  burst              = 6,
  burstRate          = 0.109,
  predictBoost       = 0.25,
  reloadTime         = 1.5,
}

-- .50 Caliber Breda SAFAT Air MG (ITA)
local BredaSafat05 = HeavyMGClass:New(AMG):New{
  burst				 = 6,
  burstRate          = 0.125,
  name               = [[.50 Caliber Breda SAFAT]],
  range              = 900,
  heightBoostFactor  = 0,
  reloadTime         = 1.2,
  soundStart         = [[ITA_breda12_7mm]],
  customparams = {
    no_range_adjust    = true,
  }
}


-- Type 93 (JPN)
local Type93HMG = HeavyMGClass:New{
  name               = [[Type 93 13mm Heavy Machine Gun]],
  range              = 1120,
  reloadTime         = 4,
  soundStart         = [[US_50CAL]],
  sprayAngle         = 300,
}

-- Type 93 AA
local Type93AA = Type93HMG:New(AAMG):New{
  accuracy	     = 200,
  burst              = 6,
  burstRate          = 0.109,
  predictBoost       = 0.25,
  reloadTime         = 1.5,
  sprayAngle         = 300,
}

-- Type 1 Ho-103 12.7mm Air MG (JPN)
local Type1Ho103 = HeavyMGClass:New(AMG):New{
  burst			= 5,
  burstRate          = 0.085,
  name               = [[Type1 Ho-103 12.7mm]],
  range              = 800,
  heightBoostFactor  = 0,
  reloadTime         = 0.8,
  soundStart         = [[US_50CALAir]],
  customparams = {
    no_range_adjust    = true,
  }
}

-- Solothurn 31M
local mg30 = MG34:New{
  	range              = 930,
	name			= [[Solothurn 31M]],
}
-- schwarzlose
local Schwarzlose = Maxim:New{
	name               = [[Schwarzlose 07/31M]],
  	burst			= 16,
	range			= 1190,
	burstRate          = 0.132,	-- sync with sound
	reloadTime         = 3.5,
  	sprayAngle         = 400,
	soundStart	   = [[7m_Schwarzlose_burst]],
}
-- gebauer 37m
local gebauer_1934_37m = M1919A4Browning:New{
  	sprayAngle         = 400,
	name			= [[Gebauer Tank Machine Gun 1934/37.M]],
}

-- France
local MACmle1931 = MGClass:New{
	burst              = 6,
	burstRate          = 0.1,
	name               = [[Reibel mle1931]],
	range              = 870,
	reloadTime         = 2.8,
	soundStart         = [[FRAMle1924MG]],
	sprayAngle         = 320,
}

-- Return only the full weapons
return lowerkeys({
  -- 8mm
  BESA = BESA,
  Bren = Bren,
  Vickers = Vickers,
  MG34 = MG34,
  MG42 = MG42,
  MG42_Deployed = MG42_Deployed,
  MG42AA = MG42AA,
  mg42remote = mg42remote,
  DP = DP,
  DT = DT,
  Maxim = Maxim,
  MaximAA = MaximAA,
  ShKAS1941 = ShKAS1941,
  M1919A4Browning = M1919A4Browning,
  M1919A4Browning_Deployed = M1919A4Browning_Deployed,
  Breda30 = Breda30,
  BredaM37 = BredaM37,
  BredaM38 = BredaM38,
  BredaSafat03 = BredaSafat03,
  Type97MG = Type97MG,
  Type92MG = Type92MG,
  TE4 = TE4,
  -- 13mm
  Twin05CalVickers = Twin05CalVickers,
  DShK = DShK,
  Twin_DShK = Twin_DShK,
  BeresinUBS = BeresinUBS,
  M2Browning = M2Browning,
  M2BrowningAA = M2BrowningAA,
  M2BrowningAMG = M2BrowningAMG,
  BredaM1931 = BredaM1931,
  BredaM1931AA = BredaM1931AA,
  BredaSafat05 = BredaSafat05,
  Type93HMG = Type93HMG,
  Type93AA = Type93AA,
  Type1Ho103 = Type1Ho103,
  ksp_m1936 = ksp_m1936,
  ksp_m1936AMG = ksp_m1936AMG,
  ksp_m1936AA = ksp_m1936AA,
  ksp_m1936_deployed = ksp_m1936_deployed,
  ksp_m1939 = ksp_m1939,
  mg30 = mg30,
  mg7_deployed = Schwarzlose,
  gebauer_1934_37m = gebauer_1934_37m,
  MACmle1931 = MACmle1931,
})
