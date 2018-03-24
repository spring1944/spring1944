local confdata = {}

local color = {
	white		= {1,1,1,1},
	yellow		= {1,1,0,1},
	gray		= {0.5,.5,.5,1},
	darkgray	= {0.3,.3,.3,1},
	cyan		= {0,1,1,1},
	red			= {1,0,0,1},
	darkred		= {0.5,0,0,1},
	blue		= {0,0,1,1},
	black		= {0,0,0,1},
	darkgreen	= {0,0.5,0,1},
	green		= {0,1,0,1},
	postit		= {1,0.9,0.5,1},
	
	grayred		= {0.5,0.4,0.4,1},
	grayblue	= {0.4,0.4,0.45,1},
	transblack	= {0,0,0,0.3},
	transblack2 = {0,0,0,0.7},
	transGray	= {0.1,0.1,0.1,0.8},
}

do

	color.tooltip_bg	= color.transGray
	color.tooltip_fg	= color.white
	color.tooltip_info	= color.cyan
	color.tooltip_help	= color.green

	color.main_bg = color.white
	color.main_fg = color.white

	color.menu_bg = color.black
	color.menu_fg = color.white

	color.game_bg = color.gray
	color.game_fg = color.white

	color.sub_bg = color.transblack
	color.sub_fg = color.white
	color.sub_header = color.yellow

	color.sub_button_bg = color.gray
	color.sub_button_fg = color.white

	color.sub_back_bg = color.grayblue
	color.sub_back_fg = color.white

	color.sub_close_bg = color.grayblue
	color.sub_close_fg = color.white

	color.stats_bg = color.sub_bg
	color.stats_fg = color.sub_fg
	color.stats_header = color.sub_header

	color.context_bg = color.transblack
	color.context_fg = color.white
	color.context_header = color.yellow

	confdata.color = color

end

local spSendCommands = Spring.SendCommands

confdata.eopt = {}
local path = ''

local function numberIndexes( value, bounds, n )
    local relVal = (value - bounds[1]) / (bounds[2] - bounds[1])
    local index = math.floor(relVal * (n - 1))
    local indexes = {}
    for i=1,n do
        indexes[i] = i - index
    end
    return indexes
end

