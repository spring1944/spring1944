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
local min, max					= math.min, math.max

-- Synced Read
local GetUnitRulesParam			= Spring.GetUnitRulesParam
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitPosition			= Spring.GetUnitPosition
local GetMetalAmount			= Spring.GetMetalAmount

-- Synced Ctrl
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitResourcing			= Spring.SetUnitResourcing
local SetUnitRulesParam			= Spring.SetUnitRulesParam

-- constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local DEFAULT_EXTRACT			= UnitDefNames["flag"].extractsMetal
-- how much can a flag grow?
local GROWTH_CAP	= 10
-- how fast does the flag grow?
-- 1.12 means a flag hits max after 21 minutes of uninterrupted ownership.
local GROWTH_RATE	= 1.12

-- prospector constants
local GRID_SIZE = Game.squareSize
local METAL_MAP_SQUARE_SIZE = 2 * GRID_SIZE
local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_X_SCALED = MAP_SIZE_X / METAL_MAP_SQUARE_SIZE
local MAP_SIZE_Z = Game.mapSizeZ
local MAP_SIZE_Z_SCALED = MAP_SIZE_Z / METAL_MAP_SQUARE_SIZE
local EXTRACT_RADIUS = Game.extractorRadius
local EXTRACT_RADIUS_SQR = EXTRACT_RADIUS * EXTRACT_RADIUS

-- variables
local teams = Spring.GetTeamList()

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

local mapCommandPerPlayer = tonumber(modOptions.map_command_per_player) or -1
local communismMode = modOptions.communism_mode or false

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
				-- 104.0.1: Spring.GetGroundInfo returns different values. Better
				-- using Spring.GetMetalAmount
				local metal = GetMetalAmount(cx / METAL_MAP_SQUARE_SIZE,
				                             cz / METAL_MAP_SQUARE_SIZE)
				result = result + metal
			end
		end
	end
	return result
end
--prospector widget code ends

local function setProduction(flagID, amount)

	-- communism handles resource giving by reading flag production UnitRulesParam
	-- so don't add any real resources if it is active (or flags will produce double)
	if not communismMode then
		SetUnitResourcing(flagID, "umm", amount)
	end

	local access = {}
	if modOptions and modOptions.always_visible_flags == "0" then
		-- just allied players can see current production
		access = {allied = true}
	else
		-- flags always visible, you could calculate production in a widget, so don't hide
		access = {public = true}
	end

	SetUnitRulesParam(flagID, "production", amount, access)
end

-- when not using map_command_per_player, either get the amount
-- defined by the map flag config, or use what is extracted by the flag
-- from the metalmap
local function getInitialProduction(flagID)
	local mapConfigProd = GetUnitRulesParam(flagID, "map_config_init_production")
	if mapConfigProd then return mapConfigProd end

	-- metal in radius
	local x, _, z = GetUnitPosition(flagID)
	local metal = IntegrateMetal(x, z)
	-- multiply with metal_extraction value
	return metal * DEFAULT_EXTRACT
end

local function initializeFlag(flagID, initialProduction)
	-- remove extracted metal, we're only using metal make
	SetUnitMetalExtraction(flagID, 0, 0)
	SetUnitRulesParam(flagID, "init_production", initialProduction, {public = true})
	setProduction(flagID, initialProduction)
end

local function calculateProduction(initialProduction, lifespan)
	return initialProduction * GROWTH_RATE ^ lifespan
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

function gadget:Initialize()
	gadget:GameStart() -- Will only do something if game has already started
end

function gadget:GameStart()
	-- calculate map_command_per_player values
	-- in the case of map_command_per_player, all flags start
	-- out at the same value, and only vary according to lifespan, not
	-- according to metal map.
	local globalInitialProduction
	if mapCommandPerPlayer > 0 then
		-- -1 to ignore GAIA
		local nonGaiaTeams = #teams - 1
		local flagCount = #GG.flags
		local maxMapIncome = mapCommandPerPlayer * nonGaiaTeams
		local maxFlagIncome = maxMapIncome / flagCount
		globalInitialProduction = maxFlagIncome / GROWTH_CAP
	end

	for i = 1, #GG.flags do
		local flagID = GG.flags[i]
		-- initial flag income is determined either by map_command_per_player,
		-- or the flag's metal patch. it is the value that flags reset to when captured
		local initialProd = globalInitialProduction or getInitialProduction(flagID)
		initializeFlag(flagID, initialProd)
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "flag" or ud.name == "buoy" then
		local flagID = unitID
		-- check if it was passed within an ally team (/take)
		local oldAllyTeamID = select(6, Spring.GetTeamInfo(oldTeam))
		local newAllyTeamID = select(6, Spring.GetTeamInfo(unitTeam))
		if oldAllyTeamID ~= newAllyTeamID then
			SetUnitRulesParam(flagID, "lifespan", 0) -- also reset in flagManager

			local init_production = GetUnitRulesParam(unitID, "init_production")
			setProduction(flagID, init_production)
		end
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

				local init_production = GetUnitRulesParam(flagID, "init_production")
				local production = GetUnitRulesParam(flagID, 'production')
				local prodForReal = Spring.GetUnitResources(flagID)
				local flagMaxProd = GROWTH_CAP * init_production
				local newProd = calculateProduction(init_production, lifespan)

				if newProd < flagMaxProd then
					setProduction(flagID, newProd)
				elseif (production < flagMaxProd) or (production > flagMaxProd) then
					setProduction(flagID, flagMaxProd)
				end
			end
		end
	end
end

else
--UNSYNCED
end
