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

local anims, variants, keyframes, keyframeDelays = include "anims/infantry/base.lua"

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

local weaponsTags = {}
local weaponsKeyFrames = {}
local weaponsKeyFrameDelays = {}

local weaponsMap = {}
local weaponsPriorities = {}

local mainAnim = GG.lusHelper[unitDefID].mainAnimation

local function CreateMainPoses(mainVariants)
	for name, mainVariant in pairs(mainVariants) do
		CreatePose(variants[name .. "_base"] or variants.null, mainVariant, name)
	end
end

if mainAnim then
	local mainTags, mainVariants, mainKeyFrames, mainKeyFrameDelays = include("anims/infantry/" .. mainAnim .. ".lua")
	CreateMainPoses(mainVariants)

	weaponsTags[mainAnim] = mainTags
	weaponsKeyFrames[mainAnim] = mainKeyFrames or {}
	weaponsKeyFrameDelays[mainAnim] = mainKeyFrameDelays or {}
end

for weaponNum, weaponAnim in pairs(GG.lusHelper[unitDefID].weaponAnimations) do
	if not VFS.FileExists("scripts/anims/infantry/" .. weaponAnim .. ".lua") then
		weaponAnim = "rifle"
	end
	weaponsMap[weaponNum] = weaponAnim
	if not weaponsTags[weaponAnim] then
		local weaponTags, weaponVariants, weaponKeyFrames, weaponKeyFrameDelays = include("anims/infantry/" .. weaponAnim .. ".lua")
		weaponsPriorities[weaponAnim] = weaponNum
		if not mainAnim then
			CreateMainPoses(weaponVariants)
		end
		if weaponVariants.stand_aim then
			CreatePose(variants.stand_base, weaponVariants.stand_aim, "stand_aim_" .. weaponAnim)
		end
		if weaponVariants.prone_aim then
			CreatePose(variants.prone_base, weaponVariants.prone_aim, "prone_aim_" .. weaponAnim)
		end
		if weaponVariants.run_aim then
			for _, stance in pairs(weaponVariants.run_aim) do
				stance.anim = anims.run_aim
			end
			CreatePose(variants.run_base, weaponVariants.run_aim, "run_aim_" .. weaponAnim)
		end

		weaponsTags[weaponAnim] = weaponTags
		weaponsKeyFrames[weaponAnim] = weaponKeyFrames or {}
		weaponsKeyFrameDelays[weaponAnim] = weaponKeyFrameDelays or {}
	end
end


if not poseVariants.crawl then
	CreatePose(variants.null, variants.crawl, "crawl")
end
if not poseVariants.pinned then
	CreatePose(variants.null, variants.pinned, "pinned")
end
if UnitDefs[unitDefID].isBuilder and not poseVariants.build then
	CreatePose(variants.stand_base, variants.build, "build")
end

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
						 moves = moves,
						 emit = stance.emit}
		ApplyManipulationData(currentTurnData, tData)
		ApplyManipulationData(currentMoveData, tData)
	end
	return currentTurnData, currentMoveData
end

local function CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
	if #intermediateStances + 1 ~= #delays then
		Spring.Log("infantry script loader", "error","bad parameters for transition " .. startPoseID .. " " .. endPoseID .. " " .. #intermediateStances .. " " .. #delays)
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
	local anim = endPose.anim
	if anim then
		for i = 1, #transition do
			transition[i].anim = endPose.anim
		end
	end
	
	local lastDelay = delays[#delays]
	local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, endTurnData, endMoveData, lastDelay)

	transition[#transition + 1] = {duration = lastDelay * 1000,
									turns = turns,
									moves = moves,
									headingTurn = headingTurn, 
									pitchTurn = pitchTurn,
									anim = endPose.anim,
									emit = endPose.emit}
	
	return transition
end

local transitions = {}
local fireTransitions = {}

local function CreateVariantTransitions(transitionsMap, startVariant, endVariant, intermediateStances, delays)
	if not (startVariant and endVariant) then
		return
	end
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

--CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.stand)
CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.prone, keyframes.stand_to_prone, keyframeDelays.stand_to_prone)
CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.run)

if UnitDefs[unitDefID].isBuilder then
	CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.build)
	CreateVariantTransitions(transitions, poseVariants.build, poseVariants.stand)
end


