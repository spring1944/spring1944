function gadget:GetInfo()
	return {
		name      = "Immobilization",
		desc      = "Implements immobilization after weapon hits",
		author    = "yuritch",
		date      = "9 November 2016",
		license   = "GNU GPL v2",
		layer     = 2, -- must run after LUS
		enabled   = true
	}
end

local random 					= math.random
local SetUnitRulesParam 		= Spring.SetUnitRulesParam
local GetUnitIsDead 			= Spring.GetUnitIsDead
local immobilizedUnits = {}

local IMMOBILIZATION_TIME = 10
local CHECK_FREQUENCY = 10	-- every 10 ticks

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:UnitDestroyed(unitID)
	immobilizedUnits[unitID] = nil
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if GetUnitIsDead(unitID) then
		return
	end
	local wd = WeaponDefs[weaponDefID]
	local cp = wd.customParams
	if cp.immobilizationchance and tonumber(cp.immobilizationchance) > 0 then
		-- get target unit resistance. If none then this unit can't be immobilized
		local ud = UnitDefs[unitDefID]
		local ucp = ud.customParams
		if ucp and ucp.immobilizationresistance then
			local finalResistance = cp.immobilizationchance * (1 - ucp.immobilizationresistance)
			local randomRoll = random(1000)
			--Spring.Echo('roll: ' .. randomRoll .. ' vs ' .. (finalResistance * 1000))
			if randomRoll < finalResistance * 1000 then
				-- Immobilization happened!
				immobilizedUnits[unitID] = IMMOBILIZATION_TIME * (30 / CHECK_FREQUENCY)
				SetUnitRulesParam(unitID, "immobilized", 1)
				GG.ApplySpeedChanges(unitID)
				--Spring.Echo('Unit immobilized!')
			end
		end
	end
end

function gadget:GameFrame(n)
	if (n % CHECK_FREQUENCY) == 0 then
		for unitID, remainingTime in pairs(immobilizedUnits) do
			immobilizedUnits[unitID] = immobilizedUnits[unitID] - 1
			if immobilizedUnits[unitID] <= 0 then
				-- un-immobilize
				SetUnitRulesParam(unitID, "immobilized", 0)
				-- remove from list
				immobilizedUnits[unitID] = nil
				-- notify the movement speed code
				GG.ApplySpeedChanges(unitID)
			end
		end
	end
end

end