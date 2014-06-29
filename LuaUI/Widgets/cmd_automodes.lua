function widget:GetInfo()
	return {
		name      = "Automatic Modes", -- Based on Hold position v2 by Gnome
		desc      = "Sets relevant units to hold position and/or hold fire",
		author    = "ashdnazg",
		date      = "June 2014",
		license   = "Public domain",
		layer     = 0,
		enabled   = true
	}
end


--[[

 IMPLEMENTED SOMETHING NEW? GREAT! ADD IT HERE:
 
 1) Sets all units without firearcs (and don't fly) to Hold Position by default.
    Units are returned to Maneuver when disabled. 
 2) Sets Howitzers to hold fire.
 
]]--


local howitzerDefIDs = {}

local GiveOrderToUnit = Spring.GiveOrderToUnit

function widget:GameFrame(n)
	if(n == 1) then
		for _, uid in ipairs(Spring.GetTeamUnits(Spring.GetLocalTeamID())) do
			local udid = Spring.GetUnitDefID(uid)
			local tid = Spring.GetUnitTeam(uid)
			widget:UnitCreated(uid, udid, tid)
		end
		widgetHandler:RemoveCallIn("GameFrame")
	end
end

local function ResetToManeuver(uid)
	Spring.GiveOrderToUnit(uid, CMD.MOVE_STATE, { 1 }, 0)
end

function widget:Initialize()

    for unitDefID, unitDef in pairs(UnitDefs) do
        local weapon = unitDef.weapons[1]
        if weapon then
            local cp = WeaponDefs[weapon.weaponDef].customParams
            if cp and cp.howitzer then -- and weapon.customparams.howitzer then
                howitzerDefIDs[unitDefID] = true
            end
        end
    end

	for _, uid in ipairs(Spring.GetTeamUnits(Spring.GetLocalTeamID())) do
		local udid = Spring.GetUnitDefID(uid)
		local tid = Spring.GetUnitTeam(uid)
		widget:UnitCreated(uid, udid, tid)
	end
    
	Spring.SendMessageToPlayer(Spring.GetLocalPlayerID(),"All units set to Hold Position")
    
end

function widget:Shutdown()
	for _, uid in ipairs(Spring.GetTeamUnits(Spring.GetLocalTeamID())) do
		ResetToManeuver(uid)
	end
	Spring.SendMessageToPlayer(Spring.GetLocalPlayerID(),"All units set to Maneuver")
end

function widget:UnitCreated(uid, udid, tid)
	if (UnitDefs[udid].weapons[1] ~= nil) then
		if(UnitDefs[udid].canFly == true) then			--aircraft don't attack ground properly in hold pos, they need to be ignored
			GiveOrderToUnit(uid, CMD.MOVE_STATE, { 1 }, 0)	--{0} = holdpos, {1} = maneuver, {2} = roam
		else
			GiveOrderToUnit(uid, CMD.MOVE_STATE, { 0 }, 0)
		end
	end
    
    if howitzerDefIDs[udid] then
        GiveOrderToUnit(uid, CMD.FIRE_STATE, { 0 }, 0)
    end
    
end
