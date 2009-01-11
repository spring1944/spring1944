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
-- Synced Ctrl
local CreateUnit		=	Spring.CreateUnit
-- Constants
local APMineNumber		=	6
local APMineSpread		= 	25

local ATMineNumber		=	3
local ATMineSpread		=	18
-- Variables
local engineerBuilt	=	{}

if gadgetHandler:IsSyncedCode() then
--	SYNCED

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
			local xpos = (math.random(-3, 3) * APMineSpread) + x
			local zpos = (math.random(-3, 3) * APMineSpread) + z
			local ypos = GetGroundHeight(xpos, zpos)
			CreateUnit("apmine", xpos, ypos, zpos, 0, unitTeam)
			mineCount = mineCount + 1
		end
	end
	
	if ud.name == "atminesign" and engineerBuilt[unitID] ~= nil then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < ATMineNumber do
			local xpos = (math.random(-3, 3) * ATMineSpread) + x
			local zpos = (math.random(-3, 3) * ATMineSpread) + z
			CreateUnit("atmine", xpos, y, zpos, 0, unitTeam)
			mineCount = mineCount + 1
		end
	end
end

else
--	UNSYNCED
end
