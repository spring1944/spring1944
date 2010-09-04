function gadget:GetInfo()
  return {
    name      = "Transport Helper",
    desc      = "Hides units when inside a closed transport, issues stop command to units trying to enter a full transport",
    author    = "FLOZi",
    date      = "09/02/10",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-- Unsynced Ctrl
local SetUnitNoDraw			= Spring.SetUnitNoDraw
-- Synced Read
local GetUnitDefID			= Spring.GetUnitDefID
local GetUnitPosition 		= Spring.GetUnitPosition
local GetUnitTransporter 	= Spring.GetUnitTransporter
local GetUnitsInCylinder 	= Spring.GetUnitsInCylinder
-- Synced Ctrl
local GiveOrderToUnit		= Spring.GiveOrderToUnit

-- Constants
local RADIUS_MULT = 2
-- Variables
local switch = {}
local massLeft = {}

if (gadgetHandler:IsSyncedCode()) then

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local unitDef = UnitDefs[unitDefID]
	local maxMass = unitDef.transportMass
	if maxMass then
		massLeft[unitID] = maxMass
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	massLeft[unitID] = nil
	switch[unitID] = nil
end

local function TransportIsFull(transportID, transportDefID, teamID)
	local transportDef = UnitDefs[transportDefID]
	local x, _, z = GetUnitPosition(transportID)
	local nearUnits = GetUnitsInCylinder(x, z, transportDef.loadingRadius * RADIUS_MULT, teamID)
	for i = 1, #nearUnits do
		local unitID = nearUnits[i]
		if not GetUnitTransporter(unitID) then -- ignore the units we already loaded
			local unitDef = UnitDefs[GetUnitDefID(unitID)]
			if unitDef.xsize / 2 == transportDef.transportSize then
				local commandQueue = Spring.GetUnitCommands(unitID)
				if commandQueue[1] then
					if commandQueue[1].id == CMD.LOAD_ONTO and commandQueue[1].params[1] == transportID then
						--Spring.Echo("Trying to load onto a full transport!")
						GiveOrderToUnit(unitID, CMD.STOP, {}, {})
					end
				end
			end
		end
	end
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	--Spring.Echo("UnitLoaded")
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	--[[massLeft[transportID] = massLeft[transportID] - unitDef.mass
	if massLeft[transportID] == 0 then
		--switch[transportID] = not switch[transportID] -- this is a hack required because UnitLoaded is called when a unit is unloaded, due to attach-unit being called
		--if switch[transportID] then
			TransportIsFull(transportID, GetUnitDefID(transportID), transportTeam)
		--end
	end]] -- CODE COMMENTED OUT TO PREVENT CRASH
	if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
		-- transportee is Footprint of 1 (doubled by engine) and transporter is not a boat and transportee is not an infantry gun
		SetUnitNoDraw(unitID, true)
	end
end

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
	--Spring.Echo("UnitUnloaded")
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	--massLeft[transportID] = massLeft[transportID] + unitDef.mass
	if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
		SetUnitNoDraw(unitID, false)
	end
end

else

end


