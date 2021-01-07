--[[

Syntax:

local squadDefs = {
	["squad_spawner"] = {
		"squad_member_1",
		"squad_member_2",
		"squad_member_3",
		...
		"squad_member_n",
	},
	... -- more squad spawners
}

where:

  squad_spawner is the unitname of the unit that spawns the
squad upon completion. This unit can be build from a factory, 
builder, spawned by Lua, anything. When it is created, it will
spawn the units specified in its squad_member array

  squad_member_n is the unit name of one of unit to spawn in
the squad. There can be as many squad_members as needed. All 
members of the squad will receive the orders assigned to the 
spawner unit. Thus, whole squads can be ordered around from
in a factory, like a normal unit would be.

]]--

local squadDefs = VFS.Include("luarules/configs/squad_defs_loader.lua")

-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

if UnitDefNames then
    local squadDefIDs = { }

    for i, squad in pairs(squadDefs) do
        local unitDef = UnitDefNames[i]
        if unitDef ~= nil then
            squadDefIDs[unitDef.id] = squad
        else
            Spring.Log('squad defs', 'error', "  Bad unitName! " .. i)
        end
    end

    for i, squad in pairs(squadDefIDs) do
        squadDefs[i] = squad
    end
end

return squadDefs
