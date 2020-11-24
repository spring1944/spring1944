function widget:GetInfo()
    return {
        name = "1944 Default Commands",
        desc = "Allows using the rightclick for some commands",
        author = "KDR_11k (David Becker), Craig Lawrence",
        date = "2008-06-24",
        license = "Public Domain",
        layer = 1,
        enabled = true
    }
end

local CMD_FIGHT = CMD.FIGHT
local CMD_ATTACK = CMD.ATTACK
local CMD_CAPTURE = CMD.CAPTURE
local CMD_AREA_ATTACK = 39954 -- as set in areaattack.lua gadget
local defCom = {}

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if (not defCom[unitDefID]) then
        local ud = UnitDefs[unitDefID]
        -- mobile combat units except SPGs, AT guns, etc
        --if (ud.speed > 0 and ud.canAttack and not ud.customParams.defaultmove) then
        --    defCom[unitDefID] = CMD_FIGHT
        -- Deployed howitzers with area attack
        --[[else]]if (ud.speed == 0 and ud.customParams.canareaattack) then
                defCom[unitDefID] = CMD_AREA_ATTACK
        -- Deployed AT and AA guns
        elseif (ud.speed == 0 and ud.canAttack and not ud.customParams.canareaattack and not ud.isBuilder) then
                defCom[unitDefID] = CMD_ATTACK
        end
    end
end

function widget:Initialize()
    WG.activeCommand=0 -- needed??
end

function widget:DefaultCommand(targetType, targetID)
    -- To select the default command, we have several criteria. In order of
    -- priority:
    --   1. If we are targeting an unit, which is abandoned and can be captured,
    --      then we return CMD_CAPTURE
    --   2. In case all the selected units share a common "defCom" (see
    --      UnitCreated() above), then we are returing such a "defCom"
    --   3. nil/false otherwise, so another widget may eventually change that
    local capturableTarget = false
    if targetType == "unit" and (Spring.GetUnitAllyTeam(targetID) ~= Spring.GetMyAllyTeamID()) then
        local targetDefID = Spring.GetUnitDefID(targetID)
        local targetDef = UnitDefs[targetDefID]
        capturableTarget = targetDef.capturable and Spring.GetUnitNeutral(targetID)
    end

    local cmd = false
    for _,u in ipairs(Spring.GetSelectedUnits()) do
        local unitDefID = Spring.GetUnitDefID(u)
        if capturableTarget and UnitDefs[unitDefID].canCapture then
            return CMD_CAPTURE
        end

        local unitDefCom = defCom[Spring.GetUnitDefID(u)]
        if unitDefCom and cmd == false then
            cmd = unitDefCom
        elseif cmd ~= unitDefCom then
            cmd = nil
        end
    end
    return cmd
end
