local units = {}

local axis = {ger = true, ita = true, jpn = true}

for _, side in pairs(Sides) do
	units[side .. "pontoonraft"] = PontoonRaft:New{}
	if axis[side] then -- for now make all axis use Ger model and all Allied use US
		units[side .. "pontoonraft"].objectName = "GER/GerPontoonRaft.s3o"
	end
end

return lowerkeys(units)