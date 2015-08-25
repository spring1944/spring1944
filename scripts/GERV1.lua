include "Aircraft.lua"

local isFalling = false

local function ExhaustSmoke()
	local exhaust = piece "exhaust"
	while not isFalling do
		EmitSfx(exhaust, SFX.WHITE_SMOKE)
		Sleep(33)
	end
end

function script.Create()
	StartThread(ExhaustSmoke)
end

function Falling()
	isFalling = true
end

function script.Killed(recentDamage, maxHealth)
	return -1
end
