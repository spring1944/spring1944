-- Artillery - Auto Cannon (Light AA Guns)
-- Implementations

-- FlaK 38 20mm (GER)
Weapon('FlaK3820mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 255,
  burst              = 4, -- 20 round box mag, 5 bursts
  burstRate          = 0.133, -- cyclic 450rpm
  reloadTime         = 1.3, -- 180rpm practical
  name               = [[2cm FlaK 38]],
  range              = 730,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 1800,
  damage = {
    default            = 110,
  },
  customparams = {
    weaponcost = 1,
  },
}

Weapon('FlaK3820mmAA'):Extends('AutoCannonAA'):Extends('FlaK3820mm'):Attrs{ -- name append
  range              = 1910,
}
Weapon('FlaK3820mmHE'):Extends('AutoCannonHE'):Extends('FlaK3820mm') -- name append
Weapon('FlaK3820mmAP'):Extends('AutoCannonAP'):Extends('FlaK3820mm'):Attrs{ -- name append
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 9,
    armor_penetration_100m  = 20,
  },
  damage = {
    default            = 385,
  },
}

-- Flakvierling
-- derives from the above, only with 4x burst (can't have 1/4 the burstrate)
Weapon('FlakVierling20mmAA'):Extends('FlaK3820mmAA'):Attrs{ -- name append
  burst              = 16,
  name               = [[(Quad)]],
}
Weapon('FlakVierling20mmHE'):Extends('FlaK3820mmHE'):Attrs { -- name append
  burst              = 16,
  name               = [[(Quad)]],
}

-- Oerlikon/Polsten 20mm (GBR)
Weapon('Oerlikon20mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 255,
  burst              = 5, -- 15 or 30 round drum
  burstRate          = 0.133, -- cyclic 450rpm
  reloadTime         = 1.2, -- practical 250 rpm
  name               = [[20mm Oerlikon]],
  range              = 750,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 475,
  weaponVelocity     = 1640,
  damage = {
    default            = 110, -- copy from FlaK / TNSh
  },
  customparams = {
    weaponcost = 1,
  },
}

Weapon('Oerlikon20mmAA'):Extends('AutoCannonAA'):Extends('Oerlikon20mm'):Attrs{ -- name append
  range              = 1950,
}
Weapon('Oerlikon20mmHE'):Extends('AutoCannonHE'):Extends('Oerlikon20mm') -- name append
Weapon('Twin_Oerlikon20mmAA'):Extends('Oerlikon20mmAA'):Attrs{ -- name append
  name               = [[(Twin)]],
  reloadTime         = 0.6,
}

-- TNSh 20mm (RUS)
Weapon('TNSh20mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 300,
  burst              = 3,
  burstRate          = 0.1,
  name               = [[20mm TNSh]],
  range              = 675,
  reloadTime         = 4.5,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 444,
  weaponVelocity     = 1600,
  damage = {
    default            = 110,
  },
}

Weapon('TNSh20mmHE'):Extends('AutoCannonHE'):Extends('TNSh20mm') -- name append
Weapon('TNSh20mmAP'):Extends('AutoCannonAP'):Extends('TNSh20mm'):Attrs{ -- name append
  weaponVelocity     = 1500,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m  = 35,
  },
  damage = {
    default            = 310,
  },
}

-- Breda M35 20mm (ITA)
Weapon('BredaM3520mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 100, --Why not 255 like the rest?
  burst              = 4,
  burstRate          = 0.261,
  name               = [[Breda Model 35]],
  range              = 730,
  reloadTime         = 1.6,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 300,
  weaponVelocity     = 2000,
  damage = {
    default            = 41,
  },
  customparams = {
    weaponcost = 1,
  },
}

Weapon('BredaM3520mmAA'):Extends('AutoCannonAA'):Extends('BredaM3520mm'):Attrs{ -- name append
  range              = 1950,
  sprayAngle         = 475,
}

Weapon('TwinBredaM3520mmAA'):Extends('BredaM3520mmAA'):Attrs{
  burst              = 8,
  burstRate          = 0.13,
}

Weapon('BredaM3520mmHE'):Extends('AutoCannonHE'):Extends('BredaM3520mm'):Attrs{ -- name append
  customparams = {
    fearaoe            = 30,
  },
}

Weapon('BredaM3520mmAP'):Extends('AutoCannonAP'):Extends('BredaM3520mm'):Attrs{ -- name append
  sprayAngle         = 400,
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 6,
    armor_penetration_100m  = 29,
  },
  damage = {
    default            = 345,
  },
}

-- Type 98 20mm (JPN)
Weapon('Type9820mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 255,
  areaOfEffect       = 15,
  burst              = 4,
  burstRate          = 0.2,
  name               = [[Type 98 20mm]],
  range              = 730,
  reloadTime         = 2,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 52,
  },
}

Weapon('Type9820mmAA'):Extends('AutoCannonAA'):Extends('Type9820mm'):Attrs{ -- name append
  range              = 1950,
}

Weapon('Type9820mmHE'):Extends('AutoCannonHE'):Extends('Type9820mm') -- name append

-- Type 96 25mm (JPN)
Weapon('Type9625mm'):Extends('AutoCannon'):Attrs{
  accuracy           = 255,
  areaOfEffect       = 15, --if this is changed, change AA and HE aoe and fearaoe accordingly
  burst              = 5,
  burstRate          = 0.231,
  name               = [[Type 98 20mm]],
  range              = 780,
  reloadTime         = 2.7,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 45,
  },
  customparams = {
    weaponcost = 1,
  },
}

Weapon('Type9625mmAA'):Extends('AutoCannonAA'):Extends('Type9625mm'):Attrs{ -- name append
  range              = 1950,
  damage = {
    default            = 55,
  },
}

Weapon('TwinType9625mmAA'):Extends('Type9625mmAA'):Attrs{
	burst            = 36,
	burstrate        = 0.12,
    reloadtime       = 6.5,
}

Weapon('Type9625mmHE'):Extends('AutoCannonHE'):Extends('Type9625mm') -- name append

Weapon('TwinType9625mmHE'):Extends('Type9625mmHE'):Attrs{
	burst            = 36,
	burstrate        = 0.12,
    reloadtime       = 6.5,
}


-- Return only the full weapons
