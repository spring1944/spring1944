function widget:GetInfo()
	return {
		name	  = "Targeting debugger",
		desc	  = "debugs targeting",
		author	  = "ashdnazg",
		date	  = "29 May 2015",
		license	  = "GPL v2 or later",
		layer	  = 0,
		enabled	  = false
	}
end


function widget:GameFrame(n)
	local selectedUnit = Spring.GetSelectedUnits()[1]
	if not selectedUnit then
		return
	end
	
	local queue = Spring.GetUnitCommands(selectedUnit, 1)
	local targetID
	if queue and queue[1] and queue[1].id == CMD.ATTACK then
		if #queue[1].params == 1 then
			targetID = queue[1].params[1]
		end
	end
	if not targetID then
		return
	end
	
	if selectedUnit then
		local try = Spring.GetUnitWeaponTryTarget(selectedUnit, 1, targetID)
		local test = Spring.GetUnitWeaponTestTarget(selectedUnit, 1, targetID)
		local range = Spring.GetUnitWeaponTestRange(selectedUnit, 1, targetID)
		local lof = Spring.GetUnitWeaponHaveFreeLineOfFire(selectedUnit, 1, targetID)
		Spring.Echo("Try:", try, "Test:", test, "Range:", range, "LoF", lof)
	end
end
