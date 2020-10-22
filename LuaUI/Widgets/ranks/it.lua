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

local function Aspirante()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAAspirante.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Sottotenente()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITASottotenente.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Tenente()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITATenente.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function PrimoTenente()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAPrimoTenente.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Capitano()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITACapitano.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function PrimoCapitano()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAPrimoCapitano.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Maggiore()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAMaggiore.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function TenenteColonnello()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITATenenteColonnello.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Colonnello()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAColonnello.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function ColonnelloComandante()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAColonnelloComandante.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GeneraleDiBrigata()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAGeneraleDiBrigata.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GeneraleDiDivisione()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAGeneraleDiDivisione.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GeneraleDiCorpoDArmata()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAGeneraleDiCorpoDArmata.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GeneraleDesignatoDArmata()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAGeneraleDesignatoDArmata.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function GeneraleDArmata()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAGeneraleDArmata.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function MarescialloDItalia()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAMarescialloDItalia.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

return {
    name = "it",
    lists = {
        {0.1, 0, Aspirante},
        {0.5, 0, Sottotenente},
        {1.0, 0, Tenente},
        {5.0, 0, PrimoTenente},
        {10.0, 0, Capitano},
        {20.0, 0, PrimoCapitano},
        {30.0, 0, Maggiore},
        {40.0, 0, TenenteColonnello},
        {50.0, 0, Colonnello},
        {55.0, 0, ColonnelloComandante},
        {60.0, 0, GeneraleDiBrigata},
        {70.0, 0, GeneraleDiDivisione},
        {80.0, 0, GeneraleDiCorpoDArmata},
        {90.0, 0, GeneraleDesignatoDArmata},
        {95.0, 0, GeneraleDArmata},
        {100.0, 0, MarescialloDItalia},
    },
}
