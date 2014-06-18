function widget:GetInfo()
	return {
		name      = "Square Buildpics",
		desc      = "Forces square buildpics at any resolution",
		author    = "Gnome, Maelstrom",
		date      = "December 7, 2007", --Updated October 2008
		license   = "PD",
		layer     = 5,
		enabled   = true  --  loaded by default?
	}
end

local iconscale = 64					--assuming 1024x768 as the base
local iconsX = 3						--number of buildpics per row
local iconsY = 5						--number of buildpics per row
local tooltipheightpercentage = 0.1 	--if you are using the default tooltip box, use 0.1
local xPos = 0							--bar x position
local yPos = 0							--bar y position
local select  = { x = 50,   y = 5 }		--the position of the "Selected Units" text
local runOnce = 0
--------------------

local function SetupCtrlPanel(iconSizeX, iconSizeY, iconsY, xSelectPos, ySelectPos)
	local f = io.open("panel.txt", "w+")
	if (f) then
		f:write("xIcons " .. iconsX .. "\n")
		f:write("yIcons " .. iconsY .. "\n")
		f:write("xIconSize " .. iconSizeX .. "\n")
		f:write("yIconSize " .. iconSizeY .. "\n")
		f:write("xPos " .. xPos .. "\n")
		f:write("yPos " .. yPos .. "\n")
		f:write("xSelectionPos " .. xSelectPos .. "\n")
		f:write("ySelectionPos " .. ySelectPos .. "\n")

		f:write("textBorder 0.003\n")			--you can also edit these settings or add any other ctrlpanel tags
		f:write("iconBorder 0\n")
		f:write("frameBorder 0\n")
		f:write("frameAlpha 0.0\n")

		f:write("outlinefont 1\n")
		f:write("textureAlpha 1\n")
		f:write("selectGaps 0\n")
		f:write("selectThrough 1\n")
		f:write("frontByEnds 1\n")
		
		f:close()
		Spring.SendCommands({"ctrlpanel panel.txt"})
	end
	os.remove("panel.txt")
end

function dostuffs(vsx, vsy)
	if (vsx <= 1) or (vsx == nil) or (vsy <= 1) or (vsy == nil) then
		return
	end

	local _,_,_,minimapY = Spring.GetMiniMapGeometry()

	local ratio = vsy * iconscale / 768

	local iconSizeY = ratio / vsy
	local iconSizeX = ratio / vsx

	local tooltipoffset = tooltipheightpercentage * vsy

	local avaliableY = vsy - vsx * 0.13 - tooltipoffset

	local iconsY = math.floor(avaliableY / ratio)

	xPos = xPos / vsx
	yPos = yPos / vsy + tooltipheightpercentage

	local xSelectPos = select.x / vsx
	local ySelectPos = select.y / vsy

	SetupCtrlPanel(iconSizeX, iconSizeY, iconsY, xSelectPos, ySelectPos)
end

function widget:ViewResize(vsx, vsy)
	dostuffs(vsx, vsy)
end

function widget:Initialize()
	local vsx, vsy = widgetHandler:GetViewSizes()
	dostuffs(vsx, vsy)
end

function widget:GameFrame()
	if runOnce < 1 then
		vsx,vsy = gl.GetViewSizes()
		dostuffs(vsx, vsy)
		runOnce = 9001
	end
end
	
function widget:Shutdown()
	Spring.SendCommands({'ctrlpanel LuaUI/panel.txt'})
end