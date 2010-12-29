function gadget:GetInfo()
	return {
		name = "Beaching Command",
		desc = "Give special beaching command to LCG(M)",
		author = "FLOZi (C. Lawrence)",
		date = "27/12/2010",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end

-- Localisations

-- Constants
local CMD_BEACH = 1000
local MIN_DEPTH = -150 -- lowest depth that we allow the command for
local ACTUAL_MIN_DEPTH = -15 -- lowest depth that the model should be lowered to
local SINK_RATE = -0.1
local SINK_TIME = math.floor(ACTUAL_MIN_DEPTH / SINK_RATE)
local ARMOUR_MULTIPLE = 0.25
local ACCURACY_MULT = 0.025
local BASE_ACCURACY = WeaponDefs[ UnitDefNames["gbrlcgm"].weapons[1].weaponDef ].accuracy -- ;_;

-- Variables
local activeUnits = {}

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

local DelayCall = GG.Delay.DelayCall

local beachDesc= {
	name	= "Beach",
	action	= "beach",
	id		= CMD_BEACH,
	type	= CMDTYPE.ICON_MODE,
	tooltip	= "Ground the ship for improved armour and accuracy",
	params	= {0, 'Beach', 'Unbeach'},
}

local function EndBeach(unitID, disable)
	Spring.CallCOBScript(unitID, "StopMoving", 0)
	Spring.MoveCtrl.SetVelocity(unitID, 0, 0, 0)
	activeUnits[unitID] = nil
	if disable then -- unit has surfaced
		Spring.MoveCtrl.Disable(unitID) 
		--Spring.SetUnitArmored(unitID, false)
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, 0) -- delete me
		Spring.SetUnitWeaponState(unitID, 0, {accuracy = BASE_ACCURACY})
		Spring.SetUnitWeaponState(unitID, 1, {accuracy = BASE_ACCURACY})
	else -- unit is grounded
		-- 3rd param won't work till next Spring version, and the callin is broken till then anyway!
		--Spring.SetUnitArmored(unitID, true, ARMOUR_MULTIPLE) 
		-- so do this for now instead
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, 1)
		Spring.SetUnitWeaponState(unitID, 0, {accuracy = BASE_ACCURACY * ACCURACY_MULT})
		Spring.SetUnitWeaponState(unitID, 1, {accuracy = BASE_ACCURACY * ACCURACY_MULT})
	end
end

local function Beach(unitID, groundHeight)
	Spring.CallCOBScript(unitID, "EmitWakes", 0)
	Spring.MoveCtrl.Enable(unitID)
	Spring.MoveCtrl.SetVelocity(unitID, 0, SINK_RATE, 0)
	if groundHeight >= ACTUAL_MIN_DEPTH then
		Spring.MoveCtrl.SetTrackGround(unitID, true)
		Spring.MoveCtrl.SetCollideStop(unitID, true)
	else
		DelayCall(EndBeach, {unitID, false}, SINK_TIME)
	end
end

local function UnBeach(unitID)
	Spring.CallCOBScript(unitID, "EmitWakes", 0)
	Spring.MoveCtrl.SetVelocity(unitID, 0, -SINK_RATE, 0)
	DelayCall(EndBeach, {unitID, true}, SINK_TIME)
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	if unitDefID == UnitDefNames["gbrlcgm"].id then -- switch to custom param?
		Spring.InsertUnitCmdDesc(unitID, beachDesc)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	activeUnits[unitID] = nil
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_BEACH then
		-- check that this unit has this command
		local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_BEACH)
		if not cmdDescID then return false end
		-- check unit is not already un/beaching
		if activeUnits[unitID] then return false end
		-- check unit is in shallow enough water
		local x, _, z = Spring.GetUnitBasePosition(unitID)
		local groundHeight = Spring.GetGroundHeight(x,z)
		if groundHeight < MIN_DEPTH then 
			Spring.SendMessageToTeam(teamID, "Water is too deep to beach here!")
			return false
		end
		if cmdParams[1] == 1 then
			activeUnits[unitID] = true
			Beach(unitID, groundHeight)
		else
			activeUnits[unitID] = true
			UnBeach(unitID)
		end
		--Spring.MoveCtrl.SetLimits(unitID, x, -15, z, x, 15, z)
		beachDesc.params[1] = cmdParams[1]
		Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = beachDesc.params})
	end
	return true
end

function gadget:MoveCtrlNotify(unitID, unitDefID, unitTeam, data)
	if activeUnits[unitID] then
		Spring.MoveCtrl.SetTrackGround(unitID, false)
		Spring.MoveCtrl.SetCollideStop(unitID, false)
		EndBeach(unitID)
	end
	return false
end

else

-- UNSYNCED

end
