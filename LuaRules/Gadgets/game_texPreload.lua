function gadget:GetInfo()
	return {
		name      = "Texture preloader",
		desc      = "Loads select models/skins during the pre-game time instead of at game start",
		author    = "Gnome, FLOZi",
		date      = "October 2008",
		license   = "GNU GPL v2",
		layer     = -math.huge,
		enabled   = true
}
end

if(gadgetHandler:IsSyncedCode()) then
-- 	SYNCED

else
--	UNSYNCED
local hqDefs = VFS.Include("LuaRules/Configs/hq_spawn.lua")

local function PreloadUnitTexture(unitName)
	gl.PushMatrix()
		gl.Translate(100, -1000, 100)
		gl.Color(1,1,1,0)
		gl.UnitShape(UnitDefNames[unitName].id,0)
		gl.Color(1,1,1,1)
	gl.PopMatrix()
end

function gadget:DrawWorld()
	PreloadUnitTexture("flag")
	-- let's find out all the units which are spawned at start
	local unitsToPreload = {}
	for startUnit, spawnData in pairs(hqDefs) do
		unitsToPreload[startUnit] = 1
		local tmpUnits = spawnData.units
		if tmpUnits then
			for i=1, #tmpUnits do
				unitsToPreload[tmpUnits[i]] = 1
			end
		end
	end
	for unitName, _ in pairs(unitsToPreload) do
		PreloadUnitTexture(unitName)
	end
	unitsToPreload = nil
	gadgetHandler:RemoveGadget()
end

end
