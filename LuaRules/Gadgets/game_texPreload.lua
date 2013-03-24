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
local sides = {"gbr", "ger", "us", "rus", "ita", "jap",} -- this is unpleasant

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
	for _, side in pairs(sides) do
		local startUnit = Spring.GetSideData(side)
		local spawnList = hqDefs[startUnit]
		if spawnList~=nil then
			for i = 1, #spawnList.units do
				local unitName = spawnList.units[i]
				PreloadUnitTexture(unitName)
			end
		end
	end
	gadgetHandler:RemoveGadget()
end

end
