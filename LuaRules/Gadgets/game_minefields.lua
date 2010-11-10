function gadget:GetInfo()
	return {
		name		= "Minefield spawner",
		desc		= "Randomly spawns mines in a small area when an engineer builds one.",
		author		= "Nemo (B. Tyler), FLOZi (C. Lawrence)",
		date		= "December 30, 2008",
		license		 = "Public domain",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end
	
-- function localisations
-- Synced Read
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitHealth			= Spring.GetUnitHealth
local GetUnitsInCylinder	= Spring.GetUnitsInCylinder
local GetGroundHeight		= Spring.GetGroundHeight
-- Synced Ctrl
local CreateUnit			= Spring.CreateUnit
-- Constants
local GAIA_TEAM_ID 			= Spring.GetGaiaTeamID()

local APMineNumber			= 16
local APMineSpread			= 25

local ATMineNumber			= 5
local ATMineSpread			= 23

local APMineMinDist			= 2.5
local ATMineMinDist			= 1.5

if gadgetHandler:IsSyncedCode() then
--	SYNCED
local DelayCall = GG.Delay.DelayCall

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "apminesign" then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < APMineNumber do
			local xpos = (math.random(-5, 5) * APMineSpread) + x
			local zpos = (math.random(-5, 5) * APMineSpread) + z
			while #GetUnitsInCylinder(xpos, zpos, APMineMinDist, GAIA_TEAM_ID) > 0 do
				xpos = (math.random(-5, 5) * APMineSpread) + x
				zpos = (math.random(-5, 5) * APMineSpread) + z
			end
			local ypos = GetGroundHeight(xpos, zpos)
			CreateUnit("apmine", xpos, ypos, zpos, 0, GAIA_TEAM_ID) --unitTeam
			mineCount = mineCount + 1
		end
		DelayCall(Spring.TransferUnit, {unitID, GAIA_TEAM_ID}, 1)
	end
	
	if ud.name == "atminesign" then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < ATMineNumber do
			local xpos = (math.random(-3, 3) * ATMineSpread) + x
			local zpos = (math.random(-3, 3) * ATMineSpread) + z
			while #GetUnitsInCylinder(xpos, zpos, ATMineMinDist, GAIA_TEAM_ID) > 0 do
				xpos = (math.random(-3, 3) * ATMineSpread) + x
				zpos = (math.random(-3, 3) * ATMineSpread) + z
			end
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
