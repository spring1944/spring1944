----------------------------------------------------------------------------------------------------
--                                            ss44 UI                                             --
----------------------------------------------------------------------------------------------------
function widget:GetInfo()
	return {
		name	= "NotAchili ss44 UI",
		desc	= "Unit Control Menu",
		author	= "a1983",
		date	= "01 04 2013",
		license	= "GPL",
		layer	= math.huge,
		handler	= true, -- used widget handlers
		enabled	= true  -- loaded by default
	}
end

----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local smallSize		= 2.5
local mediumSize	= 3.0
local largeSize		= 3.5

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local globalSize = smallSize

--local oldMinimapGeometry

local players = {}

----------------------------------------------------------------------------------------------------
--                                        Global variables                                        --
----------------------------------------------------------------------------------------------------
if not WG.SS44_UI then
	WG.SS44_UI = {}
end
SS44_UI = WG.SS44_UI

SS44_UI.players = players

local function SetGlobalSize( globalSize )
	if type( globalSize ) == "table" then
		globalSize = globalSize.priv_value
	end

	SS44_UI.globalSize = globalSize
	
	SS44_UI.imageW = 21 * globalSize
	SS44_UI.imageH = 16 * globalSize
	SS44_UI.imageOffset = 2 * globalSize
	SS44_UI.imageInRow = 4
	
	SS44_UI.labelH = 8 * globalSize
	SS44_UI.labelFontSize = 4.8 * globalSize
	
	SS44_UI.skinMargin = 5 * globalSize
	
	SS44_UI.minimapH = 80 * globalSize
	
	SS44_UI.stateW = 9.6 * globalSize
	SS44_UI.stateH = 9.6 * globalSize
	
	local count = SS44_UI.imageInRow
	SS44_UI.rowSize	= SS44_UI.imageW * count + SS44_UI.imageOffset * ( count + 1 )
	SS44_UI.totalW	= SS44_UI.rowSize + SS44_UI.skinMargin * 2
end

-- by default small size
SetGlobalSize( smallSize )

----------------------------------------------------------------------------------------------------
-- Settings for crude menu
----------------------------------------------------------------------------------------------------
options_path = "Settings/Interface"
options_order = { 
	"interfaceSizeOption",
}

options = {
	interfaceSizeOption = {
		name = "Interface Size",
		type = "list",
		OnChange = function( key )
			SetGlobalSize( key )

			-- Recreate all widgets to apply new settings
			
			if SS44_UI.ResetMinimapWidget then
				SS44_UI.ResetMinimapWidget()
			end
			
			WG.crude.ResetWidget( SS44_UI )
			-- MINIMAP_WIDGET.ResetWidget()
			SELECTION_WIDGET.ResetWidget()
			ORDERS_WIDGET.ResetWidget()
			BUILD_WIDGET.ResetWidget()
			RESOURCE_BAR_WIDGET.ResetWidget()
			CONSOLE_WIDGET.ResetWidget()
			
		end,
		default = mediumSize,
		items = {
			{
				key = smallSize,
				name = "Small Interface Size",
				desc = "Small Interface Size",
			},
			{
				key = mediumSize,
				name = "Medium Interface Size",
				desc = "Medium Interface Size",
			},
			{
				key = largeSize,
				name = "Large Interface Size",
				desc = "Large Interface Size",
			},
		},		
	},
}

----------------------------------------------------------------------------------------------------
--                                            Includes                                            --
----------------------------------------------------------------------------------------------------
include( "keysym.h.lua" )

local path = "Widgets/notAchili/ss44UI/"
include( path .. "tools.lua" )
include( path .. "unitControlTools.lua" )
include( path .. "minimapWidget.lua" )
include( path .. "selectionWidget.lua" )
include( path .. "ordersWidget.lua" )
include( path .. "buildWidget.lua" )

include( path .. "resourceBarWidget.lua" )
include( path .. "consoleWidget.lua" )

SS44_UI.Tools = TOOLS

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CommandsHandler	( xIcons, yIcons, cmdCount, commands ) end
local function SetupPlayers		() end
local function DisableWidgets	() end
----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local currentCommands		= UNIT_CONTROL_TOOLS.currentCommands
local RefreshCommands		= UNIT_CONTROL_TOOLS.RefreshCommands

--local CreateMinimapWidget	= MINIMAP_WIDGET.CreateMinimapWidget
--local RenderMinimap			= MINIMAP_WIDGET.RenderMinimap
--local UpdateMinimapGeometry	= MINIMAP_WIDGET.UpdateMinimapGeometry

local CreateSelectionWidget = SELECTION_WIDGET.CreateSelectionWidget
local UpdateSelectionWidget = SELECTION_WIDGET.UpdateSelectionWidget
local UpdateSelectionData	= SELECTION_WIDGET.UpdateSelectionData

