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

local function Menig()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMenig.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Menig1()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMenig1.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Menig2()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMenig2.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Menig3()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMenig3.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Menig4()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMenig4.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Vicekorpral()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEVicekorpral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Korpral()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEKorpral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Furir()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEFurir.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Overfurir()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEOverfurir.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Sergeant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWESergeant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Oversergeant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEOversergeant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Fanjunkare()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEFanjunkare.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Forvaltare()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEForvaltare.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Regementsforvaltare()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWERegementsforvaltare.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Kadett()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEKadett.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Fanrik()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEFanrik.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Lojtnant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWELojtnant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Kapten()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEKapten.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Major()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEMajor.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Overstelojtnant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEOverstelojtnant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Overste()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEOverste.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Brigadgeneral()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEBrigadgeneral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Generalmajor()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEGeneralmajor.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Generallojtnant()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEGenerallojtnant.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function General()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "SWEGeneral.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

return {
    name = "sw",
    lists = {
        -- OR-1
        {0.1, 0, Menig},
        {0.13, 0, Menig1},
        {0.16, 0, Menig2},
        -- OR-2
        {0.2, 0, Menig3},
        {0.25, 0, Menig4},
        -- OR-3
        {0.3, 0, Vicekorpral},
        -- OR-4
        {0.5, 0, Korpral},
        -- OR-5
        {0.65, 0, Furir},
        {0.85, 0, Overfurir},
        -- OR-6
        {0.95, 0, Sergeant},
        {1.05, 0, Oversergeant},
        -- OR-7
        {1.25, 0, Fanjunkare},
        -- OR-8
        {1.5, 0, Forvaltare},
        -- OR-9
        {2.0, 0, Regementsforvaltare},
        -- OF-0
        {2.5, 0, Kadett},
        -- OF-1
        {2.75, 0, Fanrik},
        {3.25, 0, Lojtnant},
        -- OF-2
        {3.5, 0, Kapten},
        -- OF-3
        {5.0, 0, Major},
        -- OF-4
        {8.0, 0, Overstelojtnant},
        -- OF-5
        {12.0, 0, Overste},
        -- OF-6
        {20.0, 0, Brigadgeneral},
        -- OF-7
        {25.0, 0, Generalmajor},
        -- OF-8
        {30.0, 0, Generallojtnant},
        -- OF-9
        {50.0, 0, General},
    },
}
