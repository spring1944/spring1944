local Drawer = VFS.Include("LuaUI/Widgets/ranks/utilities/drawing.lua", nil, VFS.RAW_FIRST)
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Ranks/"

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local sin, cos, tan = math.sin, math.cos, math.tan
local sqrt = math.sqrt
local rad = math.rad

local glCreateList = gl.CreateList
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate
local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect

----------------------------------------------------------------
--gl lists
----------------------------------------------------------------
local color = {0.25, 0.5, 0}
local highlightColor = {0.375, 0.75, 0}
local gold = {0.75, 0.75, 0}
local highlightGold = {1, 1, 0}

local function DrawGoldOrder()
    glPushMatrix()
        glScale(0.75, 0.75, 0.75)
        Drawer.DrawOrderOfBath(gold, highlightGold)
    glPopMatrix()
end

local function LanceCorporal()
    glPushMatrix()
        glRotate(180, 0, 0, 1)
        Drawer.DrawTopChevron(color, highlightColor)
    glPopMatrix()
end

local function Corporal()
    LanceCorporal()
    glPushMatrix()
        glTranslate(0, 0.375, 0)
        LanceCorporal()
    glPopMatrix()
end

local function Sergeant()
    Corporal()
    glPushMatrix()
        glTranslate(0, 0.75, 0)
        LanceCorporal()
    glPopMatrix()
end

local function StaffSergeant()
    Sergeant()
    glPushMatrix()
        glTranslate(0, 0.75, 0)
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBCrown.png")
        glTexRect(-0.5, -0.5, 0.5, 0.5)
        glTexture(false)
    glPopMatrix()
end

local function SecondLieutenant()
    glPushMatrix()
        glScale(0.75, 0.75, 0.75)
        Drawer.DrawOrderOfBath(color, highlightColor)
    glPopMatrix()
end

local function Lieutenant()
    SecondLieutenant()
    glPushMatrix()
        glTranslate(0, 1.5, 0)
        SecondLieutenant()
    glPopMatrix()
end

local function Captain()
    Lieutenant()
    glPushMatrix()
        glTranslate(0, 3, 0)
        SecondLieutenant()
    glPopMatrix()
end

local function Major()
    glColor(1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "GBCrown.png")
    glTexRect(-1, -1, 1, 1)
    glTexture(false)
end

local function LieutenantColonel()
    DrawGoldOrder()
    
    glPushMatrix()
        glTranslate(0, 1.5, 0)
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBCrown.png")
        glTexRect(-0.75, -0.75, 0.75, 0.75)
        glTexture(false)
    glPopMatrix()
end

local function Colonel()
    DrawGoldOrder()
    
    glPushMatrix()
        glTranslate(0, 1.5, 0)
        LieutenantColonel()
    glPopMatrix()
end

local function Brigadier()
    glPushMatrix()
        glTranslate(0, 1, 0)
        LieutenantColonel()
        glTranslate(-1, -1, 0)
        DrawGoldOrder()
        glTranslate(2, 0, 0)
        DrawGoldOrder()
    glPopMatrix()
end

local function MajorGeneral()
    glPushMatrix()
        glTranslate(0, 0.75, 0)
        DrawGoldOrder()
        glTranslate(0, -1.5, 0)
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
        glTexRect(-1, -1, 1, 1)
        glTexture(false)
    glPopMatrix()
end

local function LieutenantGeneral()
    glPushMatrix()
        glColor(1, 1, 1)
        glTranslate(0, 0.75, 0)
        glTexture(IMAGE_DIRNAME .. "GBCrown.png")
        glTexRect(-1, -1, 1, 1)
        glTexture(false)
        glTranslate(0, -1.5, 0)
        glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
        glTexRect(-1, -1, 1, 1)
        glTexture(false)
    glPopMatrix()
end

local function General()
    glPushMatrix()
        glTranslate(0, 2, 0)
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBCrown.png")
        glTexRect(-1, -1, 1, 1)
        glTexture(false)
        glTranslate(0, -2, 0)
        DrawGoldOrder()
        glTranslate(0, -1.5, 0)
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBSwoBat.png")
        glTexRect(-1, -1, 1, 1)
        glTexture(false)
    glPopMatrix()
end

local function FieldMarshal()
    glPushMatrix()
        glColor(1, 1, 1)
        glTexture(IMAGE_DIRNAME .. "GBBatLau.png")
        glTexRect(-2, -2, 2, 2)
        glTexture(false)
        glTranslate(0, 4, 0)
        glTexture(IMAGE_DIRNAME .. "GBCrown.png")
        glTexRect(-2, -2, 2, 2)
        glTexture(false)
    glPopMatrix()
end

return {
    name = "gb",
    lists = {
        {0.2, glCreateList(LanceCorporal)},
        {0.5, glCreateList(Corporal)},
        {0.75, glCreateList(Sergeant)},
        {1, 0, StaffSergeant},
        {1.5, glCreateList(SecondLieutenant)},
        {2, glCreateList(Lieutenant)},
        {3, glCreateList(Captain)},
        {5, 0, Major},
        {8, 0, LieutenantColonel},
        {12, 0, Colonel},
        {20, 0, Brigadier},
        {25, 0, MajorGeneral},
        {30, 0, LieutenantGeneral},
        {50, 0, General},
        {100, 0, FieldMarshal},
    },
}
