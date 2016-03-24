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

--recieve
local transitionTime = 1.5 --how long it takes the camera to move

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

local Camera = VFS.Include("LuaRules/Includes/camera.lua")
local Net = VFS.Include("LuaRules/Includes/network.lua")

------------------------------------------------
--const
------------------------------------------------
local PACKET_HEADER = "="
local PACKET_HEADER_LENGTH = strLen(PACKET_HEADER)

local COLOR_REGULAR     = {1,1,1, 1}
local COLOR_SELECTED = {0.8, 0, 0, 1}

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
			SetCameraState(info[2])
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
	local data = msg:sub(1 + PACKET_HEADER_LENGTH)
	data = Net.DeltaDecompress(data, lastBroadcasts[playerID] and lastBroadcasts[playerID][3])
	if not data then
		return
	end
	local cameraState = Camera.PacketToState(data)

	if not cameraState then
		Log('lock-camera', 'error', "Bad packet recieved.")
		WG.RemoveWidget(self)
		return
	end
	if not lastBroadcasts[playerID] then
		lastBroadcasts[playerID] = {totalTime, cameraState, data}
		UpdatePlayerButtons()
	else
		lastBroadcasts[playerID][1], lastBroadcasts[playerID][2], lastBroadcasts[playerID][3] = totalTime, cameraState, data
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
