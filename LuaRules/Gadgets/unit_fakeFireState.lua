function gadget:GetInfo()
  return {
    name      = "Fake fire state",
    desc      = "Gives a fire state switch for undeployed trucks etc.",
    author    = "ashdnazg",
    date      = "21 Jan 2015",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 2,
    enabled   = true  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local fireStateDefs = {}

local CMD_FAKE_FIRE_STATE = GG.CustomCommands.GetCmdID("CMD_FAKE_FIRE_STATE")
local cmdDesc = {
	id 		 = CMD_FAKE_FIRE_STATE,
	type   = CMDTYPE.ICON_MODE,
	action = "fakefirestate",
	tooltip = "Fire State: Sets under what conditions a\n unit will start to fire at enemy units\n without an explicit attack order",
	params = {2, "Hold fire", "Return fire", "Fire at will"},
	name = "Fire State"
}

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID ~= CMD_FAKE_FIRE_STATE or not fireStateDefs[unitDefID] then
		return
	end
	local updatedCmdParams = {unpack(cmdDesc.params)}
	local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
	updatedCmdParams[1] = cmdParams[1]
	Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = updatedCmdParams})
	return true, true
end


function gadget:UnitCreated(unitID, unitDefID)
	if fireStateDefs[unitDefID] then
		Spring.InsertUnitCmdDesc(unitID, 3, cmdDesc)
	end
end

function gadget:Initialize()
	local morphDefs = _G.morphDefs
	for from, morphs in pairs(morphDefs) do
		for _, morph in pairs(morphs) do
			if #UnitDefs[morph.into].weapons > 0 then
				fireStateDefs[from] = true
			end
		end
	end
	
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end