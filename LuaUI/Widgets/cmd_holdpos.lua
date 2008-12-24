function widget:GetInfo()
	return {
		name      = "Hold position v2",
		desc      = "Sets all units without firearcs (and don't fly) to Hold Position by default.\nUnits are returned to Maneuver when disabled.",
		author    = "Gnome",
		date      = "July 2008", --edited sept 15, 2008
		license   = "Public domain",
		layer     = 0,
		enabled   = true
	}
end

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
		elseif ((UnitDefs[udid].weapons[1].maxAngleDif > 0) and (UnitDefs[udid].canFly == false or UnitDefs[udid].canFly == nil)) then
			GiveOrderToUnit(uid, CMD.MOVE_STATE, { 1 }, 0)	--{0} = holdpos, {1} = maneuver, {2} = roam
		else
			GiveOrderToUnit(uid, CMD.MOVE_STATE, { 0 }, 0)
		end
	end
end
