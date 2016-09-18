local dozer = piece "dozer"

local function deploy()
	Turn(dozer, x_axis, -math.rad(95), math.rad(15))
end

local function undeploy()
	
	Turn(dozer, x_axis, 0, math.rad(15))

end

local anims =
{
	deploy = deploy,
	undeploy = undeploy,
}

return anims
