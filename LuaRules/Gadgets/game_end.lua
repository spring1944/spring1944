--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
    return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
    return {
        name      = "Game Over",
        desc      = "GAME OVER! (handles conditions thereof)",
        author    = "SirMaverick, Google Frog, KDR_11k, CarRepairer (unified by KingRaptor)",
        date      = "2009",
        license   = "GPL",
        layer     = 1,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--  End game if only one allyteam with players AND units is left.
--  An allyteam is counted as dead if none of
--  its active players have units left.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local spGetTeamInfo         = Spring.GetTeamInfo
local spGetTeamList         = Spring.GetTeamList
local spGetTeamUnits        = Spring.GetTeamUnits
local spDestroyUnit         = Spring.DestroyUnit
local spGetAllUnits         = Spring.GetAllUnits
local spGetAllyTeamList     = Spring.GetAllyTeamList
local spGetPlayerInfo       = Spring.GetPlayerInfo
local spGetPlayerList       = Spring.GetPlayerList
local spAreTeamsAllied      = Spring.AreTeamsAllied
local spGetUnitTeam         = Spring.GetUnitTeam
local spGetUnitDefID        = Spring.GetUnitDefID
local spGetUnitIsStunned    = Spring.GetUnitIsStunned
local spGetUnitHealth       = Spring.GetUnitHealth
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
local spTransferUnit        = Spring.TransferUnit
local spKillTeam            = Spring.KillTeam
local spGameOver            = Spring.GameOver
local spEcho                = Spring.Echo
local spSetTeamShareLevel   = Spring.SetTeamShareLevel

local ECON_SUPREMACY_MULT = 25

--------------------------------------------------------------------------------
-- vars
--------------------------------------------------------------------------------
local gaiaTeamID = Spring.GetGaiaTeamID()
local gaiaAllyTeamID = select(6, Spring.GetTeamInfo(gaiaTeamID))

local aliveCount = {}
local aliveValue = {}
local destroyedAlliances = {}
local allianceToReveal

local finishedUnits = {}    -- this stores a list of all units that have ever been completed, so it can distinguish between incomplete and partly reclaimed units
local toDestroy = {}

local modOptions = Spring.GetModOptions() or {}
local destroy_type = modOptions.defeatmode or 'losecontrol'

local revealed = false
local gameover = false
local gameOverSent = false

local nilUnitDef = {id=-1}
local function GetUnitDefIdByName(defName)
  return (UnitDefNames[defName] or nilUnitDef).id
end

local allyTeams = spGetAllyTeamList()

local inactiveWinAllyTeam = false

--------------------------------------------------------------------------------
-- local funcs
--------------------------------------------------------------------------------

local function isFinished(UnitID)
  local _,_,_,_,buildProgress = spGetUnitHealth(UnitID)
  return (buildProgress==nil)or(buildProgress>=1)
end

local function CountAllianceUnits(allianceID)
    local teamlist = spGetTeamList(allianceID) or {}
    local count = 0
    for i=1,#teamlist do
        local teamID = teamlist[i]
        count = count + (aliveCount[teamID] or 0)
    end
    return count
end

local function CountAllianceValue(allianceID)
    local teamlist = spGetTeamList(allianceID) or {}
    local value = 0
    for i=1,#teamlist do
        local teamID = teamlist[i]
        value = value + (aliveValue[teamID] or 0)
    end
    return value
end

local function EchoUIMessage(message)
    spEcho("game_message: " .. message)
end

local function UnitWithinBounds(unitID)
    local x, y, z = Spring.GetUnitPosition(unitID)
    return (x > -500) and (x < Game.mapSizeX + 500) and (y > -1000) and (z > -500) and (z < Game.mapSizeZ + 500)
end

-- if only one allyteam left, declare it the victor
local function CheckForVictory()
	if Spring.IsCheatingEnabled() or gameOverSent then
		return
	end
    local allylist = spGetAllyTeamList()
    local count = 0
    local lastAllyTeam
    for _,a in pairs(allylist) do
        if not destroyedAlliances[a] and (a ~= gaiaAllyTeamID) then
            count = count + 1
            lastAllyTeam = a
        end
    end
    if count < 2 then
		EchoUIMessage(( (lastAllyTeam and ("Alliance " .. lastAllyTeam)) or "Nobody") .. " wins!")
		if Spring.GetGameFrame() > 1 then
			spGameOver({lastAllyTeam})
			gameOverSent = true
		else
			Spring.Echo("But it's only the first frame, so I think you don't want me to stop this game yet")
			GG.RemoveGadget(gadget)
		end
    end
end

local function RevealAllianceUnits(allianceID)
    allianceToReveal = allianceID
    local teamList = spGetTeamList(allianceID)
    for i=1,#teamList do
        local t = teamList[i]
        local teamUnits = spGetTeamUnits(t)
        for j=1,#teamUnits do
            local u = teamUnits[j]
            -- purge extra-map units
            if not UnitWithinBounds(u) then
                Spring.DestroyUnit(u)
            else
                Spring.SetUnitAlwaysVisible(u, true)
            end
        end
    end
end

-- purge the alliance!
local function DestroyAlliance(allianceID)
    if not destroyedAlliances[allianceID] then
        destroyedAlliances[allianceID] = true
        local teamList = spGetTeamList(allianceID)
        if teamList == nil then return end  -- empty allyteam, don't bother

        if Spring.IsCheatingEnabled() or destroy_type == 'debug' then
            EchoUIMessage("Game Over: DEBUG")
            EchoUIMessage("Game Over: Allyteam " .. allianceID .. " has met the game over conditions.")
            EchoUIMessage("Game Over: If this is true, then please resign.")
            return  -- don't perform victory check
        elseif destroy_type == 'destroy' then   -- kaboom
            EchoUIMessage("Game Over: Destroying alliance " .. allianceID)
            for i=1,#teamList do
                local t = teamList[i]
                local teamUnits = spGetTeamUnits(t)
                for j=1,#teamUnits do
                    local u = teamUnits[j]
                    toDestroy[u] = true
                end
                spKillTeam(t)
            end
        elseif destroy_type == 'losecontrol' then   -- no orders can be issued to team
            EchoUIMessage("Game Over: Destroying alliance " .. allianceID)
			if Spring.GetGameFrame() > 1 then
				for i=1,#teamList do
					spKillTeam(teamList[i])
				end
			else
				Spring.Echo("I don't feel like killing teams in the first frame of the game")
			end
        end
    end
    CheckForVictory()
end
GG.DestroyAlliance = DestroyAlliance

local function AddAllianceUnit(u, ud, teamID)
	local cp = UnitDefs[ud].customParams
	if cp and cp.dontcount == "1" then
        return
	end
    local _, _, _, _, _, allianceID = spGetTeamInfo(teamID)
    aliveCount[teamID] = aliveCount[teamID] + 1

    aliveValue[teamID] = aliveValue[teamID] + UnitDefs[ud].metalCost

end

local function RemoveAllianceUnit(u, ud, teamID)
    local cp = UnitDefs[ud].customParams
	if cp and cp.dontcount == "1" then
        return
	end
	local _, _, _, _, _, allianceID = spGetTeamInfo(teamID)
    aliveCount[teamID] = aliveCount[teamID] - 1

    -- dead team, set share levels to 0 so allies can benefit from existing
    -- resources.
    if aliveCount[teamID] <= 0 then
        aliveCount[teamID] = 0
        spSetTeamShareLevel(teamID, 'metal', 0)
        spSetTeamShareLevel(teamID, 'energy', 0)
    end

    aliveValue[teamID] = aliveValue[teamID] - UnitDefs[ud].metalCost
    if aliveValue[teamID] < 0 then
        aliveValue[teamID] = 0
    end

    if CountAllianceUnits(allianceID) <= 0 then
        Spring.Log(gadget:GetInfo().name, LOG.INFO, "<Game Over> Purging allyTeam " .. allianceID)
        DestroyAlliance(allianceID)
    end
end

local function CompareArmyValues(ally1, ally2)
    local value1, value2 = CountAllianceValue(ally1), CountAllianceValue(ally2)
    if value1 > ECON_SUPREMACY_MULT*value2 then
        return ally1
    elseif value2 > ECON_SUPREMACY_MULT*value1 then
        return ally2
    end
    return nil
end

-- used during initialization
local function CheckAllUnits()
    aliveCount = {}
    local teams = spGetTeamList()
    for i=1,#teams do
        local teamID = teams[i]
        if teamID ~= gaiaTeamID then
            aliveCount[teamID] = 0
        end
    end
    local units = spGetAllUnits()
    for i=1,#units do
        local unitID = units[i]
        local teamID = spGetUnitTeam(unitID)
        local unitDefID = spGetUnitDefID(unitID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end
end

-- check for active players
local function ProcessLastAlly()
    if Spring.IsCheatingEnabled() or destroy_type == 'debug' then
        return
    end
    local allylist = spGetAllyTeamList()
    local activeAllies = {}
	local droppedAllies = {}
    local lastActive = nil
	for i = 1, #allylist do
        repeat
        local a = allylist[i]
        if (a == gaiaAllyTeamID) then break end -- continue
        if (destroyedAlliances[a]) then break end -- continue
        local teamlist = spGetTeamList(a)
        if (not teamlist) then break end -- continue
        local activeTeams = 0
		local hasActiveTeam = false
		local hasDroppedTeam = false
        for i=1,#teamlist do
            local t = teamlist[i]
            -- any team without units is dead to us; so only teams who are active AND have units matter
            local numAlive = aliveCount[t]
            if #(Spring.GetTeamUnits(t)) == 0 then numAlive = 0 end
            if numAlive > 0 then
                local playerlist = spGetPlayerList(t, true) -- active players
                if playerlist then
						for j = 1, #playerlist do
							local name,active,spec = spGetPlayerInfo(playerlist[j])
							if not spec then
								if active then
									hasActiveTeam = true
									activeTeams = activeTeams + 1
								else
									hasDroppedTeam = true
								end
							else
							end
						end
					end

                -- count AI teams as active
                local _,_,_,isAiTeam = spGetTeamInfo(t)
                if isAiTeam then
                    activeTeams = activeTeams + 1
                end
            end
        end
        if activeTeams > 0 then
            activeAllies[#activeAllies+1] = a
            lastActive = a
		elseif hasDroppedTeam then
			droppedAllies[#droppedAllies+1] = a
        end
        until true
    end -- for

	-- trying to add ZK 'inactivity win' functionality here
	if #activeAllies > 1 and inactiveWinAllyTeam then
		inactiveWinAllyTeam = false
		Spring.SetGameRulesParam("inactivity_win", -1)
	end

    if #activeAllies == 2 then
        if revealed then return end
        -- run value comparison
        local supreme = CompareArmyValues(activeAllies[1], activeAllies[2])
        if supreme then
            EchoUIMessage("AllyTeam " .. supreme .. " has an overwhelming numerical advantage!")
            for i=1, #allylist do
                local a = allylist[i]
                if (a ~= supreme) and (a ~= gaiaAllyTeamID) then
                    RevealAllianceUnits(a)
                    revealed = true
                end
            end
        end
    elseif #activeAllies < 2 then
		if #droppedAllies > 0 then
			if lastActive then
				inactiveWinAllyTeam = lastActive
				Spring.SetGameRulesParam("inactivity_win", lastActive)
			else
				Draw()
			end
		else
			if #activeAllies == 1 then
				-- remove every unit except for last active alliance
				for i=1, #allylist do
					local a = allylist[i]
					if (a ~= lastActive)and(a ~= gaiaAllyTeamID) then
						DestroyAlliance(a)
					end
				end
			else -- no active team. Killed each other?
				Draw()
			end
		end
    end
end

local function Draw() -- declares a draw
	if gameOverSent then
		return
	end
	EchoUIMessage("The game ended in a draw!")
	spGameOver({gaiaAllyTeamID}) -- exit uses {} so use Gaia for draw to differentiate
	gameOverSent = true
end

local function CheckInactivityWin(cmd, line, words, player)
	if inactiveWinAllyTeam and not gameover then
		if player then 
			local name,_,spec,_,allyTeamID = Spring.GetPlayerInfo(player)
			if allyTeamID == inactiveWinAllyTeam and not spec then
				Spring.Echo((name or "") .. " has forced a win due to dropped opposition.")
				CauseVictory(inactiveWinAllyTeam)
			end
		end
	end
end
--------------------------------------------------------------------------------
-- callins
--------------------------------------------------------------------------------

function gadget:UnitFinished(u, ud, team)
    if team ~= gaiaTeamID and not finishedUnits[u] then
        finishedUnits[u] = true
        AddAllianceUnit(u, ud, team)
    end
end

function gadget:UnitCreated(u, ud, team)
    if revealed then
        local allyTeam = select(6, spGetTeamInfo(team))
		if isFinished(u) then
			gadget:UnitFinished(u, ud, team)
		end
        if allyTeam == allianceToReveal then
            Spring.SetUnitAlwaysVisible(u, true)
        end
    end
end

function gadget:UnitDestroyed(u, ud, team)
    if team ~= gaiaTeamID and finishedUnits[u] then
        finishedUnits[u] = nil
        RemoveAllianceUnit(u, ud, team)
    end
    toDestroy[u] = nil
end

-- note: Taken comes before Given
function gadget:UnitGiven(u, ud, newTeam, oldTeam)
    if (newTeam ~= gaiaTeamID) and (not select(3,spGetUnitIsStunned(u))) then
        AddAllianceUnit(u, ud, newTeam)
    end
end

function gadget:UnitTaken(u, ud, oldTeam, newTeam)
    if (oldTeam ~= gaiaTeamID) and (select(5,spGetUnitHealth(u))>=1) then
        RemoveAllianceUnit(u, ud, oldTeam)
    end
end

function gadget:Initialize()
    local teams = spGetTeamList()
    for i=1,#teams do
        aliveValue[teams[i]] = 0
    end

    CheckAllUnits()

	gadgetHandler:AddChatAction('inactivitywin', CheckInactivityWin, "")

    Spring.Log(gadget:GetInfo().name, LOG.INFO, "Game Over initialized")
end

function gadget:GameFrame(n)
    -- check for last ally:
    -- end condition: only 1 ally with human players, no AIs in other ones
	if n == 1 then
		local playerlist = spGetPlayerList(t, true)
		local activePlayers = 0
		if playerlist then
			for j=1,#playerlist do
				local _,active,spec = spGetPlayerInfo(playerlist[j])
				if active and not spec then
					activePlayers = activePlayers + 1
				end
			end
		end

		-- add AIs
		local aTeamList = spGetAllyTeamList()
		local i
		for i = 1, #aTeamList do
			local teamList = spGetTeamList(aTeamList[i])
			local j
			for j = 1, #teamList do
				local _,_,_,isAiTeam = spGetTeamInfo(teamList[j])
				if isAiTeam then
					activePlayers = activePlayers + 1
				end
			end
		end
		
		if activePlayers < 2 then
			GG.RemoveGadget(gadget)
			return
		end
    elseif (n % 45 == 0) then
        if toDestroy then
            for u in pairs(toDestroy) do
                local ud = spGetUnitDefID(u)
                local isFlag = ud.customParams and ud.customParams.flag
                if not isFlag then
                    spDestroyUnit(u, true)
                end
            end
        end
        toDestroy = {}
        if not gameover then
            ProcessLastAlly()
        end
    end
end

function gadget:GameOver()
    gameover = true
end

