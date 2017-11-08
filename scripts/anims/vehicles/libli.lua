local function PrePositionTurrets()
	local i = 1
	while i <= 6 do
		local turret = piece('turret_' .. i)
		Turn(turret, y_axis, math.rad((i%2) * 180 - 90))
		i = i + 1
	end
end

return {
	postCreate = PrePositionTurrets,
}