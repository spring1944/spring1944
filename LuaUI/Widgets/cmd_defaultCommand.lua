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

function widget:DefaultCommand()
    local type = false
    for _,u in ipairs(Spring.GetSelectedUnits()) do
        local unitDefCom = defCom[Spring.GetUnitDefID(u)]
        if unitDefCom and type == false then
            -- only default to fight for groups over 5
            --[[if unitDefCom == CMD_FIGHT then 
                if Spring.GetSelectedUnitsCount() >= 6 then
                    local mx, my = Spring.GetMouseState()
                    local s,t = Spring.TraceScreenRay(mx, my)
                    -- apply ATTACK if cursor over a unit
                    if s == "unit" then
                        type = CMD_ATTACK
                    -- apply default otherwise
                    else
                        type=unitDefCom
                    end
                end
            -- other default commands should always be applied
            else]]
                type=unitDefCom
            --end
        elseif type ~= unitDefCom then
            type=nil
        end
    end
    return type
end
