function widget:GetInfo()
	return {
		name = "1944 Resupply Timer",
		desc = "Adds a countdown timer to the next logistics refill",
		author = "Craig Lawrence",
		date = "6th July 2008",
		license = "CC-BY-NC",
		layer = 1,
		enabled = false
	}
end

local vsx, vsy = widgetHandler:GetViewSizes()
local floor = math.floor

-- the 'f' suffixes are fractions  (and can be nil)
local color  = { 1.0, 1.0, 0.25 }
local xposf  = 0.52
local xpos   = xposf * vsx
local yposf  = 0.010
local ypos   = yposf * vsy
local sizef  = 0.03
local size   = sizef * vsy

local timeLeft = 0
local arrivalGap = 300 -- default to 5 minutes

function widget:GameFrame(t)
	if t == 1 then
		vsx, vsy = widgetHandler:GetViewSizes()
		UpdateGeometry()
	end
	if (t % 30 == 0) then
		if timeLeft > 0 then
			timeLeft = timeLeft - 1
		end
	end
	if (t % (arrivalGap*30) < 0.1) then
		timeLeft = arrivalGap
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if (ud.customParams.hq == '1') then
		arrivalGap = tonumber(ud.customParams.arrivalgap)
	end
end

function widget:DrawScreen()
	local minutes = floor(timeLeft / 60)
	local seconds = timeLeft % 60
	local timeString = string.format('Resupply in: %02i:%02i', minutes, seconds)
	gl.Color(color)
	gl.Text(timeString, xpos, ypos, size, "ocn")
end

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
	UpdateGeometry()
end

function UpdateGeometry()
	xpos = xposf * vsx
	ypos = yposf * vsy
	size = sizef * vsy
end
