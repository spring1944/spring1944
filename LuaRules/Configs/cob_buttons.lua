-- $Id: cob_buttons.lua 3171 2008-11-06 09:06:29Z det $
local tmpReturn = {
	gerkarl = {
	{
		cob = "TriggerDeploy",
		name = "Deploy",
		tooltip = "Prepare the gun for firing or moving"},
	},
	ruspartisanrifle = {
	{
		cob = "SetAmbush",
		name = "Ambush",
		tooltip = "Prepare for ambush",},
	{
		cob = "CancelAmbush",
		name = "Cancel Ambush",
		tooltip = "Cancel Ambush",},
	}
}

-- process things caused by customparams tags
for _, tmpUnitDef in pairs(UnitDefs) do
	if (tmpUnitDef.customParams) then
		local tmpParams = tmpUnitDef.customParams
		-- Turn button
		if (tmpParams.hasturnbutton) then
			-- determine unit's turn speed
			local turnSpeed = tmpUnitDef.turnRate or 5*182
			local tmpCmd = {
				cob = "RotateHere",
				name = "Turn",
				tooltip = "Turn to face a given point",
				requiresdirection = "1",
				type = CMDTYPE.ICON_MAP,
				cursor = "Patrol",
				precob = "SetTurnSpeed",
				precobparam = turnSpeed,
			}
			if (tmpReturn[tmpUnitDef.name]) then
				table.insert(tmpReturn[tmpUnitDef.name], tmpCmd)
			else
				tmpReturn[tmpUnitDef.name] ={
					tmpCmd,
				}
			end
		end
		if (tmpParams.canclearmines) then
			local tmpCmd = {
				cob = "LookForMines",
				name = "Clear Mines",
				tooltip = "Search for mines",
			}
			if (tmpReturn[tmpUnitDef.name]) then
				table.insert(tmpReturn[tmpUnitDef.name], tmpCmd)
			else
				tmpReturn[tmpUnitDef.name] ={
					tmpCmd,
				}
			end
		end
		if (tmpParams.canfiresmoke) then
			-- add Smoke button
			local tmpCmd = {
				cob = "SwitchToSmoke",
				name = "Smoke",
				tooltip = "Switch to smoke shells"
			}
			if (tmpReturn[tmpUnitDef.name]) then
				table.insert(tmpReturn[tmpUnitDef.name], tmpCmd)
			else
				tmpReturn[tmpUnitDef.name] ={
					tmpCmd,
				}
			end
			-- add HE button
			tmpCmd = {
				cob = "SwitchToHE",
				name = "HE",
				tooltip = "Switch to HE shells"
			}
			-- no need to check for existing cmddescs since we just added one
			table.insert(tmpReturn[tmpUnitDef.name], tmpCmd)
		end
		-- other things to come later
	end
end

return tmpReturn