CreateVariantTransitions(transitions, poseVariants.prone, poseVariants.stand, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
--CreateVariantTransitions(transitions, poseVariants.prone, poseVariants.prone)
CreateVariantTransitions(transitions, poseVariants.prone, poseVariants.crawl)
CreateVariantTransitions(transitions, poseVariants.prone, poseVariants.pinned)

CreateVariantTransitions(transitions, poseVariants.run, poseVariants.stand)
--CreateVariantTransitions(transitions, poseVariants.run, poseVariants.run)

CreateVariantTransitions(transitions, poseVariants.crawl, poseVariants.prone)

CreateVariantTransitions(transitions, poseVariants.pinned, poseVariants.prone)

for weaponAnim, tags in pairs(weaponsTags) do
	if tags.canStandFire then
		CreateVariantTransitions(transitions, poseVariants.stand, poseVariants["stand_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].ready_to_aim, weaponsKeyFrames[weaponAnim].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["stand_aim_" .. weaponAnim], poseVariants.stand, weaponsKeyFrames[weaponAnim].aim_to, weaponsKeyFrames[weaponAnim].aim_to)
	end
	if tags.canProneFire then
		CreateVariantTransitions(transitions, poseVariants.prone, poseVariants["prone_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].ready_to_aim, weaponsKeyFrames[weaponAnim].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["prone_aim_" .. weaponAnim], poseVariants.prone, weaponsKeyFrames[weaponAnim].aim_to, weaponsKeyFrames[weaponAnim].aim_to)
	end
	if tags.canRunFire then
		CreateVariantTransitions(transitions, poseVariants.run, poseVariants["run_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].ready_to_aim, weaponsKeyFrames[weaponAnim].ready_to_aim)
		CreateVariantTransitions(transitions, poseVariants["run_aim_" .. weaponAnim], poseVariants.run, weaponsKeyFrames[weaponAnim].aim_to, weaponsKeyFrames[weaponAnim].aim_to)
	end
	if weaponsTags[weaponAnim].aimOnLoaded then
		if tags.canStandFire then
			CreateVariantTransitions(fireTransitions, poseVariants["stand_aim_" .. weaponAnim], poseVariants.stand, weaponsKeyFrames[weaponAnim].stand_fire, weaponsKeyFrameDelays[weaponAnim].stand_fire)
		end
		if tags.canProneFire then
			CreateVariantTransitions(fireTransitions, poseVariants["prone_aim_" .. weaponAnim], poseVariants.prone, weaponsKeyFrames[weaponAnim].prone_fire, weaponsKeyFrameDelays[weaponAnim].prone_fire)
		end
		if tags.canRunFire then
			CreateVariantTransitions(fireTransitions, poseVariants["run_aim_" .. weaponAnim], poseVariants.run, weaponsKeyFrames[weaponAnim].run_fire, weaponsKeyFrameDelays[weaponAnim].run_fire)
		end
	else
		if tags.canStandFire then
			CreateVariantTransitions(fireTransitions, poseVariants["stand_aim_" .. weaponAnim], poseVariants["stand_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].stand_fire, weaponsKeyFrameDelays[weaponAnim].stand_fire)
		end
		if tags.canProneFire then
			CreateVariantTransitions(fireTransitions, poseVariants["prone_aim_" .. weaponAnim], poseVariants["prone_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].prone_fire, weaponsKeyFrameDelays[weaponAnim].prone_fire)
		end
		if tags.canRunFire then
			CreateVariantTransitions(fireTransitions, poseVariants["run_aim_" .. weaponAnim], poseVariants["run_aim_" .. weaponAnim], weaponsKeyFrames[weaponAnim].run_fire, weaponsKeyFrameDelays[weaponAnim].run_fire)
		end
	end
end

-- Add poses when the soldier is sheltered in a gun
-- ================================================
local noningunposes = {}
for _, pose in pairs(poseVariants) do
    noningunposes[#noningunposes + 1] = pose
end
local gvariants = include "anims/infantry/ingun.lua"
for varName, varVal in pairs(gvariants) do
    CreatePose(variants.null, varVal, varName .. "_ingun")
    -- Create all the possible transitions with non-ingun poses
    for _, pose in pairs(noningunposes) do
        CreateVariantTransitions(transitions, poseVariants[varName .. "_ingun"], pose)
        CreateVariantTransitions(transitions, pose, poseVariants[varName .. "_ingun"])
    end
end

CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.run_ingun)
CreateVariantTransitions(transitions, poseVariants.run, poseVariants.stand_ingun)

CreateVariantTransitions(transitions, poseVariants.stand_ingun, poseVariants.run_ingun)
CreateVariantTransitions(transitions, poseVariants.run_ingun, poseVariants.stand_ingun)

CreateVariantTransitions(transitions, poseVariants.stand_ingun, poseVariants.prone_ingun)
CreateVariantTransitions(transitions, poseVariants.prone_ingun, poseVariants.stand_ingun)

CreateVariantTransitions(transitions, poseVariants.prone_ingun, poseVariants.crawl_ingun)
CreateVariantTransitions(transitions, poseVariants.crawl_ingun, poseVariants.prone_ingun)

CreateVariantTransitions(transitions, poseVariants.prone_ingun, poseVariants.pinned_ingun)
CreateVariantTransitions(transitions, poseVariants.pinned_ingun, poseVariants.prone_ingun)

CreateVariantTransitions(transitions, poseVariants.stand, poseVariants.stand_ingun)
CreateVariantTransitions(transitions, poseVariants.stand_ingun, poseVariants.stand)

CreateVariantTransitions(transitions, poseVariants.prone, poseVariants.prone_ingun)
CreateVariantTransitions(transitions, poseVariants.prone_ingun, poseVariants.prone)

CreateVariantTransitions(transitions, poseVariants.pinned, poseVariants.pinned_ingun)
CreateVariantTransitions(transitions, poseVariants.pinned_ingun, poseVariants.pinned)


-- Compile everything
-- ==================
local info = GG.lusHelper[unitDefID]

info.animation = {poses, poseVariants, anims, transitions, fireTransitions, weaponsTags, weaponsMap, weaponsPriorities}
info.cegPieces = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)
local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	local weaponClass = weaponsMap[weaponNum]
	local tags = weaponsTags[weaponClass]
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
	info.customAnims = include("anims/infantry/" .. info.customAnimsName .. ".lua")
end
