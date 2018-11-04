--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "1944 notAchili Vote Display",
    desc      = "GUI for votes",
    author    = "KingRaptor",
    date      = "May 04, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = -9, 
    experimental = true,
    enabled   = false,
  }
end
--//version +0.3;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local NotAchili
local Button
local Label
local Window
local Panel
local TextBox
local Image
local Progressbar
local Control
local Font

-- elements
local window, stack_main, label_title
local stack_vote, label_vote, button_vote, progress_vote = {}, {}, {}, {}
local button_end, button_end_image

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local voteCount, voteMax = {}, {}
local pollActive = false
local votingForceStart = false

local string_success = " vote successful"
local string_fail = " not enough votes"
local string_vote1 = " option 1 has "
local string_vote2 = " option 2 has "
local string_votetopic = " Do you want to "
local string_endvote = " poll cancelled"
local string_titleEnd = "? !vote 1 = yes, !vote 2 = no"
local string_noVote = "There is no poll going on, start some first"

local springieName = Spring.GetModOptions().springiename or ''

--local voteAntiSpam = false
local VOTE_SPAM_DELAY = 1	--seconds
local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"

--[[
local index_votesHave = 14
local index_checkDoubleDigits = 17
local index_votesNeeded = 18
local index_voteTitle = 15
]]--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function GetVotes(line)
	local voteNum = 1
	if line:find(string_vote2) then
		voteNum = 2
	end
	local index_init = line:find("%s"..voteNum.."%s")
	local index_votesHave = line:find("%s%d[%s%d]", index_init + 1)
	local index_votesNeeded = line:find("%s%d[%s%d]", index_votesHave + 1)
	--Spring.Echo(index_init, index_votesHave, index_votesNeeded)
	local numVotes = tonumber(line:sub(index_votesHave, index_votesHave + 2))
	local maxVotes = tonumber(line:sub(index_votesNeeded, index_votesNeeded + 2))
	voteCount[voteNum] = numVotes
	for i=1, 2 do
		voteMax[i] = maxVotes
		progress_vote[i]:SetCaption(voteCount[i]..'/'..voteMax[i])
		progress_vote[i]:SetValue(voteCount[i]/voteMax[i])
	end
end

local lastClickTimestamp = 0
local function CheckForVoteSpam (currentTime) --// function return "true" if not a voteSpam
	local elapsedTimeFromLastClick = currentTime - lastClickTimestamp
	if elapsedTimeFromLastClick < VOTE_SPAM_DELAY then
		return false
	else
		lastClickTimestamp= currentTime
		return true
	end
end

function widget:AddConsoleLine(line,priority)
	if votingForceStart and line:sub(1,7) == "GameID:" then
		pollActive = false
		screen0:RemoveChild(window)
		for i=1,2 do
			voteCount[i] = 0
			voteMax[i] = 1	-- protection against div0
			progress_vote[i]:SetCaption('?/?')
			progress_vote[i]:SetValue(0)
		end
		votingForceStart = false
	end
	if line:sub(1,springieName:len()) ~= springieName then	-- no spoofing messages
		return
	end
	if line:find(string_success) or line:find(string_fail) or line:find(string_endvote) or line:find(string_noVote) then	--terminate existing vote
		pollActive = false
		screen0:RemoveChild(window)
		for i=1,2 do
			voteCount[i] = 0
			voteMax[i] = 1	-- protection against div0
			progress_vote[i]:SetCaption('?/?')
			progress_vote[i]:SetValue(0)
		end
		votingForceStart = false
	elseif line:find(string_votetopic) and line:find(string_titleEnd) then	--start new vote
		if pollActive then --//close previous windows in case Springie started a new vote without terminating the last one.
			screen0:RemoveChild(window)
			for i=1,2 do
				voteCount[i] = 0
				voteMax[i] = 1	-- protection against div0
				progress_vote[i]:SetCaption('?/?')
				progress_vote[i]:SetValue(0)
			end
			votingForceStart = false		
		end
		pollActive = true
		screen0:AddChild(window)
		local indexStart = select(2, line:find(string_votetopic))
		local indexEnd = line:find(string_titleEnd)
		local title = line:sub(indexStart, indexEnd - 1)
		votingForceStart = ((title:find("force game"))~=nil)
		label_title:SetCaption("Poll: "..title)
	elseif line:find(string_vote1) or line:find(string_vote2) then	--apply a vote
		GetVotes(line)
	end
