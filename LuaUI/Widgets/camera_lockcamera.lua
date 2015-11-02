local versionNumber = "v2.9"

function widget:GetInfo()
	return {
		name = "LockCamera",
		desc = versionNumber .. " Allows you to lock your camera to another player's camera",
		author = "Evil4Zerggin, ashdnazg", --Also see camera_broadcast unsynced gadget
		date = "16 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = -5,
		enabled = true
	}
end

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

--recieve
local transitionTime = 1.5 --how long it takes the camera to move
local listTime = 30 --how long back to look for recent broadcasters

function widget:GetConfigData(data)
	return {
	}
end

function widget:SetConfigData(data)
end

------------------------------------------------
--vars
------------------------------------------------
local myPlayerID
local lockPlayerID
local totalTime
--playerID = {time, state}
local lastBroadcasts = {}

local myTeamID

local window0
local exitButton
local playerButtons = {}


------------------------------------------------
--speedups
------------------------------------------------
local GetCameraState = Spring.GetCameraState
local SetCameraState = Spring.SetCameraState
local GetSpectatingState = Spring.GetSpectatingState

local GetMyPlayerID = Spring.GetMyPlayerID
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamColor = Spring.GetTeamColor

local SendCommands = Spring.SendCommands

local Log = Spring.Log
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

local COLOR_REGULAR     = {1,1,1, 1}
local COLOR_SELECTED = {0.8, 0, 0, 1}

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
--helpers
------------------------------------------------

local function GetPlayerName(playerID)
	if not playerID then return "" end
	local name = GetPlayerInfo(playerID)
	return name or ""
end

------------------------------------------------
--drawing
------------------------------------------------

local function GetPlayerColor(playerID)
	local _, _, _, teamID = GetPlayerInfo(playerID)
	if (not teamID) then return nil end
	return GetTeamColor(teamID)
end

------------------------------------------------
--update
------------------------------------------------

local function UpdateButtonColors()
	for _, button in pairs (playerButtons) do
		button.font.color = button.playerID and button.playerID == lockPlayerID and COLOR_SELECTED or COLOR_REGULAR
		button.font:Invalidate()
	end
end

local function LockCamera(playerID)
	if playerID and playerID ~= myPlayerID and playerID ~= lockPlayerID then
		lockPlayerID = playerID
		local info = lastBroadcasts[lockPlayerID]
		if info then
			SetCameraState(info[2], transitionTime)
			local _, _, _, teamID = Spring.GetPlayerInfo(playerID)
			Spring.SendCommands("specteam ".. teamID)
		end
	else
		lockPlayerID = nil
	end
	UpdateButtonColors()
end


local function UpdatePlayerButtons()
	local Chili = WG.Chili
	for k,v in pairs (playerButtons) do
		playerButtons[k]:Dispose()
		playerButtons[k] = nil
	end
	local y = 20
	local _, specFullview, _ = Spring.GetSpectatingState()
	playerButtons[#playerButtons + 1] = Chili.Button:New{
		y = y, width = 80, caption = specFullview and "Viewing All" or "Viewing Team",
		OnClick = {
			function(self)
				Spring.SendCommands("specfullview ".. (specFullview and 2 or 3))
				UpdatePlayerButtons()
			end
		}
	}
	y = y + 20

	for playerID, _ in pairs(lastBroadcasts) do
		local playerName, _, _, teamID = Spring.GetPlayerInfo(playerID)
		playerButtons[#playerButtons + 1] = Chili.Button:New{
			y = y, width = 80, caption = playerName,
			backgroundColor = {Spring.GetTeamColor(teamID)},
			OnClick = {
				function(self) LockCamera(self.playerID ~= lockPlayerID and self.playerID or nil) end
			},
			playerID = playerID
		}
		y = y + 20
	end
	playerButtons[#playerButtons + 1] = Chili.Button:New{
		y = y, width = 80, caption = "Stop",
		OnClick = {
			function(self) LockCamera(nil) end
		}
	}

	UpdateButtonColors()

	for k,v in pairs (playerButtons) do
		window0:AddChild(playerButtons[k])
	end
end

local function InitGUI()
	local Chili = WG.Chili

	window0 = Chili.Window:New{
		caption = "Lock Camera",
		y = "70%",
		right = 10,
		width  = 200,
		height = 200,
		parent = Chili.Screen0,
		autosize = true,
		savespace = true,
	}

	UpdatePlayerButtons()
end

------------------------------------------------
--callins
------------------------------------------------

function widget:RecvLuaMsg(msg, playerID)
	--check header
	if strSub(msg, 1, PACKET_HEADER_LENGTH) ~= PACKET_HEADER then return end

	totalCharsRecv = totalCharsRecv + strLen(msg)

	--a packet consisting only of the header indicated that transmission has stopped
	if msg == PACKET_HEADER then
		if lastBroadcasts[playerID] then
			lastBroadcasts[playerID] = nil
		end
		if lockPlayerID == playerID then
			LockCamera(nil)
		end
		return
	end

	local cameraState = PacketToCameraState(msg)

	if not cameraState then
		Log('lock-camera', 'error', "Bad packet recieved.")
		WG.RemoveWidget(self)
		return
	end
	if not lastBroadcasts[playerID] then
		lastBroadcasts[playerID] = {totalTime, cameraState}
		UpdatePlayerButtons()
	else
		lastBroadcasts[playerID][1], lastBroadcasts[playerID][2] = totalTime, cameraState
	end


	if (playerID == lockPlayerID) then
		 SetCameraState(cameraState, transitionTime)
	end

end


function widget:Initialize()

	myPlayerID = GetMyPlayerID()
	totalTime = 0
end

function widget:Shutdown()
	if window0 then
		window0:Dispose()
	end
end

function widget:Update(dt)

	local isSpectator = GetSpectatingState()

	if isSpectator and not window0 then
		InitGUI()
	end

	totalTime = totalTime + dt
end

function widget:GameOver()
  Log('lock-camera', 'info', totalCharsSent .. " chars sent, " .. totalCharsRecv .. " chars received.")
end
