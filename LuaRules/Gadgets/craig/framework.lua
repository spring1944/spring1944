-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This file defines the following global functions:

In SYNCED code:

function gadget:Initialize()
function gadget:GameFrame(f)
function gadget:RecvLuaMsg(msg, player)

In UNSYNCED code:

function gadget:Initialize()
function GiveOrderToUnit(unitID, cmd, params, options)
TODO: function GiveOrderToUnitMap(...)
TODO: function GiveOrderToUnitArray(...)
TODO: function GiveOrderArrayToUnitMap(...)
TODO: function GiveOrderArrayToUnitArray(...)

This framework automatically chains it's gadget methods with user defined
gadget methods, so effectively both get called. In other words, you can safely
define your own (synced/unsynced) gadget:GameFrame, this framework work ensure
both it's own code as your code gets called.

Additionally, the framework examines the team list and tries to kill the gadget
whenever there are no AI teams or (for the unsynced part) when there are no AI
teams with the current player as team leader.

For this to work, the framework needs to be included at the end of the main
gadget file, and the result of the include statement needs to be returned to
the gadgetHandler.

Example:

if (not gadgetHandler:IsSyncedCode()) then

-- Your own unsynced LUA AI callins and code.
function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	Spring.Echo("UnitCreated: " .. UnitDefs[unitDefID].humanName)
end

end

-- Set up LUA AI framework.
callInList = {
	"UnitCreated",
}
return include("LuaRules/Gadgets/.../framework.lua")
]]--


local function Log(...)
	--uncomment to debug LUA AI framework code
	--Spring.Echo("LUA AI: " .. table.concat{...})
end


if (gadgetHandler:IsSyncedCode()) then

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  SYNCED
--

--speedups
local bit_and = math.bit_and
local GiveOrderToUnit = Spring.GiveOrderToUnit
local ValidUnitID = Spring.ValidUnitID
local GetUnitTeam = Spring.GetUnitTeam

-- globals
local numMessages = 0
local messageQueue = {}
--local allowedPlayers = {}
local allowedTeams = {}

gadget.team = allowedTeams


-- If no AIs are in the game, ask for a quiet death.
do
	local name = gadget:GetInfo().name
	local count = 0
	for _,t in ipairs(Spring.GetTeamList()) do
		if Spring.GetTeamLuaAI(t) == name then
			--local _,leader,_,_,_,_ = Spring.GetTeamInfo(t)
			--allowedPlayers[leader] = true
			--Log("SYNCED: allowed player: ", leader)
			allowedTeams[t] = true
			Log("SYNCED: allowed team: ", t)
			count = count + 1
		end
	end
	if count == 0 then return false end
end


local function DeserializeAndProcessMessage(msg)
	local msgpos = 1 --first byte is signature
	local msglen = msg:len()

	while (msgpos < msglen) do
		local b1, b2, b3, b4, b5 = msg:byte(msgpos+1, msgpos+5)
		msgpos = msgpos + 5

		local unitID    = b1 * 256 + b2
		local cmd       = b3 * 256 + b4 - 32768
		local options   = bit_and(b5, 240)
		local numParams = bit_and(b5, 15)

		local params = {}
		for i=1,numParams do
			b1, b2 = msg:byte(msgpos+1, msgpos+2)
			msgpos = msgpos + 2
			params[i] = b1 * 256 + b2 - 32768
		end

		-- unit may have died between SendLuaRulesMsg and GameFrame
		-- worse, a new unit might have been created with same unitID
		if ValidUnitID(unitID) and allowedTeams[GetUnitTeam(unitID)] then
			--Log("SYNCED: DeserializeAndProcessOrder: ", unitID)
			GiveOrderToUnit(unitID, cmd, params, options)
		end
	end
end

--------------------------------------------------------------------------------
--
--  The call-in routines
--

local function Initialize(self)
	Log("SYNCED: Initialize")
	-- Set up the forwarding calls to the unsynced part of the gadget.
	local SendToUnsynced = SendToUnsynced
	for _,callIn in pairs(callInList) do
		local fun = gadget[callIn]
		if (fun ~= nil) then
			gadget[callIn] = function(self, ...) fun(self, ...) SendToUnsynced(callIn, ...) end
		else
			gadget[callIn] = function(self, ...) SendToUnsynced(callIn, ...) end
		end
		gadgetHandler:UpdateCallIn(callIn)
	end
end


local function GameFrame(self)
	if (numMessages ~= 0) then
		Log("SYNCED: GameFrame: processing ", numMessages, " messages")
		for _,msg in ipairs(messageQueue) do
			DeserializeAndProcessMessage(msg)
		end
		numMessages = 0
		messageQueue = {}
	end
end


