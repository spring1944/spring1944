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
	end
end

return tmpReturn