local CreateBuildWidget		= BUILD_WIDGET.CreateBuildWidget
local UpdateBuildsWidget	= BUILD_WIDGET.UpdateBuildsWidget
local UpdateBuildsData		= BUILD_WIDGET.UpdateBuildsData
local UpdateActiveBuild		= BUILD_WIDGET.UpdateActiveCommand

local CreateOrdersWidget	= ORDERS_WIDGET.CreateOrdersWidget
local UpdateOrdersWidget	= ORDERS_WIDGET.UpdateOrdersWidget
local UpdateOrdersData		= ORDERS_WIDGET.UpdateOrdersData
local UpdateActiveOrder		= ORDERS_WIDGET.UpdateActiveCommand

local CreateResourceBarWidget	= RESOURCE_BAR_WIDGET.CreateResourceBarWidget
local UpdateResourceBarWidget	= RESOURCE_BAR_WIDGET.UpdateResourceBarWidget
local UpdateResourceBarGeometry = RESOURCE_BAR_WIDGET.UpdateResourceBarGeometry

local CreateConsoleWidget	= CONSOLE_WIDGET.CreateConsoleWidget
local UpdateConsoleWidget	= CONSOLE_WIDGET.UpdateConsoleWidget
local UpdateConsoleGeometry	= CONSOLE_WIDGET.UpdateConsoleGeometry
local AddConsoleLine		= CONSOLE_WIDGET.AddConsoleLine
local ToggleConsoleTextBox	= CONSOLE_WIDGET.ToggleConsoleTextBox
local DisableConsoleTextBox	= CONSOLE_WIDGET.DisableConsoleTextBox
local ToggleConsoleMode		= CONSOLE_WIDGET.ToggleConsoleMode

local SpGetActiveCommand	= Spring.GetActiveCommand
local SpGetTeamColor		= Spring.GetTeamColor
local SpGetPlayerList		= Spring.GetPlayerList
local SpGetPlayerInfo		= Spring.GetPlayerInfo
local SpGetTeamInfo			= Spring.GetTeamInfo

local string_format = string.format
local string_char	= string.char

----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLLINS                                        --
----------------------------------------------------------------------------------------------------
function widget:Initialize ()
	DisableWidgets()
	
	-- hide default console
	Spring.SendCommands( "console 0" )
	
	-- hide default rez bar
	Spring.SendCommands( "resbar 0" )
	
	-- hide default selection info
	Spring.SetDrawSelectionInfo( false )
	
	-- set commands handler
	if widgetHandler.ConfigLayoutHandler then
		widgetHandler:ConfigLayoutHandler( CommandsHandler )
	end
	Spring.ForceLayoutUpdate()
	
	-- set minimap handler
	--oldMinimapGeometry = Spring.GetConfigString( "MiniMapGeometry", "2 2 200 200" )
	--gl.SlaveMiniMap( true )
	--WG.NotAchili.PostNotAchiliDraw = RenderMinimap
	
	WG.crude.ResetWidget( SS44_UI )
	
	-- initialize widgets
	--CreateMinimapWidget()
	CreateSelectionWidget()
	CreateOrdersWidget()
	CreateBuildWidget()
	CreateResourceBarWidget()
	CreateConsoleWidget()
	
	SetupPlayers()
	
	Spring.SendCommands( {
		"bind              Any++  speedup",
		"bind              Any+=  speedup",
		"bind              Any+-  slowdown",
		"bind         Any+insert  speedup",
		"bind         Any+delete  slowdown",
		"bind        Any+numpad+  speedup",
		"bind        Any+numpad-  slowdown",
	} )
	
	-- customCommands extension
	widgetHandler:RegisterGlobal({}, 'CustomCommandUpdate', CustomCommandUpdate)
end

----------------------------------------------------------------------------------------------------
function widget:AddConsoleLine( line )
	AddConsoleLine( line )
end

----------------------------------------------------------------------------------------------------
local enterKey		= 13
local escapeKey		= 27


local keyEnterPressed = false

function widget:KeyPress( key, mods, isRepeat, label, unicode )
	if key == enterKey then
		
		if keyEnterPressed then
			keyEnterPressed = false
			DisableConsoleTextBox()
		else
			keyEnterPressed = true
			ToggleConsoleTextBox()
		end
	elseif key == escapeKey and mods.shift then
		ToggleConsoleMode()
	end
end

function widget:KeyRelease( key, mods, isRepeat, label, unicode )
	if key == enterKey then
		if keyEnterPressed then
			keyEnterPressed = false
		else
			local modPresent = mods.alt or mods.ctrl or mods.shift

			if not modPresent then
				DisableConsoleTextBox()
			end
		end
	elseif key == escapeKey then
		keyEnterPressed = false
		DisableConsoleTextBox()
	end
