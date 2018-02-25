local versionNumber = "v1.2"

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

local DEFAULT_VOLUME = 1
local updatePeriod = 0.1

local SOUND_DIR = "sounds/engine/"
local SOUND_EXT = ".wav"

local timeSinceLast = 0

local GetAllUnits = Spring.GetAllUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetCameraPosition = Spring.GetCameraPosition
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVelocity = Spring.GetUnitVelocity
local PlaySoundFile = Spring.PlaySoundFile
local vNormalized

local floor = math.floor
local PI = math.pi

--unitDefID = {engineSound, engineSoundNr, maxSpeed}
local infos = {}

--unitID = timeSinceLastUpdate
local times = {}

function widget:Initialize()	
	vNormalized = WG.Vector.Normalized
	
	for unitDefID, unitDef in pairs(UnitDefs) do
		local engineSound = unitDef.customParams.enginesound
		if engineSound then
			local engineSoundNr = tonumber(unitDef.customParams.enginesoundnr)
			local maxSpeed = unitDef.speed / 30
			local soundVolume = tonumber(unitDef.customParams.enginevolume) or DEFAULT_VOLUME
			infos[unitDefID] = {engineSound, engineSoundNr, maxSpeed, soundVolume}
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
				times[unitID] = (unitID * PI) % updatePeriod
			end
			
			if times[unitID] > updatePeriod then
				times[unitID] = times[unitID] - updatePeriod
				
				local engineSound, engineSoundNr, maxSpeed, soundVolume = info[1], info[2], info[3], info[4]
				local ux, uy, uz = GetUnitPosition(unitID)
				local vx, vy, vz = GetUnitVelocity(unitID)
				
				--normalize to max speed
				local vx, vy, vz = vx/maxSpeed, vy/maxSpeed, vz/maxSpeed
				
				--normalize
				local dx, dy, dz = vNormalized(ux - cx, uy - cy, uz - cz)
				
				local vDotD = vx*dx + vy*dy + vz*dz
				
				local soundNumber = 1 + floor(0.5 * (1 + vDotD) * engineSoundNr)
				
				if soundNumber < 2 then soundNumber = 2
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

function widget:AddConsoleLine(msg, priority)
  if msg:find("aircraft spotted overhead!") then
    PlaySoundFile("sounds/GEN_air_raid.wav", 1)
  end
end
