function gadget:GetInfo()
	return {
		name      = "Pontoon Bridges",
		desc      = "Allows building of pontoon bridges",
		author    = "FLOZi",
		date      = "28/01/2010",
		license   = "GPL v2",
		layer     = -5,
		enabled   = true --  loaded by default?
	}
end
-- function localisations
-- Synced Read
local GetUnitPosition 	= Spring.GetUnitPosition
local GetUnitTeam		= Spring.GetUnitTeam
-- Synced Ctrl
local CreateUnit 		= Spring.CreateUnit
-- Unsynced Read
local GetUnitCommands	= Spring.GetUnitCommands
-- Unsynced Ctrl
local GiveOrderToUnit	= Spring.GiveOrderToUnit
-- constants
local BLOCKS = 8 * 3
-- variables
local spawners = {}
local couples = {}

if (gadgetHandler:IsSyncedCode()) then

	function gadget:UnitFinished(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		if ud.name:lower() == "pontoonbridge" then
			Spring.SetUnitBlocking(unitID, false, false)
			Spring.SetUnitNoSelect(unitID, true)
			local x, _, z = Spring.GetUnitPosition(unitID)
			local facing = Spring.GetUnitBuildFacing(unitID)
			Spring.Echo(facing)
			if facing == 1 or facing == 3 then
				Spring.LevelHeightMap(x - BLOCKS - 16, z - BLOCKS, x + BLOCKS + 16, z + BLOCKS, 1)
			elseif facing == 0 or facing == 2 then
				Spring.LevelHeightMap(x - BLOCKS, z - BLOCKS - 16, x + BLOCKS, z + BLOCKS + 16, 1)
			end
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID)

	end

	function gadget:GameFrame(n)

	end


else -- UNSYNCED

end