local function RecvLuaMsg(self, msg, player)
	-- Tried to check allowedPlayers[player] too but this breaks replays, and
	-- Spring.IsReplay() only returns true for hosted replays, not local ones.
	if (msg:byte() == 213) then
		Log("SYNCED: RecvLuaMsg from player ", player)
		-- it's not allowed to call GiveOrderToUnit here
		numMessages = numMessages + 1
		messageQueue[numMessages] = msg
	end
end

--------------------------------------------------------------------------------

if gadget.Initialize then
	local fun = gadget.Initialize
	gadget.Initialize = function(self) Initialize(self) return fun(self) end
else
	gadget.Initialize = Initialize
end

if gadget.GameFrame then
	local fun = gadget.GameFrame
	gadget.GameFrame = function(self, f) GameFrame(self, f) return fun(self, f) end
else
	gadget.GameFrame = GameFrame
end

if gadget.RecvLuaMsg then
	local fun = gadget.RecvLuaMsg
	gadget.RecvLuaMsg = function(self, msg, player)
		if RecvLuaMsg(self, msg, player) then return true end
		return fun(self, msg, player)
	end
else
	gadget.RecvLuaMsg = RecvLuaMsg
end

else

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  UNSYNCED
--

-- If we are not teamLeader of an AI team, ask for a quiet death.
do
	local count = 0
	local name = gadget:GetInfo().name
	local myPlayerID = Spring.GetMyPlayerID()
	for _,t in ipairs(Spring.GetTeamList()) do
		if Spring.GetTeamLuaAI(t) == name then
			local _,leader,_,_,_,_ = Spring.GetTeamInfo(t)
			if (leader == myPlayerID) then count = count + 1 end
		end
	end
	if count == 0 then return false end
end


--globals
local optionStringToNumber = {
	alt   = CMD.OPT_ALT,
	ctrl  = CMD.OPT_CTRL,
	shift = CMD.OPT_SHIFT,
	right = CMD.OPT_RIGHT,
}
local bufferSize = 1
local messageBuffer = {string.char(213)}


local function SerializeOrder(unitID, cmd, params, options)
	-- convert the table format (e.g. '{"shift"}') for options to a number
	if type(options) == "table" then
		local newOptions = 0
		for _,opt in ipairs(options) do
			newOptions = newOptions + optionStringToNumber[opt]
		end
		options = newOptions
	end

	cmd = cmd + 32768 --signed 16 bit integer range

	local b = {
		unitID / 256,
		unitID % 256,
		cmd / 256,
		cmd % 256,
		options + #params, --options are in high 4 (5) bits
	}

	for i=1,#params do
		local param = params[i] + 32768
		b[#b+1] = param / 256
		b[#b+1] = param % 256
	end

	-- NETMSG_LUAMSG    : size = 7 + msg.size() + 1 = 14 + params.size() * 2
	-- NETMSG_AICOMMAND : size = 11 + params.size() * 4

	-- So for all orders with params.size() >= 2 I'm sending less bytes over
	-- the network then LuaUnsyncedCtrl::GiveOrderToUnit would have done if it
	-- had worked :-)

	return string.char(unpack(b))
end

function GiveOrderToUnit(unitID, cmd, params, options)
	--Log("UNSYNCED: GiveOrderToUnit ", unitID)
	local status, msg = pcall(SerializeOrder, unitID, cmd, params, options)
	if not status or msg == nil then
		Log("Failed to serialize command", unitID, cmd)
		return nil
	end
	bufferSize = bufferSize + 1
	messageBuffer[bufferSize] = msg
end

--------------------------------------------------------------------------------
--
--  The call-in routines
--

local function Initialize(self)
	Log("UNSYNCED: Initialize")
	for _,callIn in pairs(callInList) do
		local fun = gadget[callIn]
		--uncomment this to trace all callIn calls
		--fun = function(name, ...) Spring.Echo("UNSYNCED: " .. name) gadget[callIn](name, ...) end
		gadgetHandler:AddSyncAction(callIn, fun)
	end
end


local function GameFrame(self, f)
	if (bufferSize ~= 1) then
		Log("UNSYNCED: GameFrame: sending ", bufferSize - 1, " orders")
		Spring.SendLuaRulesMsg(table.concat(messageBuffer))
		bufferSize = 1
		messageBuffer = {string.char(213)}
	end
end

--------------------------------------------------------------------------------

if gadget.Initialize then
	local fun = gadget.Initialize
	gadget.Initialize = function(self) Initialize(self) return fun(self) end
else
	gadget.Initialize = Initialize
end

if gadget.GameFrame then
	local fun = gadget.GameFrame
	-- Call the user GameFrame first, and only then the framework GameFrame.
	-- This way as much orders can be combined into a single message as possible,
	-- assuming sometime orders will be given from inside the user GameFrame.
	gadget.GameFrame = function(self, f) fun(self, f) return GameFrame(self, f) end
else
	gadget.GameFrame = GameFrame
end

end
