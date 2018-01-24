local function PrePositionTurrets()
	Turn(piece("turret_1"), y_axis, math.rad(90))
	Turn(piece("turret_2"), y_axis, math.rad(-90))
	Turn(piece("turret_3"), y_axis, math.rad(-90))
	Turn(piece("turret_4"), y_axis, math.rad(90))
end

return {
	postCreate = PrePositionTurrets,
}