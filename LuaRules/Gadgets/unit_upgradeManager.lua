--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: upgrade_manager.lua
--  brief: Allows upgrading of units
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Upgrade definitions are defined in 'gamedata/LuaConfigs/upgrade_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Unit Upgrader",
		desc      = "Allows upgrading of units",
		author    = "Maelstrom",
		date      = "3rd August 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

	-- Constants

local STALLING = true
local NORMAL = false
local ADD_BAR = "AddBar"
local SET_BAR = "SetBar"
local REMOVE_BAR = "RemoveBar"

	-- Speed Up

local CMD_UPGRADE = 31140 -- 31150
local CMD_MAX_UPGRADES = 10

if (gadgetHandler:IsSyncedCode()) then
	
	
	
	local upgradeDefs = { }
	local upgradeUnits = { }
	
	
	
	local function checkUpgradeDefs(rawUpgradeDefs)
		
		upgrades = { }
		
		for unitDefName, upgrades in pairs(rawUpgradeDefs) do
			
			local udSrc = UnitDefNames[unitDefName]
			local udID = udSrc.id
			upgradeDefs[udID] = { }
			
			upgradeDefs[udID].name = unitDefName
			
			for _, upgrade in ipairs(upgrades) do
				
				local udDst = UnitDefNames[upgrade.into]
				upgrade.udID = udDst.id
				
				if upgrade.time <= 0 then
					upgrade.increment = 1
				else
					upgrade.increment = (1 / (32 * upgrade.time))
				end
				
				upgrade.resTable = {
					m = (upgrade.increment * upgrade.mcost),
					e = (upgrade.increment * upgrade.ecost)
				}
			end
			
			upgradeDefs[udID].upgrades = upgrades
			
		end
		
	end
	
	
	
	function gadget:Initialize()
		
		upgradeDefs = { }
		local rawUpgradeDefs = include("LuaRules/Configs/upgrade_defs.lua")
		checkUpgradeDefs(rawUpgradeDefs)
		
		-- _G.upgradeUnits = upgradeUnits
		
		for i = 1,CMD_MAX_UPGRADES do
			gadgetHandler:RegisterCMDID(CMD_UPGRADE + i)
		end
		
			-- Loops through the units, calling g:UnitFinished() on each of them
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local teamID = Spring.GetUnitTeam(unitID)
			local unitDefID = Spring.GetUnitDefID(unitID)
			gadget:UnitCreated(unitID, unitDefID, teamID)
		end
		
	end
	
	
	
	local function GetUpgradeToolTip(unitID, upgradeDef)
		local ud = UnitDefs[upgradeDef.udID]
		local tt = ''
		tt =       upgradeDef.name .. ' - ' .. upgradeDef.desc .. '\n'
		--tt = tt .. 'Energy cost ' .. upgradeDef.ecost .. '\n'
		tt = tt .. 'Command cost ' .. upgradeDef.mcost .. '\n'
		tt = tt .. 'Build time ' .. upgradeDef.time .. '\n'
		
		return tt
	end
	
	
	
	function gadget:UnitCreated(unitID, unitDefID, teamID)
		
		local upgradeCmdDesc = {
			id     = CMD_UPGRADE,
			type   = CMDTYPE.ICON,
			name   = 'Upgrade',
			cursor = 'Upgrade',  -- add with LuaUI?
			action = 'upgrade',
		}
		
		if upgradeDefs[unitDefID] then
			for i, upgrade in ipairs(upgradeDefs[unitDefID].upgrades) do
				
				upgradeCmdDesc.id = CMD_UPGRADE + i - 1
				if upgrade.buttonname then
					upgradeCmdDesc.name = upgrade.buttonname
				else
					upgradeCmdDesc.name = "Upgrade " .. i
				end

				if upgrade.buildpic then
					upgradeCmdDesc.texture = "&.9x.9&unitpics/" .. upgrade.buildpic .. "&bitmaps/frame.tga"
				end

				if upgrade.notext == true then
					upgradeCmdDesc.onlyTexture = true
				else
					upgradeCmdDesc.onlyTexture = false
				end

				upgradeCmdDesc.tooltip = GetUpgradeToolTip(unitID, upgrade)
				Spring.InsertUnitCmdDesc(unitID, upgradeCmdDesc)
				
			end
		end
		
	end
	
	
	
	local function StartUpgrade(unitID, unitDefID, cmdNum)
		  local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
			if (buildProgress<1) then
			return false
		end
		if (not upgradeDefs[unitDefID]) then
			return false
		end
		
		if (not upgradeDefs[unitDefID].upgrades[cmdNum]) then
			return false
		end
		
		-- paralyze the unit
		Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })    -- turns mexes and mm off
	
		upgradeUnits[unitID] = {
			def = upgradeDefs[unitDefID].upgrades[cmdNum],
			progress = 0.0,
			increment = upgradeDefs[unitDefID].upgrades[cmdNum].increment,
			state = NORMAL
		}
		
		if upgradeUnits[unitID].def.onStart ~= nil then
			upgradeUnits[unitID].def.onStart(unitID)
		end
		
	end
	
	
	
	local function FinishUpgrade(unitID, upgradeData)
		local udSrc = UnitDefs[Spring.GetUnitDefID(unitID)]
		local udDst = UnitDefs[upgradeData.def.udID]
		
			-- Cleaning up from the old unit
		Spring.SetUnitBlocking(unitID, false)
		upgradeUnits[unitID] = nil
		
		
			-- Creating the new unit
		local px, py, pz = Spring.GetUnitBasePosition(unitID)
		local heading = Spring.GetUnitBuildFacing(unitID)

		local newUnit = Spring.CreateUnit(udDst.name, px, py, pz, heading, Spring.GetUnitTeam(unitID))
		
	
			-- Copy some settings
			-- Rotation
		if(udSrc.speed > 0) then
			local rot = Spring.GetUnitHeading(unitID)
			Spring.SetUnitRotation(newUnit, 0, -rot * math.pi / 32768, 0)
		end
			-- Experience
		Spring.SetUnitExperience(newUnit, Spring.GetUnitExperience(unitID))
			-- Command queue
		local cmds = Spring.GetUnitCommands(unitID)
		for i = 2, cmds.n do  -- skip the first command (CMD_UPGRADE)
			local cmd = cmds[i]
			Spring.GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
		end
			-- Command States
		local states = Spring.GetUnitStates(unitID)
		Spring.GiveOrderArrayToUnitArray({ newUnit }, {
			{ CMD.FIRE_STATE, { states.firestate },             {} },
			{ CMD.MOVE_STATE, { states.movestate },             {} },
			{ CMD.REPEAT,     { states['repeat']  and 1 or 0 }, {} },
			{ CMD.CLOAK,      { states.cloak      and 1 or 0 }, {} },
			{ CMD.ONOFF,      { 1 },			    {} },
			{ CMD.TRAJECTORY, { states.trajectory and 1 or 0 }, {} },
		})
			--Health
		local oldHealth = Spring.GetUnitHealth(unitID)
		local newHealth = oldHealth * (udDst.health / udSrc.health)
		Spring.SetUnitHealth(newUnit, newHealth)

		Spring.SetUnitRulesParam(unitID, "upgradeProgress", 0)
		
		if upgradeData.def.onUpgrade then
			upgradeData.def.onUpgrade(unitID, newUnit, upgradeData)
		end
 
 
		Spring.DestroyUnit(unitID, false, true, unitID) -- selfd = false, reclaim = true
	end
	
	
	
	local function StepUpgrade(unitID, upgradeData)
		
		if (Spring.UseUnitResource(unitID, upgradeData.def.resTable)) then
			upgradeData.progress = upgradeData.progress + upgradeData.increment
			if upgradeData.state ~= NORMAL then
				if upgradeData.def.onStart ~= nil then
					upgradeData.def.onStart(unitID)
				end
				upgradeData.state = NORMAL
			end
		else
			if upgradeData.state ~= STALLING then
				if upgradeData.def.onStall ~= nil then
					upgradeData.def.onStall(unitID)
				end
				upgradeData.state = STALLING
			end
		end

		Spring.SetUnitRulesParam(unitID, "upgradeProgress", upgradeData.progress)
		
		if (upgradeData.progress >= 1.0) then
			FinishUpgrade(unitID, upgradeData)
			return false -- remove from the list, all done
		end
		return true
		
		
	end
	
	
	
	local function StopUpgrade(unitID)
		if upgradeUnits[unitID] then
			if upgradeUnits[unitID].def.onStop ~= nil then
				upgradeUnits[unitID].def.onStop(unitID)
			end
			Spring.SetUnitHealth(unitID, { paralyze = -1 })
			
			local upgradeData = upgradeUnits[unitID]
			local progress = upgradeData.progress / upgradeData.increment
			Spring.AddUnitResource(unitID, "m", upgradeData.def.resTable.m * progress)
			Spring.AddUnitResource(unitID, "e", upgradeData.def.resTable.e * progress)
			
			upgradeUnits[unitID] = nil

			Spring.SetUnitRulesParam(unitID, "upgradeProgress", 0)
			
		end
	end
	
	
	
	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		
		if upgradeUnits[unitID] then
			
			if (cmdID >= CMD_UPGRADE and cmdID <= CMD_UPGRADE + CMD_MAX_UPGRADES) then
				return false  -- command was not used
			end
			if cmdID == CMD.STOP then
				StopUpgrade(unitID, upgradeUnits[unitID])
				return true
			end
			return false
			
		else
			
			if (cmdID >= CMD_UPGRADE and cmdID <= CMD_UPGRADE + CMD_MAX_UPGRADES) then
				StartUpgrade(unitID, unitDefID, cmdID - CMD_UPGRADE + 1)
			end
			return true  -- command was not used
			
		end
		
	end
	
	
	
	function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		if (cmdID < CMD_UPGRADE or cmdID > CMD_UPGRADE + CMD_MAX_UPGRADES) then
			return false  -- command was not used
		end
		StartUpgrade(unitID, unitDefID, cmdID - CMD_UPGRADE + 1)
		return true, true  -- command was used, remove it
	end



	function gadget:GameFrame(n)

		if (next(upgradeUnits) == nil) then
			return  -- no upgradinging units
		end

		local killUnits = {}
		for unitID, upgradeData in pairs(upgradeUnits) do
			if (not StepUpgrade(unitID, upgradeData)) then
				killUnits[unitID] = true
			end
		end

		for unitID in pairs(killUnits) do
			upgradeUnits[unitID] = nil
		end

	end



	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
		StopUpgrade(unitID)
	end
end

