local versionNumber = "v2.9"

function gadget:GetInfo()
	return {
		name = "LockCamera",
		desc = versionNumber .. " Allows you to lock your camera to another player's camera.\n"
				.. "/luaui lockcamera_interval to set broadcast interval (minimum 0.25 s).",
		author = "Evil4Zerggin",
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

------------------------------------------------
--speedups
------------------------------------------------
local GetCameraState = Spring.GetCameraState
local SetCameraState = Spring.SetCameraState
local IsGUIHidden = Spring.IsGUIHidden
local GetMouseState = Spring.GetMouseState
local GetSpectatingState = Spring.GetSpectatingState

local SendLuaUIMsg = Spring.SendLuaUIMsg

local GetMyPlayerID = Spring.GetMyPlayerID
local GetMyTeamID = Spring.GetMyTeamID
local GetPlayerList = Spring.GetPlayerList
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamColor = Spring.GetTeamColor

local SendCommands = Spring.SendCommands
local GetLastUpdateSeconds = Spring.GetLastUpdateSeconds

local Echo = Spring.Echo
local Log = Spring.Log
local strGMatch = string.gmatch
local strSub = string.sub
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
	fps = {
		"px", "py", "pz",
		"dx", "dy", "dz",
		"rx", "ry", "rz",
		"oldHeight",
	},
	free = {
		"px", "py", "pz",
		"dx", "dy", "dz",
		"rx", "ry", "rz",
		"fov",
		"gndOffset",
		"gravity",
		"slide",
		"scrollSpeed",
		"tiltSpeed",
		"velTime",
		"avelTime",
		"autoTilt",
		"goForward",
		"invertAlt",
		"gndLock",
		"vx", "vy", "vz",
		"avx", "avy", "avz",
	},
	OrbitController = {
		"px", "py", "pz",
		"tx", "ty", "tz",
	},
	ta = {
		"px", "py", "pz",
		"dx", "dy", "dz",
		"height",
		"angle",
		"flipped",
		"fov",
	},
	ov = {
		"px", "py", "pz",
	},
	rot = {
		"px", "py", "pz",
		"dx", "dy", "dz",
		"rx", "ry", "rz",
		"oldHeight",
	},
	sm = {
		"px", "py", "pz",
		"dx", "dy", "dz",
		"height",
		"zscale",
		"flipped",
	},
	tw = {
		"px", "py", "pz",
		"rx", "ry", "rz",
	},
	spring = {
		"px", "py", "pz",
		"rx", "ry", "rz",
		"dx", "dy", "dz",
		"dist",
		"fov",
	},
}

local CAMERA_NAMES = {
	"fps",
	"free",
	"OrbitController",
	"ta",
	"ov",
	"rot",
	"sm",
	"tw",
	"spring",
}
local CAMERA_IDS = {}

for i=1, #CAMERA_NAMES do
	CAMERA_IDS[CAMERA_NAMES[i]] = i
end

--does not allow spaces in keys; values are numbers
local function CameraStateToPacket(s)
	
	local name = s.name
	local stateFormat = CAMERA_STATE_FORMATS[name]
	local cameraID = CAMERA_IDS[name]
	
	if not stateFormat or not cameraID then return nil end
	
	local result = PACKET_HEADER .. CustomPackU8(cameraID) .. CustomPackU8(s.mode)
	
	for i=1, #stateFormat do
		local cameraAttribute = stateFormat[i]
		local num = s[cameraAttribute]
		if not num then 
			Log('lock-camera', 'warning', "camera " .. name .. " missing attribute " .. cameraAttribute .. " in getCameraState")
			return nil 
		end
		result = result .. CustomPackF16(num)
	end
	
	return result
end

local function PacketToCameraState(p)
	local offset = PACKET_HEADER_LENGTH + 1
	local cameraID = CustomUnpackU8(p, offset)
	local mode = CustomUnpackU8(p, offset + 1)
	local name = CAMERA_NAMES[cameraID]
	local stateFormat = CAMERA_STATE_FORMATS[name]
	if not (cameraID and mode and name and stateFormat) then 
		Log('lock-camera', 'warning', "packet did not contain cameraID and mode and name and stateFormat")
		return nil 
	end
	
	local result = {
		name = name,
		mode = mode,
	}
	
	offset = offset + 2
	
	for i=1, #stateFormat do
		local num = CustomUnpackF16(p, offset)
		
		if not num then return nil end
		
		result[stateFormat[i]] = num
		offset = offset + 2
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