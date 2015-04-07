Spring.SetUnitNanoPieces(unitID, {piece("beam")})
local base = piece("base")
local pad = piece("pad")
local door = piece("door")
local radar = piece("radar")

function build(buildID, buildDefID)
	if UnitDef.customParams.separatebuildspot then
		local buildDef = UnitDefs[buildDefID]
		if buildDef and buildDef.customParams.buildoutside then
			Move(pad, x_axis, 50)
		else
			Move(pad, x_axis, 0)
		end
	end
end

function script.QueryBuildInfo()
    return pad
end

local function OpenCloseAnim(open)
    Signal(1) -- Kill any other copies of this thread
    SetSignalMask(1) -- Allow this thread to be killed by fresh copies
	if door then
		if open then
			Turn(door, y_axis, math.rad(130), math.rad(50))
		else
			Turn(door, y_axis, 0, math.rad(50))
		end
	end
    SetUnitValue(COB.INBUILDSTANCE, open)
    SetUnitValue(COB.BUGGER_OFF, open)
end

-- Called when factory yard opens
function script.Activate()
    -- OpenCloseAnim must be threaded to call Sleep() or WaitFor functions
    StartThread(OpenCloseAnim, true)
end

-- Called when factory yard closes
function script.Deactivate()
    -- OpenCloseAnim must be threaded to call Sleep() or WaitFor functions
    StartThread(OpenCloseAnim, false)
end

function script.StartBuilding()
    -- TODO: You can run any animation that continues throughout the build process here e.g. spin pad
end

function script.StopBuilding()
    -- TODO: You can run any animation that signifies the end of the build process here
end

local function Raise()
	local height = Spring.GetUnitHeight(unitID)
	while select(5, Spring.GetUnitHealth(unitID)) < 1 do
		Move(base, y_axis, -height * (1 - select(5, Spring.GetUnitHealth(unitID))))
		Sleep(100)
 	end
	Move(base, y_axis, 0)
	if radar then
		Spin(radar, y_axis, math.rad(60), math.rad(5))
	end
end

function script.Create()
	StartThread(Raise)
end

-- GERHQBunker has an MG turret
local flare, flare1 = piece("flare", "flare1")
function script.QueryWeapon(weaponID)
	return flare
end

function script.AimFromWeapon(weaponID)
	return flare1
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(2)
	SetSignalMask(2)
	Turn(flare1, y_axis, heading)
	return true
end

function script.Shot(weaponID)
	GG.EmitSfxName(unitID, flare, "MG_MUZZLEFLASH")
end

function script.Killed()
	Spring.UnitScript.Explode(base, SFX.SHATTER)
end