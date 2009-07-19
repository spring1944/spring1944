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

	rusvehicleyard = {
		{
			into = 'rusvehicleyard1',
			mcost = 2000,
			ecost = 0,
			time = 65,
			buttonname = 'Upg: L. Armor',
			name = 'Upgrade: Light Armor',
			desc = 'Makes Light Armor available in this yard',
			notext = true,
			buildpic = 'ruslightarmorupg.png',
		},
	},
	
	usvehicleyard = {
		{
			into = 'usvehicleyard1',
			mcost = 2000,
			ecost = 0,
			time = 65,
			buttonname = 'Upg: L. Armor',
			name = 'Upgrade: Light Armor',
			desc = 'Makes Light Armor available in this yard',
			notext = true,
			buildpic = 'uslightarmorupg.png',
		},
	},
	
	gervehicleyard = {
		{
			into = 'gervehicleyard1',
			mcost = 2000,
			ecost = 0,
			time = 65,
			buttonname = 'Upg: L. Armor',
			name = 'Upgrade: Light Armor',
			desc = 'Makes Light Armor available in this yard',
			notext = true,
			buildpic = 'gerlightarmorupg.png',
		},
	},
	
	gbrvehicleyard = {
		{
			into = 'gbrvehicleyard1',
			mcost = 2000,
			ecost = 0,
			time = 65,
			buttonname = 'Upg: L. Armor',
			name = 'Upgrade: Light Armor',
			desc = 'Makes Light Armor available in this yard',
			notext = true,
			buildpic = 'gbrlightarmorupg.png',
		},
	},
	
	rusgunyard = {
		{
			into = 'russpyard',
			mcost = 3500,
			ecost = 0,
			time = 100,
			buttonname = 'Upg: SP Guns',
			name = 'Upgrade: Self Prop. Guns',
			desc = 'Makes Self-Propelled Artillery available in this yard',
			notext = true,
			buildpic = 'russpupg.png',
		},
		{
			into = 'russpyard1',
			mcost = 4500,
			ecost = 0,
			time = 130,
			buttonname = 'Upg: TD',
			name = 'Upgrade: Tank Destroyers',
			desc = 'Makes Tank Destroyers available in this yard',
			notext = true,
			buildpic = 'rustdupg.png',
		},
	},
	
	usgunyard = {
		{
			into = 'usspyard',
			mcost = 3000,
			ecost = 0,
			time = 85,
			buttonname = 'Upg: SP Guns',
			name = 'Upgrade: Self Prop. Guns',
			desc = 'Makes Self-Propelled Artillery available in this yard',
			notext = true,
			buildpic = 'usspupg.png',
		},
	},
	
	gergunyard = {
		{
			into = 'gerspyard',
			mcost = 3000,
			ecost = 0,
			time = 85,
			buttonname = 'Upg: SP Guns',
			name = 'Upgrade: Self Prop. Guns',
			desc = 'Makes Self-Propelled Artillery available in this yard',
			notext = true,
			buildpic = 'gerspupg.png',
		},
		{
			into = 'gerspyard1',
			mcost = 4500,
			ecost = 0,
			time = 130,
			buttonname = 'Upg: TD',
			name = 'Upgrade: Tank Destroyers',
			desc = 'Makes Tank Destroyers available in this yard',
			notext = true,
			buildpic = 'gertdupg.png',
		},
	},	
	
	gbrgunyard = {
		{
			into = 'gbrspyard',
			mcost = 3000,
			ecost = 0,
			time = 85,
			buttonname = 'Upg: SP Guns',
			name = 'Upgrade: Self Prop. Guns',
			desc = 'Makes Self-Propelled Artillery available in this yard',
			notext = true,
			buildpic = 'gbrspupg.png',
		},
		{
			into = 'gbrspyard1',
			mcost = 4500,
			ecost = 0,
			time = 130,
			buttonname = 'Upg: TD',
			name = 'Upgrade: Tank Destroyers',
			desc = 'Makes Tank Destroyers available in this yard',
			notext = true,
			buildpic = 'gbrtdupg.png',
		},
	},	
	
	rustankyard = {
		{
			into = 'rustankyard1',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Adv. Med',
			name = 'Upgrade: Advanced Mediums',
			desc = 'Makes Advanced Medium Armor available in this yard',
			notext = true,
			buildpic = 'rusadvmedarmorupg.png',
		},
		{
			into = 'rustankyard2',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Heavy',
			name = 'Upgrade: Heavy Armor',
			desc = 'Makes Heavy Armor available in this yard',
			notext = true,
			buildpic = 'rusheavyarmorupg.png',
		},
	},
	
	ustankyard = {
		{
			into = 'ustankyard1',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Adv. Med',
			name = 'Upgrade: Advanced Mediums',
			desc = 'Makes Advanced Medium Armor available in this yard',
			notext = true,
			buildpic = 'usadvmedarmorupg.png',
		},
		{
			into = 'ustankyard2',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Heavy',
			name = 'Upgrade: Heavy Armor',
			desc = 'Makes Heavy Armor available in this yard',
			notext = true,
			buildpic = 'usheavyarmorupg.png',
		},
	},
	
	gertankyard = {
		{
			into = 'gertankyard1',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Adv. Med',
			name = 'Upgrade: Advanced Mediums',
			desc = 'Makes Advanced Medium Armor available in this yard',
			notext = true,
			buildpic = 'geradvmedarmorupg.png',
		},

		{
			into = 'gertankyard2',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Heavy',
			name = 'Upgrade: Heavy Armor',
			desc = 'Makes Heavy Armor available in this yard',
			notext = true,
			buildpic = 'gerheavyarmorupg.png',
		},
	},
	
	gbrtankyard = {
		{
			into = 'gbrtankyard1',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Adv. Med',
			name = 'Upgrade: Advanced Mediums',
			desc = 'Makes Advanced Medium Armor available in this yard',
			notext = true,
			buildpic = 'gbradvmedarmorupg.png',
		},
	
		{
			into = 'gbrtankyard2',
			mcost = 4500,
			ecost = 0,
			time = 60,
			buttonname = 'Upg: Heavy',
			name = 'Upgrade: Heavy Armor',
			desc = 'Makes Heavy Armor available in this yard',
			notext = true,
			buildpic = 'gbrheavyarmorupg.png',
		},
	},
	gbrboatyard = {
		{
			into = 'gbrboatyardlarge',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upg: Large BY',
			name = 'Upgrade: Large Boatyard',
			desc = 'Makes larger ships available',
			notext = true,
			buildpic = 'gbrboatyard.png',
		},
	},
	
	gerboatyard = {
		{
			into = 'gerboatyardlarge',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upg: Large BY',
			name = 'Upgrade: Large Boatyard',
			desc = 'Makes larger ships available',
			notext = true,
			buildpic = 'gerboatyard.png',
		},
	},
	
	rusboatyard = {
		{
			into = 'rusboatyardlarge',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upg: Large BY',
			name = 'Upgrade: Large Boatyard',
			desc = 'Makes larger ships available',
			notext = true,
			buildpic = 'rusboatyard.png',
		},
	},
	
	usboatyard = {
		{
			into = 'usboatyardlarge',
			mcost = 3000,
			ecost = 0,
			time = 30,
			buttonname = 'Upg: Large BY',
			name = 'Upgrade: Large Boatyard',
			desc = 'Makes larger ships available',
			notext = true,
			buildpic = 'usboatyard.png',
		},
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