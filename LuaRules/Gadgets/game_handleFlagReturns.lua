function gadget:GetInfo()
	return {
		name = "Flag Returns",
		desc = "Set flags production in map_command_per_player mode, increases the output of flags according to how long they've been held, set init_production and production rules params",
		author = "Nemo (B. Tyler), FLOZi (C. Lawrence), Prospector widget code form gui_prospector.lua by Evil4Zerggin, Szunti",
		date = "2011-09-01",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end
-- function localisations
local floor						= math.floor
local min, max                  = math.min, math.max

-- Synced Read
local GetUnitRulesParam			= Spring.GetUnitRulesParam
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitPosition           = Spring.GetUnitPosition
local GetGroundInfo				= Spring.GetGroundInfo

-- Synced Ctrl
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitResourcing			= Spring.SetUnitResourcing
local SetUnitRulesParam			= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID		= Spring.GetGaiaTeamID()
local DEFAULT_OUTPUT 	= UnitDefNames["flag"].extractsMetal
local MULTIPLIER_CAP	= 10
local OUTPUT_BASE		= 1.12

-- prospector constants
local METAL_MAP_SQUARE_SIZE = 16
local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_X_SCALED = MAP_SIZE_X / METAL_MAP_SQUARE_SIZE
local MAP_SIZE_Z = Game.mapSizeZ
local MAP_SIZE_Z_SCALED = MAP_SIZE_Z / METAL_MAP_SQUARE_SIZE
local EXTRACT_RADIUS = Game.extractorRadius
local EXTRACT_RADIUS_SQR = EXTRACT_RADIUS * EXTRACT_RADIUS

-- variables
local teams	= Spring.GetTeamList()

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

local metalMake = tonumber(modOptions.map_command_per_player) or -1
		
-- Custom Functions
-- prospector widget code start (some modifications)
local function IntegrateMetal(posX, posZ)
	local startX = floor((posX - EXTRACT_RADIUS) / METAL_MAP_SQUARE_SIZE)
	local startZ = floor((posZ - EXTRACT_RADIUS) / METAL_MAP_SQUARE_SIZE)
	local endX = floor((posX + EXTRACT_RADIUS) / METAL_MAP_SQUARE_SIZE)
	local endZ = floor((posZ + EXTRACT_RADIUS) / METAL_MAP_SQUARE_SIZE)
	startX, startZ = max(startX, 0), max(startZ, 0)
	endX, endZ = min(endX, MAP_SIZE_X_SCALED - 1), min(endZ, MAP_SIZE_Z_SCALED - 1)
	
	local result = 0
	for i = startX, endX do
		for j = startZ, endZ do
			local cx, cz = (i + 0.5) * METAL_MAP_SQUARE_SIZE, (j + 0.5) * METAL_MAP_SQUARE_SIZE
			local dx, dz = cx - posX, cz - posZ
			local dist = dx * dx + dz * dz
			
			if (dist < EXTRACT_RADIUS_SQR) then
				local _, metal = GetGroundInfo(cx, cz)
				result = result + metal
			end
		end
	end
	return result
end
--prospector widget code ends

local function getInitialFlagExtractRate(flagID)
	-- metal in radius
	local x, _, z = GetUnitPosition(flagID)
	local metal = IntegrateMetal(x, z)
	-- multiply with metal_extraction value
	return metal * DEFAULT_OUTPUT
end

local function setInitialProductionRulesParams(flagID, mMake)
	local init_production
	if mMake >= 0 then
		init_production = mMake
	else
		init_production = getInitialFlagExtractRate(flagID)
	end
	SetUnitRulesParam(flagID, "init_production", init_production, {public = true})
	-- Set production rulesparam to current production, now it's init_production, 
	-- but Increasing Flag Return gadget can change it
	local access = {}
	if modOptions and modOptions.always_visible_flags == "0" then
		access = {allied = true} -- just allied players can see current production
	else
		access = {public = true} -- flags always visible, you could calculate production in a widget, so don't hide
	end
	SetUnitRulesParam(flagID, "production", init_production, access)
end

local function OutputCalc(lifespan)
	return DEFAULT_OUTPUT * OUTPUT_BASE ^ lifespan
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

function gadget:GameStart()
	if metalMake >= 0 then
		metalMake = metalMake * (#teams - 1) / #GG.flags
	end
	--Spring.Echo(tostring(metalMake or "N/A"))
	for i = 1, #GG.flags do
		local flagID = GG.flags[i]
		if metalMake >= 0 then -- this is a little messy
			SetUnitMetalExtraction(flagID, 0, 0) -- remove extracted metal
			SetUnitResourcing(flagID, "umm", metalMake)
		end
		setInitialProductionRulesParams(flagID, metalMake)
	end
	-- Remove the gadget if using map command per player
	if metalMake >= 0 then
		gadgetHandler:RemoveGadget() -- possibly unsafe
	end
end


function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "flag" then
		SetUnitRulesParam(unitID, "lifespan", 0) -- also reset in flagManager
		SetUnitMetalExtraction (unitID, DEFAULT_OUTPUT)
		-- set production rules param
		local init_production = GetUnitRulesParam(unitID, "init_production")
		SetUnitRulesParam(unitID, "production", init_production)
	end
end

function gadget:GameFrame(n) -- increase flag returns
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
					-- set production rules param, use the same multiplier as for output
					local init_production = GetUnitRulesParam(flagID, "init_production")
					local multiplier = output / DEFAULT_OUTPUT
					local production = init_production * multiplier
					SetUnitRulesParam(flagID, "production", production)
				end
			end
		end
	end
end

else
--UNSYNCED
end
