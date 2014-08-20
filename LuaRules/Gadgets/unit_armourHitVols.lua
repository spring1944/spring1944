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
local SetUnitPieceCollisionVolumeData	= Spring.SetUnitPieceCollisionVolumeData

local armourPieces = {["base"] = true, ["turret"] = true}
local boatPieces = {["base"] = true, ["hull"] = true, ["tower"] = true, ["tower2"] = true}

local function SetColVols(unitID, ud, colPieces)
	if ud.model.type ~= "3do" then
		local pieces = GetUnitPieceList(unitID)
		for i, pieceName in pairs(pieces) do
			--Spring.Echo(i, pieceName)
			if not colPieces[pieceName] and i ~= "n" then
				--Spring.Echo("piece " .. i .. " called " .. pieceName .. " to be disabled")
				SetUnitPieceCollisionVolumeData(unitID, i - 1, false, 1, 1, 1, 0, 0, 0)
			end
		end
	end
end


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.children then
		--Spring.Echo("Found a BoatMother, setting ColVols")
		SetColVols(unitID, ud, boatPieces)
	elseif cp and cp.armor_front then
		SetColVols(unitID, ud, armourPieces)
	end
end


else
--	UNSYNCED
end
