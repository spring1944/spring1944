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

local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitDefID				= Spring.GetUnitDefID
local TransferUnit				= Spring.TransferUnit
local SetUnitNeutral			= Spring.SetUnitNeutral

local GetGroundHeight			= Spring.GetGroundHeight
local TestBuildOrder			= Spring.TestBuildOrder

local CreateUnit				= Spring.CreateUnit

local modOptions				= Spring.GetModOptions()

local currentMode = modOptions.spoilsofwar
local spawnTable = {}

if (gadgetHandler:IsSyncedCode()) then

function FlagCapNotification(flagID, teamID)
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
					if not cp2 or not cp2.flag then
						-- transfer unit to the new flag owner
						TransferUnit(unitID, teamID, false)
						SetUnitNeutral(unitID, false)
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
	--[[	
	local ud = UnitDefs[unitDefID]
	-- avoid plopping units in places they can't move out of
	if ud.speed > 0 then
		local sx, sy, sz = GetTeamStartPosition(teamID)
		local validMoveToStart = TestMoveOrder(unitDefID, x, y, z, sx, sy, sz, true, true)
		if not validMoveToStart then
			return false
		end
	end
	-- Don't place units too close together.
	local units = GetUnitsInCylinder(x, z, CLEARANCE)
	if (units[1] ~= nil) then
		return false
	end
	]]--
	return true
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
				for spawnType, unitTable in pairs(tmpTable) do
					if currentMode == spawnType then
						for _, unitName in pairs(unitTable) do
							Spring.Log('spoils of war', 'info', 'Adding: ' .. (unitName or 'nil'))
							spawnTable[#spawnTable + 1] = unitName
						end
					end
					tmpCount = tmpCount + 1
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
	if n == 2 then
		-- Spawn everything here, so the flags are already in place
		local allUnits = Spring.GetAllUnits()
		local flags = {}
		for _, unitID in pairs(allUnits) do
			if GetUnitTeam(unitID) == GAIA_TEAM_ID then
				local cp = UnitDefs[GetUnitDefID(unitID)].customParams
				if cp and cp.flag then
					flags[#flags + 1] = unitID
				end
			end
		end
		local spawnUnitTypeCount = #spawnTable
		local random = math.random
		for _, flagID in pairs(flags) do
			-- get flag position
			local x, y, z = GetUnitPosition(flagID)
			-- get a random unit to place
			local i = random(spawnUnitTypeCount)
			local unitTypeName = spawnTable[i]
			--Spring.Echo('unitType ' .. i .. ' is ' .. (unitTypeName or 'nil'))
			local unitTypeID = UnitDefNames[unitTypeName].id
			-- attempt to place this unit
			-- first directly at flag position
			if IsPositionValid(GAIA_TEAM_ID, unitTypeID, x, z) then
				local unitID = CreateUnit(unitTypeName, x, 0, z, 0, GAIA_TEAM_ID)
				SetUnitNeutral(unitID, true)
			else
				-- if not possible then attempt to shift a bit
				local maxSpread = 200
				local curSpread = 50
				local spreadStep = 50
				while curSpread <= maxSpread do
					local dx = random(-curSpread, curSpread)
					local dz = random(-curSpread, curSpread)
					if IsPositionValid(GAIA_TEAM_ID, unitTypeID, x + dx, z + dz) then
						local unitID = CreateUnit(unitTypeName, x + dx, 0, z + dz, 0, GAIA_TEAM_ID)
						SetUnitNeutral(unitID, true)
						break
					end
					curSpread = curSpread + spreadStep
				end
			end
		end
	end
end

end