end

----------------------------------------------------------------------------------------------------
function widget:ViewResize( w, h )
	--UpdateMinimapGeometry()
	UpdateSelectionWidget()
	UpdateOrdersWidget()
	UpdateBuildsWidget()
	UpdateResourceBarGeometry()
	UpdateConsoleGeometry()
end

----------------------------------------------------------------------------------------------------
function widget:GamePreload()
	SetupPlayers()
end

function widget:GameStart()
	SetupPlayers()
end

function widget:PlayerAdded( playerID )
	SetupPlayers()
end

function widget:PlayerChanged( playerID )
	SetupPlayers()
end

function widget:PlayerRemoved( playerID, reason )
	local player = players[ playerID ]
	
	if player then
		players[ player.name ] = nil
	end
	
	players[ playerID ] = nil
end

----------------------------------------------------------------------------------------------------
function widget:Update( dt )
	local _, id = SpGetActiveCommand()
	UpdateActiveOrder( id )
	UpdateActiveBuild( id )
	
	UpdateResourceBarWidget( dt )
	UpdateConsoleWidget( dt )
end

----------------------------------------------------------------------------------------------------
function widget:Shutdown ()

	if WG.NotAchili then
		WG.NotAchili.PostNotAchiliDraw = nil
	end

	-- restore default console
	Spring.SendCommands( "console 1" )

	-- restore default resource bars
	Spring.SendCommands( "resbar 1" )

	-- restore minimap
	--Spring.SendCommands( "minimap geometry " .. oldMinimapGeometry )
	--gl.SlaveMiniMap( false )

	-- restore default commands handler
	if widgetHandler.ConfigLayoutHandler then
		widgetHandler:ConfigLayoutHandler( true )
	end
	Spring.ForceLayoutUpdate()
	
	-- restore selection info
	Spring.SetDrawSelectionInfo( true )
end

----------------------------------------------------------------------------------------------------
--                                         Implementation                                         --
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--       Handler, called by Spring every time, when selected units commands states changed        --
----------------------------------------------------------------------------------------------------
function CommandsHandler( xIcons, yIcons, cmdCount, commands )

	widgetHandler.commands   = commands
	widgetHandler.commands.n = cmdCount
	--widgetHandler:CommandsChanged()
		
	UpdateSelectionData()
	
	--Spring.Echo( "Update" )
	
	RefreshCommands( commands )
	
	UpdateOrdersData( currentCommands )
	UpdateBuildsData( currentCommands.builds )
	
	return "", xIcons, yIcons, {}, {}, {}, {}, {}, {}, {}, { [ 1337 ] = 9001 }
	--[[
	  return menuName, xIcons, yIcons,
         removeCmds, customCmds,
         onlyTextureCmds, reTextureCmds,
         reNamedCmds, reTooltipCmds, reParamsCmds,
         iconList
	--]]
end

----------------------------------------------------------------------------------------------------
function SetupPlayers()

	local idList = SpGetPlayerList()
	for i = 1, #idList do
		local playerID = idList[ i ]
		local info = { SpGetPlayerInfo( playerID ) }
		local player = {
			name		= info[ 1 ],
			spectator	= info[ 3 ],
			playerID	= playerID,
			teamID		= info[ 4 ],
			allyID		= info[ 5 ],
		}
		--Spring.Echo( info[ 1 ], info[ 2 ], info[ 3 ] )

		local r, g, b = SpGetTeamColor( player.teamID )
		player.color = { r, g, b }


		local _, _, _, _, side = SpGetTeamInfo( player.teamID )
		player.side = side

		players[ player.name ]	= player
		players[ playerID ]		= player
	end

end

----------------------------------------------------------------------------------------------------
local disabledWidgets = {
	"Build costs 1.02",
	"LoIUI",
	"Red Resource Bars",
	"Red Console",
	"Red Build/Order Menu",
	"Red Minimap",
	"Red Tooltip",
	"Red_UI_Framework",
	"Red_Drawing",
	"SelectionButtons",
	"Unit Stats",
}

function DisableWidgets()

	for i = 1, #disabledWidgets do
		local name = disabledWidgets[ i ]
		
		local known = widgetHandler.knownWidgets[ name ]
		if known and known.active then
			widgetHandler:DisableWidget( name )
		end
		
		local widgetOrder = widgetHandler.orderList[ name ]
		if widgetOrder and widgetOrder > 0 then
			widgetHandler.orderList[ name ] = 0
		end
	end
end
----------------------------------------------------------------------------------------------------