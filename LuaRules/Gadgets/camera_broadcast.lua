local versionNumber = "v2.9"

function gadget:GetInfo()
	return {
		name = "LockCamera",
		desc = versionNumber .. " Broadcasts your camera to the lockcamera widget.",
		author = "Evil4Zerggin, ashdnazg",
		date = "16 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = -5,
		enabled = true
	}
end

if gadgetHandler:IsSyncedCode() then

else

------------------------------------------------
--debug
------------------------------------------------
local totalCharsSent = 0
local totalCharsRecv = 0

------------------------------------------------
--config
------------------------------------------------

--broadcast
local broadcastPeriod = 0.125 --will send packet in this interval (s)
local broadcastSpecsAsSpec = false

local broadcastSpecsAsPlayer = true
local broadcastAlliesAsPlayer = false


function gadget:GetConfigData(data)
	return {
		broadcastPeriod = broadcastPeriod,
		broadcastSpecsAsSpec = broadcastSpecsAsSpec,
		notBroadcastSpecsAsPlayer = not broadcastSpecsAsPlayer,
		broadcastAlliesAsPlayer = broadcastAlliesAsPlayer,
	}
end

function gadget:SetConfigData(data)
	broadcastPeriod = data.broadcastPeriod or broadcastPeriod
	broadcastSpecsAsSpec = data.broadcastSpecsAsSpec
	broadcastSpecsAsPlayer = not data.notBroadcastSpecsAsPlayer
	broadcastAlliesAsPlayer = data.broadcastAlliesAsPlayer
end

------------------------------------------------
--vars
------------------------------------------------
local myPlayerID
local totalTime
local timeSinceBroadcast

local lastPacketSent
local packetsToKeyFrame = 0
local keyFrameState

------------------------------------------------
--speedups
------------------------------------------------
local GetCameraState = Spring.GetCameraState
local SetCameraState = Spring.SetCameraState
local GetSpectatingState = Spring.GetSpectatingState

local SendLuaUIMsg = Spring.SendLuaUIMsg

local GetMyPlayerID = Spring.GetMyPlayerID

local SendCommands = Spring.SendCommands
local GetLastUpdateSeconds = Spring.GetLastUpdateSeconds

local Log = Spring.Log
local strLen = string.len
local strByte = string.byte
local strChar = string.char

local floor = math.floor

local vfsPackU8 = VFS.PackU8
local vfsPackF32 = VFS.PackF32
local vfsUnpackU8 = VFS.UnpackU8
local vfsUnpackF32 = VFS.UnpackF32

------------------------------------------------
--const
------------------------------------------------
local PACKET_HEADER = "="
local PACKET_HEADER_LENGTH = strLen(PACKET_HEADER)

------------------------------------------------
--H4X
------------------------------------------------
--[0, 254] -> char
local function CustomPackU8(num)
	return strChar(num + 1)
end

local function CustomUnpackU8(s, offset)
	local byte = strByte(s, offset)
	if byte then
		return strByte(s, offset) - 1
	else
		return nil
	end
end

--1 sign bit, 7 exponent bits, 8 mantissa bits, -64 bias, denorm, no infinities or NaNs, avoid zero bytes, big-Endian
local function CustomPackF16(num)
	--vfsPack is little-Endian
	local floatChars = vfsPackF32(num)
	if not floatChars then return nil end

	local sign = 0
	local exponent = strByte(floatChars, 4) * 2
	local mantissa = strByte(floatChars, 3) * 2

	local negative = exponent >= 256
	local exponentLSB = mantissa >= 256
	local mantissaLSB = strByte(floatChars, 2) >= 128

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
		mantissa = floor((256 + mantissa) * 2^(exponent + 62))
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

	return strChar(byte1, byte2)
end

local function CustomUnpackF16(s, offset)
	offset = offset or 1
	local byte1, byte2 = strByte(s, offset, offset + 1)

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

