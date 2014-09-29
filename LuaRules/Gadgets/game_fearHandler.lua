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
-- variables
local cobScriptIDs = {}
local lusScriptIDs = {}

local fearLevels = {}
local engineerIDs = {}
local engineerDefIDs = {}

local targets = {}
local tLength = 0

local blockAllyTeams = {}

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local function UpdateSuppression(unitID)
	local _, currFear = CallCOBScript(unitID, cobScriptIDs[unitID], 1, 1)
	fearLevels[unitID] = currFear
	SetUnitRulesParam(unitID, "suppress", currFear)
	if engineerIDs[unitID] then -- unit is an engineer, toggle his buildpower
		if currFear <= 2 then
			Spring.SetUnitBuildSpeed(unitID, engineerIDs[unitID])
		else
			Spring.SetUnitBuildSpeed(unitID, 0.000001) -- must be non-0 or building will decay
		end
	end
end


function gadget:UnitCreated(unitID, unitDefID)
	local scriptID = GetCOBScriptID(unitID, "luaFunction")
	env = Spring.UnitScript.GetScriptEnv(unitID)
	if (scriptID or (env and env.AddFear)) then
		SetUnitRulesParam(unitID, "suppress", 0)
		cobScriptIDs[unitID] = scriptID 
		lusScriptIDs[unitID] = env and env.AddFear
		if engineerDefIDs[unitDefID] == nil then -- first of this unitdef, check if it is a builder
			if UnitDefs[unitDefID].isBuilder then
				engineerDefIDs[unitDefID] = true
				engineerIDs[unitID] = UnitDefs[unitDefID].buildSpeed
			else
				engineerDefIDs[unitDefID] = false
			end
		elseif engineerDefIDs[unitDefID] then -- is a builder
			engineerIDs[unitID] = UnitDefs[unitDefID].buildSpeed
		end
	end
end


function gadget:UnitDestroyed(unitID)
	cobScriptIDs[unitID] = nil
	lusScriptIDs[unitID] = nil
	engineerIDs[unitID] = nil
end


function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if cobScriptIDs[unitID] and weaponID and weaponID > 0 then
		local wd = WeaponDefs[weaponID]
		local cp = wd.customParams
		-- SMGs and Rifles do a small amount of suppression cob side, so update suppression when hit by them
		-- ... but be sure not to update suppression for a dead unit (UnitDamaged is called before UnitDestroyed, so cobScriptIDs[unitID] is still valid!)
		if cp and cp.damagetype == "smallarms" and not cp.fearid and not GetUnitIsDead(unitID) then
			if cobScriptIDs[unitID] then
				UpdateSuppression(unitID)
			else -- danger Will Robinson! assumes the unit must have a lusScriptID
				Spring.UnitScript.CallAsUnit(unitID, lusScriptIDs[unitID], 1)
			end
		end
	end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams)
	local ud = UnitDefs[unitDefID]
		if cobScriptIDs[unitID] then
			local fearLevel = GetUnitRulesParam(unitID, "suppress")
			if fearLevel > 0 and fearLevel <= 2 then
				--Spring.Echo("dude should get up and run")
				CallCOBScript(unitID, "RestoreAfterCover", 0, 0, 0)
			elseif fearLevel > 2 then
				--if they're in smoke, they don't have to fear...
				local unitInSmoke = GetUnitRulesParam(unitID, "smoked") == 1 
				if unitInSmoke then
					CallCOBScript(unitID, "RestoreAfterCover", 0, 0, 0)
				else
					local unitAllyTeam = GetUnitAllyTeam(unitID)
					local ux, uy, uz = GetUnitPosition(unitID)
					local nearbyUnits = GetUnitsInSphere(ux, uy, uz, MORALE_RADIUS)
					for i = 1, #nearbyUnits do
						if nearbyUnits[i] ~= unitID then
							local nearbyUnitAllyTeam = GetUnitAllyTeam(nearbyUnits[i])
							local nearbyUD = UnitDefs[GetUnitDefID(nearbyUnits[i])]
							if nearbyUD.customParams.blockfear == "1" and (unitAllyTeam == nearbyUnitAllyTeam) then
								CallCOBScript(unitID, "RestoreAfterCover", 0, 0, 0)
								break
							end
						end
					end
				end
			end
		end
	return true
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	local wd = WeaponDefs[weaponID]
	local cp = wd.customParams
	local fearID = cp.fearid
	
	if not fearID then return false end
  
	local unitsAtSpot = GetUnitsInSphere(px, py, pz, cp.fearaoe)
	
	-- if the weapon is a howitzer shell reset the gun's experience to 0
	if ValidUnitID(ownerID) and (cp.howitzer or cp.infgun) then
		SetUnitExperience(ownerID, 0)
	end
	
	for i = 1, #unitsAtSpot do
		local unitID = unitsAtSpot[i]
		local ud = UnitDefs[GetUnitDefID(unitID)]
		--[[if ud.customParams.blockfear == "1" then
			blockAllyTeams[GetUnitAllyTeam(unitID)] = unitID
		else]]--
		if ud.customParams.feartarget then
			tLength = tLength + 1
			targets[tLength] = unitID
		end
	end
	
	for i = 1, tLength do
		local unitID = targets[i]
		-- GetUnitInSphere can catch tombstoned units, so check that cobScriptIDs[unitID] is valid (unit is not dead)
		if unitID ~= ownerID then
			if lusScriptIDs[unitID] then
				Spring.UnitScript.CallAsUnit(unitID, lusScriptIDs[unitID], FEAR_IDS[fearID])
			elseif cobScriptIDs[unitID] then
				CallCOBScript(unitID, "HitByWeaponId", 0, 0, 0, fearID, 0)
				UpdateSuppression(unitID)
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
		if weaponDef.customParams.fearid then
			--Spring.Echo(weaponDef.name) -- useful for debugging
			Script.SetWatchWeapon(weaponId, true)
		end
	end
end

-- Until we move to LUS or someone bothers to update the COBs; keep polling in order to reset fear levels due to recovery
function gadget:GameFrame(n)
	if (n % (1.5*30) < 0.1) then
		for unitID, funcID in pairs(cobScriptIDs) do
			UpdateSuppression(unitID)
		end
	end
end
else
-- UNSYNCED
end