local function indexedNumber( option )
    local relVal = (option.value - option.valuelist[1]) /
                   (option.valuelist[#option.valuelist] - option.valuelist[1])
    return relVal * (option.actualBounds[2] - option.actualBounds[1]) +
           option.actualBounds[1]
end

local function AddOption( option )
	option.path = path
	if not option.key then
		option.key = option.name
	end
	table.insert( confdata.eopt, option )
end

local function ShButton( caption, action2, tooltip, advanced )
	AddOption({
		type='button',
		name=caption,
		desc = tooltip or '',
		action = (type(action2) == 'string' and action2 or nil),
		OnChange = (type(action2) ~= 'string' and action2 or nil),
		key=caption,
		advanced = advanced,
	})
end

local function ShLabel( caption )
	AddOption({
		type='label',
		name=caption,
		value = caption,
		key=caption,
	})
end

-- SETUP MENU HERE

path='Settings/Game'

	ShButton( 'Increase Game Speed', 'speedup' )
	ShButton( 'Decrease Game Speed', 'slowdown' )
	ShButton( 'Pause/Unpause', 'pause' )
	ShLabel('') 
	--ShButton( 'Last Message Position', 'lastmsgpos' )
	--ShButton( 'Share Dialog...', 'sharedialog' ) 
	--ShButton( 'Choose Commander Type', (function() spSendCommands{"luaui showstartupinfoselector"} end) ) 

--[[
path='Game/Screenshots'	
	ShButton( 'Save Screenshot (PNG)', 'screenshot', 'Find your screenshots under Spring/screenshots' ) 
	ShButton( 'Save Screenshot (JPG)', 'screenshot jpg', 'Find your screenshots under Spring/screenshots' ) 
	
--path='Game'
--	ShButton( 'Constructor Auto Assist', function() spSendCommands{"luaui togglewidget Constructor Auto Assist"} end ) 
]]--

path='Settings/Camera'
	ShLabel( 'Camera Type') 
	ShButton( 'Total Annihilation', 'viewta' ) 
	ShButton( 'FPS', 'viewfps' ) 
	ShButton( 'Free', 'viewfree' ) 
	ShButton( 'Rotatable Overhead', 'viewrot' ) 
	ShButton( 'Total War', 'viewtw' ) 
	ShButton( 'Flip the TA Camera', 'viewtaflip' ) 
	ShButton( 'Toggle advanced COFC camera', 'luaui togglewidget Combo Overhead/Free Camera (experimental)' ) 

path='Settings/Reset Settings'
	ShLabel( 'Reset graphic settings to minimum.')
	ShButton( 'Reset graphic settings',function()
					spSendCommands{"water 0",
						"Shadows 0",
						"maxparticles 100",
						"advshading 0",
						"grounddecals 0",
						'luaui disablewidget LupsManager',
						"luaui disablewidget Display DPS",
						"luaui disablewidget SelectionHalo",
						"luaui disablewidget SelectionCircle",
						"luaui disablewidget UnitShapes",
					}
				end,
				'Use this if your performance is poor'
			)
	ShLabel( 'Reset custom settings to default.')
	ShButton( 'Reset custom settings', function() WG.crude.ResetSettings() end )
	ShLabel( 'Reset hotkeys.')
	ShButton( 'Reset hotkeys',function() WG.crude.ResetKeys() end )

--[[
path='Settings'
	AddOption({
		name = 'Show Advanced Settings',
		type = 'bool',
		value = false,
	})
--]]

path='Settings/Interface/Interface Skin'
	AddOption({
		name = 'Skin Sets',
		type = 'list',
		OnChange = function (self)
			WG.crude.SetSkin( self.value );
		end,
		items = {
			{ key = 'ss44UI', name = 'Default Spring 1944 UI',},
		},
	})
	
path='Settings/Interface/Mouse Cursor'
	ShButton('Toggle Grab Input', function() spSendCommands{"grabinput"} end, 'Mouse cursor won\'t be able to leave the window.' )
	AddOption({ 	
		name = 'Hardware Cursor',
		type = 'bool',
		springsetting = 'HardwareCursor',
		OnChange=function(self) spSendCommands{"hardwarecursor " .. (self.value and 1 or 0) } end, 
	} )
	
path='Settings/Misc'
	ShButton( 'Local Widget Config', function() spSendCommands{"luaui localwidgetsconfig"} end, '', true )
	ShButton( 'LuaUI TweakMode (Esc to exit)', 'luaui tweakgui', 'LuaUI TweakMode. Move and resize parts of the user interface. (Hit Esc to exit)' )

path='Settings/Graphics'
	ShLabel('Lups (Lua Particle System)')
	ShButton('Toggle Lups', function() spSendCommands{'luaui togglewidget LupsManager'} end )
	
	--[[
	ShLabel('Various')
	AddOption({
		name = 'Shiny Units',
		type = 'bool',
		springsetting = 'AdvUnitShading',
		OnChange=function(self) spSendCommands{"advshading " .. (self.value and 1 or 0) } end, --needed as setconfigint doesn't apply change right away
	} )
	AddOption({ 	
		name = 'Ground Decals',
		type = 'bool',
		springsetting = 'GroundDecals',
		OnChange=function(self) spSendCommands{"grounddecals " .. (self.value and 1 or 0) } end, 
	} )
	--]]

	AddOption({
		name = 'Maximum Particles (100 - 20,000)',
		type = 'number',
		valuelist = {100,500,1000,2000,5000,10000,20000},
		springsetting = 'MaxParticles',
		OnChange=function(self) Spring.SendCommands{"maxparticles " .. self.value } end, 
	} )
	
	--[[
	ShLabel('Ground Details')
	
	ShButton('Increase Ground Details', "increaseviewradius" )
	ShButton('Decrease Ground Details', "decreaseviewradius" )


	ShLabel('Trees')
	ShButton('Toggle View', 'drawtrees' )
	ShButton('See More Trees', 'moretrees' )
	ShButton('See Less Trees', 'lesstrees' )
	--{'Toggle Dynamic Sky', function(self) spSendCommands{'dynamicsky'} end },
	--]]
	
	ShLabel('Water Settings')
	ShButton('Basic', function() spSendCommands{"water 0"} end )
	ShButton('Reflective', function() spSendCommands{"water 1"} end )
	ShButton('Reflective and Refractive', function() spSendCommands{"water 3"} end )
	ShButton('Dynamic', function() spSendCommands{"water 2"} end )
	ShButton('Bumpmapped', function() spSendCommands{"water 4"} end )

	ShLabel('Shadow Settings')
	ShButton('Disable Shadows', function() spSendCommands{"Shadows 0"} end )
	ShButton('Toggle Terrain Shadows', function() local curShadow=Spring.GetConfigInt("Shadows"); if (curShadow<2) then curShadow=2 else curShadow=1 end; spSendCommands{"Shadows "..curShadow} end )
	ShButton('Low Detail Shadows', function() local curShadow=Spring.GetConfigInt("Shadows"); curShadow=math.max(1,curShadow); spSendCommands{"Shadows " .. curShadow .. " 1024"} end )
	ShButton('Medium Detail Shadows', function() local curShadow=Spring.GetConfigInt("Shadows"); curShadow=math.max(1,curShadow); spSendCommands{"Shadows " .. curShadow .. " 2048"} end )
	ShButton('High Detail Shadows', function() local curShadow=Spring.GetConfigInt("Shadows"); curShadow=math.max(1,curShadow); spSendCommands{"Shadows " .. curShadow .. " 4096"} end )

	ShLabel('GFX effects')

path='Settings/Graphics/GFX effects'
	ShLabel('Screen Space Ambience Occlusion')
	ShButton('Toggle SSAO', function() spSendCommands{'luaui togglewidget Screen-Space Ambient Occlusion'} end )

	ShLabel('Post-Processing')
	ShButton('Toggle Post-processing effects', function() spSendCommands{'luaui togglewidget Post-processing'} end )
	AddOption({
		name = 'Gamma',
		type = 'number',
		valuelist = numberIndexes(0.75, {0.5, 1.0}, 9),
		actualBounds = {0.5, 1.0},
		springsetting = 'GFXGamma',
		OnChange = function(self) WG.POSTPROC.tonemapping.gamma = indexedNumber(self) end, 
	} )
	AddOption({
		name = 'Gamma fluctuation',
		type = 'number',
		valuelist = numberIndexes(0.0, {0.0, 1.0}, 9),
		actualBounds = {0.0, 1.0},
		springsetting = 'GFXGammaFluctuation',
		OnChange = function(self) WG.POSTPROC.tonemapping.dGamma = indexedNumber(self) end,
	} )
	AddOption({
		name = 'Film grain',
		type = 'number',
		valuelist = numberIndexes(0.02, {0.0, 0.1}, 9),
		actualBounds = {0.0, 0.1},
		springsetting = 'GFXFilmGrain',
		OnChange = function(self) WG.POSTPROC.filmgrain.grain = indexedNumber(self) end,
	} )
	AddOption({
		name = 'Scratches',
		type = 'number',
		valuelist = numberIndexes(0.0, {0.0, 1.0}, 9),
		actualBounds = {0.0, 1.0},
		springsetting = 'GFXScratches',
		OnChange = function(self) WG.POSTPROC.scratches.threshold = indexedNumber(self) end,
	} )
	AddOption({
		name = 'Vignette',
		type = 'number',
		valuelist = numberIndexes(1.0, {0.7, 2.0}, 9),
		actualBounds = {2.0, 0.7},
		springsetting = 'GFXVignette',
		OnChange = function(self) WG.POSTPROC.vignette.vignette[2] = indexedNumber(self) end, 
	} )
	AddOption({
		name = 'Chromatic aberration',
		type = 'number',
		valuelist = numberIndexes(0.1, {0.0, 0.5}, 9),
		actualBounds = {0, 0.5},
		springsetting = 'GFXAberration',
		OnChange = function(self) WG.POSTPROC.aberration.aberration = indexedNumber(self) end, 
	} )

path='Settings/View'

	ShLabel('Spectator View/Selection')
	ShButton('View Chosen Player', function() spSendCommands{"specfullview 0"} end )
	ShButton('View All', function() spSendCommands{"specfullview 1"} end )
	ShButton('Select Any Unit', function() spSendCommands{"specfullview 2"} end )
	ShButton('View All & Select Any', function() spSendCommands{"specfullview 3"} end )

	ShLabel('Other settings')
	
	--[[
	AddOption({
		name = 'Brightness',
		type = 'number',
		min = 0, 
		max = 1, 
		step = 0.01,
		value = 1,
		OnChange = function(self) Spring.SendCommands{"luaui enablewidget Darkening", "luaui darkening " .. 1-self.value} end, 
	} )
	--]]
	
	AddOption({
		name = 'Icon Distance',
		type = 'number',
		min = 1, 
		max = 1000,
		springsetting = 'UnitIconDist',
		OnChange = function(self) Spring.SendCommands{"disticon " .. self.value} end 
	} )
	
	--ShLabel('')
	--ShButton('Toggle DPS Display', function() spSendCommands{"luaui togglewidget Display DPS"} end, 'Shows RPG-style damage' )

--[[
path='Settings/View/Effects'
	ShButton('Night View', function() spSendCommands{'luaui togglewidget Night'} end )
	ShButton('Smoke Signal Markers', function() spSendCommands{'luaui togglewidget Smoke Signal'} end )				
	ShButton('Toggle Camera Shake', function() spSendCommands{'luaui togglewidget CameraShake'} end )
--]]
	
path='Settings/View/Map'	

	ShButton('VR Grid', function() spSendCommands{'luaui togglewidget External VR Grid'} end )
	--ShButton('Map Extension', function() spSendCommands{'luaui togglewidget Map Edge Extension'} end )
	--ShButton('Edge Barrier', function() spSendCommands{'luaui togglewidget Map Edge Barrier'} end )

--[[
path='Help'
	AddOption({
		type='text',
		name='Tips',
		value="Hold your meta-key (spacebar by default) while clicking on a unit or corpse for more info and options. " ..
			"You can also space-click on menu elements to see context settings. "
	})
	ShButton('Tutorial', function() spSendCommands{"luaui togglewidget Nubtron"} end )
	ShButton('Tip Dispenser', function() spSendCommands{"luaui togglewidget Automatic Tip Dispenser"} end )
]]--



return confdata

