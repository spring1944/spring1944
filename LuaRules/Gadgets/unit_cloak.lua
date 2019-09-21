function gadget:GetInfo()
return {
		name      = "Cloak controller",
		desc      = "Controls automatic unit cloaking and re-cloaking",
		author    = "[s44]yuritch",
		date      = "May 11, 2019",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false--true  --  loaded by default?
	}
end

-- This is only meant to run in synced
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- some constants
local CLOAK_CHECK_PERIOD = 5
local DECLOAK_AFTER_FIRING_DELAY = 30 * 5 -- 5 seconds?

-- localizations
local spSetUnitCloak = Spring.SetUnitCloak
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy

local spGetUnitRulesParam = Spring.GetUnitRulesParam

local spLog = Spring.Log

-- defs which can cloak
local cloakedDefs = {}

-- all units which can cloak
local cloakedUnits = {}
GG.cloakedUnits = cloakedUnits

-- units which are pending cloaking (they can cloak but are not cloaked yet for some reason)
local unitsWantToCloak = {}

-- Precache unit defs which can cloak
for i = 1, #UnitDefs do
	local ud = UnitDefs[i]
	if (ud.canCloak or ud.startCloaked) and ud.decloakDistance then
		cloakedDefs[i] = ud.decloakDistance
		--spLog('unit_cloak', 'error', ud.name .. ' ' .. ud.decloakDistance)
	end
end

-- Control the unit list
function gadget:UnitCreated(unitID, unitDefID)
	if cloakedDefs[unitDefID] then
		cloakedUnits[unitID] = unitDefID
		unitsWantToCloak[unitID] = unitDefID
	end
end

-- Just remove the item, no need to check if it's there
function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	cloakedUnits[unitID] = nil
end

-- is this unit performing some noisy activity like firing? Or are there enemies too close to it?
local function hasDecloakingCondition(unitID, unitDefID, currentFrame)
	-- check distance first
	local decloakDistance = cloakedDefs[unitDefID]
	local enemyTooClose = spGetUnitNearestEnemy(unitID, decloakDistance, false)
	if enemyTooClose then
		return true
	end

	-- then check if param expired
	local lastDecloakActivityFrame = spGetUnitRulesParam(unitID, 'decloak_activity_frame')
	if lastDecloakActivityFrame and (lastDecloakActivityFrame + DECLOAK_AFTER_FIRING_DELAY) > currentFrame then
		return true
	end

	return false
end

-- main loop
function gadget:GameFrame(n)
	if n % CLOAK_CHECK_PERIOD < 0.1 then
		-- 1. try to cloak units from the pending cloak list
		for unitID, unitDefID in pairs(unitsWantToCloak) do
			-- TBD: is this currently spotted by binocs?
			-- is this fully built?
			local _,_,_,_,buildProgress = spGetUnitHealth(unitID)
			if buildProgress == 1 and hasDecloakingCondition(unitID, unitDefID, n) == false then
				-- try cloaking
				--spLog('unit_cloak', 'error', 'cloaking unit: ' .. unitID)
				-- nothing is too close, we can cloak
				spSetUnitCloak(unitID, true)
				-- remove from the list, we do not want to cloak anymore - already cloaked
				unitsWantToCloak[unitID] = nil
			end
		end

		-- 2. try to decloak units which should be decloaked
		for unitID, unitDefID in pairs(cloakedUnits) do
			-- are we not in the pending list? If we are in the pending cloak list then there is nothing to do here
			if not unitsWantToCloak[unitID] then
				if hasDecloakingCondition(unitID, unitDefID, n) then
					--spLog('unit_cloak', 'error', 'de-cloaking unit: ' .. unitID)
					-- decloak
					spSetUnitCloak(unitID, false)
					Spring.SetUnitRulesParam(unitID, 'decloak_activity_frame', n)
					-- put in the pending cloak list
					unitsWantToCloak[unitID] = unitDefID
				end
			end
		end
	end
end

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = spGetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID)
	end
end