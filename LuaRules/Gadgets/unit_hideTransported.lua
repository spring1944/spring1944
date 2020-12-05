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


if (gadgetHandler:IsSyncedCode()) then

-- Unsynced Ctrl
local SetUnitNoDraw         = Spring.SetUnitNoDraw
-- Synced Read
local GetUnitDefID          = Spring.GetUnitDefID
local GetUnitTeam           = Spring.GetUnitTeam
local GetUnitPosition       = Spring.GetUnitPosition
local GetUnitTransporter    = Spring.GetUnitTransporter
local GetUnitsInCylinder    = Spring.GetUnitsInCylinder
local GetUnitSensorRadius   = Spring.GetUnitSensorRadius
-- Synced Ctrl
local GiveOrderToUnit       = Spring.GiveOrderToUnit
local SetUnitNeutral        = Spring.SetUnitNeutral
local SetUnitSensorRadius   = Spring.SetUnitSensorRadius

-- Constants
local CMD_LOAD_ONTO = CMD.LOAD_ONTO
local CMD_STOP = CMD.STOP
local CMD_MOVE = CMD.MOVE

local LOS_TYPES = {"airLos", "los", "radar", "sonar", "seismic", "radarJammer", "sonarJammer"}
-- Variables
local massLeft = {}
local toBeLoaded = {}
local savedRadius = {}

local function StoreLOSRadius(unitID, unitDefID)
	if not savedRadius[unitDefID] then
		radiusArray = {}
		for i, losType in ipairs(LOS_TYPES) do
			radiusArray[i] = GetUnitSensorRadius(unitID, losType)
		end
		for _, losType in ipairs(LOS_TYPES) do
			SetUnitSensorRadius(unitID, losType, 0)
		end
		savedRadius[unitDefID] = radiusArray
	else
		for _, losType in ipairs(LOS_TYPES) do
			SetUnitSensorRadius(unitID, losType, 0)
		end
	end
end

local function RestoreLOSRadius(unitID, unitDefID)
	radiusArray = savedRadius[unitDefID]
	for i, losType in ipairs(LOS_TYPES) do
		SetUnitSensorRadius(unitID, losType, radiusArray[i])
	end
end

--[[
function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_LOAD_ONTO then
		local transportID = cmdParams[1]
		toBeLoaded[unitID] = transportID
	end
	return true
end
--]]


function gadget:UnitCreated(unitID, unitDefID, teamID)
	local unitDef = UnitDefs[unitDefID]
	local maxMass = unitDef.transportMass
	if maxMass then
		massLeft[unitID] = maxMass
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	massLeft[unitID] = nil
	-- toBeLoaded[unitID] = nil
end

--[[
local function TransportIsFull(transportID)
	for unitID, targetTransporterID in pairs(toBeLoaded) do
		if targetTransporterID == transportID then
			GiveOrderToUnit(unitID, CMD_STOP, {}, {})
			toBeLoaded[unitID] = nil
		end
	end
end
--]]

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	
	-- should fix engineers still thinking they're building.
	GiveOrderToUnit(unitID, CMD_STOP, {}, {})
	
	-- Check if transport is full (former crash risk!)
	if massLeft[transportID] then
		massLeft[transportID] = massLeft[transportID] - unitDef.mass
	
		--[[
		if massLeft[transportID] == 0 then
			TransportIsFull(transportID)
		end
		--]]
		if unitDef.xsize == 2 and not transportDef.modCategories.ship and not unitDef.customParams.hasturnbutton and not transportDef.customParams.infgun and not unitDef.customParams.infgun then 
			-- transportee is Footprint of 1 (doubled by engine) and transporter is not a boat and neither transporter nor transportee are infantry guns
			-- SetUnitNoDraw(unitID, true)
			-- SetUnitNeutral(unitID, true)
			StoreLOSRadius(unitID, unitDefID)
		end
	end
	Spring.SetUnitNoMinimap(unitID, true)
	
end

--[[
local function IsPositionValid(unitDefID, x, z)
	-- Don't place units underwater. (this is also checked by TestBuildOrder
	-- but that needs proper maxWaterDepth/floater/etc. in the UnitDef.)
	local y = Spring.GetGroundHeight(x, z)
	if (y <= 0) then
		return false
	end
	-- Don't place units where it isn't be possible to build them normally.
	local test = Spring.TestBuildOrder(unitDefID, x, y, z, 0)
	if (test ~= 2) then
		return false
	end
	-- Don't place units too close together.
	local ud = UnitDefs[unitDefID]
	local units = Spring.GetUnitsInCylinder(x, z, 16)
	if (units[1] ~= nil) then
		return false
	end
	return true
end
--]]

--[[
local function FindUnloadPlace(unitID, unitDefID, transportID)
	local ux, uy, uz = Spring.GetUnitPosition(unitID)
	local tx, ty, tz = Spring.GetUnitPosition(transportID)
	
	local vx, vz  = -(uz - tz), ux - tx -- rotate 90 degrees
	local magnitude = math.sqrt(vx*vx + vz*vz)
	local vx, vz = vx / magnitude, vz / magnitude
	local step = math.max(UnitDefs[unitDefID].xsize, UnitDefs[unitDefID].zsize) * 4
	
	--limit iterations
	for i = 3,12 do
		local x, z =  ux + vx * i * step, uz + vz * i * step
		if IsPositionValid(unitDefID, x, z) then
			Spring.SetUnitPosition(unitID, x, z)
			return
		end
		x, z =  ux - vx * i * step, uz - vz * i * step
		if IsPositionValid(unitDefID, x, z) then
			Spring.SetUnitPosition(unitID, x, z)
			return
		end
	end
end
--]]

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	massLeft[transportID] = massLeft[transportID] + unitDef.mass
	if unitDef.xsize == 2 and not (transportDef.modCategories.ship) and not unitDef.customParams.hasturnbutton and not transportDef.customParams.infgun and not unitDef.customParams.infgun then 
		-- SetUnitNoDraw(unitID, false)
		-- SetUnitNeutral(unitID, false)
		RestoreLOSRadius(unitID, unitDefID)
	end
	-- GG.Delay.DelayCall(Spring.SetUnitVelocity, {unitID, 0, 0, 0}, 16)
	Spring.SetUnitNoMinimap(unitID, false)
	-- GG.Delay.DelayCall(Spring.SetUnitBlocking, {unitID, true, true, true, true, true, true, true}, 16) -- Engine doesn't properly reset blockign on lua-loaded units
	-- FindUnloadPlace(unitID, unitDefID, transportID)
end

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitTeam = GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID, unitTeam)
	end
end

else

end


