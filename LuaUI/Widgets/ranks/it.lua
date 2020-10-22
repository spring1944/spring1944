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

local function Caporale()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITACaporale.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function CaporalMaggiore()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITACaporalMaggiore.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Sergente()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITASergente.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function SergenteMaggiore()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITASergenteMaggiore.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function MarescialloOrdinario()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAMarescialloOrdinario.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function MarescialloCapo()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAMarescialloCapo.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function MarescialloMaggiore()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAMarescialloMaggiore.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function AiutanteDiBattaglia()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ITAAiutanteDiBattaglia.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

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
        -- OR-2
        {0.2, 0, Caporale},
        -- OR-3
        {0.3, 0, CaporalMaggiore},
        -- OR-5
        {0.75, 0, Sergente},
        -- OR-6
        {1.0, 0, SergenteMaggiore},
        -- OR-8
        {1.5, 0, MarescialloOrdinario},
        -- OR-9
        {1.75, 0, MarescialloCapo},
        {2.0, 0, MarescialloMaggiore},
        {2.25, 0, AiutanteDiBattaglia},
        -- OF-0
        {2.5, 0, Aspirante},
        -- OF-1
        {2.75, 0, Sottotenente},
        {3.0, 0, Tenente},
        {3.25, 0, PrimoTenente},
        -- OF-2
        {3.5, 0, Capitano},
        {4.0, 0, PrimoCapitano},
        -- OF-3
        {5.0, 0, Maggiore},
        -- OF-4
        {8.0, 0, TenenteColonnello},
        -- OF-5
        {10.0, 0, Colonnello},
        {14.0, 0, ColonnelloComandante},
        -- OF-6
        {20.0, 0, GeneraleDiBrigata},
        -- OF-7
        {25.0, 0, GeneraleDiDivisione},
        -- OF-8
        {30.0, 0, GeneraleDiCorpoDArmata},
        -- OF-9
        {50.0, 0, GeneraleDesignatoDArmata},
        {75.0, 0, GeneraleDArmata},
        -- OF-10
        {100.0, 0, MarescialloDItalia},
    },
}
