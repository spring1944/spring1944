function gadget:GetInfo()
	return {
		name      = "UnitFortify",
		desc      = "Allows unit entrenching",
		author    = "yuritch (based on morph gadget by many others)",
		date      = "Nov, 2014",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then

local fortifyingUnits = {}
local fortifyDestinations = {}
local fortifyDefs = {}

local CMD_FORTIFY = GG.CustomCommands.GetCmdID("CMD_FORTIFY")
local CMD_FORTIFY_STOP = GG.CustomCommands.GetCmdID("CMD_FORTIFY_STOP")

local SetUnitBlocking = Spring.SetUnitBlocking
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitHeading = Spring.GetUnitHeading
local CreateUnit = Spring.CreateUnit
local GetUnitTeam = Spring.GetUnitTeam
local EnableMoveCtrl = Spring.MoveCtrl.Enable
local DisableMoveCtrl = Spring.MoveCtrl.Disable
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local SetUnitRotation = Spring.SetUnitRotation
local SetUnitPosition = Spring.SetUnitPosition
local GetUnitTransporter = Spring.GetUnitTransporter

include("LuaRules/colors.h.lua")

local fortifyCmdDesc = {
	id = CMD_FORTIFY,
	type = CMDTYPE.ICON,
	name = 'Fortify',
	tooltip = 'Fortify unit so becomes more resistant to damage',
	cursor = 'Fight',
	action = 'fortify',
	hidden = false,
	disabled = false,
}

local function HeadingToFacing(heading)
	return ((heading + 8192) / 16384) % 4
end

local function FindUnitDefByName(uDefName)
	local retUD = UnitDefs[uDefName]

	local lowerName = uDefName:lower()
	for _, ud in pairs(UnitDefs) do
		if ud.name:lower() == lowerName then
			retUD = ud
			break
		end
	end

	return retUD
end

local function AddFortifyDef(unitDefID, targetName, delay)
	if not fortifyDefs[unitDefID] then
		local newDef =
		{
			name = targetName,
			duration = delay * 30,
		}
		fortifyDefs[unitDefID] = newDef
	end
end

local function StartFortification(unitID, unitDefID)
	local fortDef = fortifyDefs[unitDefID]
	if fortDef then
		fortifyingUnits[unitID] = fortDef.duration
		fortifyDestinations[unitID] = fortDef.name
		Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })
		EnableMoveCtrl(unitID)
		Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, { "alt" })
		local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_FORTIFY)
		if (cmdDescID) then
			Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=CMD_FORTIFY_STOP, name=LightRedStr.."Stop", type = CMDTYPE.ICON})
		end
	end
end

local function StopFortification(unitID)
	if fortifyingUnits[unitID] then
		fortifyingUnits[unitID] = nil
		fortifyDestinations[unitID] = nil
		Spring.SetUnitHealth(unitID, { paralyze = 0 })
		DisableMoveCtrl(unitID)
		local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_FORTIFY_STOP)
		if (cmdDescID) then
			Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=CMD_FORTIFY, name=fortifyCmdDesc.name, type = CMDTYPE.ICON})
		end
	end
end

function ForcedLoading(transportID, passengerID)
	env = Spring.UnitScript.GetScriptEnv(transportID)
	Spring.UnitScript.CallAsUnit(transportID, env.script.TransportPickup, passengerID)
end

local function FortificationComplete(unitID)
	if fortifyDestinations[unitID] then
		SetUnitBlocking(unitID, false)
		local px, py, pz = GetUnitBasePosition(unitID)
		local h = GetUnitHeading(unitID)
		local unitTeam = GetUnitTeam(unitID)
		local newUnit = CreateUnit(fortifyDestinations[unitID], px, py, pz, HeadingToFacing(h), unitTeam, false)
		SetUnitRotation(newUnit, 0, -h * math.pi / 32768, 0)
		SetUnitPosition(newUnit, px, py, pz)
		-- make the new unit to load the original unit
		--Spring.CallCOBScript(newUnit, "TransportPickup", 0, unitID, 1)
		GG.Delay.DelayCall(ForcedLoading, {newUnit, unitID}, 1)
		SetUnitBlocking(unitID, true)
	end
	StopFortification(unitID)
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local customParams = UnitDefs[unitDefID].customParams
	if customParams then
		local targetDefName = customParams.fortifyinto
		if targetDefName then
			targetDefName = targetDefName:lower()
			local fortDef = FindUnitDefByName(targetDefName)
			if fortDef then
				InsertUnitCmdDesc(unitID, fortifyCmdDesc)
				AddFortifyDef(unitDefID, customParams.fortifyinto, customParams.fortifydelay or 0)
			end
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	StopFortification(unitID)
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_FORTIFY then
		if GetUnitTransporter(unitID) then
			return false
		end
		StartFortification(unitID, unitDefID)
	elseif cmdID == CMD_FORTIFY_STOP then
		StopFortification(unitID)
	end
	return true
end

function gadget:GameFrame(n)
	for unitID, _ in pairs(fortifyingUnits) do
		if fortifyingUnits[unitID] <= 0 then
			FortificationComplete(unitID)
		else
			fortifyingUnits[unitID] = fortifyingUnits[unitID] - 1
		end
	end
end

end
