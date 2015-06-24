local versionNumber = "v2.9"

function widget:GetInfo()
	return {
		name = "LockCamera",
		desc = versionNumber .. " Allows you to lock your camera to another player's camera",
		author = "Evil4Zerggin, updated to Chili by ashdnazg", --Also see camera_broadcast unsynced gadget
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

local Echo = Spring.Echo
local Log = Spring.Log
local strGMatch = string.gmatch
local strSub = string.sub
local strLen = string.len
local strByte = string.byte
local strChar = string.char

local floor = math.floor

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glText = gl.Text
local glShape = gl.Shape

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale

local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_LINE_STRIP = GL.LINE_STRIP

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
		button.backgroundColor = button.playerID and button.playerID == lockPlayerID and COLOR_SELECTED or COLOR_REGULAR
		button:Invalidate()
	end
end

local function LockCamera(playerID)
	if playerID and playerID ~= myPlayerID and playerID ~= lockPlayerID then
		lockPlayerID = playerID
		local info = lastBroadcasts[lockPlayerID]
		if info then
			SetCameraState(info[2], transitionTime)
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
	for playerID, _ in pairs(lastBroadcasts) do
		local playerName, _, spec, teamID = Spring.GetPlayerInfo(playerID)
		playerButtons[#playerButtons + 1] = Chili.Button:New{
			y = y, width = 80, caption = playerName, 
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
		lastBroadcasts[playerID] = {totalTime, cameraState}
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
