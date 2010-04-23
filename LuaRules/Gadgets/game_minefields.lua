function gadget:GetInfo()
	return {
		name		= "Minefield spawner",
		desc		= "Randomly spawns mines in a small area when an engineer builds one.",
		author	= "Nemo (B. Tyler)",
		date		= "December 30, 2008",
		license = "Public domain",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end
	
-- function localisations
-- Synced Read
local GetUnitPosition	=	Spring.GetUnitPosition
local GetUnitHealth		=	Spring.GetUnitHealth
local GetGroundHeight	=	Spring.GetGroundHeight
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
-- Synced Ctrl
local CreateUnit		=	Spring.CreateUnit
-- Constants
local APMineNumber		=	16
local APMineSpread		= 	25

local ATMineNumber		=	5
local ATMineSpread		=	23
-- Variables
local engineerBuilt	=	{}

if gadgetHandler:IsSyncedCode() then
--	SYNCED
local DelayCall = GG.Delay.DelayCall
  
function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if (ud.name == "apminesign" and builderID ~= nil) or (ud.name == "atminesign" and builderID ~= nil) then
	engineerBuilt[unitID] = 1
	end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "apminesign" and engineerBuilt[unitID] ~= nil then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < APMineNumber do
			local xpos = (math.random(-5, 5) * APMineSpread) + x
			local zpos = (math.random(-5, 5) * APMineSpread) + z
			local ypos = GetGroundHeight(xpos, zpos)
			CreateUnit("apmine", xpos, ypos, zpos, 0, GAIA_TEAM_ID) --unitTeam
			mineCount = mineCount + 1
		end
		DelayCall(Spring.TransferUnit, {unitID, GAIA_TEAM_ID}, 1)
	end
	
	if ud.name == "atminesign" and engineerBuilt[unitID] ~= nil then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < ATMineNumber do
			local xpos = (math.random(-3, 3) * ATMineSpread) + x
			local zpos = (math.random(-3, 3) * ATMineSpread) + z
			CreateUnit("atmine", xpos, y, zpos, 0, GAIA_TEAM_ID)
			mineCount = mineCount + 1
		end
		DelayCall(Spring.TransferUnit, {unitID, GAIA_TEAM_ID}, 1)
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "apminesign" or ud.name == "atminesign" and unitTeam == GAIA_TEAM_ID then
		Spring.SetUnitCloak(unitID, true)
	end
end

else
--	UNSYNCED
end
