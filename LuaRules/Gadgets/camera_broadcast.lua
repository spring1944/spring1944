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
local keyFramePeriod = 10
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
local timeToKeyFrame

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

local Camera = VFS.Include("LuaRules/Includes/camera.lua")
local Net = VFS.Include("LuaRules/Includes/network.lua")

------------------------------------------------
--const
------------------------------------------------
local PACKET_HEADER = "="
local PACKET_HEADER_LENGTH = strLen(PACKET_HEADER)


------------------------------------------------
--callins
------------------------------------------------

function gadget:Initialize()
	myPlayerID = GetMyPlayerID()
	timeSinceBroadcast = 0
	totalTime = 0
	timeToKeyFrame = 0
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
	timeToKeyFrame = timeToKeyFrame - dt
	if timeToKeyFrame <= 0 then
		timeToKeyFrame = keyFramePeriod
	end
	if timeSinceBroadcast > broadcastPeriod then

		local state = GetCameraState()
		local msg = Camera.StateToPacket(state)

		--don't send duplicates

		if not msg then
			Log('camera-broadcast', 'error', "Error creating packet! Removing gadget.")
			GG.RemoveGadget(self)
			return
		end

		if msg ~= lastPacketSent then
			compressed = PACKET_HEADER .. Net.DeltaCompress(msg, lastPacketSent or '', timeToKeyFrame == keyFramePeriod)
			if (not isSpectator and broadcastAlliesAsPlayer) then
				SendLuaUIMsg(compressed, "a")
			end

			if (isSpectator and broadcastSpecsAsSpec)
					or (not isSpectator and broadcastSpecsAsPlayer) then
				SendLuaUIMsg(compressed, "s")
			end

			totalCharsSent = totalCharsSent + strLen(compressed)

			lastPacketSent = msg
		end

		timeSinceBroadcast = timeSinceBroadcast - broadcastPeriod
	end
end

function gadget:GameOver()
	Log('camera-broadcast', 'info', totalCharsSent .. " chars sent, " .. totalCharsRecv .. " chars received.")
end

end