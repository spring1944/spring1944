-- Smallarms - Infantry Grenades

-- Implementations
-- AP Nades
-- No. 69 Mills Bomb (GBR)
local No69 = APGrenadeClass:New{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[No. 69 Hand Grenade]],
}

-- Model 24 (GER)
local Model24 = APGrenadeClass:New{
  accuracy           = 1250,
  areaOfEffect       = 24,
  edgeEffectiveness  = 0.5, -- intended?
  name               = [[Model 24 Stielhandgranate]],
  range              = 200,
  reloadtime         = 6.5, -- intended?
  weaponVelocity     = 210, -- intended?
  damage = {
    default            = 1725,
  },
}

-- Mk. 2 (USA)
local Mk2 = APGrenadeClass:New{
  accuracy           = 1777,
  areaOfEffect       = 40,
  name               = [[Mk. 2 Hand Grenade]],
  weaponVelocity     = 310, -- intended?
}

-- F1 (RUS)
-- this is new, currently unused, stas copied from No.69
local F1 = APGrenadeClass:New{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[F-1 Hand Grenade]],
}

-- OTO Model 35 (ITA)
local OTO_model35 = APGrenadeClass:New{
  areaOfEffect       = 30,
  name               = [[italian Grenade]],
  range              = 200,
  customparams = {
    armor_penetration  = 25, 
  },
  damage = {
    default            = 880,
  },
}

-- Type 99 AP Grenade (JPN)
local Type99Grenade = APGrenadeClass:New{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[Type 99 Grenade]],
}



-- AT nades
-- RPG-43 AT Nade (RUS)
local RPG43 = ATGrenadeClass:New{
  accuracy           = 200,
  areaOfEffect       = 24,
  weaponVelocity     = 170,
  reloadtime         = 6,
  name               = [[RPG-43 Anti-Tank Grenade]],
  customparams = {
    armor_penetration  = 75,
  },
  damage = {
    default            = 4896,
  },  
}

-- Model 42 AT Grenade (ITA)
local BredaMod42 = ATGrenadeClass:New{
  areaOfEffect       = 31,
  name               = [[Breda Anti-Tank Grenade]],
  weaponVelocity     = 420,
  reloadtime         = 9,
  damage = {
    default            = 1390,
  },
    customparams = {
    armor_penetration  = 52,
    damagetype         = [[fire]],
    howitzer	= true,
  },
}

-- L-type heavy AT grenade (ITA)
local L_type_grenade = ATGrenadeClass:New{
  areaOfEffect       = 33,
  name               = [[Italian Anti-Tank Stickgrenade]],
  weaponVelocity     = 380,
  reloadtime         = 12, 
  damage = {
    default            = 2040,
  },
    customparams = {
    armor_penetration  = 59,
    damagetype         = [[fire]],
    howitzer	= true,
  },
}

-- Type 3 AT Grenade (JPN)
local Type3AT = ATGrenadeClass:New{
  accuracy           = 150,
  areaOfEffect       = 23,
  weaponVelocity     = 160,
  reloadtime         = 7,
  name               = [[Type 3 Anti-Tank Grenade]],
  customparams = {
    armor_penetration  = 72,
  },
  damage = {
    default            = 4206,
  },  
}

-- Smoke nades
-- No. 77 WP (GBR)
local No77 = SmokeGrenadeClass:New{
  accuracy           = 1421,
  name               = [[No. 77 Smoke Grenade]],
}

-- Other nades
local Molotov = GrenadeClass:New{
  areaOfEffect       = 40,
  canattackground    = true, -- intended?
  cegTag             = [[Flametrail]],
  explosionGenerator = [[custom:Molotov]],
  explosionSpeed     = 0.01, -- needed?
  fireStarter        = 100,
  groundBounce       = false,
  name               = [["Molotov Cocktail"]],
  range              = 180,
  reloadTime         = 10,
  tolerance          = 200,
  weaponVelocity     = 260,
  customparams = {
	damagetype         = [[fire]],
	fearaoe            = 1,
	fearid             = 1,
	damagetime         = 25,
	ceg                = [[Molotov]],
	onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
  },
  damage = {
    default            = 15,
	lightbuildings     = 400,
  },  
}

-- Return only the full weapons
return lowerkeys({
  -- AP nades
  No69 = No69,
  Model24 = Model24,
  Mk2 = Mk2,
  F1 = F1,
  OTO_model35 = OTO_model35,
  Type99Grenade = Type99Grenade,
  -- AT nades
  RPG43 = RPG43,
  BredaMod42 = BredaMod42,
  L_type_grenade = L_type_grenade,
  Type3AT = Type3AT,
  -- Smoke nades
  No77 = No77,
  -- Other
  Molotov = Molotov,
})
