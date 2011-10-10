function gadget:GetInfo()
	return {
		name = "Game Sensors",
		desc = "Units in radar range become visible",
		author = "FLOZi (C. Lawrence)",
		date = "02/02/2011",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

-- Localisations
local DelayCall = GG.Delay.DelayCall
local SetUnitRulesParam	= Spring.SetUnitRulesParam
-- Synced Read
local GetGameFrame 		= Spring.GetGameFrame
local GetTeamInfo		= Spring.GetTeamInfo
-- Synced Ctrl
local SetUnitLosMask 	= Spring.SetUnitLosMask
local SetUnitLosState 	= Spring.SetUnitLosState

-- Unsynced Ctrl
-- Constants
--local NARC_ID = WeaponDefNames["narc"].id
--local NARC_DURATION = 32 * 60 -- 30 seconds

-- Variables
local modOptions = Spring.GetModOptions()
local inRadarUnits = {}
local outRadarUnits = {}

local allyTeams = Spring.GetAllyTeamList()
local numAllyTeams = #allyTeams

for i = 1, numAllyTeams do
	local allyTeam = allyTeams[i]
	inRadarUnits[allyTeam] = {}
	outRadarUnits[allyTeam] = {}
end

--[[local narcUnits = {}

local function NARC(unitID, allyTeam)
	local narcFrame = GetGameFrame() + NARC_DURATION
	narcUnits[unitID] = narcFrame
	SetUnitLosState(unitID, allyTeam, {los=true, prevLos=true, radar=true, contRadar=true} ) 
	SetUnitLosMask(unitID, allyTeam, {los=true, prevLos=false, radar=false, contRadar=false} )	
	-- Set rules param here so that widgets know the unit is NARCed, value points to the frame NARC runs out
	SetUnitRulesParam(unitID, "NARC", GetGameFrame() + NARC_DURATION, {inlos = true})
end

local function DeNARC(unitID, allyTeam)
	if narcUnits[unitID] <= GetGameFrame() + 1 then
		narcUnits[unitID] = nil
		SetUnitLosMask(unitID, allyTeam, {los=false, prevLos=false, radar=false, contRadar=false} )
		-- unset rules param
		SetUnitRulesParam(unitID, "NARC", -1, {inlos = true})
	end
end]]

function gadget:UnitEnteredRadar(unitID, unitTeam, allyTeam, unitDefID)
	--Spring.Echo(UnitDefs[unitDefID].name .. " entered radar " .. allyTeam)
	inRadarUnits[allyTeam][unitID] = true
	outRadarUnits[allyTeam][unitID] = nil
end

function gadget:UnitLeftRadar(unitID, unitTeam, allyTeam, unitDefID)
	--Spring.Echo(UnitDefs[unitDefID].name .. " left radar" .. allyTeam)
	outRadarUnits[allyTeam][unitID] = true
	inRadarUnits[allyTeam][unitID] = nil
end

--[[function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
	-- ignore non-NARC weapons
	if weaponID ~= NARC_ID or not attackerID then return damage end
	local allyTeam = select(6, GetTeamInfo(attackerTeam))
	-- do the NARC, delay the deNARC
	NARC(unitID, allyTeam)
	DelayCall(DeNARC, {unitID, allyTeam}, NARC_DURATION)
	-- NARC does 0 damage
	return 0
end]]

function gadget:GameFrame(n)
	for i = 1, numAllyTeams do
		local allyTeam = allyTeams[i]
		for unitID in pairs(inRadarUnits[allyTeam]) do
			--if not narcUnits[unitID] then
				SetUnitLosState(unitID, allyTeam, {los=true, prevLos=true, radar=true, contRadar=true} ) 
				SetUnitLosMask(unitID, allyTeam, {los=true, prevLos=false, radar=false, contRadar=false} )	
				inRadarUnits[allyTeam][unitID] = nil
			--end
		end
		for unitID in pairs(outRadarUnits[allyTeam]) do
			--if not narcUnits[unitID] then
				SetUnitLosMask(unitID, allyTeam, {los=false, prevLos=false, radar=false, contRadar=false} )
				outRadarUnits[allyTeam][unitID] = nil
			--end
		end
	end
end

else

-- UNSYNCED

end
