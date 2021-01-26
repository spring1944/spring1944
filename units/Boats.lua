local units = {}

local axis = {ger = true, ita = true, jpn = true, hun = true}

-- Model changes have to use lowercase objectname, does not work otherwise!
for _, side in pairs(Sides) do
	if axis[side] then -- for now make all axis use Ger model and all Allied use US
		units[side .. "pontoonraft"] = PontoonRaft:New{
			objectname = "GER/GerPontoonRaft.s3o",
			customParams = {
				normaltex = "unittextures/GERPontoonRaft_normals.png",
			},
		}
		units[side .. "assaultboat"] = AssaultBoat:New{
			objectname = "GER/GerSturmboot.s3o",
			customParams = {
				normaltex = "unittextures/GERSturmboot_normals.png",
			},
		}
	elseif side == "rus" then -- TODO: eventually, unified script and <SIDE>AssaultBoat.s3o
		units[side .. "pontoonraft"] = PontoonRaft:New{}
		units[side .. "assaultboat"] = AssaultBoat:New{
			objectname = "RUS/RUSPG117.s3o",
			name = "PG-117",
			-- script = "RUSPG117.cob",
			customParams = {
				normaltex = "unittextures/RUSPG117a_normals.png",
			},
		}
	else
		units[side .. "pontoonraft"] = PontoonRaft:New{}
		units[side .. "assaultboat"] = AssaultBoat:New{}
	end
	-- band-aid fix: remove corpses
	units[side .. "pontoonraft"].corpse = nil
	units[side .. "assaultboat"].corpse = nil
end

return lowerkeys(units)
