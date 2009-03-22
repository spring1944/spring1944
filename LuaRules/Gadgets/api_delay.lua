local versionNumber = "v1.0"

function gadget:GetInfo()
	return {
		name      = "Delay API",
		desc      = versionNumber .. " Allows delaying of function calls.",
		author    = "Evil4Zerggin",
		date      = "21 March 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -10000,
		enabled   = true  --  loaded by default?
	}
end

--[[
DOCUMENTATION:
 * This is synced only.
 * Use by calling GG.Delay.DelayCall(f, args, delay).
 * Will call f with arguments equal to args after delay frames (but at least 1).
 * Arguments are evaluated when DelayCall is called, not when the delayed call executes.
]]

--synced only
if not gadgetHandler:IsSyncedCode() then return end

local floor = math.floor

local currentFrame = 0

--index = {call, call...}
local calls = {}

local function DelayCall(f, args, delay)
	if delay < 1 then
		delay = 1
	else
		delay = floor(delay)
	end
	
	local targetFrame = currentFrame + delay
	
	if not calls[targetFrame] then
		calls[targetFrame] = {}
	end
		
	local frameCalls = calls[targetFrame]
	
	frameCalls[#frameCalls+1] = {f, args}
end

function gadget:GameFrame(n)
	local frameCalls = calls[n]
	if frameCalls then
		for i=1,#frameCalls do
			local currCall = frameCalls[i]
			currCall[1](unpack(currCall[2]))
		end
		--delete
		calls[n] = nil
	end
	currentFrame = n
end

GG.Delay = {
	DelayCall = DelayCall,
}
