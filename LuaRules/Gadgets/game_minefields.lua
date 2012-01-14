function gadget:GetInfo()
	return {
		name		= "Minefield spawner",
		desc		= "Randomly spawns mines in a small area when an engineer builds one.",
		author		= "Nemo (B. Tyler), FLOZi (C. Lawrence)",
		date		= "December 30, 2008",
		license		= "GNU GPL v2",
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
local SetUnitBlocking		= Spring.SetUnitBlocking
local SetUnitCloak			= Spring.SetUnitCloak
local TransferUnit			= Spring.TransferUnit

-- Constants
local GAIA_TEAM_ID 			= Spring.GetGaiaTeamID()

local mineTypes = {}
mineTypes["apminesign"] = {
	number = 16,
	spread = 25,
	minDist = 2.5,
	fieldSize = 5,
	mineToSpawn = "apmine",
}
mineTypes["atminesign"] = {
	number = 5,
	spread = 23,
	minDist = 1.5,
	fieldSize = 3,
	mineToSpawn = "atmine",
}

if gadgetHandler:IsSyncedCode() then
--	SYNCED
local DelayCall = GG.Delay.DelayCall

local function RandPos(mineData)
	return math.random(-mineData.fieldSize, mineData.fieldSize) * mineData.spread
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	local mineData = mineTypes[ud.name]
	if mineData then		
		local x, y, z = GetUnitPosition(unitID)
		local mineCount = 0
		while mineCount < mineData.number do
			local xpos = RandPos(mineData) + x
			local zpos = RandPos(mineData) + z
			while #GetUnitsInCylinder(xpos, zpos, mineData.minDist, GAIA_TEAM_ID) > 0 do -- This could well be slow >_>
				xpos = RandPos(mineData) + x
				zpos = RandPos(mineData) + z
			end
			local ypos = GetGroundHeight(xpos, zpos)
			local mineID = CreateUnit(mineData.mineToSpawn, xpos, ypos, zpos, 0, GAIA_TEAM_ID)
			SetUnitBlocking(mineID, false, false, false)
			mineCount = mineCount + 1
		end
		 -- DelayCall needed to fix the notify widget as unsynced can't find gaia units!
		DelayCall(TransferUnit, {unitID, GAIA_TEAM_ID}, 1)
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	local ud = UnitDefs[unitDefID]
	local mineData = mineTypes[ud.name]
	if mineData and unitTeam == GAIA_TEAM_ID then
		SetUnitCloak(unitID, true)
	end
end

else
--	UNSYNCED
end
