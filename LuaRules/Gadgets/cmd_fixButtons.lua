--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Button Manipulator",
    desc      = "Replaces 'Reclaim' Command with 'Salvage', hides Cloak and On/Off",
    author    = "FLOZi (C. Lawrence)",
    date      = "Jun 24, 2008",
    license   = "GNU GPL v2",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
	
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

local EditUnitCmdDesc	= Spring.EditUnitCmdDesc
local FindUnitCmdDesc	= Spring.FindUnitCmdDesc
local RemoveUnitCmdDesc	= Spring.RemoveUnitCmdDesc

local CMD_RECLAIM	= CMD.RECLAIM
local CMD_CLOAK		= CMD.CLOAK
local CMD_ONOFF		= CMD.ONOFF
local CMD_DGUN		= CMD.DGUN
local CMD_CAPTURE	= CMD.CAPTURE


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if (ud.speed > 0 and ud.canReclaim) then
		local unitReclaimCmdDesc = FindUnitCmdDesc(unitID, CMD_RECLAIM)
		if (unitReclaimCmdDesc) then 
			EditUnitCmdDesc(unitID, unitReclaimCmdDesc, {name = "Salvage", tooltip = "Salvage: Salvage wrecks back into Command Points"}) 
		end
	elseif (ud.speed > 0 and ud.canCloak) then
		local unitCloakCmdDesc = FindUnitCmdDesc(unitID, CMD_CLOAK)
		if (unitCloakCmdDesc) then
			RemoveUnitCmdDesc(unitID, unitCloakCmdDesc)
		end
	end
	if (ud.jammerRadius) then
		local unitOnOffCmdDesc = FindUnitCmdDesc(unitID, CMD_ONOFF)
		if (unitOnOffCmdDesc) then
			RemoveUnitCmdDesc(unitID, unitOnOffCmdDesc)
		end
	end
	if (ud.canManualFire) then -- switch to canManualFire after 0.83
		local dGunCmdDesc = FindUnitCmdDesc(unitID, CMD_DGUN)
		if (dGunCmdDesc) then
			EditUnitCmdDesc(unitID, dGunCmdDesc, {name = "Smoke\nGrenade", tooltip = "Smoke Grenade: Throw a smoke grenade"}) 
		end
	end
	if (ud.canCapture) then -- switch to canManualFire after 0.83
		local dCaptureCmdDesc = FindUnitCmdDesc(unitID, CMD_CAPTURE)
		if (dCaptureCmdDesc) then
			EditUnitCmdDesc(unitID, dCaptureCmdDesc, {name = "Capture", tooltip = "Capture: Take control of abandoned units"}) 
		end
	end
end

end
