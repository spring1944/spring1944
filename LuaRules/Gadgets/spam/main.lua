
-- main.lua
 
-- Spam main file
 
config = include ("LuaRules/Configs/spam_config.lua")
 
local ai_list = {}
local lifetime = {}
local randomness_factor = 16 -- Must be an integer and larger than zero
 
local function get_ai_instance (team)
    for _, i in ipairs (ai_list) do
        if i.team == team then
            return i
        end
    end
    return nil
end
 
local function GetSpamTeams ()
    local l = {}
    for _, i in ipairs (ai_list) do
        table.insert (l, i.team)
    end
    return l
end
 
local function GetSpamHq (team)
    local instance = get_ai_instance (team)
    if instance ~= nil then
        return instance.hq
    end
    return nil
end
 
local function CalcUnitLongevity (unitDefID)
    return 300 * Game.gameSpeed -- math.ceil ((Game.mapSizeX + Game.mapSizeZ) / UnitDefs[unitDefID].speed)
end
 
local function MakeSpamInstance (team)
    local instance = {}
    instance.team = team
    instance.ally = 0
    instance.unitCount = 0
    instance.hq = 0
    instance.build_list = {}
    instance.health_coeff = 1.0
    instance.enemies = {}
    for _, team in ipairs (Spring.GetTeamList ()) do
        if not Spring.AreTeamsAllied (team, instance.team) and team ~= Spring.GetGaiaTeamID () then
            table.insert (instance.enemies, team)
        end
    end
    if #instance.enemies == 0 then
        Spring.SetAlly (team, team, false) -- :)
        instance.current_enemy = team
    else
        instance.current_enemy = instance.enemies[math.random (#instance.enemies)]
    end
    instance.current_target = nil
    local x, y, z = Spring.GetTeamStartPosition (instance.current_enemy)
    instance.vector1 = {x, y ,z}
    instance.vector2 = {x, y ,z}
    instance.lastVector = false
    instance.current_squad = {}
    instance.current_squad_size = 0
    return instance
end
 
local function issue_build_order (instance, unitId, builder, x, y, z)
    Spring.GiveOrderToUnit (builder, -unitId, {x, y, z}, {"shift"})
    table.insert (instance.build_list, {unitId, builder})
end
 
local function build_order_completed (team, unit, unitDef)
    --local build_list = get_ai_instance(unit).build_list
   
end
 
local function apply_unit_bonus (unit)
 
end
 
local function SetTarget (teamID, target)
    local instance = get_ai_instance (teamID)
    if instance == nil then
        return
    end
    local x, y, z
    if type (target) == "number" then
        if target <= #Spring.GetTeamList () and not Spring.AreTeamsAllied (teamID, target) then
            x, y, z = Spring.GetTeamStartPosition (target)
            instance.current_enemy = target
        end
    elseif type (target) == "table" and #target == 3 then
        x = target[1]
        y = target[2]
        z = target[3]
        --instance.current_enemy = nil
    else
        target = nil
    end
    if target ~= nil then
        Spring.GiveOrderToUnit (instance.hq, CMD.FIGHT, {x, y, z}, {})
        Spring.GiveOrderToUnit (instance.hq, CMD.MOVE, {x, y, z}, {"shift"}) -- For units that cannot fight
    end
end
 
local function make_random_build_order (build_list)
    local new_list = {}
    for _, i in ipairs (build_list) do
        for j = 0, i[2] do
            table.insert (new_list, i[1])
        end
    end
    for i = 1, #new_list + 1 do
        local x = math.random (#new_list) + 1
        if new_list[i] ~= new_list[x] and math.random (math.round (math.abs (x - i) / #new_list * randomness_factor) + 1) == 1 then
            local t = new_list[i]
            new_list[i] = new_list[x]
            new_list[x] = t
        end
    end
    return new_list
end
 
local function StartSpam (team)
    local instance = get_ai_instance (team)
    if instance == nil then
        return nil
    end
    for _, unit in ipairs (make_random_build_order (config.build_order)) do
        Spring.GiveOrderToUnit (instance.hq, -(UnitDefNames[unit].id), {}, {"shift"})
    end
end
 
local function SpawnSpam (team)
    local instance = get_ai_instance (team)
    if instance == nil then
        return nil
    end
    local x, y, z = Spring.GetTeamStartPosition (team)
    local rot = 0
    local hq = Spring.CreateUnit ("spam_hq", x, y, z, rot, team) -- Create hq first and then remove all other units to not kill the team
    Spring.LevelHeightMap ((x - 4) / 16, (z - 4) / 16, (x + 4) / 16, (z + 4) / 16, y)
    --if select (Spring.GetTeamStartPosition (instance.team), 1) <= )
    instance.hq = hq
    for _, unit in ipairs (Spring.GetTeamUnits (team)) do -- Spawn hq first so game ending doesnt trigger
        if unit ~= hq then
            Spring.DestroyUnit (unit, false, true)
        end
    end
    Spring.SetTeamRulesParam (team, "commander", "{{" .. "-1, " .. tostring (hq) .. "}}") -- Galactic conquest specific needed setting
    if config.metal_income ~= nil then
        Spring.SetUnitResourcing (hq, "umm", config.metal_income)
    end
    if config.energy_income ~= nil then
        Spring.SetUnitResourcing (hq, "ume", config.energy_income)
    end
    if config.hq_build_speed ~= nil then
        Spring.SetUnitBuildSpeed (hq, config.hq_build_speed)
    end
    if config.hq_los ~= nil then
        Spring.SetUnitSensorRadius (hq, "los", config.hq_los)
    end
    if config.hq_hp ~= nil then
        Spring.SetUnitMaxHealth (hq, config.hq_hp)
        Spring.SetUnitHealth (hq, config.hq_hp)
    end
    x, y, z = Spring.GetTeamStartPosition (instance.current_enemy)
    Spring.GiveOrderToUnit (hq, CMD.REPEAT, {1}, {}) -- Remove this when factories can idle in spring
    Spring.GiveOrderToUnit (hq, CMD.FIGHT, {x, y, z}, {})
    Spring.GiveOrderToUnit (hq, CMD.MOVE, {x, y, z}, {"shift"}) -- For units that cannot fight
    GG.Delay.DelayCall (function (t) StartSpam (t) end, {team}, config.wait * Game.gameSpeed)
    return hq
end
 
function gadget:Initialize ()
    for _, t in ipairs (Spring.GetTeamList ()) do
        local teamID, _, _, isAI = Spring.GetTeamInfo (t)
        if isAI and Spring.GetTeamLuaAI (teamID) == gadget:GetInfo ().name then
            table.insert (ai_list, MakeSpamInstance (teamID))
        end
    end
    if #ai_list == 0 then
        gadgetHandler:RemoveGadget ()
    end
    for index, unit in ipairs (config.build_order) do
        if UnitDefNames[unit[1]] == nil then
            Spring.Echo ("Invalid unitdef name " .. unit[1] .. " specified in spam build order")
            for i = index, #build_order do
                config.build_order[i] = config.build_order[i + 1]
            end
            unit[#config.build_order] = nil
        end    
    end
    if #config.build_order == 0 then
        for _, instance in ipairs (ai_list) do
            Spring.KillTeam (instance.team)
        end
        Spring.Echo ("Empty spam build list, quitting please check LuaRules/Configs/spam_config.lua.")
        gadgetHandler:RemoveGadget ()
        return
    end
    Spring.Echo ("SPAM loaded for: " .. Game.gameName)
    for _, instance in ipairs (ai_list) do
        GG.Delay.DelayCall (function (i) SpawnSpam (i) end, {instance.team}, 1) -- Because in the first frame units need to be spawned by default gadget
    end
    for _, p in ipairs (Spring.GetPlayerList ()) do
        GG.Delay.DelayCall (Spring.SendMessageToPlayer, {p, config.warning}, config.wait * Game.gameSpeed)
    end
end
 
function gadget:UnitCreated (unitID, unitDefID, unitTeam, builderID)
    local instance = get_ai_instance (unitTeam)
    if instance ~= nil then
        local maxHealth = select (2, Spring.GetUnitHealth (unitID))
        Spring.GiveOrderToUnit (unitID, CMD.FIRE_STATE, {2}, {})
        Spring.GiveOrderToUnit (unitID, CMD.MOVE_STATE, {2}, {})
        --Spring.SetUnitMaxHealth (unitID, maxHealth + instance.health_coeff)
        if instance.unitCount + 1 == max_units and instance.unitCount < max_units then -- Units may be created by gadgets thus check for extra
            Spring.GiveOrderToUnit (instance.hq, CMD.WAIT, {}, {})
            for _, player in ipairs (Spring.GetPlayerList ()) do
                Spring.SendMessageToPlayer (player, "Go forth my minions!")
            end
        end
        instance.unitCount = instance.unitCount + 1
        if unitID ~= instance.hq and instance.hq ~= 0 then --
            GG.Delay.DelayCall (Spring.DestroyUnit, {unitID, false}, CalcUnitLongevity (unitDefID))
        end
    end
end
 
function gadget:UnitFinished (unitID, unitDefID, team)
end
 
function gadget:UnitFromFactory (unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
    local instance = get_ai_instance (unitTeam)
    if instance ~= nil then
        --Spring.GiveOrderToUnit (unitID, CMD.WAIT, {}, {}) -- This callin is broken in 103 it blocks factory
        table.insert (instance.current_squad, unitID)
        instance.current_squad_size = instance.current_squad_size + UnitDefs[unitDefID].metalCost
        if instance.current_squad_size >= 5000 then
            for _, i in ipairs (instance.current_squad) do
                --Spring.GiveOrderToUnit (i, CMD.WAIT, {}, {})
            end
            instance.current_squad = {}
            instance.current_squad_size = 0
        end
    end
end
 
function gadget:UnitDestroyed (unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    local instance = get_ai_instance (unitTeam)
    if instance ~= nil then
        if unitID == instance.hq then
            for _, p in ipairs (Spring.GetPlayerList ()) do
                Spring.SendMessageToPlayer (p, "I'll see you in hell!")
            end
            Spring.KillTeam (unitTeam)
        else
            instance.health_coeff = instance.health_coeff + 0.1
            if instance.unitCount == max_units then
                Spring.GiveOrderToUnit (instance.hq, CMD.WAIT, {}, {})
            end
            instance.unitCount = instance.unitCount - 1
        end
    else
        if math.random (10) == 0 then
            for _, p in ipairs (Spring.GetPlayerList ()) do
                Spring.SendMessageToPlayer (p, "Die!")
            end
        end
    end
end
 
function gadget:UnitEnteredLos (unitID, unitTeam, allyTeam, unitDefID)
    for _, team in pairs (Spring.GetTeamList (allyTeam)) do
        local instance = get_ai_instance (team)
        if instance ~= nil then
           if unitTeam == instance.current_enemy then
               local x, y, z = Spring.GetUnitPosition (unitID)
           end
        end
    end
end
 
function gadget:UnitIdle (unitID, unitDefID, unitTeam)
    if get_ai_instance (unitTeam) ~= nil then
        if unitID == get_ai_instance (unitTeam).hq then
            local maxHealth = select (2, Spring.GetUnitHealth (unitID))
            local metal, _, energy, _ = Spring.GetUnitResources (unitID)
            Spring.SetUnitResourcing (unitID, "umm", config.metal * config.hq_bonus_multiplier)
            Spring.SetUnitResourcing (unitID, "ume", config.energy * config.hq_bonus_multiplier)
            Spring.SetUnitBuildSpeed (unitID, Spring.GetUnitCurrentBuildPower (unitID) * config.hq_bonus_multiplier)
            Spring.SetUnitMaxHealth (unitID, maxHealth * config.hq_bonus_multiplier)
            Spring.SetUnitSensorRadius (unitID, "los", Spring.GetUnitSensorRadius (unitID, "los") * config.hq_bonus_multiplier)
            Spring.SetUnitSensorRadius (unitID, "radar", Spring.GetUnitSensorRadius (unitID, "radar") * config.hq_bonus_multiplier)
            Spring.SetUnitSensorRadius (unitID, "radarJammer", Spring.GetUnitSensorRadius (unitID, "radarJammer") * config.hq_bonus_multiplier)
            --for i = 1, 4 do
                Spring.SetUnitWeaponState (unitID, 1, "range", Spring.GetUnitMaxRange (unitID) * config.hq_bonus_multiplier)
            --end
            Spring.SetUnitMaxRange (unitID, Spring.GetUnitMaxRange (unitID) * config.hq_bonus_multiplier)
            for _, unit in ipairs (make_random_build_order (build_order)) do
                GG.Delay.DelayCall (Spring.GiveOrderToUnit, {unitID, -(UnitDefNames[unit].id), {}, {"shift"}}, 1)
            end
            for _, p in ipairs (Spring.GetPlayerList ()) do
                Spring.SendMessageToPlayer (p, "Huahahhahahahhaaaa! Try and take me now!")
            end
        else
            GG.Delay.DelayCall (Spring.GiveOrderToUnit, {unitID, CMD.ATTACK, {Spring.GetUnitNearestEnemy (unitID)}, {}}, 1)
        end
    end
end
 
function gadget:TeamDied (team)
    local newlist = {}
    for _, instance in ipairs (ai_list) do
        if instance.team ~= team then
            table.insert (newlist, instance)
        end
    end
    ai_list = newlist
    for _, instance in ipairs (ai_list) do
        instance.enemies = {}
        for _, teamX in ipairs (Spring.GetTeamList ()) do
            local dead = select (3, Spring.GetTeamInfo (teamX))
            if not Spring.AreTeamsAllied (teamX, instance.team) and teamX ~= Spring.GetGaiaTeamID () and not dead and teamX ~= team then
                table.insert (instance.enemies, teamX)
            end
        end
        if #instance.enemies == 0 then -- Let the bots kill one another after game is over :p
            Spring.SetAlly (instance.team, team, false)
            instance.current_enemy = instance.team
        else
            instance.current_enemy = instance.enemies[math.random (#instance.enemies)]
        end
        local x, y, z = Spring.GetTeamStartPosition (instance.current_enemy)
        for _, unit in ipairs (Spring.GetTeamUnits (instance.team)) do
            Spring.GiveOrderToUnit (unit, CMD.FIGHT, {x, y, z}, {})
        end
    end
end
 
GG.Spam = {GetSpamTeams = GetSpamTeams,
           GetSpamHq = GetSpamHq,
           MakeSpamInstance = MakeSpamInstance,
           SpawnSpam = SpawnSpam,
           SetTarget = SetTarget}
           
