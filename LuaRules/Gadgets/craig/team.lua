-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local team = CreateTeam(myTeamID, myAllyTeamID, mySide)

function team.UnitCreated(unitID, unitDefID, unitTeam, builderID)
function team.UnitFinished(unitID, unitDefID, unitTeam)
function team.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
function team.UnitTaken(unitID, unitDefID, unitTeam, newTeam)
function team.UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
]]--

function CreateTeam(myTeamID, myAllyTeamID, mySide)

local team = {}

-- constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

-- Enemy start positions (assumes this are base positions)
local enemyBases = {}
local enemyBaseCount = 0
local enemyBaseLastAttacked = 0

-- Unit building (one buildOrder per factory)
local unitBuildOrder = gadget.unitBuildOrder

-- Base building (one global buildOrder)
local buildsiteFinder = CreateBuildsiteFinder(myTeamID)
local baseBuildOrder = gadget.baseBuildOrder[mySide]
local baseBuildIndex = 0
local baseBuilders = gadget.baseBuilders
local baseBuildOptions = {} -- map of unitDefIDs (buildOption) to unitDefIDs (builders)
local baseBuildOptionsDirty = false
local currentBuild          -- one unitDefID
local currentBuilder        -- one unitID

local delayedCallQue = { first = 1, last = 0 }

local Log = function (message)
	Log("Team[" .. myTeamID .. "] " .. message)
end

local function DelayedCall(fun)
	delayedCallQue.last = delayedCallQue.last + 1
	delayedCallQue[delayedCallQue.last] = fun
end

local function PopDelayedCall()
	local ret = delayedCallQue[delayedCallQue.first]
	if ret then
		delayedCallQue.first = delayedCallQue.first + 1
	end
	return ret
end

-- does not modify sim; is called from outside GameFrame
local function BuildBaseInterrupted(violent)
	if violent then
		baseBuildIndex = baseBuildIndex - 1
		Log("Reset baseBuildIndex to " .. baseBuildIndex)
	end
	currentBuild = nil
	currentBuilder = nil
end

-- modifies sim, only call this in GameFrame! (or use DelayedCall)
local function BuildBase()
	if currentBuild then
		local unitID = Spring.GetUnitIsBuilding(currentBuilder)
		local vx,vy,vz = Spring.GetUnitVelocity(currentBuilder)
		local _,_,inBuild = Spring.GetUnitIsStunned(currentBuilder)
		-- consider build aborted when:
		-- * the builder isn't building anymore (unitID == nil)
		-- * the builder doesn't exist anymore (vx == nil)
		-- * the builder is not moving, except when he is being build!
		if (unitID == nil) and ((vx == nil) or ((vx*vx + vz*vz < 0.0001) and (not inBuild))) then
			Log(UnitDefs[currentBuild].humanName .. " was finished/aborted, but neither UnitFinished nor UnitDestroyed was called")
			BuildBaseInterrupted(false)
		--[[else
			local _,_,inBuild = Spring.GetUnitIsStunned(unitID)
			if not inBuild then
				Log(UnitDefs[currentBuild].humanName .. " was finished, but neither UnitFinished nor UnitDestroyed was called (2)")
				BuildBaseInterrupted(false)
			end]]--
		end
	end

	-- nothing to do if something is still being build
	if currentBuild then return end

	local unitDefID = baseBuildOrder[baseBuildIndex + 1]
	-- restart queue when finished
	if not unitDefID then
		baseBuildIndex = 0
		unitDefID = baseBuildOrder[1]
		Log("Restarted baseBuildOrder, next item: " .. UnitDefs[unitDefID].humanName)
	end

	local builderDefID = baseBuildOptions[unitDefID]
	-- nothing to do if we have no builders available yet who can build this
	if not builderDefID then Log("No builder available for " .. UnitDefs[unitDefID].humanName) return end

	local builders = Spring.GetTeamUnitsByDefs(myTeamID, builderDefID)
	if not builders then Log("internal error: Spring.GetTeamUnitsByDefs returned nil") return end

	local builderID = builders[1]
	if not builderID then Log("internal error: Spring.GetTeamUnitsByDefs returned empty array") return end

	-- give the order to the builder, iff we can find a buildsite
	local x,y,z,facing = buildsiteFinder.FindBuildsite(builderID, unitDefID)
	if not x then Log("Could not find buildsite for " .. UnitDefs[unitDefID].humanName) return end

	Log("Queueing in place: " .. UnitDefs[unitDefID].humanName)
	Spring.GiveOrderToUnit(builderID, -unitDefID, {x,y,z,facing}, {})

	-- give guard order to the other builders with the same def
	for i=2,#builders do
		Spring.GiveOrderToUnit(builders[i], CMD.GUARD, {builderID}, {})
	end

	-- TODO: give guard order to all builders with another def

	-- finally, register the build as started
	baseBuildIndex = baseBuildIndex + 1
	currentBuild = unitDefID
	currentBuilder = builderID
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function team.GameStart()
	Log("GameStart")
	-- Can not run this in the initialization code at the end of this file,
	-- because at that time Spring.GetTeamStartPosition seems to always return 0,0,0.
	for _,t in ipairs(Spring.GetTeamList()) do
		--Log("considering team " .. t)
		if (t ~= GAIA_TEAM_ID) and (not Spring.AreTeamsAllied(myTeamID, t)) then
			local x,y,z = Spring.GetTeamStartPosition(t)
			if x and x ~= 0 then
				enemyBaseCount = enemyBaseCount + 1
				enemyBases[enemyBaseCount] = {x,y,z}
				Log("Enemy base spotted at coordinates: " .. x .. ", " .. z)
			else
				Log("Oops, Spring.GetTeamStartPosition failed")
			end
		end
	end
	Log("Preparing to attack " .. enemyBaseCount .. " enemies")
