function gadget:GetInfo()
	return {
		name	  = "Spoils of War",
		desc	  = "Handles capturing of neutral units near flags",
		author	  = "yuritch",
		date	  = "6th May 2017",
		license   = "GNU GPL v2",
		layer	  = -5,
		enabled   = true  --  loaded by default?
	}
end

local sqrt = math.sqrt
local floor = math.floor

local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitDefID				= Spring.GetUnitDefID
local TransferUnit				= Spring.TransferUnit
local SetUnitNeutral			= Spring.SetUnitNeutral
local GetTeamStartPosition		= Spring.GetTeamStartPosition
local SetUnitHealth				= Spring.SetUnitHealth
local GetUnitIsTransporting		= Spring.GetUnitIsTransporting

local GetGroundHeight			= Spring.GetGroundHeight
local TestBuildOrder			= Spring.TestBuildOrder

local CreateUnit				= Spring.CreateUnit

local modOptions				= Spring.GetModOptions()

local currentMode = modOptions.spoilsofwar or 'disabled'

-- Should created units be paralyzed to prevent them shooting at players before being captured?
local stunSpawnedUnits = (currentMode ~= "mines")

local spawnTable = {}
local maxSpawnTier = 1

local flags = {}
local flagDistances = {}

if (gadgetHandler:IsSyncedCode()) then

