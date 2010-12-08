function gadget:GetInfo()
	return {
		name = "Increasing Flag Returns",
		desc = "Increases the output of flags according to how long they've been held",
		author = "Nemo (B. Tyler), FLOZi (C. Lawrence)",
		date = "2008-03-06",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end


-- function localisations
-- Synced Read
local GetUnitRulesParam			= Spring.GetUnitRulesParam
local GetUnitTeam				= Spring.GetUnitTeam
-- Synced Ctrl
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitRulesParam			= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID		= Spring.GetGaiaTeamID()
local DEFAULT_OUTPUT 	= UnitDefNames["flag"].extractsMetal
local MULTIPLIER_CAP	= 2
local OUTPUT_BASE		= 1.025

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

-- Remove the gadget is using map command per player
if tonumber(modOptions.map_command_per_player) or -1 >= 0 then
	gadgetHandler:RemoveGadget()
end
		
if (gadgetHandler:IsSyncedCode()) then
--SYNCED
local function OutputCalc(lifespan)
	return DEFAULT_OUTPUT * OUTPUT_BASE ^ lifespan
end

function gadget:GameFrame(n)
	if n % (60 * 30) == 0 and n > 1 then -- every minute, from first minute onwards
		for i = 1, #GG.flags do
			local flagID = GG.flags[i]
			
			if GetUnitTeam(flagID) ~= GAIA_TEAM_ID then -- Neutral flags do not gain lifespan
				local lifespan = GetUnitRulesParam(flagID, "lifespan") or 0
				lifespan = lifespan + 1
				SetUnitRulesParam(flagID, "lifespan", lifespan)
				
				local output = OutputCalc(lifespan)
				if output < MULTIPLIER_CAP * DEFAULT_OUTPUT then
					SetUnitMetalExtraction (flagID, output)	
				end
			end
		end
	end
end

else
--UNSYNCED
end
