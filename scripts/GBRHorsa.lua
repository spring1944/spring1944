include "Aircraft.lua"

function Falling()
	local hull = piece "hull"
	Turn(hull, x_axis, math.rad(-40), math.rad(10))
end

function script.Killed(recentDamage, maxHealth)
	if recentDamage > 0 then
		local pieceMap = Spring.GetUnitPieceMap(unitID)
		for _,pieceID in pairs(pieceMap) do
			if math.random(5) < 2 then
				Explode(pieceID, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
			else
				Explode(pieceID, SFX.SHATTER)
			end
		end
		return -1
	end
	return 1
end