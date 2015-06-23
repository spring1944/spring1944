function widget:GetInfo()
	return {
		name = "Indirect Fire Accuracy",
		desc = "Shows information whether LOS bonus is in effect or not",
		author = "ashdnazg",
		date = "29 June 2014",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true
	}
end

------------------------------------------------
--config
------------------------------------------------
local fontSizeWorld = 12
local fontSizeScreen = 16
local targettedColor = {0.0, 1.0, 0.0, 0.8}
local targettingColor = {0.8, 0.8, 0.0, 0.8}
local noLOSColor = {1.0, 0.0, 0.0, 0.8}

------------------------------------------------
--vars
------------------------------------------------
local font

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetUnitRulesParam      = Spring.GetUnitRulesParam
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetUnitCommands        = Spring.GetUnitCommands
local GetUnitAllyTeam        = Spring.GetUnitAllyTeam
local IsPosInAirLos             = Spring.IsPosInAirLos
local ValidUnitID            = Spring.ValidUnitID
local WorldToScreenCoords    = Spring.WorldToScreenCoords
local GetUnitPosition        = Spring.GetUnitPosition

local CMD_ATTACK             = CMD.ATTACK


local glColor = gl.Color


------------------------------------------------
--callins
------------------------------------------------

function widget:Initialize()
	font = WG.S44Fonts.TypewriterBold32
end

function widget:DrawScreen()
    local selectedUnitsSorted = GetSelectedUnitsSorted()

    for unitDefID, unitIDs in pairs(selectedUnitsSorted) do
        local unitDef = UnitDefs[unitDefID]
        if unitDef then
            local cp = unitDef.customParams
            if cp and cp.canareaattack then
                for i = 1, #unitIDs do
                    local unitID = unitIDs[i]
                    local allyTeam = GetUnitAllyTeam(unitID)
                    local targetStr
                    queue = GetUnitCommands(unitID, 1)
                    if queue and queue[1] and queue[1].id == CMD_ATTACK then
                        target = queue[1].params
                        -- attack order on the ground, target is filled with
                        -- world coordinates
                        local x, y, z
                        if target[2] then
                            x, y, z = target[1], target[2], target[3]
                        -- on a unit, target is a unitID
                        elseif ValidUnitID(target[1]) then
                            x, y, z = GetUnitPosition(target[1])
                        end

                        if x and y and z then
                            sx, sy, sz = WorldToScreenCoords(x, y, z)
                            if IsPosInAirLos(x, y, z, allyTeam) then
                                local zeroed = GetUnitRulesParam(unitID, "zeroed")
                                if zeroed and zeroed == 1 then
                                    glColor(targettedColor)
                                    targetStr = "Targetted"
                                else
                                    glColor(targettingColor)
                                    targetStr = "Targetting..."
                                end
                            else
                                glColor(noLOSColor)
                                targetStr = "No Sight"
                            end
                            font:Print(targetStr, sx + 10, sy - 20, fontSizeScreen, "n")
                        end
                    end
                end
            end
        end
    end
end
