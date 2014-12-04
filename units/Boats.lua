local units = {}

local axis = {ger = true, ita = true, jpn = true}

for _, side in pairs(Sides) do
	units[side .. "pontoonraft"] = PontoonRaft:New{}
	units[side .. "assaultboat"] = AssaultBoat:New{}
	if axis[side] then -- for now make all axis use Ger model and all Allied use US
		units[side .. "pontoonraft"].objectName = "GER/GerPontoonRaft.s3o"
		units[side .. "assaultboat"].objectName = "GER/GerSturmboot.s3o"
	elseif side == "rus" then -- TODO: eventually, unified script and <SIDE>AssaultBoat.s3o
		units[side .. "assaultboat"].objectName = "RUS/RUSPG117.s3o"
		units[side .. "assaultboat"].name = "PG-117"
		units[side .. "assaultboat"].script = "RUSPG117.cob"
	end
end

return lowerkeys(units)