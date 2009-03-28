local luaType = gadget
if not gadget then
	luaType = widget
end

local versionNumber = "v1.0"

function luaType:GetInfo()
	return {
		name      = "Metal API",
		desc      = versionNumber .. " Metal map-related functions.",
		author    = "Evil4Zerggin",
		date      = "21 March 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -10000,
		enabled   = true  --  loaded by default?
	}
end

local GetGroundInfo = Spring.GetGroundInfo

local MAP_SIZE_X, MAP_SIZE_Z = Game.mapSizeX, Game.mapSizeZ
local METAL_MAP_SQUARE_SIZE = 16

------------------------------------------------
--local vars
------------------------------------------------
local totalMetal = 0
local maxMetal = 0
local minMetal

for x = METAL_MAP_SQUARE_SIZE * 0.5, MAP_SIZE_X, METAL_MAP_SQUARE_SIZE do
	for z = METAL_MAP_SQUARE_SIZE * 0.5, MAP_SIZE_Z, METAL_MAP_SQUARE_SIZE do
		local _, metal = GetGroundInfo(x, z)
		if not minMetal or metal < minMetal then
			minMetal = metal
		end
		
		if metal > maxMetal then
			maxMetal = metal
		end
		
		totalMetal = totalMetal + metal
	end
end

local Metal = {
	totalMetal = totalMetal,
	maxMetal = maxMetal,
	minMetal = minMetal,
}

if GG then
	GG.Metal = Metal
elseif WG then
	WG.Metal = Metal
end
