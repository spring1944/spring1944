-- Smallarms - Infantry Grenades

-- Implementations
-- AP Nades
-- No. 69 Mills Bomb (GBR)
Weapon('No69'):Extends('APGrenadeClass'):Attrs{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[No. 69 Hand Grenade]],
}

-- Model 24 (GER)
Weapon('Model24'):Extends('APGrenadeClass'):Attrs{
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
Weapon('Mk2'):Extends('APGrenadeClass'):Attrs{
  accuracy           = 1777,
  areaOfEffect       = 40,
  name               = [[Mk. 2 Hand Grenade]],
  weaponVelocity     = 310, -- intended?
}

-- F1 (RUS)
-- this is new, currently unused, stas copied from No.69
Weapon('F1'):Extends('APGrenadeClass'):Attrs{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[F-1 Hand Grenade]],
}

-- OTO Model 35 (ITA)
Weapon('OTO_model35'):Extends('APGrenadeClass'):Attrs{
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
Weapon('Type99Grenade'):Extends('APGrenadeClass'):Attrs{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[Type 99 Grenade]],
}



-- AT nades
-- RPG-43 AT Nade (RUS)
Weapon('RPG43'):Extends('ATGrenadeClass'):Attrs{
  accuracy           = 400,
  areaOfEffect       = 24,
  name               = [[RPG-43 Anti-Tank Grenade]],
  customparams = {
    armor_penetration  = 75,
  },
  damage = {
    default            = 4896,
  },  
}

-- Model 42 AT Grenade (ITA)
Weapon('BredaMod42'):Extends('ATGrenadeClass'):Attrs{
  areaOfEffect       = 31,
  name               = [[Breda Anti-Tank Grenade]],
  reloadtime         = 9,
  damage = {
    default            = 2780,
  },
    customparams = {
    damagetype         = [[explosive]],
    howitzer	= true,
  },
}

-- L-type heavy AT grenade (ITA)
Weapon('L_type_grenade'):Extends('ATGrenadeClass'):Attrs{
  areaOfEffect       = 33,
  name               = [[Italian Anti-Tank Stickgrenade]],
  reloadtime         = 12, 
  damage = {
    default            = 4080,
  },
    customparams = {
    damagetype         = [[explosive]],
    howitzer	= true,
  },
}

-- Type 3 AT Grenade (JPN)
Weapon('Type3AT'):Extends('ATGrenadeClass'):Attrs{
  accuracy           = 400,
  areaOfEffect       = 24,
  name               = [[Type 3 Anti-Tank Grenade]],
  customparams = {
    armor_penetration  = 75,
  },
  damage = {
    default            = 4896,
  },  
}

-- Smoke nades
-- No. 77 WP (GBR)
Weapon('No77'):Extends('SmokeGrenadeClass'):Attrs{
  accuracy           = 1421,
  name               = [[No. 77 Smoke Grenade]],
}

-- Other nades
Weapon('Molotov'):Extends('GrenadeClass'):Attrs{
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
  },
  damage = {
    default            = 15,
	lightbuildings     = 400,
  },  
}

-- Return only the full weapons
