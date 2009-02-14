function gadget:GetInfo()
	return {
		name      = "Test",
		desc      = "Test",
		author    = "Evil4Zerggin",
		date      = "Whenever",
		license   = "Whatever",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if not gadgetHandler:IsSyncedCode() then return end

local CMD_PLANES = 34400
local FORMATION_SEPARATION = 128
local PLANE_STATE_ACTIVE = 0
local PLANE_STATE_RETREAT = 1

local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local GiveOrderToUnit = Spring.GiveOrderToUnit
local SetUnitPosition = Spring.SetUnitPosition
local SetUnitRotation = Spring.SetUnitRotation
local SetUnitVelocity = Spring.SetUnitVelocity
local SetUnitNoSelect = Spring.SetUnitNoSelect
local GetTeamStartPosition = Spring.GetTeamStartPosition
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local UseUnitResource = Spring.UseUnitResource
local GetUnitFuel = Spring.GetUnitFuel
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetGameFrame = Spring.GetGameFrame

local sqrt = math.sqrt
local sin, cos, atan2 = math.sin, math.cos, math.atan2

local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ

local CMDTYPE_ICON_MAP = CMDTYPE.ICON_MAP
local CMDTYPE_ICON_UNIT_OR_MAP = CMDTYPE.ICON_UNIT_OR_MAP
local CMD_MOVE = CMD.MOVE
local CMD_PATROL = CMD.PATROL
local CMD_OPT_SHIFT = CMD.OPT_SHIFT

----------------------------------------------------------------
--init
----------------------------------------------------------------
--unitname = missions
local planeDefs = VFS.Include("LuaRules/Configs/plane_defs.lua")

--cmdID = mission
local planeCmdIDs = {}

--unitID = state
local planeStates = {}

--framenum = {missions}
local orderedMissions = {}

local currCmdID = CMD_PLANES

local function GetDefaultTexture(mission)
	local unitname = mission.units[1]
	local unitDef = UnitDefNames[unitname]
	if not unitDef then return end
	
	return "unitpics/" .. unitDef.buildpicname
end

local function BuildCmdDesc(mission)
	result = {
		id = currCmdID,
		type = CMDTYPE_ICON_MAP,
		name = mission.name,
		cursor = "Attack",
		tooltip = mission.tooltip,
		texture = mission.texture or GetDefaultTexture(mission),
	}
	
	planeCmdIDs[currCmdID] = mission
	
	currCmdID = currCmdID + 1 
	
	return result
end

for radioTowerID, missions in pairs(planeDefs) do
	for i=1,#missions do
		missions[i].cmdDesc = BuildCmdDesc(missions[i])
	end
end

----------------------------------------------------------------
--helpers
----------------------------------------------------------------
local function AddVectors(u, v)
	local result = {}
	for i = 1, #u do
		result[i] = u[i] + v[i]
	end
	return result
end

local function SubtractVectors(u, v)
	local result = {}
	for i = 1, #u do
		result[i] = u[i] - v[i]
	end
	return result
end

local function ScaleVector(c, v)
	local result = {}
	for i = 1, #v do
		result[i] = c * v[i]
	end
	return result
end

local function VectorMagnitude(v)
	local resultSq = 0
	for i=1, #v do
		resultSq = resultSq + v[i] * v[i]
	end
	return sqrt(resultSq)
end

local function VectorNormalize(v)
	local mag = VectorMagnitude(v)
	local result = {}
	for i=1, #v do
		result[i] = v[i] / mag
	end
	return result
end

local function ClampVectorToMap(v)
	local x, y, z = v[1], v[2], v[3]
	if x < 0 then 
		x = 0 
	elseif x > mapSizeX then
		x = mapSizeX
	end
	if z < 0 then 
		z = 0 
	elseif z > mapSizeZ then
		z = mapSizeZ
	end
	
	return {x, y, z}
end

local function RotateVectorByHeading(v, heading)
	local sinHeading = sin(heading)
	local cosHeading = cos(heading)
	return {v[1] * cosHeading + v[3] * sinHeading, v[2], v[3] * cosHeading - v[1] * sinHeading}
end

local function SpawnPlane(teamID, unitname, pos, target, dir, rotation)
	target = ClampVectorToMap(target)
	local x, y, z = pos[1], pos[2], pos[3]
	
	local unitDef = UnitDefNames[unitname]
	local speed = unitDef.speed
	local altitude = unitDef.wantedHeight
	local velocity = ScaleVector(speed / 120, dir)
	y = y + altitude
	local unitID = CreateUnit(unitname, x, y, z, 0, teamID)
	SetUnitPosition(unitID, x, y, z)
	SetUnitRotation(unitID, 0, rotation, 0)
	SetUnitVelocity(unitID, velocity[1], velocity[2], velocity[3])
	GiveOrderToUnit(unitID, CMD_MOVE, target, {})
	GiveOrderToUnit(unitID, CMD_PATROL, pos, {"shift"})
	planeStates[unitID] = PLANE_STATE_ACTIVE
end

local function SpawnFlight(teamID, units, pos, target)
	local diff = SubtractVectors(target, pos)
	local dir = VectorNormalize(diff)
	local rotation = -atan2(diff[1], diff[3])
	
	local cosRotation = cos(rotation) * FORMATION_SEPARATION
	local sinRotation = sin(rotation) * FORMATION_SEPARATION
	local diffRotation = cosRotation - sinRotation
	local sumRotation = cosRotation + sinRotation
	
	--"deuce" formation
	if #units == 2 then
		local currPos = AddVectors(pos, {cosRotation, 0, -sinRotation})
		local currTarget = AddVectors(target, {cosRotation, 0, -sinRotation})
		SpawnPlane(teamID, units[1], currPos, currTarget, dir, rotation)
		
		currPos = AddVectors(pos, {cosRotation, 0, sinRotation})
		currTarget = AddVectors(target, {cosRotation, 0, sinRotation})
		SpawnPlane(teamID, units[2], currPos, currTarget, dir, rotation)
		return
	end
	
	--single, "vic", "finger four", etc.
	local currPos = pos
	local currTarget = target
	local unitname = units[1]
	SpawnPlane(teamID, unitname, currPos, currTarget, dir, rotation)
	
	local i = 1
	while true do
		unitname = units[2*i]
		if not unitname then return end
		--right side
		currPos = AddVectors(pos, {-diffRotation * i, 0, -sumRotation * i})
		currTarget = AddVectors(target, {-diffRotation * i, 0, -sumRotation * i})
		SpawnPlane(teamID, unitname, currPos, currTarget, dir, rotation)
		
		
		unitname = units[2*i+1]
		if not unitname then return end
		--left side
		currPos = AddVectors(pos, {sumRotation * i, 0, -diffRotation * i})
		currTarget = AddVectors(target, {sumRotation * i, 0, -diffRotation * i})
		SpawnPlane(teamID, unitname, currPos, currTarget, dir, rotation)
		
		i = i + 1
	end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local unitDef = UnitDefs[unitDefID]
	local unitDefName = unitDef.name
	local missions = planeDefs[unitDefName]
	
	if not missions then return end
	for i=1,#missions do
		InsertUnitCmdDesc(unitID, missions[i].cmdDesc)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if planeStates[unitID] == PLANE_STATE_RETREAT then
		return false
	end
	
	local mission = planeCmdIDs[cmdID]
	if not mission then
		return true
	end
	
	if UseUnitResource(unitID, "m", mission.cost) then
		local targetFrame = GetGameFrame() + mission.delay * 30
		if not orderedMissions[targetFrame] then
			orderedMissions[targetFrame] = {}
		end
		
		orderedMissions[targetFrame][#orderedMissions+1] = {
			mission,
			teamID,
			cmdParams
		}
	end
	
	return false
end

function gadget:GameFrame(n)
	local missionsThisFrame = orderedMissions[n]
	if missionsThisFrame then
		for i=1, #missionsThisFrame do
			local info = missionsThisFrame[i]
			local mission = info[1]
			local teamID = info[2]
			local target = info[3]
			local pos = {}
			pos[1], pos[2], pos[3] = GetTeamStartPosition(teamID)
			SpawnFlight(teamID, mission.units, pos, target)
		end
		orderedMissions[n] = nil --delete
	end
	
	if n % 30 ~= 14 then return end
	
	for unitID, state in pairs(planeStates) do
		local unitDefID = GetUnitDefID(unitID)
		local unitDef = UnitDefs[unitDefID]
		local teamID = GetUnitTeam(unitID)
		if state == PLANE_STATE_ACTIVE then
			if GetUnitFuel(unitID) < 1 and unitDef.maxFuel > 0 then
				Spring.Echo(GetUnitFuel(unitID))
				planeStates[unitID] = PLANE_STATE_RETREAT
				SetUnitNoSelect(unitID, true)
			end
		elseif state == PLANE_STATE_RETREAT then
			DestroyUnit(unitID, false, true)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	planeStates[unitID] = nil
end
