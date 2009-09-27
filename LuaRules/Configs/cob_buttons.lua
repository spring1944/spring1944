-- $Id: cob_buttons.lua 3171 2008-11-06 09:06:29Z det $
local tmpReturn = {
	ruscommissar = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	ruscommander = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	
	rusengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},

	gbrengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	
	gbrhqengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	
	gerengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	
	gerhqengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	
	usengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},

	ushqengineer = {
	{
		cob = "LookForMines",
		name = "Clear Mines",
		tooltip = "Search for mines"},
	},
	gbr25pdr_stationary = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},
	gerlefh18_stationary = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},
	rusm30_stationary = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},	
	usm2gun_stationary = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},
	gbr3inmortar = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},	
	gergrw34 = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},	
	rusmortar = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},
	
	usm1mortar = {
		{
			cob = "SwitchToSmoke",
			name = "Smoke",
			tooltip = "Switch to smoke shells"
		},
		{
			cob = "SwitchToHE",
			name = "HE",
			tooltip = "Switch to HE shells"
		},
	},
	gerkarl = {
	{
		cob = "TriggerDeploy",
		name = "Deploy",
		tooltip = "Prepare the gun for firing or moving"},
	},
}

-- process things caused by customparams tags
for _, tmpUnitDef in pairs(UnitDefs) do
	if (tmpUnitDef.customParams) then
		local tmpParams = tmpUnitDef.customParams
		-- Turn button
		if (tmpParams.hasturnbutton) then
			local tmpCmd = {
				cob = "RotateHere",
				name = "Turn",
				tooltip = "Turn to face a given point",
				requiresdirection = "1",
				type = CMDTYPE.ICON_MAP,
				cursor = "Patrol",
			}
			if (tmpReturn[tmpUnitDef.name]) then
				table.insert(tmpReturn[tmpUnitDef.name], tmpCmd)
			else
				tmpReturn[tmpUnitDef.name] ={
					tmpCmd,
				}
			end
		end
		-- other things to come later
	end
end

return tmpReturn