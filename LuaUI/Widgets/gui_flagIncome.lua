function widget:GetInfo()
   return {
      name     = "1944 Flag Income",
      desc     = "Draws flag's command income",
      author   = "specing (Fedja Beader)",
      date     = "Jul 27, 2014",
      license  = "GNU AGPLv3",
      layer    = 0,
      enabled  = true
   }
end
-------------------------------------------------------------------------------------------------
--------------------------------------------- Data ----------------------------------------------
-------------------------------------------------------------------------------------------------
local GlDepthTest             = gl.DepthTest
local GlColor                 = gl.Color
local GlDrawFuncAtUnit        = gl.DrawFuncAtUnit
local GlTranslate             = gl.Translate
local GlBillboard             = gl.Billboard
local GlText                  = gl.Text

-- do not localize, it doesn't work otherwise
--local FhUseDefaultFont        = fontHandler.UseDefaultFont

local GetUnitDefID            = Spring.GetUnitDefID
local GetUnitRulesParam       = Spring.GetUnitRulesParam
-- variables
local flagUnitIDtoProdString  = {} -- maps all flags

-- constants
local flagDefID               = UnitDefNames["flag"].id
local buoyDefID               = UnitDefNames["buoy"].id
-------------------------------------------------------------------------------------------------
--------------------------------------------- Code ----------------------------------------------
-------------------------------------------------------------------------------------------------

if not fontHandler then
    fontHandler = VFS.Include("LuaUI/modfonts.lua")
end

-- generate a new production string (to be drawn on map) for every flag
local function GenNewFlagProdString(flagID)
   local newprod = GetUnitRulesParam(flagID, "production")

   local prodstr

   if newprod == nil then
      prodstr = '\255\1\1\255???'
   else
      prodstr = string.format('\255\1\255\1%.1f', newprod)
   end

   flagUnitIDtoProdString[flagID] = prodstr
end


-- draw on flags
function widget:DrawWorld()
   GlDepthTest(true)

   GlColor(1, 1, 1)
   fontHandler.UseDefaultFont()

   for flagID,prodStr in pairs(flagUnitIDtoProdString) do
      GlDrawFuncAtUnit(flagID, false, function(prodStr)
         GlTranslate(0, 40, -50)
         GlBillboard()
         GlText(prodStr, 0, 0, 8, "c")
      end, prodStr)
   end

   GlDepthTest(false)
end


function widget:GameFrame(n)
   if n % (60 * 30) == 1 then -- every minute, from first minute onwards
   --                  ^ gadget == 0
--    for _,unitID in ipairs(Spring.GetTeamUnitsByDefs(Spring.ALL_UNITS, flagDefID)i)  do
      for _,unitID in ipairs(Spring.GetAllUnits()) do
         local unitDefID = GetUnitDefID(unitID)
         if (unitDefID == flagDefID or unitDefID == buoyDefID) and not flagUnitIDtoProdString[unitID] then
            local str = "Not known yet"
            flagUnitIDtoProdString[unitID] = str
         end
      end

      for flagID,_ in pairs(flagUnitIDtoProdString) do
         GenNewFlagProdString(flagID)
      end
   end
end