------------------------------------------------
--packets
------------------------------------------------

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
		Spring.SetCameraState({name = name, mode = mode}, 0)
		local state = Spring.GetCameraState()
		state.name = nil
		state.mode = nil
		local argTable = {}
		for k, _ in pairs(state) do
			argTable[#argTable + 1] = k
		end
		CAMERA_STATE_FORMATS[mode] = argTable
	end
	Spring.SetCameraState(origState, 0)

	Spring.SendCommands("minimap min 0")
end

------------------------------------------------------------------
-- Packet format:
-- * PACKET_HEADER
-- * Camera mode (unsigned char)
-- * Multiple Sections, each containing:
--   * Bit mask of which floats were sent (unsigned char)
--   * Up to 7 float values according to the mask (16 bit float)
--
-- Example: A mask of 9 (00001001) will be followed by 2 encoded
--          floats, the first and the fourth.
--          The other 5 weren't sent since they haven't changed
--          since the last frame.
------------------------------------------------------------------


--does not allow spaces in keys; values are numbers
local function CameraStateToPacket(s)
	--Send keyframe every 10 seconds or when mode changes
	local doKeyFrame = packetsToKeyFrame <= 0 or keyFrameState and s.mode ~= keyFrameState.mode
	if doKeyFrame then
		packetsToKeyFrame = 10 / broadcastPeriod
		keyFrameState = s
	else
		packetsToKeyFrame = packetsToKeyFrame - 1
	end

	local cameraID = s.mode
	local name = CAMERA_NAMES[cameraID]
	local stateFormat = CAMERA_STATE_FORMATS[cameraID]

	if not stateFormat or not cameraID then return nil end

	local result = PACKET_HEADER .. CustomPackU8(cameraID)
	local currentBit = 1
	local sectionBitMask = 0
	local section = ''
	for i=1, #stateFormat do
		local cameraAttribute = stateFormat[i]
		local num = s[cameraAttribute]
		if not num then
			Log('lock-camera', 'warning', "camera " .. name .. " missing attribute " .. cameraAttribute .. " in getCameraState")
			return nil
		end
		if doKeyFrame or keyFrameState and keyFrameState[cameraAttribute] ~= num then
			section = section .. CustomPackF16(num)
			sectionBitMask = sectionBitMask + currentBit
		end
		if i % 7 == 0 or i == #stateFormat then
			result = result .. CustomPackU8(sectionBitMask) .. section
			sectionBitMask = 0
			currentBit = 1
			section = ''
		else
			currentBit = currentBit * 2
		end
	end
	return result
end

local function PacketToCameraState(p)
	local offset = PACKET_HEADER_LENGTH + 1
	local cameraID = CustomUnpackU8(p, offset)
	local name = CAMERA_NAMES[cameraID]
	local stateFormat = CAMERA_STATE_FORMATS[cameraID]
	if not (cameraID and stateFormat) then
		Log('lock-camera', 'warning', "packet did not contain cameraID and mode and name and stateFormat")
		return nil
	end

	local result = {
		name = name,
		mode = cameraID,
	}

	offset = offset + 1

	local sectionBitMask = 0
	for i=1, #stateFormat do
		if i % 7 == 1 then
			sectionBitMask = CustomUnpackU8(p, offset)
			offset = offset + 1
		end
		if sectionBitMask % 2 == 1 then -- MSB is on
			local num = CustomUnpackF16(p, offset)
			if not num then return nil end
			result[stateFormat[i]] = num
			offset = offset + 2
		end
		sectionBitMask = floor(sectionBitMask / 2) -- 8 bit shift right
	end

	return result
end

------------------------------------------------
--callins
------------------------------------------------

function gadget:Initialize()

	myPlayerID = GetMyPlayerID()
	timeSinceBroadcast = 0
	totalTime = 0
end

function gadget:Shutdown()
	SendLuaUIMsg(PACKET_HEADER, "a")
	SendLuaUIMsg(PACKET_HEADER, "s")
end

function gadget:Update()
	local dt = GetLastUpdateSeconds()
	local newIsSpectator = GetSpectatingState()
	if newIsSpectator ~= isSpectator then
		isSpectator = newIsSpectator
		if isSpectator then
			if not broadcastSpecsAsSpec then
				SendLuaUIMsg(PACKET_HEADER, "s")
				totalCharsSent = totalCharsSent + PACKET_HEADER_LENGTH
			end
		else
			if not broadcastAlliesAsPlayer then
				SendLuaUIMsg(PACKET_HEADER, "a")
				totalCharsSent = totalCharsSent + PACKET_HEADER_LENGTH
			end
			if not broadcastSpecsAsPlayer then
				SendLuaUIMsg(PACKET_HEADER, "s")
				totalCharsSent = totalCharsSent + PACKET_HEADER_LENGTH
			end
		end
	end

	if (isSpectator and not broadcastSpecsAsSpec)
			or (not isSpectator and not broadcastAlliesAsPlayer and not broadcastSpecsAsPlayer) then
		return
	end
	totalTime = totalTime + dt
	timeSinceBroadcast = timeSinceBroadcast + dt
	if timeSinceBroadcast > broadcastPeriod then

		local state = GetCameraState()
		local msg = CameraStateToPacket(state)

		--don't send duplicates

		if not msg then
			Log('lock-camera', 'error', "Error creating packet! Removing gadget.")
			GG.RemoveGadget(self)
			return
		end

		if msg ~= lastPacketSent then
			if (not isSpectator and broadcastAlliesAsPlayer) then
				SendLuaUIMsg(msg, "a")
			end

			if (isSpectator and broadcastSpecsAsSpec)
					or (not isSpectator and broadcastSpecsAsPlayer) then
				SendLuaUIMsg(msg, "s")
			end

			totalCharsSent = totalCharsSent + strLen(msg)

			lastPacketSent = msg
		end

		timeSinceBroadcast = timeSinceBroadcast - broadcastPeriod
	end
end

function gadget:GameOver()
  Log('lock-camera', 'info', totalCharsSent .. " chars sent, " .. totalCharsRecv .. " chars received.")
end

end