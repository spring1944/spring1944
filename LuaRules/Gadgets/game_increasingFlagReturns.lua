function gadget:GetInfo()
	return {
		name = "Increasing Flag Returns",
		desc = "Increases the output of flags according to how long they've been held",
		author = "Nemo (B. Tyler), FLOZi",
		date = "2008-03-06",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end


-- function localisations
-- Synced Read
local GetUnitDefID						= Spring.GetUnitDefID
local GetUnitRulesParam				=	Spring.GetUnitRulesParam
local GetUnitTeam							= Spring.GetUnitTeam
-- Synced Ctrl
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitRulesParam				= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID		= Spring.GetGaiaTeamID()
local DEFAULT_OUTPUT 	= 0
local MULTIPLIER_CAP	= 2
local OUTPUT_BASE			=	1.025

if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end
if (modOptions.gamemode == "0") then

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

local function OutputCalc(lifespan)
	return DEFAULT_OUTPUT * OUTPUT_BASE ^ lifespan
end

function gadget:GameFrame(t)

	if t == 6 then
		local flagDefID = GetUnitDefID(GG['flags'][1])
		local flagUD = UnitDefs[flagDefID]
		DEFAULT_OUTPUT = flagUD.extractsMetal
		--Spring.Echo("Flag Default Output: " .. DEFAULT_OUTPUT)
	end
	
	if (t % (60*30) < 0.1) and t > 6 then	-- every minute
		for i = 1, #GG['flags'] do
			flagID = GG['flags'][i]
			
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
else
--DEPLOYMENT MODE
end
