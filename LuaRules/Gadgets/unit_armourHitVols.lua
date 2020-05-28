function gadget:GetInfo()
	return {
		name		= "Armour Hit Volumes",
		desc		= "Limits armour to base and turret hit boxes",
		author		= "FLOZi (C. Lawrence)",
		date		= "03/11/10",
		license 	= "GNU GPL v2",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end

if gadgetHandler:IsSyncedCode() then
--	SYNCED
local GetUnitPieceList					= Spring.GetUnitPieceList
local SetPieceColVol					= Spring.SetUnitPieceCollisionVolumeData
local GetPieceColVol					= Spring.GetUnitPieceCollisionVolumeData

local armourPieces = {["base"] = true, ["turret"] = true, ["super"] = true}
local boatPieces = {["base"] = true, ["hull"] = true, ["tower"] = true, ["tower2"] = true}

local function SetColVols(unitID, ud, colPieces)
	if (ud.modeltype or ud.model.type) ~= "3do" then
		local pieces = GetUnitPieceList(unitID)
		local tweaks = table.unserialize(ud.customParams.piecehitvols) or {}
		for i, pieceName in pairs(pieces) do
			if colPieces[pieceName] and i ~= "n" then

				local pieceTweaks = tweaks[pieceName] or {
					offset = { 0, 0, 0 },
					scale = { 1, 1, 1 }
				}

				local sX, sY, sZ, oX, oY, oZ, volumeType, _, primaryAxis = GetPieceColVol(unitID, i)
				sX = sX * pieceTweaks.scale[1]
				sY = sY * pieceTweaks.scale[2]
				sZ = sZ * pieceTweaks.scale[3]

				oX = oX + pieceTweaks.offset[1]
				oY = oY + pieceTweaks.offset[2]
				oZ = oZ + pieceTweaks.offset[3]

				SetPieceColVol(unitID, i, true, sX, sY, sZ, oX, oY, oZ, volumeType, primaryAxis)
			else
				SetPieceColVol(unitID, i, false, 1,1,1, 0,0,0, -1, 0)
			end

		end
	end
end


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.children then
		SetColVols(unitID, ud, boatPieces)
	elseif cp and (cp.armor_front or cp.armour) then
		SetColVols(unitID, ud, armourPieces)
	end
end


else
--	UNSYNCED
end
