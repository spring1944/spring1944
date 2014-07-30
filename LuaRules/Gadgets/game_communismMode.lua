function gadget:GetInfo()
	return {
		name = "Communism mode",
		desc = "Handle communism mode option: income from flags distributed evenly between allied players",
		author = "Szunti",
		date = "aug 31, 2011",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end


-- function localisations
-- Synced Read
local GetUnitRulesParam			= Spring.GetUnitRulesParam
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitAllyTeam           = Spring.GetUnitAllyTeam
local AreTeamsAllied            = Spring.AreTeamsAllied
local GetAllyTeamList           = Spring.GetAllyTeamList
local GetTeamList               = Spring.GetTeamList
local GetTeamInfo               = Spring.GetTeamInfo

-- Synced Ctrl
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitResourcing			= Spring.SetUnitResourcing
local AddTeamResource           = Spring.AddTeamResource

-- constants
local GAIA_TEAM_ID		         = Spring.GetGaiaTeamID()
local GAIA_ALLYTEAM_ID           = select(6, GetTeamInfo(GAIA_TEAM_ID))

-- variables
local allyTeamFlags = {} -- allyTeamFlags[allyteamID] = {flagID1, flagID2, ...}
local numFlags = {} -- numFlags[allyTeamID] = numberOfFlagsForAllyTeam

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

--	Custom Functions
-- add flag to allyTeamFlags list, a flag shouldn't be added more than once
-- Gaia'a flags are handled
local function addFlag(allyTeamID, flagID)
	if allyTeamID ~= GAIA_ALLYTEAM_ID then -- leave GAIA_ALLYTEAM out
		if numFlags[allyTeamID] == nil then
			numFlags[allyTeamID] = 0
			allyTeamFlags[allyTeamID] = {}
		end
		local num = numFlags[allyTeamID]
		num = num + 1
		allyTeamFlags[allyTeamID][num] = flagID
		numFlags[allyTeamID] = num
	end	
end

local function removeFlag(allyTeamID, flagID)
	if allyTeamID ~= GAIA_ALLYTEAM_ID then -- leave GAIA_ALLYTEAM out
		local len = numFlags[allyTeamID] or 0
		-- introduce flags for more readable code, beacuse it's a table it's a reference, not a copy
		local flags = allyTeamFlags[allyTeamID]
		for i = 1, len do
			if flags[i] == flagID then
				if i == len then -- last flag in the list, just delete it
					flags[i] = nil
				else -- not last flag move last flag in place of the deleted one
					flags[i] = flags[len]
					flags[len] = nil
				end
				-- decrease numFlags
				len = len - 1
				numFlags[allyTeamID] = len
				break
			end
		end
	end
end
		
if (gadgetHandler:IsSyncedCode()) then
--SYNCED

-- CallIns
function gadget:Initialize()
	-- Remove the gadget if not using communism mode
	if modOptions and modOptions.communism_mode and modOptions.communism_mode ~= "1" then
		gadgetHandler:RemoveGadget()
	end
end

function gadget:GameStart()
	-- fill in allyTeamFlags
	for i = 1, #GG.flags do
		flagID = GG.flags[i]
		local allyTeamID = GetUnitAllyTeam(flagID)
		addFlag(allyTeamID, flagID)
		-- set flag's income to 0
		SetUnitResourcing(flagID, "umm", 0)
		SetUnitMetalExtraction(flagID, 0, 0)
	end
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	-- make allyTeamFlags follow changes
	if unitDefID == UnitDefNames.flag.id then -- flag change team
		-- if old and new teams are allied do nothing
		if not AreTeamsAllied(unitTeam, newTeam) then
		local oldAllyTeamID = select(6, GetTeamInfo(unitTeam))
		local newAllyTeamID = select(6, GetTeamInfo(newTeam))
		-- add the new flag
		addFlag(newAllyTeamID, unitID)
		removeFlag(oldAllyTeamID, unitID)
		else -- teams are allied
		-- do nothing
		end	
	else -- other unit
	-- do nothing
	end
end

function gadget:GameFrame(n)
	if n % 32 == 10 then -- every 32 frame, to not fluctuate in income, with 10 frame offset
	-- give command to players
		local allyTeamList = GetAllyTeamList()
		for i = 1, #allyTeamList do
			local allyTeam = allyTeamList[i]
			if allyTeam ~= GAIA_ALLYTEAM_ID then -- leave GAIA_ALLYTEAM out
				local teamList = GetTeamList(allyTeam)
				local numTeam = #teamList -- number of teams in this allyteam
				local totalCommand = 0
				-- sum command production from flags
				for i = 1, (numFlags[allyTeam] or 0) do
					local flags = allyTeamFlags[allyTeam]
					local flagID = flags[i]
					local production = GetUnitRulesParam(flagID, "production") 
					totalCommand = totalCommand + production
				end
				-- add income for the teams in the ally team
				local income = totalCommand/numTeam
				for i = 1, numTeam do
					local team = teamList[i]
					AddTeamResource(team, "metal", income)
				end
			end
		end
	end
end

else
--UNSYNCED
end