end

function team.GameFrame(f)
	Log("GameFrame")

	-- update baseBuildOptions
	if baseBuildOptionsDirty then
		baseBuildOptionsDirty = false
		baseBuildOptions = {}
		local unitCounts = Spring.GetTeamUnitsCounts(myTeamID)
		for ud,_ in pairs(baseBuilders) do
			if unitCounts[ud] and unitCounts[ud] > 0 then
				Log(unitCounts[ud] .. " x " .. UnitDefs[ud].humanName)
				for _,bo in ipairs(UnitDefs[ud].buildOptions) do
					if not baseBuildOptions[bo] then
						Log("Base can now build " .. UnitDefs[bo].humanName)
						baseBuildOptions[bo] = ud --{}
					end
					--baseBuildOptions[bo][ud] = true
				end
			end
		end
	end

	while true do
		local fun = PopDelayedCall()
		if fun then fun() else break end
	end

	BuildBase()
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

-- Currently unitTeam always equals myTeamID (enforced in gadget)

function team.UnitCreated(unitID, unitDefID, unitTeam, builderID)
	buildsiteFinder.UnitCreated(unitID, unitDefID, unitTeam, builderID)
end

function team.UnitFinished(unitID, unitDefID, unitTeam)
	Log("UnitFinished: " .. UnitDefs[unitDefID].humanName)

	-- idea from BrainDamage: instead of cheating huge amounts of resources,
	-- just cheat in the cost of the units we build.
	Spring.AddTeamResource(myTeamID, "metal", UnitDefs[unitDefID].metalCost)
	Spring.AddTeamResource(myTeamID, "energy", UnitDefs[unitDefID].energyCost)

	-- queue unitBuildOrders if we have any for this unitDefID
	if unitBuildOrder[unitDefID] then
		DelayedCall(function()
			local factory = (UnitDefs[unitDefID].TEDClass == "PLANT") -- factory or builder?
			for _,bo in ipairs(unitBuildOrder[unitDefID]) do
				if factory then
					Log("Queueing: " .. UnitDefs[bo].humanName)
					Spring.GiveOrderToUnit(unitID, -bo, {}, {})
				else
					Log("Queueing in place: " .. UnitDefs[bo].humanName)
					if UnitDefs[bo].speed == 0 then
						Log("Warning: it's not recommended to queue buildings through unitBuildOrder!")
					end
					local x,y,z,facing = buildsiteFinder.FindBuildsite(unitID, bo)
					Spring.GiveOrderToUnit(unitID, -bo, {x,y,z,facing}, {"shift"})
				end
			end
			if factory then
				-- If there are no enemies, don't bother lagging Spring to death:
				-- just go through the build queue exactly once, instead of repeating it.
				if enemyBaseCount > 0 then
					Spring.GiveOrderToUnit(unitID, CMD.REPEAT, {1}, {})
					-- Each next factory gives fight command to next enemy.
					-- Didn't use math.random() because it's really hard to establish
					-- a 100% correct distribution when you don't know whether the
					-- upper bound of the RNG is inclusive or exclusive.
					enemyBaseLastAttacked = enemyBaseLastAttacked + 1
					if enemyBaseLastAttacked > enemyBaseCount then
						enemyBaseLastAttacked = 1
					end
					-- queue up a bunch of fight orders towards all enemies
					local idx = enemyBaseLastAttacked
					for i=1,enemyBaseCount do
						-- enemyBases[] is in the right format to pass into GiveOrderToUnit...
						Spring.GiveOrderToUnit(unitID, CMD.FIGHT, enemyBases[idx], {"shift"})
						idx = idx + 1
						if idx > enemyBaseCount then idx = 1 end
					end
				end
			end
		end)
	end

	-- update base building
	if baseBuilders[unitDefID] then
		for _,bo in ipairs(UnitDefs[unitDefID].buildOptions) do
			if not baseBuildOptions[bo] then
				Log("Base can now build " .. UnitDefs[bo].humanName)
				baseBuildOptions[bo] = unitDefID --{}
			end
			--baseBuildOptions[bo][unitDefID] = true
		end
	end
	if unitDefID == currentBuild then
		Log("CurrentBuild finished")
		BuildBaseInterrupted(false)
	end
end

function team.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	Log("UnitDestroyed: " .. UnitDefs[unitDefID].humanName)

	buildsiteFinder.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)

	-- update baseBuildOptions
	if baseBuilders[unitDefID] then
		baseBuildOptionsDirty = true
	end

	-- update base building
	if unitDefID == currentBuild then
		Log("CurrentBuild destroyed")
		BuildBaseInterrupted(true)
	end
	if unitID == currentBuilder then
		Log("CurrentBuilder destroyed")
		BuildBaseInterrupted(true)
	end
end

function team.UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	team.UnitDestroyed(unitID, unitDefID, unitTeam)
end

function team.UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	team.UnitCreated(unitID, unitDefID, unitTeam, nil)
	local _, _, inBuild = Spring.GetUnitIsStunned(unitID)
	if not inBuild then
		team.UnitFinished(unitID, unitDefID, unitTeam)
	end
end

--------------------------------------------------------------------------------
--
--  Initialization
--

if not baseBuildOrder then
	error("C.R.A.I.G. is not configured properly to play as " .. mySide)
end

Log("assigned to " .. gadget:GetInfo().name .. " (allyteam: " .. myAllyTeamID .. ", side: " .. mySide .. ")")

return team
end