local function InitFlagDistances()
	-- Store all team start positions
	local teams = Spring.GetTeamList()
	local teamStarts = {}
	for _, teamID in pairs(teams) do
		local x, y, z = GetTeamStartPosition(teamID)
		local teamRecord = {
			x = x,
			y = y,
			z = z,
		}
		teamStarts[teamID] = teamRecord
	end

	-- get all the flags
	local allUnits = Spring.GetAllUnits()
	for _, unitID in pairs(allUnits) do
		if GetUnitTeam(unitID) == GAIA_TEAM_ID then
			local cp = UnitDefs[GetUnitDefID(unitID)].customParams
			if cp and cp.flag then
				-- Initialize global flags table
				flags[#flags + 1] = unitID
				-- store min distance to player start pos
				local minDistance = -1
				local flagX, flagY, flagZ = GetUnitPosition(unitID)
				for _, teamRec in pairs(teamStarts) do
					local dx = teamRec.x - flagX
					local dy = teamRec.y - flagY
					local dz = teamRec.z - flagZ
					local distance = sqrt(dx * dx + dy * dy + dz * dz)
					if minDistance < 0 or (distance < minDistance) then
						minDistance = distance
					end
				end
				-- this is the distance to closest player spawn point from this flag
				flagDistances[unitID] = minDistance
			end
		end
	end
	-- now the table needs to be sorted according to distances
	table.sort(flags, function(unitID1, unitID2) return flagDistances[unitID1] < flagDistances[unitID2] end)
end

local function TransferSpawnedUnit(unitID, newTeamID)
	-- transfer unit to the new flag owner
	TransferUnit(unitID, newTeamID, false)
	SetUnitNeutral(unitID, false)
	if stunSpawnedUnits then
		SetUnitHealth(unitID, { paralyze = -1 })
	end
	-- Do the same for anything this unit might be transporting. This covers composite units too
	local cargoList = GetUnitIsTransporting(unitID)
	if cargoList and #cargoList > 0 then
		for _, cargoID in pairs(cargoList) do
			TransferSpawnedUnit(cargoID, newTeamID)
		end
	end
end

local function FlagCapNotification(flagID, teamID)
	--Spring.Log('spoils of war', 'error', "Flag cap event received: flagID " .. (flagID or 'nil') .. ' teamID: ' .. (teamID or nil))
	if flagID and teamID ~= GAIA_TEAM_ID then
		local flagDef = UnitDefs[GetUnitDefID(flagID)]
		local cp = flagDef.customParams
		if cp then	-- don't auto-cap other nearby flags
			local radius = tonumber(cp.flagradius) or 230	-- copied from flagManager
			-- get coords of the flag
			local ux, _, uz = GetUnitPosition(flagID)
			--Spring.Log('spoils of war', 'error', "flag coorsd: x " .. (ux or 'nil') .. ' y ' .. (uy or 'nil') .. ' radius ' .. (radius or 'nil'))
			local units = GetUnitsInCylinder(ux, uz, radius)
			--Spring.Log('spoils of war', 'error', "nearby unit count: " .. #units)
			for _, unitID in pairs(units) do
				if GetUnitTeam(unitID) == GAIA_TEAM_ID then
					-- is this not a flag?
					local cp2 = UnitDefs[GetUnitDefID(unitID)].customParams
					if (not cp2) or not (cp2.flag or cp2.ismine) then
						-- transfer unit to the new flag owner
						TransferSpawnedUnit(unitID, teamID)
					end
				end
			end
		end
	end
end

local function IsPositionValid(teamID, unitDefID, x, z)
	local CLEARANCE = 125
	-- Don't place units underwater. (this is also checked by TestBuildOrder
	-- but that needs proper maxWaterDepth/floater/etc. in the UnitDef.)
	local y = GetGroundHeight(x, z)
	if (y <= 0) then
		return false
	end
	-- Don't place units where it isn't be possible to build them normally.
	local test = TestBuildOrder(unitDefID, x, y, z, 0)
	if (test ~= 2) then
		return false
	end

	return true
end

local function DelayedCreate(unitTypeName, x, y, z, facing, teamID)
	local unitID = CreateUnit(unitTypeName, x, y, z, facing, teamID)
	SetUnitNeutral(unitID, true)
	if stunSpawnedUnits then
		SetUnitHealth(unitID, { paralyze = 1.0e9 })
	end
end

function gadget:Initialize()
	if currentMode ~= "disabled" then
		Spring.Log('spoils of war', 'info', 'Building spawn table for: ' .. currentMode)
		-- Register notification function
		GG.FlagCapNotification = FlagCapNotification
		-- load unit spawn table
		local UnitFiles = VFS.DirList("luarules/configs/spoils_of_war", "*.lua")
		Spring.Log('spoils of war', 'info', "Found "..#UnitFiles.." tables")
		-- then add their contents to the main table
		for _, UnitFile in pairs(UnitFiles) do
			Spring.Log('spoils of war', 'info', " - Processing "..UnitFile)
			local tmpTable = VFS.Include(UnitFile)
			if tmpTable then
				local tmpCount = 0
				for spawnType, spawnList in pairs(tmpTable) do
					Spring.Log('spoils of war', 'info', " -- spawn type: " .. spawnType)
					if currentMode == spawnType then
						for spawnTier, unitTable in pairs(spawnList) do
							Spring.Log('spoils of war', 'info', " --- spawn tier: " .. spawnTier)
							local n = tonumber(spawnTier)
							if not spawnTable[n] then
								spawnTable[n] = {}
							end
							-- find out what the max spawn tier is
							if n > maxSpawnTier then
								maxSpawnTier = n
							end
							local tmpTable = spawnTable[n]

							for _, unitName in pairs(unitTable) do
								Spring.Log('spoils of war', 'info', '---- adding: ' .. (unitName or 'nil'))
								tmpTable[#tmpTable + 1] = unitName
								tmpCount = tmpCount + 1
							end
						end
					end
				end
				Spring.Log('spoils of war', 'info', " -- Added "..tmpCount.." entries")
				tmpTable = nil
			end
		end
	else
		-- Unload if we're not needed
		Spring.Log('spoils of war', 'info', "Removing gadget because mode is not activated")
		GG.RemoveGadget(self)
	end
end

function gadget:GameStart()
end

function gadget:GameFrame(n)
	if currentMode == "disabled" then
		return
	end
	if n == 2 then
		InitFlagDistances()
	end
	if n == 3 then
		-- Spawn everything here, so the flags are already in place
		local random = math.random
		local maxFlagNum = #flags
		for flagNum, flagID in pairs(flags) do
			-- which spawn tier is that flag number?
			local curSpawnTier = floor(maxSpawnTier * (flagNum - 1) / maxFlagNum) + 1
			local tmpSpawnTable = spawnTable[curSpawnTier]
			local spawnUnitTypeCount = #tmpSpawnTable
			-- It is possible there are no units available for some of the tiers
			if spawnUnitTypeCount > 0 then
				-- get flag position
				local x, y, z = GetUnitPosition(flagID)
				-- get a random unit to place
				local i = random(spawnUnitTypeCount)
				local unitTypeName = tmpSpawnTable[i]
				-- it is possible there are empty units in the list, so check for that
				if unitTypeName and UnitDefNames[unitTypeName] then
					local unitTypeID = UnitDefNames[unitTypeName].id
					-- attempt to place this unit
					-- first directly at flag position
					if IsPositionValid(GAIA_TEAM_ID, unitTypeID, x, z) then
						GG.Delay.DelayCall(DelayedCreate, {unitTypeName, x, 0, z, 0, GAIA_TEAM_ID}, flagNum)
					else
						-- if not possible then attempt to shift a bit
						local maxSpread = 200
						local curSpread = 50
						local spreadStep = 50
						while curSpread <= maxSpread do
							local dx = random(-curSpread, curSpread)
							local dz = random(-curSpread, curSpread)
							if IsPositionValid(GAIA_TEAM_ID, unitTypeID, x + dx, z + dz) then
								GG.Delay.DelayCall(DelayedCreate, {unitTypeName, x + dx, 0, z + dz, 0, GAIA_TEAM_ID}, floor(flagNum / 10) + 1)
								break
							end
							curSpread = curSpread + spreadStep
						end
					end
				end
			end
		end
	end
end

end