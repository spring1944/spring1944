function gadget:GetInfo()
  return {
    name      = "megaboom",
    desc      = "allows ",
    author    = "asdfasd",
    date      = "asdfsd",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -5,
    enabled   = true  --  loaded by default?
  }
end

local GetTeamResources          = Spring.GetTeamResources
local UseTeamResource           = Spring.UseTeamResource
local InsertUnitCmdDesc			= Spring.InsertUnitCmdDesc
local EditUnitCmdDesc			= Spring.EditUnitCmdDesc
local SpawnProjectile           = Spring.SpawnProjectile
local GetTeamList               = Spring.GetTeamList
local GetUnitTeam               = Spring.GetUnitTeam
local FindUnitCmdDesc           = Spring.FindUnitCmdDesc

local MAP_GRAVITY = -1 * Game.gravity

local MEGABOOM_COST = 25000
local BOOM_RADIUS = 500
local NUMBER_OF_SHELLS = 300

-- indexed by teamID
local unitsWithTheBoom = {}
--synced only

if not gadgetHandler:IsSyncedCode() then return end

local CMD_BOOM = GG.CustomCommands.GetCmdID("CMD_BOOM")
local boomCmdDesc = {
	id = CMD_BOOM,
	type = CMDTYPE.ICON_MAP,
	name = "BOOM",
	action = "boom",
	tooltip = "Call in a heavy artillery strike from off-map",
	cursor = "Attack",
    disabled = true,
}


local weapChoices = {"ml20s152mmhe", "M30122mmHE", "qf25pdrhe", "QF75mmHE", "QF2Pdr40mmHE", "Bofors40mmHE"}

local function FireSalvo(x, y, z)
    local random = math.random
    local floor = math.floor
    DelayCall = GG.Delay.DelayCall
    
    for i=0,NUMBER_OF_SHELLS do
        local xShift = random() * BOOM_RADIUS
        if random() > 0.5 then
            xShift = -1 * xShift
        end

        local zShift = random() * BOOM_RADIUS
        if random() > 0.5 then
            zShift = -1 * zShift
        end
        local wd = WeaponDefNames[weapChoices[random(#weapChoices)]:lower()]
        local wdid = wd.id
        local spreadMult = 1.3
        local spawnProjectileArgs = {
            gravity = 0.001*MAP_GRAVITY,
            speed = {
                random() * spreadMult - random() * spreadMult,
                random() * spreadMult - random() * spreadMult,
                random() * spreadMult - random() * spreadMult
            },
            pos = { x + xShift, y + 15000, z + zShift }
        }
        spawnProjectileArgs['end'] = { x + xShift, y, z + zShift }

        DelayCall(SpawnProjectile, {wdid, spawnProjectileArgs}, floor(i * random()))
    end
end

local function EnableMegaboomForTeam(teamID)
    if unitsWithTheBoom[teamID] then
        for uid, alive in pairs(unitsWithTheBoom[teamID]) do
            local cmdDescID = FindUnitCmdDesc(uid, CMD_BOOM)
            EditUnitCmdDesc(uid, cmdDescID, {disabled = false})
        end
    end
end

local function DisableMegaboomForTeam(teamID)
    if unitsWithTheBoom[teamID] then
        for uid, alive in pairs(unitsWithTheBoom[teamID]) do
            local cmdDescID = FindUnitCmdDesc(uid, CMD_BOOM)
            EditUnitCmdDesc(uid, cmdDescID, {disabled = true})
        end
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_BOOM then
        local currentLog = GetTeamResources(teamID, "energy")
        if currentLog >= MEGABOOM_COST then
            UseTeamResource(teamID, "energy", MEGABOOM_COST)
            local x, y, z = cmdParams[1], cmdParams[2], cmdParams[3]
            FireSalvo(x, y, z)
            GG.Delay.DelayCall(FireSalvo, { x, y, z }, 30 * 15);
            GG.Delay.DelayCall(FireSalvo, { x, y, z }, 30 * 25);
        end
	end
	return true
end

function gadget:UnitCreated(uid, udid)
    local ud = UnitDefs[udid]
    local teamID = GetUnitTeam(uid)
    local isFactory = ud.buildSpeed and ud.modCategories["building"]
    if isFactory then
        InsertUnitCmdDesc(uid, boomCmdDesc)
        if not unitsWithTheBoom[teamID] then
            unitsWithTheBoom[teamID] = {}
        end
        unitsWithTheBoom[teamID][uid] = true
    end
end

function gadget:UnitDestroyed(uid, udid, teamID)
    if unitsWithTheBoom[teamID] and unitsWithTheBoom[teamID][uid] then
        unitsWithTheBoom[teamID][uid] = nil
    end
end

function gadget:GameFrame(n)
	if (n % (1*30) < 0.1) then
        local allTeams = GetTeamList()
        for i = 1, #allTeams do
            local teamID = allTeams[i]
            local currentLog = GetTeamResources(teamID, "energy")
            if currentLog > MEGABOOM_COST then
                EnableMegaboomForTeam(teamID)
            else
                DisableMegaboomForTeam(teamID)
            end
        end
	end
end


