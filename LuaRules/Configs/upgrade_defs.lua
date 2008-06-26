--[[

Syntax is like this:
local upgradeDefs = {
	unitname = <upgrades>,
	unitname = <upgrades>,
	...
	unitname = <upgrades>
}
<upgrades>
	{
		<upgrade option 1>, -- first upgrade option
		<upgrade option 2>, -- second upgrade option
		...
		<upgrade option n>  -- nth upgrade option
	}

<upgrade options>
		{
			into  = 'unitname', -- what it upgrades into, case sensitive
			mcost = ###,        -- metal cost of upgrading. Optional, defaults to 0
			ecost = ###,        -- energy cost of upgrading. Optional, defaults to 0
			time  = ###,        -- seconds taken to upgrade. Optional, defaults to 0
			
				-- runs a function upon defined event. Optional, defaults to nothing
				-- run when a unit finishes upgrading
			onUpgrade = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when a unit starts upgrading, or stops stalling
			onStart   = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when the Stop command is sent if upgrading
			onStop    = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when a unit starts stalling (ie. no resources)
			onStall   = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
		}



  Note: All unitnames are case sensitive!
]]--



local upgradeDefs = {
	rustankyard = {
		{
			into = 'rustankyard1',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upgrade',
		},
	},
	ustankyard = {
		{
			into = 'ustankyard1',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upgrade',
		},
	},
	gertankyard = {
		{
			into = 'gertankyard1',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upgrade',
		},
	},
	gertankyard1 = {
		{
			into = 'gertankyard2',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upgrade',
		}
	},
	gbrtankyard = {
		{
			into = 'gbrtankyard1',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upgrade',
		}
	},
}


-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

for _, upgrades in pairs(upgradeDefs) do
	for _, upgrade in ipairs(upgrades) do
		if (upgrade.mcost == nil) then upgrade.mcost = 0 end
		if (upgrade.ecost == nil) then upgrade.ecost = 0 end
		if (upgrade.time == nil)  then upgrade.time  = 0 end
	end
end

return upgradeDefs