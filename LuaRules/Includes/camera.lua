-- License: GPL v2 or later
-- Contains code from lockcamera by Evil4Zerggin

--Gather camera info
local CAMERA_STATE_FORMATS = {
}

local CAMERA_IDS = Spring.GetCameraNames()
local CAMERA_NAMES = {}

do
	for k,v in pairs(CAMERA_IDS) do
		CAMERA_NAMES[v] = k
	end
	local origState = Spring.GetCameraState()
	for name, mode in pairs(CAMERA_IDS) do
		Spring.SetCameraState({name = name, mode = mode})
		local state = Spring.GetCameraState()
		state.name = nil
		state.mode = nil
		local argTable = {}
		for k, _ in pairs(state) do
			argTable[#argTable + 1] = k
		end
		CAMERA_STATE_FORMATS[mode] = argTable
	end
	Spring.SetCameraState(origState)

	Spring.SendCommands("minimap min 0")
end

--Pack/Unpack data
local function CustomPackU8(num)
	return string.char(num)
end

local function CustomUnpackU8(s, offset)
	return string.byte(s, offset)
end

--1 sign bit, 7 exponent bits, 8 mantissa bits, -64 bias, denorm, no infinities or NaNs, avoid zero bytes, big-Endian
local function CustomPackF16(num)
	--vfsPack is little-Endian
	local floatChars = VFS.PackF32(num)
	if not floatChars then return nil end

	local sign = 0
	local exponent = string.byte(floatChars, 4) * 2
	local mantissa = string.byte(floatChars, 3) * 2

	local negative = exponent >= 256
	local exponentLSB = mantissa >= 256
	local mantissaLSB = string.byte(floatChars, 2) >= 128

	if negative then
		sign = 128
		exponent = exponent - 256
	end

	if exponentLSB then
		exponent = exponent - 126
		mantissa = mantissa - 256
	else
		exponent = exponent - 127
	end

	if mantissaLSB then
		mantissa = mantissa + 1
	end

	if exponent > 63 then
		exponent = 63
		--largest representable number
		mantissa = 255
	elseif exponent < -62 then
		--denorm
		mantissa = math.floor((256 + mantissa) * 2^(exponent + 62))
		--preserve zero-ness
		if mantissa == 0 and num ~= 0 then
			mantissa = 1
		end
		exponent = -63
	end

	if mantissa ~= 255 then
		mantissa = mantissa + 1
	end

	local byte1 = sign + exponent + 64
	local byte2 = mantissa

	return string.char(byte1, byte2)
end

local function CustomUnpackF16(s, offset)
	offset = offset or 1
	local byte1, byte2 = string.byte(s, offset, offset + 1)

	if not (byte1 and byte2) then return nil end

	local sign = 1
	local exponent = byte1
	local mantissa = byte2 - 1
	local norm = 1

	local negative = (byte1 >= 128)

	if negative then
		exponent = exponent - 128
		sign = -1
	end

	if exponent == 1 then
		exponent = 2
		norm = 0
	end

	local order = 2^(exponent - 64)

	return sign * order * (norm + mantissa / 256)
end

local Camera = {}

function Camera.StateToPacket(s)
	local cameraID = s.mode
	local name = CAMERA_NAMES[cameraID]
	local stateFormat = CAMERA_STATE_FORMATS[cameraID]

	if not stateFormat or not cameraID then return nil end

	local result = CustomPackU8(cameraID)
	for i=1, #stateFormat do
		local cameraAttribute = stateFormat[i]
		local num = s[cameraAttribute]
		if not num then
			Spring.Log('camera', 'warning', "camera " .. name .. " missing attribute " .. cameraAttribute .. " in getCameraState")
			return nil
		end
		result = result .. CustomPackF16(num)
	end
	return result
end

function Camera.PacketToState(p)
	local offset = 1
	local cameraID = CustomUnpackU8(p, offset)
	offset = offset + 1

	local name = CAMERA_NAMES[cameraID]
	local stateFormat = CAMERA_STATE_FORMATS[cameraID]
	if not (cameraID and stateFormat) then
		Spring.Log('camera', 'warning', "packet did not contain cameraID and mode and name and stateFormat")
		return nil
	end

	local result = {
		name = name,
		mode = cameraID,
	}


	for i=1, #stateFormat do
		local num = CustomUnpackF16(p, offset)
		if not num then return nil end
		result[stateFormat[i]] = num
		offset = offset + 2
	end

	return result
end


--Interpolation code, thanks ZK!
local currentMode
local beginTimer
local active
local period
local beginCam = {}
local deltaEnd = {}
local targetCam = {}

local function CopyState(cs, newState)
	for k, v in pairs(newState) do
		cs[k] = v
	end
end

local function Sub(result, vector1, vector2)
	for k, v in pairs(vector1) do
		if type(v) == type(0) then
			result[k] = vector1[k] - vector2[k]
		end
	end
end


function Camera.OverrideSetCameraStateInterpolate(cs,smoothness)
	if currentMode ~= cs.mode then
		Spring.SetCameraState(cs)
		currentMode = cs.mode
		active = false
		beginCam = {}
		deltaEnd = {}
		targetCam = {}
		return
	end
	Camera.Interpolate()
	beginTimer = Spring.GetTimer()
	period = smoothness

	local now = Spring.GetCameraState()
	CopyState(beginCam, now)

	CopyState(targetCam, cs)
	active = true

	Sub(deltaEnd, cs, now)

end

local function Add(vector1,vector2,factor)
	local newVector = {}
	for k, v in pairs(vector1) do
		if type(v) == type(0) then
			newVector[k] = v + (vector2[k] or 0) * factor
		else
			newVector[k] = v
		end
	end
	return newVector
end

local function DisableEngineTilt(cs)
	--Disable engine's tilt when we press arrow key and move mouse
	cs.tiltSpeed = 0
	cs.scrollSpeed = 0
end

--All algorithm is from "Spring/rts/game/CameraHandler.cpp"
function Camera.Interpolate()
	if not (active) then return end

	local lapsedTime = Spring.DiffTimers(Spring.GetTimer(), beginTimer);

	if ( lapsedTime >= period) then
		local cs = Spring.GetCameraState()
		CopyState(cs, targetCam)
		DisableEngineTilt(cs)
		Spring.SetCameraState(cs)
		active = false
	else
		if (period > 0) then
			local timeRatio = (period - lapsedTime) / (period);
			local tweenFact = 1.0 - math.pow(timeRatio, 4);

			local newState = Add(beginCam,deltaEnd,tweenFact) --add changes to camera state in gradual manner
			local cs = Spring.GetCameraState()
			CopyState(cs, newState)
			DisableEngineTilt(cs)
			Spring.SetCameraState(cs)
		end
	end
end





return Camera