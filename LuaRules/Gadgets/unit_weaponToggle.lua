function gadget:GetInfo()
  return {
    name      = "LUS weapon toggle",
    desc      = "Implements weapon toggles for units with LUS",
    author    = "ashdnazg",
    date      = "21 Jan 2015",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 2,
    enabled   = true  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end




local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local EditUnitCmdDesc = Spring.EditUnitCmdDesc

local toggleDefs = VFS.Include("LuaRules/Configs/toggle_defs.lua")

local toggleCache
local toggleUnits
local unitDefIDToCMDID
local cmdIDToCMDDesc
local cmdIDToStates
local cmdIDToFuncName

local function ProcessToggleData(unitDefID, toggleData)

	local cmdID = GG.CustomCommands.GetCmdID(toggleData.id)
	local cmdDesc = cmdIDToCMDDesc[cmdID]
	if not cmdDesc then

		local params = {0}
		for _, state in pairs(toggleData.states) do
			params[#params + 1] = state.name
		end

		cmdDesc = {
			id 		 = cmdID,
			type   = CMDTYPE.ICON_MODE,
			action = toggleData.action,
			tooltip = toggleData.tooltip,
			params = params,
			queueing = false
		}
		cmdIDToCMDDesc[cmdID] = cmdDesc
		cmdIDToStates[cmdID] = toggleData.states
		cmdIDToFuncName[cmdID] = toggleData.funcName
	end
	unitDefIDToCMDID[unitDefID] = cmdID
end

local function ApplyToggle(unitID, cmdID, newState)
	if not (cmdIDToFuncName[cmdID] and toggleCache[unitID]) then
		return
	end
	local toggleFunc = toggleCache[unitID][cmdIDToFuncName[cmdID]]
	local weaponStateTable = cmdIDToStates[cmdID][newState + 1].toggle
	for weaponNum, isEnabled in pairs(weaponStateTable) do
		Spring.UnitScript.CallAsUnit(unitID, toggleFunc, weaponNum, isEnabled)
	end
	local params = cmdIDToCMDDesc[cmdID].params
	local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
	local updatedCmdParams = {unpack(params)}
	updatedCmdParams[1] = newState
	Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = updatedCmdParams})
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if not cmdIDToStates[cmdID] then
		return
	end
	if unitDefIDToCMDID[unitDefID] == cmdID then
		ApplyToggle(unitID, cmdID, cmdParams[1])
	end
	return true, true
end

function gadget:UnitCreated(unitID, unitDefID)
	if not toggleUnits[unitDefID] then
		return
	end

	local env = Spring.UnitScript.GetScriptEnv(unitID)
	if env then
		toggleCache[unitID] = env
	else
		return
	end
	local cmdID = unitDefIDToCMDID[unitDefID]
	InsertUnitCmdDesc(unitID, cmdIDToCMDDesc[cmdID])
	ApplyToggle(unitID, cmdID, 0)
end

function gadget:Initialize()
	toggleCache = {}
	unitDefIDToCMDID = {}
	cmdIDToCMDDesc = {}
	cmdIDToStates = {}
	toggleUnits = {}
	cmdIDToFuncName = {}
	for unitDefID, unitDef in pairs (UnitDefs) do
		local toggleName = unitDef.customParams.weapontoggle
		if toggleName and toggleName ~= "false" then
			local toggleData = toggleDefs[toggleName]
			toggleUnits[unitDefID] = true
			ProcessToggleData(unitDefID, toggleData)
		end
	end

	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end