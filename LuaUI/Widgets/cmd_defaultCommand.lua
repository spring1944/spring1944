function widget:GetInfo()
	return {
		name = "1944 defaultCommand",
		desc = "Gives combat units Fight command as default",
		author = "KDR_11k (David Becker), Craig Lawrence",
		date = "2008-06-24",
		license = "None",
		layer = 1,
		enabled = true
	}
end

local CMD_FIGHT = CMD.FIGHT
local CMD_ATTACK = CMD.ATTACK
local CMD_AREA_ATTACK = 39954 -- as set in areaattack.lua gadget
local defCom = {}

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if (not defCom[unitDefID]) then
		local ud = UnitDefs[unitDefID]
		if (ud.speed > 0 and ud.canAttack and not ud.customParams.defaultmove) then
			defCom[unitDefID] = CMD_FIGHT
		elseif (ud.speed == 0 and ud.customParams.canareaattack) then
				defCom[unitDefID] = CMD_AREA_ATTACK
		end
	end
end

--[[function widget:Initialize()
	WG.activeCommand=0 -- needed??
end]]

function widget:DefaultCommand()
	local type = false
	for _,u in ipairs(Spring.GetSelectedUnits()) do
		if defCom[Spring.GetUnitDefID(u)] and type == false then
			type=defCom[Spring.GetUnitDefID(u)]
		elseif type ~= defCom[Spring.GetUnitDefID(u)] then
			type=nil
		end
	end
	return type
end
