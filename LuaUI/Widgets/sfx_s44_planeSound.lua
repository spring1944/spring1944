local versionNumber = "v1.0"

function widget:GetInfo()
	return {
		name    = "1944 Aircraft Sounds",
		desc    = versionNumber .. " Advanced doppler-sound fx for aircraft",
		author  = "Zpock and Evil4Zerggin",
		date    = "21 March 2008",
		license = "GNU LGPL, v2.1 or later",
		layer   = 10000,
		enabled = true  --  loaded by default?
	}
end

local soundVolume = 4
local updatePeriod = 0.25

local SOUND_DIR = "sounds/engine/"
local SOUND_EXT = ".wav"

local timeSinceLast = 0

local GetAllUnits = Spring.GetAllUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetCameraPosition = Spring.GetCameraPosition
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVelocity = Spring.GetUnitVelocity
local PlaySoundFile = Spring.PlaySoundFile
local vNormalized = WG.Vector.Normalized

local floor = math.floor
local PI = math.pi

--unitDefID = {engineSound, engineSoundNr, maxSpeed}
local infos = {}

--unitID = timeSinceLastUpdate
local times = {}

function widget:Initialize()
	if (Game.modShortName ~= "S44") then
		widgetHandler:RemoveWidget()
		return
	end
	
	for unitDefID=1,#UnitDefs do
		local unitDef = UnitDefs[unitDefID]
		local engineSound = unitDef.customParams.enginesound
		if engineSound then
			local engineSoundNr = tonumber(unitDef.customParams.enginesoundnr)
			local maxSpeed = unitDef.speed / 30
			infos[unitDefID] = {engineSound, engineSoundNr, maxSpeed}
		end
	end
end

function widget:Update(dt)
	local allUnits = GetAllUnits()
	local cx, cy, cz = GetCameraPosition()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		local unitDefID = GetUnitDefID(unitID)
		local info = infos[unitDefID]
		if info then
			if times[unitID] then
				times[unitID] = times[unitID] + dt
			else
				times[unitID] = math.fmod(unitID * PI, updatePeriod)
			end
			
			if times[unitID] > updatePeriod then
				times[unitID] = times[unitID] - updatePeriod
				
				local engineSound, engineSoundNr, maxSpeed = info[1], info[2], info[3]
				local ux, uy, uz = GetUnitPosition(unitID)
				local vx, vy, vz = GetUnitVelocity(unitID)
				
				--normalize to max speed
				local vx, vy, vz = vx/maxSpeed, vy/maxSpeed, vz/maxSpeed
				
				--normalize
				local dx, dy, dz = vNormalized(ux - cx, uy - cy, uz - cz)
				
				local vDotD = vx*dx + vy*dy + vz*dz
				
				local soundNumber = floor(0.5 * (1 + vDotD) * engineSoundNr)
				
				if soundNumber < 1 then soundNumber = 1
				elseif soundNumber > engineSoundNr then soundNumber = engineSoundNr
				end
				
				local soundFile = SOUND_DIR .. engineSound .. soundNumber .. SOUND_EXT
				PlaySoundFile(soundFile, soundVolume, ux, uy, uz)
			end
		end
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	times[unitID] = nil
end