end

--[[
local timer = 0
function widget:Update(dt)
	if not voteAntiSpam then
		return
	end
	timer = timer + dt
	if timer < VOTE_SPAM_DELAY then
		return
	end
	voteAntiSpam = false
	timer = 0
end
--]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button = NotAchili.Button
	Label = NotAchili.Label
	Colorbars = NotAchili.Colorbars
	Window = NotAchili.Window
	StackPanel = NotAchili.StackPanel
	Image = NotAchili.Image
	Progressbar = NotAchili.Progressbar
	Control = NotAchili.Control
	screen0 = NotAchili.Screen0
	
	--create main NotAchili elements
	local screenWidth,screenHeight = Spring.GetWindowGeometry()
	local height = tostring(math.floor(screenWidth/screenHeight*0.35*0.35*100)) .. "%"
	local y = tostring(math.floor((1-screenWidth/screenHeight*0.35*0.35)*100)) .. "%"
	
	local labelHeight = 24
	local fontSize = 16

	window = Window:New{
		--parent = screen0,
		name   = 'votes';
		color = {0, 0, 0, 0},
		width = 300;
		height = 120;
		right = 2; 
		y = "45%";
		dockable = false;
		draggable = true,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minWidth = MIN_WIDTH, 
		minHeight = MIN_HEIGHT,
		padding = {0, 0, 0, 0},
		--itemMargin  = {0, 0, 0, 0},
	}
	stack_main = StackPanel:New{
		parent = window,
		resizeItems = true;
		orientation   = "vertical";
		height = "100%";
		width =  "100%";
		padding = {0, 0, 0, 0},
		itemMargin  = {0, 0, 0, 0},
	}
	label_title = Label:New{
		parent = stack_main,
		autosize=false;
		align="center";
		valign="top";
		caption = '';
		height = 16,
		width = "100%";
	}
	for i=1,2 do
		stack_vote[i] = StackPanel:New{
			parent = stack_main,
			resizeItems = true;
			orientation   = "horizontal";
			y = (40*(i-1))+15 ..'%',
			height = "40%";
			width =  "100%";
			padding = {0, 0, 0, 0},
			itemMargin  = {0, 0, 0, 0},
		}
		--[[
		label_vote[i] = Label:New{
			parent = stack_vote[i],
			autosize=false;
			align="left";
			valign="center";
			caption = (i==1) and 'Yes' or 'No',
			height = 16,
			width = "100%";
		}
		]]--
		progress_vote[i] = Progressbar:New{
			parent = stack_vote[i],
			x		= "0%",
			width   = "80%";
			height	= "100%",
			max     = 1;
			caption = "?/?";
			color   = (i == 1 and {0.2,0.9,0.3,1}) or {0.9,0.15,0.2,1};
		}
		button_vote[i] = Button:New{
			parent = stack_vote[i],
			x = "80%",
			width = "20%",
			height = "100%",
			caption = (i==1) and 'Yes' or 'No',
			OnMouseDown = {	function () 
					--if voteAntiSpam then return end
					--voteAntiSpam = true
					local notSpam = CheckForVoteSpam (os.clock())
					if notSpam then
						Spring.SendCommands({'say !vote '..i})
					end
				end},
			padding = {1,1,1,1},
			--keepAspect = true,
			styleKey = "buttonResizable",
		}
		progress_vote[i]:SetValue(0)
		voteCount[i] = 0
		voteMax[i] = 1	-- protection against div0
	end
	button_end = Button:New {
		width = 20,
		height = 20,
		y = 0,
		right = 0,
		parent=window;
		padding = {0, 0, 0,0},
		margin = {0, 0, 0, 0},
		backgroundColor = {1, 1, 1, 0.4},
		caption="";
		tooltip = "End vote (requires server admin)";
		OnMouseDown = {function() 
				--if voteAntiSpam then return end
				--voteAntiSpam = true
				local notSpam = CheckForVoteSpam (os.clock())
					if notSpam then
					Spring.SendCommands("say !endvote")
				end
			end},
		styleKey = "buttonResizable",
	}
	button_end_image = Image:New {
		width = 16,
		height = 16,
		x = 2,
		y = 2,
		keepAspect = false,
		file = SS44_UI_DIRNAME .. "images/closex_32.png";
		parent = button_end;
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

