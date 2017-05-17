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
local MAX_PLACEMENT_RETRIES = 3

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

local function DelayedCreate(unitTypeName, x, y, z, facing, teamID)
	local mineID = CreateUnit(unitTypeName, x, y, z, facing, teamID)
	SetUnitBlocking(mineID, false, false, false)
end

local function RandPos(mineData)
	return math.random(-mineData.fieldSize, mineData.fieldSize) * mineData.spread
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.minetype then
		local mineData = mineTypes[cp.minetype]
		if mineData then
			local x, y, z = GetUnitPosition(unitID)
			local mineCount = 0
			while mineCount < mineData.number do
				local placementRetry = 1

				local xpos = RandPos(mineData) + x
				local zpos = RandPos(mineData) + z

				-- Try to find free spot for mine three times, otherwise skip placing this mine
				while #GetUnitsInCylinder(xpos, zpos, mineData.minDist, GAIA_TEAM_ID) > 0 and placementRetry <= MAX_PLACEMENT_RETRIES do
					xpos = RandPos(mineData) + x
					zpos = RandPos(mineData) + z

					placementRetry = placementRetry + 1
				end

				if #GetUnitsInCylinder(xpos, zpos, mineData.minDist, GAIA_TEAM_ID) == 0 then
					local ypos = GetGroundHeight(xpos, zpos)
					GG.Delay.DelayCall(DelayedCreate, {mineData.mineToSpawn, xpos, ypos, zpos, 0, GAIA_TEAM_ID})
					--local mineID = CreateUnit(mineData.mineToSpawn, xpos, ypos, zpos, 0, GAIA_TEAM_ID)
					--SetUnitBlocking(mineID, false, false, false)
				end

				mineCount = mineCount + 1
			end
			-- DelayCall needed to fix the notify widget as unsynced can't find gaia units!
			GG.Delay.DelayCall(TransferUnit, {unitID, GAIA_TEAM_ID}, 1)
		end
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
