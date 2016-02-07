local axis = {ger = true, ita = true, jpn = true}

for _, side in pairs(Sides) do
	if axis[side] then -- for now make all axis use Ger model and all Allied use US
		Unit(side..'PontoonRaft'):Extends('PontoonRaft'):Attrs{
			objectName	= 'GER/GerPontoonRaft.s3o'
		}
		Unit(side..'AssaultBoat'):Extends('AssaultBoat'):Attrs{
			objectName	= "GER/GerSturmboot.s3o"
		}

	elseif side == "rus" then -- TODO: eventually, unified script and <SIDE>AssaultBoat.s3o
		Unit(side..'PontoonRaft'):Extends('PontoonRaft')
		Unit(side..'AssaultBoat'):Extends('AssaultBoat'):Attrs{
			name		= "PG-117",
			objectName	= "RUS/RUSPG117.s3o",
			script		= "RUSPG117.cob"
		}
	else
		Unit(side..'PontoonRaft'):Extends('PontoonRaft')
		Unit(side..'AssaultBoat'):Extends('AssaultBoat')
	end
end
