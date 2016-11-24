
local DEFAULT_TURN_SPEED = math.rad(300)
local DEFAULT_MOVE_SPEED = 100

local function GetManipulationData(manipulationArray)
	local data = {}
	if not manipulationArray then
		return data
	end
	for _, params in pairs(manipulationArray) do
		local p, axis, target = unpack(params)
		if not data[p] then
			data[p] = {}
		end
		data[p][axis] = target
	end
	return data
end 

local function GetManipulationArray(manipulationData)
	local manipulationArray = {}
	for p, axes in pairs(manipulationData) do
		for axis, value in pairs(axes) do
			manipulationArray[#manipulationArray + 1] = {p, axis, value}
		end
	end
	return manipulationArray
end 

local function GetStanceManipulationData(manipulationArrays, deb)
	local tData = GetManipulationData(manipulationArrays.turns, deb)
	local mData = GetManipulationData(manipulationArrays.moves, deb)
	GetManipulationArray(tData)
	return tData, mData
end



local function ApplyManipulationData(base, data)
	for p, axes in pairs(data) do
		for axis, dataValue in pairs(axes) do
			if base[p] and base[p][axis] then
				base[p][axis] = dataValue
			end
		end
	end
end

local mainAnim = GG.lusHelper[unitDefID].mainAnimation
local tags, poses, keyframes, keyframeDelays = include("anims/deployed/" .. mainAnim .. ".lua")


local PI = math.pi
local TAU = 2 * PI



local function GetTurnDiff(f, t)
	if f and t then
		local diff = t - f
		if diff > PI then
			diff = TAU - diff
		end
		if diff < -PI then
			diff = diff + TAU
		end
		return math.abs(diff)
	end
end

local function CreateTransitionFrame(fromTurnData, fromMoveData, toTurnData, toMoveData, duration)

	local transitionTurns = {}
	
	for p, axes in pairs(toTurnData) do
		for axis, toValue in pairs(axes) do
			if fromTurnData[p] and fromTurnData[p][axis] then
				local fromValue = fromTurnData[p][axis]
				local diff = GetTurnDiff(fromValue, toValue)
				if diff > 0 then
					transitionTurns[#transitionTurns + 1] = {p, axis, toValue, diff / duration}
				else
					transitionTurns[#transitionTurns + 1] = {p, axis, toValue, DEFAULT_TURN_SPEED}
				end
			else
				transitionTurns[#transitionTurns + 1] = {p, axis, toValue, DEFAULT_TURN_SPEED}
			end
		end
	end
	
	local transitionMoves = {}
	
	for p, axes in pairs(toMoveData) do
		for axis, toValue in pairs(axes) do
			if fromMoveData[p] and fromMoveData[p][axis] then
				local fromValue = fromMoveData[p][axis]
				local diff = math.abs(toValue - fromValue)
				if diff > 0 then
					transitionMoves[#transitionMoves + 1] = {p, axis, toValue, diff / duration}
				else
					transitionMoves[#transitionMoves + 1] = {p, axis, toValue, DEFAULT_MOVE_SPEED}
				end
			else
				transitionMoves[#transitionMoves + 1] = {p, axis, toValue, DEFAULT_MOVE_SPEED}
			end
		end
	end
	
	if #transitionTurns == 0 then
		transitionTurns = nil
	end
	if #transitionMoves == 0 then
		transitionMoves = nil
	end
	
	return transitionTurns, transitionMoves
end

local function FlattenArray(startTurnData, startMoveData, stancesArray, transition, delays)
	local currentTurnData = startTurnData
	local currentMoveData = startMoveData
	
	for _, stance in pairs(stancesArray) do
		local tData, mData = GetStanceManipulationData(stance)
		local i = #transition + 1
		local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, tData, mData, delays[i])
		transition[i] = {duration = delays[i] * 1000, 
						 turns = turns,
						 moves = moves}
		ApplyManipulationData(currentTurnData, tData)
		ApplyManipulationData(currentMoveData, tData)
	end
	return currentTurnData, currentMoveData
end

local function CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
	if #intermediateStances + 1 ~= #delays then
		Spring.Log("deployed script loader", "error","bad parameters for transition " .. startPoseID .. " " .. endPoseID .. " " .. #intermediateStances .. " " .. #delays)
	end
	local affectedPieces = {}
	local currentTurnData, currentMoveData = GetStanceManipulationData(poses[startPoseID])
	local transition = {}
	currentTurnData, currentMoveData = FlattenArray(currentTurnData, currentMoveData, intermediateStances, transition, delays)
	local endTurnData, endMoveData = GetStanceManipulationData(poses[endPoseID])
	local endPose = poses[endPoseID]
	
	local anim = endPose.anim
	if anim then
		for i = 1, #transition do
			transition[i].anim = endPose.anim
		end
	end
	
	local lastDelay = delays[#delays]
	local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, endTurnData, endMoveData, lastDelay)
	local anim = endPose.anim
	
	transition[#transition + 1] = {duration = lastDelay * 1000,
									turns = turns,
									moves = moves,
									anim = endPose.anim}
	
	return transition
end

local function AddTransition(transitionsMap, startPoseID, endPoseID, intermediateStances, delays)
	if not intermediateStances then
		intermediateStances = {}
	end
	if not delays then
		delays = {0.1}
	end
	local transition = CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
	if not transitionsMap[startPoseID] then
		transitionsMap[startPoseID] = {[endPoseID] = transition}
	else
		transitionsMap[startPoseID][endPoseID] = transition
	end
end

local transitions = {}
local fireTransitions = {}

AddTransition(transitions, "ready", "pinned", keyframes.ready_to_pinned, keyframeDelays.ready_to_pinned)
AddTransition(transitions, "pinned", "ready", keyframes.pinned_to_ready, keyframeDelays.pinned_to_ready)

if poses.run then
	AddTransition(transitions, "ready", "run", keyframeDelays.ready_to_run)
	AddTransition(transitions, "run", "ready", keyframeDelays.run_to_ready)
end


AddTransition(fireTransitions, "ready", "ready", keyframes.fire, keyframeDelays.fire)

local info = GG.lusHelper[unitDefID]

info.animation = {poses, transitions, fireTransitions, tags}
info.cegPieces = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)
local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	if info.reloadTimes[weaponNum] then -- don't want any shields etc.
		if tags.cegPiece then
			info.cegPieces[weaponNum] = tags.cegPiece
		else
			lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
			info.cegPieces[weaponNum] = pieceMap[lastflare]
		end
	end
end

if info.customAnimsName then
	info.customAnims = include("anims/deployed/" .. info.customAnimsName .. ".lua")
end