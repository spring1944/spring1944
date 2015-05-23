local armorDefs = {}

-- grab armordefs out of ud.customParams.damageGroup
local DEFS = _G.DEFS
for unitName, unitDef in pairs(DEFS.unitDefs) do
	local cp = unitDef.customparams
	if cp and cp.damagegroup ~= nil then
		local damageGroup = string.lower(cp.damagegroup)
		if armorDefs[damageGroup] == nil then
			armorDefs[damageGroup] = {}
		end
		table.insert(armorDefs[damageGroup], unitName)
    else
        Spring.Echo("WARNING: " .. unitName .. " has no damageGroup defined!")
    end
end

local system = VFS.Include('gamedata/system.lua')

return system.lowerkeys(armorDefs)
