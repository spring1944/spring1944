local Drawer = VFS.Include("LuaUI/Widgets/ranks/utilities/drawing.lua", nil, VFS.RAW_FIRST)
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Ranks/"

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local sin, cos, tan = math.sin, math.cos, math.tan
local sqrt = math.sqrt
local rad = math.rad

local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect

----------------------------------------------------------------
--gl lists
----------------------------------------------------------------
local color = {1, 1, 0.25}
local highlightColor = {1, 1, 0.5}

local function Private()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNPrivate.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function PrivateFirstClass()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNPrivateFirstClass.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function SuperiorPrivate()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNSuperiorPrivate.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function LanceCorporal()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNLanceCorporal.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Corporal()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNCorporal.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Sergeant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNSergeant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function SergeantMajor()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNSergeantMajor.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function WarrantOfficer()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNWarrantOfficer.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function SecondLieutenant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNSecondLieutenant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function FirstLieutenant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNFirstLieutenant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Captain()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNCaptain.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Major()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNMajor.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function LieutenantColonel()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNLieutenantColonel.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Colonel()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNColonel.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function MajorGeneral()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNMajorGeneral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function LieutenantGeneral()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNLieutenantGeneral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function General()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNGeneral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function FieldMarshal()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNFieldMarshal.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GrandMarshal()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "JPNGrandMarshal.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

return {
    name = "jp",
    lists = {
        {0.1, 0, Private},
        {0.2, 0, PrivateFirstClass},
        {0.3, 0, SuperiorPrivate},
        {0.4, 0, LanceCorporal},
        {0.5, 0, Corporal},
        {1.0, 0, Sergeant},
        {2.0, 0, SergeantMajor},
        {3.0, 0, WarrantOfficer},
        {5.0, 0, SecondLieutenant},
        {8.0, 0, FirstLieutenant},
        {12.0, 0, Captain},
        {20.0, 0, Major},
        {25.0, 0, LieutenantColonel},
        {30.0, 0, Colonel},
        {50.0, 0, MajorGeneral},
        {60.0, 0, LieutenantGeneral},
        {80.0, 0, General},
        {90.0, 0, FieldMarshal},
        {100.0, 0, GrandMarshal},
    },
}
