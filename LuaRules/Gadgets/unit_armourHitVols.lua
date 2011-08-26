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

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.armor_front then
		if ud.model.type ~= "3do" then
			local pieces = GetUnitPieceList(unitID)
			for i, pieceName in pairs(pieces) do
				--Spring.Echo(i, pieceName)
				if pieceName ~= "base" and pieceName ~= "turret" and i ~= "n" then
					--Spring.Echo("piece " .. i .. " called " .. pieceName .. " to be disabled")
					SetUnitPieceCollisionVolumeData(unitID, i - 1, true,true, false,false, 0,0,0, 0,0,0, 0, 0)
					--SetUnitPieceCollisionVolumeData(unitID, i - 1, false) -- for 0.83, above is backwards compat though
				end
			end
		end
	end
end


else
--	UNSYNCED
end
