function gadget:GetInfo()
	return {
		name      = "Detonate Button",
		desc      = "Implements detonate button for satchel charges",
		author    = "Szunti",
		date      = "sep 1, 2011",
		license   = "GNU GPL v2",
		layer     = 1,
		enabled   = true  --  loaded by default?
  }
end

-- function localisations
-- Synced Read
-- Synced Ctrl
local EditUnitCmdDesc   = Spring.EditUnitCmdDesc
local FindUnitCmdDesc   = Spring.FindUnitCmdDesc

-- Constants

-- Variables
local detonate_in_progress = false

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local detonateDesc = {
	name	= "Detonate",
	action	= "selfd",
	id		= CMD.SELFD,
	type	= CMDTYPE.ICON,
	tooltip	= "Detonate",
	hidden = false
}

-- Custom Functions
local function change_detonate_button(unitID, name, tooltip)
	local unitSelfDCmdDesc = FindUnitCmdDesc(unitID, CMD.SELFD)
	if (unitSelfDCmdDesc) then 
		EditUnitCmdDesc(unitID, unitSelfDCmdDesc, {name = name, tooltip = tooltip})
	end
end

local function get_detonate_tooltip(unitDefID)
	local ud = UnitDefs[unitDefID]
	local tooltip = "Detonate in " .. tostring(ud.selfDCountdown or 0) .. " seconds"
	return tooltip
end

--	CallIns

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD.SELFD then
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.candetonate then
			if detonate_in_progress then
				-- change button back to Detonate
				change_detonate_button(unitID, "Detonate", get_detonate_tooltip(unitDefID))
			else
				-- change button to cancel
				change_detonate_button(unitID, "Cancel", "Cancel detonation")
			end
			detonate_in_progress = not detonate_in_progress
		else -- units without candetonate tag		
			-- do nothing
		end
	else -- not selfd command
		-- do nothing
	end
	return true -- always allow command		
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.candetonate then
		detonateDesc.tooltip = get_detonate_tooltip(unitDefID)
		-- change selfD command to detonate
		local unitSelfDCmdDesc = FindUnitCmdDesc(unitID, CMD.SELFD)
		if (unitSelfDCmdDesc) then 
			EditUnitCmdDesc(unitID, unitSelfDCmdDesc, detonateDesc)
		end
	end
end

function gadget:Initialize()
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

else
--	UNSYNCED

end
