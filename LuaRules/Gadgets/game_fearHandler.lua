function gadget:GetInfo()
	return {
		name      = "Infantry Suppression",
		desc      = "Lua Implementation of fear weapons causing suppression",
		author    = "FLOZi",
		date      = "13 October 2008", -- Happy Birthday Charlie!
		license   = "GNU GPL v2",
		layer     = 2, -- must run after LUS
		enabled   = true
	}
end

-- function localisations
-- Synced Read
local GetCOBScriptID			= Spring.GetCOBScriptID
local GetUnitAllyTeam			= Spring.GetUnitAllyTeam
local GetUnitDefID       		= Spring.GetUnitDefID
local GetUnitIsDead 			= Spring.GetUnitIsDead
local GetUnitsInSphere			= Spring.GetUnitsInSphere
local ValidUnitID				= Spring.ValidUnitID
local GetUnitRulesParam			= Spring.GetUnitRulesParam
local GetUnitPosition			= Spring.GetUnitPosition
local GetTeamInfo				= Spring.GetTeamInfo

-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local SetUnitExperience			= Spring.SetUnitExperience
local SetUnitRulesParam 		= Spring.SetUnitRulesParam

-- constants
local MORALE_RADIUS = 150
local FEAR_IDS = 	{["301"] = 2, --small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
					 ["401"] = 4, --small/med explosions: mortars, 88mm guns and under
					 ["501"] = 8, --large explosions: small bombs, 155mm - 105mm guns
					 ["601"] = 16, --omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty}
					 ["701"] = 2  --a hack for aircraft fear, should be merged with 301 at some point.
					}
local DEFAULT_PRONE_SPHERE_MOVE_MULT = 0.4

-- variables
local cobScriptIDs = {}
local lusScriptIDs = {}

local restoreCOBScriptIDs = {}
local restorelusScriptIDs = {}

local collisionUpdated = {}

local fearShields = {}
local targets = {}
local tLength = 0

local blockAllyTeams = {}

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local function UpdateCollision(unitID, direction)
	local unitDef = UnitDefs[Spring.GetUnitDefID(unitID)]
	
	-- filter out static units like MG nests and AA/AT posts
	if (unitDef.speed > 0) then
		
		-- filter out repeated calls on units already in proper state
		if ((collisionUpdated[unitID] and direction == 1) or (collisionUpdated[unitID] == nil and direction == -1)) then
			local sphereMult = unitDef.customParams.pronespheremovemult or DEFAULT_PRONE_SPHERE_MOVE_MULT
			
			-- hitsphere update 
			local scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ, volumeType, testType, primaryAxis = Spring.GetUnitCollisionVolumeData(unitID)
			Spring.SetUnitCollisionVolumeData(unitID, scaleX, scaleY, scaleZ, offsetX, offsetY + direction * scaleY * sphereMult, offsetZ, volumeType, testType, primaryAxis)
			
			-- ! it is not possible to play with the aim pos because it setting mid pos via Spring.SetUnitMidAndAimPos will reset the animation script
			-- enemies aiming to old position will still hit
			
			-- inverting between "nil" and "true" 
			-- better than "true" and "false" because the table is shorter for per frame iteration below
			if (collisionUpdated[unitID] == nil) then
				collisionUpdated[unitID] = true 
			else 
				collisionUpdated[unitID] = nil 
			end
		end
	end
end

local function UpdateSuppressionCOB(unitID)

	local unitInSmoke = GetUnitRulesParam(unitID, "smoked") == 1 
	if unitInSmoke then
		if restoreCOBScriptIDs[unitID] then
			CallCOBScript(unitID, restoreCOBScriptIDs[unitID], 0)
		end
	else
		local unitAllyTeam = GetUnitAllyTeam(unitID)
		local ux, uy, uz = GetUnitPosition(unitID)
		local nearbyUnits = GetUnitsInSphere(ux, uy, uz, MORALE_RADIUS)
		for i = 1, #nearbyUnits do
			if nearbyUnits[i] ~= unitID then
				local nearbyUnitAllyTeam = GetUnitAllyTeam(nearbyUnits[i])
				local nearbyUD = UnitDefs[GetUnitDefID(nearbyUnits[i])]
				if nearbyUD.customParams.blockfear == "1" and (unitAllyTeam == nearbyUnitAllyTeam) then
					if restoreCOBScriptIDs[unitID] then
						CallCOBScript(unitID, restoreCOBScriptIDs[unitID], 0)
					end
					break
				end
			end
		end
	end
	
	local _, currFear = CallCOBScript(unitID, cobScriptIDs[unitID], 1, 1)
	SetUnitRulesParam(unitID, "fear", currFear)
end

local function UpdateSuppressionLUS(unitID)
	if Spring.ValidUnitID(unitID) and restorelusScriptIDs[unitID] then
		local unitInSmoke = GetUnitRulesParam(unitID, "smoked") == 1 
		if unitInSmoke then
			Spring.UnitScript.CallAsUnit(unitID, restorelusScriptIDs[unitID])
		else
			local unitAllyTeam = GetUnitAllyTeam(unitID)
			local ux, uy, uz = GetUnitPosition(unitID)
			local nearbyUnits = GetUnitsInSphere(ux, uy, uz, MORALE_RADIUS)
			for i = 1, #nearbyUnits do
				local nearbyUnitAllyTeam = GetUnitAllyTeam(nearbyUnits[i])
				if nearbyUnits[i] ~= unitID and unitAllyTeam == nearbyUnitAllyTeam and fearShields[nearbyUnits[i]] then
					Spring.UnitScript.CallAsUnit(unitID, restorelusScriptIDs[unitID])
				end
			end
		end
	end
