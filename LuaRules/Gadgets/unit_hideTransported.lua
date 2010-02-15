function gadget:GetInfo()
  return {
    name      = "Hide Transported Units",
    desc      = "Hides units when inside a closed transport",
    author    = "FLOZi",
    date      = "09/02/10",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--Unsynced Ctrl
local SetUnitNoDraw		= Spring.SetUnitNoDraw
-- Synced Read
local GetUnitDefID		= Spring.GetUnitDefID

if (gadgetHandler:IsSyncedCode()) then

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
		-- transportee is Footprint of 1 (doubled by engine) and transporter is not a boat and transportee is not an infantry gun
		SetUnitNoDraw(unitID, true)
	end
end

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
		SetUnitNoDraw(unitID, false)
	end
end

else

end


