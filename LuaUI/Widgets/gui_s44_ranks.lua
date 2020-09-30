local versionNumber = "v0.5"

function widget:GetInfo()
  return {
    name      = "1944 Ranks",
    desc      = versionNumber .. " Displays rank icons for units.",
    author    = "Evil4Zerggin",
    date      = "GNU LGPL, v2.1 or later",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

----------------------------------------------------------------
--config
----------------------------------------------------------------
local iconSize = 0.4
local maxScale = 7
local lineWidth = 0.25
local default_list_name = "us"

----------------------------------------------------------------
--local vars
----------------------------------------------------------------

local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Ranks/"

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local sqrt = math.sqrt
local strSub = string.sub

local GetVisibleUnits = Spring.GetVisibleUnits
local GetUnitExperience = Spring.GetUnitExperience
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitRadius = Spring.GetUnitRadius
local GetUnitHeight = Spring.GetUnitHeight
local IsGUIHidden = Spring.IsGUIHidden

local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glBillboard = gl.Billboard
local glLineWidth = gl.LineWidth
local glBlendFunc = gl.BlendFunc
local glDepthTest = gl.DepthTest

local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA

----------------------------------------------------------------
--lists
----------------------------------------------------------------
local lists = {}

local function CreateLists()
    local SideFiles = VFS.DirList("LuaUI/Widgets/ranks/", "*.lua")
    Spring.Log('gui_s44_ranks', 'info', "Found " .. #SideFiles .. " rank specifications")
    for _, SideFile in pairs(SideFiles) do
        Spring.Log('gui_s44_ranks', 'info', " - Processing " .. SideFile)
        local tmpTable = VFS.Include(SideFile)
        if tmpTable then
            lists[tmpTable.name] = tmpTable.lists
            Spring.Log('gui_s44_ranks', 'info', " -- Added " .. tmpTable.name .. " ranks")
            tmpTable = nil
        end
    end
end

local function DeleteLists()
    for name, ranks in pairs(lists) do
        for i=1, #ranks do
            glDeleteList(ranks[i][2])
        end
    end
end

----------------------------------------------------------------
--helpers
----------------------------------------------------------------

local function GetRank(unitID)
    local unitDefID = GetUnitDefID(unitID)
    local unitDef = UnitDefs[unitDefID]
    
    if not unitDef then return end
    
    local power = unitDef.power
    local xp = GetUnitExperience(unitID)
    
    if not xp then return end
    
    local name = unitDef.name
    local prefix = strSub(name, 1, 2)
    
    return xp * sqrt(power * 0.01), prefix
end

local function GetRankList(rank, prefix)
    local list, nonList = nil, nil
    local rankTable = lists[prefix] or lists[default_list_name]

    for i, info in ipairs(rankTable) do
        if rank < info[1] then
            return list, nonList
        else
            list, nonList = info[2], info[3]
        end
    end
    
    return list, nonList
end

local function DrawRankIcon(unitID)
    local rank, prefix = GetRank(unitID)
    
    if not rank then return end
    
    local list, nonList = GetRankList(rank, prefix)
    
    if not list then return end
    
    local x, y, z = GetUnitPosition(unitID)
    local radius = GetUnitRadius(unitID)
    
    local scale = radius * iconSize
    if scale > maxScale then
        scale = maxScale
    end
    
    local minHeight = scale + 0.5 * radius + 8
    
    local height = GetUnitHeight(unitID)
    if height < minHeight then
        height = minHeight
    end
    
    glPushMatrix()
        glTranslate(x, y + height, z)
        glBillboard()
        glScale(scale, scale, scale)
        glCallList(list)
        if nonList then
            nonList()
        end
    glPopMatrix()
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function widget:Initialize()
    CreateLists()
end

function widget:Shutdown()
    DeleteLists()
end

function widget:DrawWorld()
    if IsGUIHidden() then return end

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glLineWidth(lineWidth)
    local visibleUnits = GetVisibleUnits(-1, 0, false)
    if not visibleUnits then return end
    local ValidUnitID = Spring.ValidUnitID
    for i=1,#visibleUnits do
        local unitID = visibleUnits[i]
        if ValidUnitID(unitID) then
            DrawRankIcon(unitID)
        end
    end
    glLineWidth(1)
end