end


function gadget:UnitCreated(unitID, unitDefID)
	local scriptID = GetCOBScriptID(unitID, "luaFunction")
	local env = Spring.UnitScript.GetScriptEnv(unitID)
	if (scriptID or (env and env.AddFear)) then
		SetUnitRulesParam(unitID, "fear", 0)
		cobScriptIDs[unitID] = scriptID 
		lusScriptIDs[unitID] = env and env.AddFear
	end
	
	scriptID = GetCOBScriptID(unitID, "RestoreAfterCover")
	if (scriptID or (env and env.RestoreAfterCover)) then
		restoreCOBScriptIDs[unitID] = scriptID 
		restorelusScriptIDs[unitID] = env and env.RestoreAfterCover
	end
	
	if UnitDefs[unitDefID].customParams.blockfear then
		fearShields[unitID] = true
	end
	
	UpdateCollision(unitID, 1)
end


function gadget:UnitDestroyed(unitID)
	cobScriptIDs[unitID] = nil
	lusScriptIDs[unitID] = nil
	fearShields[unitID] = nil
	collisionUpdated[unitID] = nil
end


function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if (cobScriptIDs[unitID] or lusScriptIDs[unitID]) and weaponDefID and weaponDefID > 0 then
		local wd = WeaponDefs[weaponDefID]
		local cp = wd.customParams
		-- SMGs and Rifles do a small amount of suppression cob side, so update suppression when hit by them
		-- ... but be sure not to update suppression for a dead unit (UnitDamaged is called before UnitDestroyed, so cobScriptIDs[unitID] is still valid!)
		if cp and cp.damagetype == "smallarm" and not cp.fearid and not GetUnitIsDead(unitID) then
			UpdateCollision(unitID, -1) 
			if cobScriptIDs[unitID] then
				UpdateSuppressionCOB(unitID)
			else -- danger Will Robinson! assumes the unit must have a lusScriptID
				Spring.UnitScript.CallAsUnit(unitID, lusScriptIDs[unitID], 1)
			end
		end
	end
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	local wd = WeaponDefs[weaponID]
	local cp = wd.customParams
	local fearID = cp.fearid
	if not fearID then return false end
  
	local unitsAtSpot = GetUnitsInSphere(px, py, pz, cp.fearaoe)
	local validOwnerID = ValidUnitID(ownerID)
	
	-- if the weapon is a howitzer shell reset the gun's experience to 0
	if validOwnerID and (cp.howitzer or cp.infgun) then
		GG.Delay.DelayCall(SetUnitExperience, {ownerID, 0}, 1)
	end

	-- protect against dead owners
	local ownerAllyTeam = -1
	if validOwnerID then
		ownerAllyTeam = GetUnitAllyTeam(ownerID)
	end

	-- friendly smallarms fear doesn't apply
	local smallarms = cp.damagetype and cp.damagetype == "smallarm"

	for i = 1, #unitsAtSpot do
		local unitID = unitsAtSpot[i]
		local ud = UnitDefs[GetUnitDefID(unitID)]
		--[[if ud.customParams.blockfear == "1" then
			blockAllyTeams[GetUnitAllyTeam(unitID)] = unitID
		else]]--
		if ud.customParams.feartarget then
			local validTargetID = ValidUnitID(unitID)
			if validTargetID then
				local targetAllyTeam = GetUnitAllyTeam(unitID)
				-- to minimize issues with LMGs hitting ground in the middle of friendly
				-- group while prone
				local friendlySmallarms = (smallarms and targetAllyTeam == ownerAllyTeam)
				if not friendlySmallarms then
					tLength = tLength + 1
					targets[tLength] = unitID
				end
			end
		end
	end
	
	for i = 1, tLength do
		local unitID = targets[i]
		-- GetUnitInSphere can catch tombstoned units, so check that cobScriptIDs[unitID] is valid (unit is not dead)
		if unitID ~= ownerID then
			UpdateCollision(unitID, -1) 
			if lusScriptIDs[unitID] then
				Spring.UnitScript.CallAsUnit(unitID, lusScriptIDs[unitID], FEAR_IDS[fearID])
			elseif cobScriptIDs[unitID] then
				CallCOBScript(unitID, "HitByWeaponId", 0, 0, 0, fearID, 0)
				UpdateSuppressionCOB(unitID)
			end
		end
	end
	-- reset tables
	targets = {}
	tLength = 0
	blockAllyTeams = {}
	
	return false
end


function gadget:Initialize()
	for weaponId, weaponDef in pairs (WeaponDefs) do
		if weaponDef.customParams.fearid or weaponDef.customParams.projectilelups then
			Script.SetWatchWeapon(weaponId, true)
		end
	end
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

-- Until we move to LUS or someone bothers to update the COBs; keep polling in order to reset fear levels due to recovery
function gadget:GameFrame(n)
	if (n % (1.5*30) < 0.1) then
		for unitID, funcID in pairs(cobScriptIDs) do
			UpdateSuppressionCOB(unitID)
		end
		for unitID, funcID in pairs(lusScriptIDs) do
			UpdateSuppressionLUS(unitID)
		end
		for unitID, _ in pairs(collisionUpdated) do
			if (GetUnitRulesParam(unitID, "fear") == 0) then
				UpdateCollision(unitID, 1)
			end
		end
	end
end
else
-- UNSYNCED
end
