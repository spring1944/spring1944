local units = {}

local axis = {ger = true, ita = true, jpn = true, hun = true}

-- Model changes have to use lowercase objectname, does not work otherwise!
for _, side in pairs(Sides) do
	units[side .. "pontoonraft"] = PontoonRaft:New{}
	units[side .. "assaultboat"] = AssaultBoat:New{}
	if axis[side] then -- for now make all axis use Ger model and all Allied use US
		units[side .. "pontoonraft"].objectname = "GER/GerPontoonRaft.s3o"
		units[side .. "assaultboat"].objectname = "GER/GerSturmboot.s3o"
	elseif side == "rus" then -- TODO: eventually, unified script and <SIDE>AssaultBoat.s3o
		units[side .. "assaultboat"].objectname = "RUS/RUSPG117.s3o"
		units[side .. "assaultboat"].name = "PG-117"
--		units[side .. "assaultboat"].script = "RUSPG117.cob"
	end
	-- band-aid fix: remove corpses
	units[side .. "pontoonraft"].corpse = nil
	units[side .. "assaultboat"].corpse = nil
end

return lowerkeys(units)