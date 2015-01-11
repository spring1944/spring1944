local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
local gun = piece "gun"
local ground = piece "ground"
local flare = piece "flare"

local luparm = piece "luparm"
local lloarm = piece "lloarm"

local ruparm = piece "ruparm"
local rloarm = piece "rloarm"

local lthigh = piece "lthigh"
local lleg = piece "lleg"
local lfoot = piece "lfoot"

local rthigh = piece "rthigh"
local rleg = piece "rleg"
local rfoot = piece "rfoot"

local DEFAULT_TURN_SPEED = math.rad(300)
local DEFAULT_MOVE_SPEED = 100


local function Concat(t1, t2)
	local c = {}
	if t1 then
		for _, v in pairs(t1) do c[#c + 1] = v end
	end
	if t2 then
		for _, v in pairs(t2) do c[#c + 1] = v end
	end
	return c
end

local function Merge(t1, t2)
	local merged = {}
	local l = math.max(#t1, #t2)
	for i = 1,l do
		merged[i] = Concat(t1[i], t2[i])
	end
	return merged
end

local anims, variants, keyframes, keyframeDelays = include "anims/base.lua"

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

local function RebaseManipulationData(base, data)
	for p, axes in pairs(base) do
		for axis, baseValue in pairs(axes) do
			if not data[p] then
				data[p] = {[axis] = baseValue}
			elseif not data[p][axis] then
				data[p][axis] = baseValue
			end
		end
	end
end

local poses = {}
local poseVariants = {}
local poseNames = {}
local function CreatePose(base, action, poseName)
	local pVariants = {}
	local i = 1
	for _, baseStance in pairs(base) do
		for _, actionStance in pairs(action) do
			local baseTurnData, baseMoveData = GetStanceManipulationData(baseStance)
			local actionTurnData, actionMoveData = GetStanceManipulationData(actionStance)
			RebaseManipulationData(baseTurnData, actionTurnData)
			RebaseManipulationData(baseMoveData, actionMoveData)
			local turns = GetManipulationArray(actionTurnData)
			local moves = GetManipulationArray(actionMoveData)
			 poses[#poses + 1] = {   turns = turns,
									 moves = moves,
									 headingTurn = actionStance.headingTurn, 
									 pitchTurn = actionStance.pitchTurn,
									 anim = actionStance.anim or baseStance.anim}
			pVariants[#pVariants + 1] = #poses
			poseNames[#poses] = poseName .. i
			i = i + 1
		end
	end
	poseVariants[poseName] = pVariants
end

local numWeapons = 0
local weaponsTags = {}
local weaponsKeyFrames = {}
local weaponsKeyFrameDelays = {}

for weaponNum, weaponAnim in pairs(GG.lusHelper[unitDefID].weaponAnimations) do
	if not VFS.FileExists("scripts/anims/" .. weaponAnim .. ".lua") then
		weaponAnim = "rifle"
	end
	local weaponTags, weaponVariants, weaponKeyFrames, weaponKeyFrameDelays = include("anims/" .. weaponAnim .. ".lua")
	numWeapons = numWeapons + 1
	if weaponVariants.stand_ready then
		CreatePose(variants.stand_base, weaponVariants.stand_ready, "stand_ready")
	end
	if weaponVariants.prone_ready then
		CreatePose(variants.prone_base, weaponVariants.prone_ready, "prone_ready")
	end
	if weaponVariants.run_ready then
		CreatePose(variants.run_base, weaponVariants.stand_ready, "run_ready")
	end
	if weaponVariants.stand_aim then
		CreatePose(variants.stand_base, weaponVariants.stand_aim, "stand_aim" .. weaponNum)
	end
	if weaponVariants.prone_aim then
		CreatePose(variants.prone_base, weaponVariants.prone_aim, "prone_aim" .. weaponNum)
	end
	if weaponVariants.run_aim then
		for _, stance in pairs(weaponVariants.run_aim) do
			stance.anim = anims.run_aim
		end
		CreatePose(variants.run_base, weaponVariants.run_aim, "run_aim" .. weaponNum)
	end
	weaponsTags[weaponNum] = weaponTags
	weaponsKeyFrames[weaponNum] = weaponKeyFrames or {}
	weaponsKeyFrameDelays[weaponNum] = weaponKeyFrameDelays or {}
end



CreatePose(variants.null, variants.crawl, "crawl")
CreatePose(variants.null, variants.pinned, "pinned")


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
		Spring.Echo("Error: bad parameters for transition", startPoseID, endPoseID, #intermediateStances, #delays)
	end
	local affectedPieces = {}
	local currentTurnData, currentMoveData = GetStanceManipulationData(poses[startPoseID])
	local transition = {}
	currentTurnData, currentMoveData = FlattenArray(currentTurnData, currentMoveData, intermediateStances, transition, delays)
	local endTurnData, endMoveData = GetStanceManipulationData(poses[endPoseID])
	local endPose = poses[endPoseID]
	local headingTurn = endPose.headingTurn
	
	if headingTurn then
		--Spring.Echo("heading in", poseNames[endPoseID])
		headingTurn = {unpack(headingTurn)}
		headingTurn[#headingTurn + 1] = DEFAULT_TURN_SPEED
		--Spring.Echo(unpack(headingTurn))
	end
	local pitchTurn = endPose.pitchTurn
	if pitchTurn then
		--Spring.Echo("pitch in", poseNames[endPoseID])
		pitchTurn = {unpack(pitchTurn)}
		pitchTurn[#pitchTurn + 1] = DEFAULT_TURN_SPEED
		--Spring.Echo(unpack(pitchTurn))
	end
	
	local lastDelay = delays[#delays]
	local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, endTurnData, endMoveData, lastDelay)
	
	
	 transition[#transition + 1] = {duration = lastDelay * 1000,
									turns = turns,
									moves = moves,
									headingTurn = headingTurn, 
									pitchTurn = pitchTurn,
									anim = endPose.anim}
	
	return transition
end

local transitions = {}
local fireTransitions = {}

local function CreateVariantTransitions(transitionsMap, startVariant, endVariant, intermediateStances, delays)
	if not intermediateStances then
		intermediateStances = keyframes.default
	end
	if not delays then
		delays = keyframeDelays.default
	end
	if startVariant ~= endVariant then
		for _, startPoseID in pairs(startVariant) do
			for _, endPoseID in pairs(endVariant) do
				local transition = CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
				if not transitionsMap[startPoseID] then
					transitionsMap[startPoseID] = {[endPoseID] = transition}
				else
					transitionsMap[startPoseID][endPoseID] = transition
				end
			end
		end
	else
		for _, startPoseID in pairs(startVariant) do
			local transition = CreateTransition(startPoseID, intermediateStances, startPoseID, delays)
			if not transitionsMap[startPoseID] then
				transitionsMap[startPoseID] = {[startPoseID] = transition}
			else
				transitionsMap[startPoseID][startPoseID] = transition
			end
		end
	end
end

CreateVariantTransitions(transitions, poseVariants.stand_ready, poseVariants.stand_ready)
CreateVariantTransitions(transitions, poseVariants.stand_ready, poseVariants.prone_ready, keyframes.stand_to_prone, keyframeDelays.stand_to_prone)
CreateVariantTransitions(transitions, poseVariants.stand_ready, poseVariants.run_ready)

CreateVariantTransitions(transitions, poseVariants.prone_ready, poseVariants.stand_ready, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
CreateVariantTransitions(transitions, poseVariants.prone_ready, poseVariants.prone_ready)
CreateVariantTransitions(transitions, poseVariants.prone_ready, poseVariants.crawl)
CreateVariantTransitions(transitions, poseVariants.prone_ready, poseVariants.pinned)

CreateVariantTransitions(transitions, poseVariants.run_ready, poseVariants.stand_ready)
CreateVariantTransitions(transitions, poseVariants.run_ready, poseVariants.run_ready)

CreateVariantTransitions(transitions, poseVariants.crawl, poseVariants.prone_ready)

CreateVariantTransitions(transitions, poseVariants.pinned, poseVariants.prone_ready)
Spring.Echo(numWeapons)
for i = 1, numWeapons do
	local tags = weaponsTags[i]
	if tags.canStandFire then
		CreateVariantTransitions(transitions, poseVariants.stand_ready, poseVariants["stand_aim" .. i], weaponsKeyFrames[i].ready_to_aim, weaponsKeyFrames[i].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["stand_aim" .. i], poseVariants.stand_ready, weaponsKeyFrames[i].aim_to_ready, weaponsKeyFrames[i].aim_to_ready)
	end
	if tags.canProneFire then
		CreateVariantTransitions(transitions, poseVariants.prone_ready, poseVariants["prone_aim" .. i], weaponsKeyFrames[i].ready_to_aim, weaponsKeyFrames[i].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["prone_aim" .. i], poseVariants.prone_ready, weaponsKeyFrames[i].aim_to_ready, weaponsKeyFrames[i].aim_to_ready)
	end
	if tags.canRunFire then
		CreateVariantTransitions(transitions, poseVariants.run_ready, poseVariants["run_aim" .. i], weaponsKeyFrames[i].ready_to_aim, weaponsKeyFrames[i].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["run_aim" .. i], poseVariants.run_ready, weaponsKeyFrames[i].aim_to_ready, weaponsKeyFrames[i].aim_to_ready)
	end
	if weaponsTags[i].aimOnLoaded then
		if tags.canStandFire then
			CreateVariantTransitions(fireTransitions, poseVariants["stand_aim" .. i], poseVariants.stand_ready, weaponsKeyFrames[i].stand_fire, weaponsKeyFrameDelays[i].stand_fire)
		end
		if tags.canProneFire then
			CreateVariantTransitions(fireTransitions, poseVariants["prone_aim" .. i], poseVariants.prone_ready, weaponsKeyFrames[i].prone_fire, weaponsKeyFrameDelays[i].prone_fire)
		end
		if tags.canRunFire then
			CreateVariantTransitions(fireTransitions, poseVariants["run_aim" .. i], poseVariants.run_ready, weaponsKeyFrames[i].run_fire, weaponsKeyFrameDelays[i].run_fire)
		end
	else
		if tags.canStandFire then
			CreateVariantTransitions(fireTransitions, poseVariants["stand_aim" .. i], poseVariants["stand_aim" .. i], weaponsKeyFrames[i].stand_fire, weaponsKeyFrameDelays[i].stand_fire)
		end
		if tags.canProneFire then
			CreateVariantTransitions(fireTransitions, poseVariants["prone_aim" .. i], poseVariants["prone_aim" .. i], weaponsKeyFrames[i].prone_fire, weaponsKeyFrameDelays[i].prone_fire)
		end
		if tags.canRunFire then
			CreateVariantTransitions(fireTransitions, poseVariants["run_aim" .. i], poseVariants["run_aim" .. i], weaponsKeyFrames[i].run_fire, weaponsKeyFrameDelays[i].run_fire)
		end
	end
end

return poses, poseVariants, anims, transitions, fireTransitions, weaponsTags