local versionNumber = "v1.3"

function widget:GetInfo()
  return {
    name      = "XP Tracker",
    desc      = versionNumber .. "Records XP statistics for units.",
    author    = "Evil4Zerggin",
    date      = "7 March 2009",
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

local GetUnitExperience = Spring.GetUnitExperience
local GetUnitDefID = Spring.GetUnitDefID

local MOD_NAME = Game.modName
local LOGFILE = LUAUI_DIRNAME .. "Logs/util_xp_tracker_log.lua"

local data

local destroyedData, gameOverData

----------------------------------------------------------------
--local functions
----------------------------------------------------------------

local function ProcessUnit(unitID, t)
	local xp = GetUnitExperience(unitID)
	if xp then
		local unitDefID = GetUnitDefID(unitID)
		local unitDef = UnitDefs[unitDefID]
		local unitName = unitDef.name
		if not t[unitName] then
			t[unitName] = {
				n = 0, --number of units with xp > 0
				xp = 0, --total xp
				n_zero = 0, --number of units with xp = 0
				avg = 0, --average xp, excluding units with zero xp
				avg_zero = 0, --average xp, including units with zero xp
			}
		end
		
		local unitData = t[unitName]
		
		if xp == 0 then
			unitData.n_zero = unitData.n_zero + 1
		else
			unitData.n = unitData.n + 1
			unitData.xp = unitData.xp + xp
		end
		
	end
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function widget:Initialize()
	if VFS.FileExists(LOGFILE, VFS.RAW) then
		data = VFS.Include(LOGFILE, nil, VFS.RAW)
	else
		data = {}
	end
	if not data[MOD_NAME] then
		data[MOD_NAME] = {
			atDestroyed = {},
			atGameOver = {},
		}
	end
	destroyedData = data[MOD_NAME].atDestroyed
	gameOverData = data[MOD_NAME].atGameOver
end

function widget:Shutdown()
	local allUnits = Spring.GetAllUnits()
	
	for i=1,#allUnits do
		ProcessUnit(allUnits[i], gameOverData)
	end
	
	for _, info in pairs(destroyedData) do
		if info.n > 0 then
			info.avg = info.xp / info.n
		else
			info.avg = 0
		end
		info.avg_zero = info.xp / (info.n + info.n_zero)
	end
	
	for _, info in pairs(gameOverData) do
		if info.n > 0 then
			info.avg = info.xp / info.n
		else
			info.avg = 0
		end
		info.avg_zero = info.xp / (info.n + info.n_zero)
	end
	table.save(data, LOGFILE)
end

function widget:GameOver()
	widgetHandler:RemoveWidget()
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	ProcessUnit(unitID, destroyedData)
end
