function widget:GetInfo()
  return {
    name      = "Stat Tracker",
    desc      = "Records surviving units and their stats so they can be accurately spawned next game.",
    author    = "B. Tyler (Nemo), built on work by Evil4Zerggin",
    date      = "July 22nd 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

----------------------------------------------------------------
--config
----------------------------------------------------------------

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitExperience		=	Spring.GetUnitExperience
local GetUnitHealth			=	Spring.GetUnitHealth
local GetUnitDefID			=	Spring.GetUnitDefID
local GetUnitRulesParam		=	Spring.GetUnitRulesParam
local GetPlayerRoster		=	Spring.GetPlayerRoster
local GetUnitTeam			=	Spring.GetUnitTeam
local GetTeamUnits			=	Spring.GetTeamUnits

local MOD_NAME				=	Game.modName
local gameID				=	Game.gameID

local LOGFILE = LUAUI_DIRNAME .. "logs/survivingUnits.lua"

local unitData	=	{}
local saveTable	=	{}

----------------------------------------------------------------
--local functions
----------------------------------------------------------------

local function ProcessUnit(unitID, playerName, teamID)
	local xp = GetUnitExperience(unitID)
	local health, maxHealth = GetUnitHealth(unitID)
	if xp and health then
		local unitDefID = GetUnitDefID(unitID)
		local teamID = GetUnitTeam(unitID)
		local unitDef = UnitDefs[unitDefID]
		local unitName = unitDef.name
		local ammo = GetUnitRulesParam(unitID, "ammo") or -1
		unitData[unitID] = {
				name = unitName,
				xp = xp, 
				health = health,
				ammo = ammo,
			}
		Spring.Echo("owner", playerName)
		Spring.Echo("unitID", unitID)
		Spring.Echo("this unit:", saveTable[playerName].unitData[unitID].name)
	end
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function widget:Initialize()
	local playerroster = GetPlayerRoster(3) --sort by teamID
	for index,player in ipairs(playerroster) do
			local playerName = player[1]
			saveTable[playerName] = {
			unitData = {}			
			}
	end
end

function widget:Shutdown()
	local playerroster = GetPlayerRoster(3) --sort by teamID
	for index,player in ipairs(playerroster) do
			local playerName = player[1]
			local playerID = player[2]
			local teamID = player[3]
			local teamUnits = GetTeamUnits(teamID)
			if teamUnits ~= nil then
				for i=1, #teamUnits do
					ProcessUnit(teamUnits[i], playerName, teamID)
				end
			end
	end
	table.save(saveTable, LOGFILE)
end

function widget:GameOver()
	widgetHandler:RemoveWidget()
end
