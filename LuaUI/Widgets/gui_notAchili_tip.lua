----------------------------------------------------------------------------------------------------
function widget:GetInfo()
  return {
    name      = "NotAchili Cursor Tip 3",
    desc      = "v0.102 NotAchili Cursor Tooltips.",
    author    = "CarRepairer",
    date      = "2009-06-02",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    experimental = false,
    enabled   = true,
  }
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local spGetCurrentTooltip		= Spring.GetCurrentTooltip
local spGetUnitDefID			= Spring.GetUnitDefID
local spGetFeatureDefID			= Spring.GetFeatureDefID
local spGetFeatureTeam			= Spring.GetFeatureTeam
local spGetUnitAllyTeam			= Spring.GetUnitAllyTeam
local spGetUnitTeam				= Spring.GetUnitTeam
local spGetUnitHealth			= Spring.GetUnitHealth
local spGetUnitResources		= Spring.GetUnitResources
local spGetSelectedUnitsCount	= Spring.GetSelectedUnitsCount
local spGetSelectedUnitsCounts	= Spring.GetSelectedUnitsCounts
local spTraceScreenRay			= Spring.TraceScreenRay
local spGetTeamInfo				= Spring.GetTeamInfo
local spGetPlayerInfo			= Spring.GetPlayerInfo
local spGetTeamColor			= Spring.GetTeamColor
local spGetUnitTooltip			= Spring.GetUnitTooltip
local spGetModKeyState			= Spring.GetModKeyState
local spGetMouseState			= Spring.GetMouseState
local spSendCommands			= Spring.SendCommands
local spGetUnitIsStunned		= Spring.GetUnitIsStunned
local spGetUnitResources		= Spring.GetUnitResources

local abs						= math.abs
local string_format 			= string.format

local echo = Spring.Echo

local iconFormat = ''

local iconTypesPath = LUAUI_DIRNAME .. "Configs/icontypes.lua"
local icontypes = VFS.FileExists(iconTypesPath) and VFS.Include(iconTypesPath)
local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"

local color = {}

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


include("keysym.h.lua")
local tildePressed, drawing, erasing
local glColor		= gl.Color
--local glAlphaTest	= gl.AlphaTest
local glTexture 	= gl.Texture
local glTexRect 	= gl.TexRect

-- pencil and eraser
local cursor_size = 24

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local NotAchili
local Button
local Label
local Window
local StackPanel
local Panel
local Grid
local TextBox
local Image
local Multiprogressbar
local Progressbar
local screen0

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local B_HEIGHT = 30
local icon_size = 20
local stillCursorTime = 0

local scrH, scrW = 0,0
local oldTooltipData, oldPointedData
local old_mx, old_my = -1,-1
local mx, my = -1,-1
local showExtendedTip = false
local changeNow = false

local window_tooltip2
local ttWindows = {}
--local tt_buildpic
local tt_healthbar, tt_unitID, tt_fid, tt_ud, tt_fd
local ttControls = {}
local ttControlsIcons = {}

local stack_main, stack_leftbar
local globalItems = {}

local ttFontSize = 2

local red = '\255\255\1\1'
local green = '\255\1\255\1'
local cyan = '\255\1\255\255'
local white = '\255\255\255\255'

local metalColor  = { 0.8, 0.8, 0.8, 1 }
local energyColor = { 1.0, 1.0, 0.0, 1 }
local metalTextColor  = '\255\204\204\204'
local energyTextColor = '\255\255\255\0'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--[[
local function StaticChanged() 
	if (window_tooltip2) then
		window_tooltip2:Dispose()
	end
	
	Initialize()
end 
--]]
options_path = 'Settings/Interface/Tooltip'
--options_order = { 'tooltip_delay',  'statictip', 'fontsize', 'staticfontsize', 'hpshort'}
options_order = { 'tooltip_delay',  'fontsize', 'hpshort', 'featurehp', 'hide_for_unreclaimable', 'showdrawtooltip',  }

options = {
	tooltip_delay = {
		name = 'Tooltip display delay (0 - 4s)',
		desc = 'Determines how long you can leave the mouse idle until the tooltip is displayed.',
		type = 'number',
		min = 0, max = 4, step = 0.1,
		value = 0.3,
	},
	fontsize = {
		name = 'Font Size (10-20)',
		desc = 'Resizes the font of the tip',
		type = 'number',
		min=10,max=20,step=1,
		value = 10,
		OnChange = FontChanged,
	},
	hpshort = {
		name = "HP Short Notation",
		type = 'bool',
		value = false,
		desc = 'Shows short number for HP.',
	},
	featurehp = {
		name = "Show HP on Features",
		type = 'bool',
		advanced = true,
		value = false,
		desc = 'Shows healthbar for features.',
		OnChange = function() 
			--fixme: dispose?
			ttControls['feature']=nil; 
			ttControls['corpse']=nil; 
		end,
	},
	hide_for_unreclaimable = {
		name = "Hide Tooltip for Unreclaimables",
		type = 'bool',
		advanced = true,
		value = true,
		desc = 'Don\'t show the tooltip for unreclaimable features.',
	},
	showdrawtooltip = {
		name = "Show Map-drawing Tooltip",
		type = 'bool',
		value = true,
		desc = 'Show map-drawing tooltip when holding down ~.',
	},
	
}

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local function FontChanged() 
	ttControls = {}
	ttControlsIcons = {}
	ttFontSize = options.fontsize.value
end

options.fontsize.OnChange = FontChanged

----------------------------------------------------------------------------------------------------
function comma_value(amount, displayPlusMinus)
	local formatted

	-- amount is a string when ToSI is used before calling this function
	if type(amount) == "number" then
		if (amount ==0) then formatted = "0" else 
			if (amount < 20 and (amount * 10)%10 ~=0) then 
				if displayPlusMinus then formatted = string_format("%+.1f", amount)
				else formatted = string_format("%.1f", amount) end 
			else 
				if displayPlusMinus then formatted = string_format("%+d", amount)
				else formatted = string_format("%d", amount) end 
			end 
		end
	else
		formatted = amount .. ""
	end

	if options.hpshort.value then 
		local k
		while true do  
			formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
			if (k==0) then
				break
			end
		end
	end 
  	return formatted
end

----------------------------------------------------------------------------------------------------
--from rooms widget by quantum
local function ToSI(num)
  if type(num) ~= 'number' then
	return 'Tooltip wacky error #55'
  end
  if (num == 0) then
    return "0"
  else
    local absNum = abs(num)
    if (absNum < 0.001) then
      return string_format("%.1fu", 1000000 * num)
    elseif (absNum < 1) then
      return string_format("%.1f", num)
    elseif (absNum < 1000) then
	  return string_format("%.0f", num)
    elseif (absNum < 1000000) then
      return string_format("%.1fk", 0.001 * num)
    else
      return string_format("%.1fM", 0.000001 * num)
    end
  end
end
----------------------------------------------------------------------------------------------------
local function ToSIPrec(num) -- more presise
  if type(num) ~= 'number' then
	return 'Tooltip wacky error #56'
  end
  if not options.hpshort.value then 
	return num
  end 
  if (num == 0) then
    return "0"
  else
    local absNum = abs(num)
    if (absNum < 0.001) then
      return string_format("%.2fu", 1000000 * num)
    elseif (absNum < 1) then
      return string_format("%.2f", num)
    elseif (absNum < 1000) then
      return string_format("%.1f", num)
    elseif (absNum < 1000000) then
      return string_format("%.2fk", 0.001 * num)
    else
      return string_format("%.2fM", 0.000001 * num)
    end
  end
end
----------------------------------------------------------------------------------------------------
local function numformat( num, displayPlusMinus )
	return comma_value( ToSIPrec(num), displayPlusMinus )
end
----------------------------------------------------------------------------------------------------
local function formatThousands( number )
	if type( number ) ~= 'number' then
		return 'Tooltip wrong number format!'
	end
	
	local thousandsSeparator = " %1"
	
	local s = string_format( "%d", number )
    local pos = string.len( s ) % 3
    if pos == 0 then 
		pos = 3 
	end
    return string.sub( s, 1, pos )
		.. string.gsub( string.sub( s, pos + 1 ), "(...)", thousandsSeparator )
end
----------------------------------------------------------------------------------------------------
local function CalculateDPS( info ) 
	local weapons = info.weapons
	
	if #weapons == 0 then
		return ""
	end
	
	local totalDps = 0
	for i = 1, #weapons do
		local weaponDef = weapons[ i ].weaponDef
		local weaponInfo = WeaponDefs[ weaponDef ]
		
		local defaultDamage = weaponInfo.damages[ 0 ]
		local burst = weaponInfo.salvoSize * weaponInfo.projectiles
		if( burst > 1 ) then
			totalDps = totalDps + defaultDamage * burst / weaponInfo.reload
		else
			totalDps = totalDps + defaultDamage / weaponInfo.reload
		end
	end
	
	return formatThousands( totalDps )
end

----------------------------------------------------------------------------------------------------
local buildInfoCache = {}
local function GetBuildTime( info )
	local unitDefId = info.id
	local defaultBuildPower = 1
	
	local selected = spGetSelectedUnitsCounts()
	for builderDefId, unitsCount in pairs( selected ) do
		if builderDefId ~= 'n' then
			local builderInfo = UnitDefs[ builderDefId ]

			if builderInfo.isBuilder then
			
				local buildInfo = buildInfoCache[ builderDefId ]
				if not buildInfo then
					buildInfo = {}
					local buildList = builderInfo.buildOptions 
					for i = 1, #buildList do
						buildInfo[ buildList[ i ] ] = builderInfo.buildSpeed 
					end
					
					buildInfoCache[ builderDefId ] = buildInfo
				end
				
				local buildPower = buildInfo[ unitDefId ]
				
				if buildPower and buildPower > defaultBuildPower then
					defaultBuildPower = buildPower
				end
			end
		end
	end
	
	--// to do: add game speed multiplier
	local buildTime = info.buildTime / defaultBuildPower
	local hours = math.floor( buildTime / 3600 )
	local minutes = math.floor( ( buildTime / 60 ) % 60 )
	local seconds = math.floor( buildTime % 60 )
	if hours > 0 then
		return string_format( "%02d:%02d:%02d", hours, minutes, seconds )
	else
		return string_format( "%02d:%02d", minutes, seconds )
	end
end


----------------------------------------------------------------------------------------------------
local function AdjustWindow(window)
	local nx
	if (0 > window.x) then
		nx = 0
	elseif (window.x + window.width > screen0.width) then
		nx = screen0.width - window.width
	end

	local ny
	if (0 > window.y) then
		ny = 0
	elseif (window.y + window.height > screen0.height) then
		ny = screen0.height - window.height
	end

	if (nx or ny) then
		window:SetPos(nx,ny)		
	end

	--//FIXME If we don't do this the stencil mask of stack_rightside doesn't get updated, when we move the mouse (affects only if type(stack_rightside) == StackPanel)
	stack_main:Invalidate()
	stack_leftbar:Invalidate()
	
	if window_tooltip2:GetChildByName('leftBar') then
		window_tooltip2:GetChildByName('leftBar'):Invalidate()
	end
	window_tooltip2:GetChildByName('main'):Invalidate()
	
end



----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local function GetUnitDesc( unitID, ud )
	if not( unitID or ud ) then
		return ''
	end
	
	local lang = WG.lang or 'en'
	if lang == 'en' then 
		return unitID and spGetUnitTooltip( unitID ) or ud.tooltip
	end
	local suffix = ('_' .. lang)
	local desc = ud.customParams and ud.customParams[ 'description' .. suffix ] or ud.tooltip 
		or 'Description error'
	
	if unitID then
		local endesc = ud.tooltip
		return spGetUnitTooltip(unitID):gsub(endesc, desc)
	end
	
	return desc
end

----------------------------------------------------------------------------------------------------
local function ParseTooltip( tooltip )
	
	tooltip = tooltip:gsub( '\r', '\n' )
	tooltip = tooltip:gsub( '\n+', '\n' )
		
	return {
		tooltip		= tooltip, 
	}
end

----------------------------------------------------------------------------------------------------

local function SetHealthbar()
	if not( tt_unitID or tt_fid ) then 
		return 'err' 
	end
	
	local tt_healthbar
	
	local health, maxhealth
	if tt_unitID then
		health, maxhealth = spGetUnitHealth(tt_unitID)
		tt_healthbar = globalItems.hp_unit
	elseif tt_fid then
		health, maxhealth = Spring.GetFeatureHealth(tt_fid)
		tt_healthbar = tt_ud and globalItems.hp_corpse or globalItems.hp_feature
	end

	local progressBar = tt_healthbar.children[ 2 ]
	
	if health then
		progressBar.color = {0,1,0, 1}
		
		tt_health_fraction = health/maxhealth
		progressBar:SetValue(tt_health_fraction)
		if options.hpshort.value then
			progressBar:SetCaption(numformat(health) .. ' / ' .. numformat(maxhealth))
		else
			progressBar:SetCaption(math.ceil(health) .. ' / ' .. math.ceil(maxhealth))
		end
		
	else
		progressBar.color = {0,0,0.5, 1}
		local maxhealth = (tt_fd and tt_fd.health) or (tt_ud and tt_ud.health) or 0
		progressBar:SetValue(1)
		if options.hpshort.value then
			progressBar:SetCaption('??? / ' .. numformat(maxhealth))
		else
			progressBar:SetCaption('??? / ' .. math.ceil(maxhealth))
		end
	end
end

----------------------------------------------------------------------------------------------------
local function KillTooltip( force )
	oldTooltipData = ''
	tt_unitID = nil
	
	if window_tooltip2 and window_tooltip2:IsDescendantOf(screen0) then
		screen0:RemoveChild(window_tooltip2)
	end
end

----------------------------------------------------------------------------------------------------
local function UpdateResourceStack( tooltipType, unitID, ud, tooltip, fontSize )

	local stack_children = {}

	local metal, energy = 0,0
	local color_m = {1,1,1,1}
	local color_e = {1,1,1,1}
	
	local resource_tt_name = 'resources_' .. tooltipType
	
	if tooltipType == 'feature' or tooltipType == 'corpse' then
		metal = ud.metal
		energy = ud.energy
		
		if unitID then
			local m, _, e, _, _ = Spring.GetFeatureResources(unitID)
			metal = m or metal
			energy =  e or energy
		end
	else --tooltipType == 'unit'
		local metalMake, metalUse, energyMake, energyUse = Spring.GetUnitResources(unitID)
		
		if metalMake then
			metal = metalMake - metalUse
		end
		if energyMake then
			energy = energyMake - energyUse
		end
		
		-- special cases for mexes
		if ud.name=='cormex' then 
			local baseMetal = 0
			local s = tooltip:match("Makes: ([^ ]+)")
			if s ~= nil then baseMetal = tonumber(s) end 
							
			s = tooltip:match("Overdrive: %+([0-9]+)")
			local od = 0
			if s ~= nil then od = tonumber(s) end
			
			metal = metal + baseMetal + baseMetal * od / 100
			
			s = tooltip:match("Energy: ([^ \n]+)")
			s = tonumber(s)
			if s ~= nil and type(s) == 'number' then 
				energy = energy + tonumber(s)
			end 
		end 
		
	end
	
	if tooltipType == 'feature' or tooltipType == 'corpse' then
		color_m = {1,1,1,1}
		color_e = {1,1,1,1}
	else
		if metal > 0 then
			color_m = {0,1,0,1}
		elseif metal < 0 then
			color_m = {1,0,0,1}
		end
		if energy > 0 then
			color_e = {0,1,0,1}
		elseif energy < 0 then
			color_e = {1,0,0,1}
		end
	end
	
	if globalItems[resource_tt_name] then
		local metalcontrol 	= globalItems[resource_tt_name]:GetChildByName('metal')
		local energycontrol = globalItems[resource_tt_name]:GetChildByName('energy')
		
		metalcontrol.font:SetColor(color_m)
		energycontrol.font:SetColor(color_e)
		
		metalcontrol:SetCaption( numformat(metal, true) )
		energycontrol:SetCaption( numformat(energy, true) )
		return
	end
	
	local lbl_metal2 = Label:New{ name='metal', caption = numformat(metal, true), autosize=true, fontSize=fontSize, valign='center' }
	local lbl_energy2 = Label:New{ name='energy', caption = numformat(energy, true), autosize=true, fontSize=fontSize, valign='center'  }
	
	globalItems[resource_tt_name] = StackPanel:New{
		centerItems = false,
		autoArrangeV = true,
		orientation='horizontal',
		resizeItems=false,
		width = '100%',
		height = icon_size+1,
		padding = {0,0,0,0},
		itemPadding = {0,0,0,0},
		itemMargin = {5,0,0,0},
		children = {
			Image:New{file= SS44_UI_DIRNAME .. 'images/resources/metal.png',height= icon_size,width= icon_size, fontSize=ttFontSize,},
			lbl_metal2,
			Image:New{file= SS44_UI_DIRNAME .. 'images/resources/energy.png',height= icon_size,width= icon_size, fontSize=ttFontSize,},
			lbl_energy2,
		},
	}
end

----------------------------------------------------------------------------------------------------
local function PlaceToolTipWindow2(x,y)
	if not window_tooltip2 then return end
	
	if not window_tooltip2:IsDescendantOf(screen0) then
		screen0:AddChild(window_tooltip2)
	end
	--if not options.statictip.value then
		local x = x
		local y = scrH-y
		window_tooltip2:SetPos(x,y)
		AdjustWindow(window_tooltip2)
	--end

	window_tooltip2:BringToFront()
end

----------------------------------------------------------------------------------------------------
local function GetHelpText( tooltipType )
	
	local sc_caption = ''
	if tooltipType == 'buildunit' then
		if showExtendedTip then
			sc_caption = 
				'Shift+click: x5 multiplier.\n'..
				'Ctrl+click: x20 multiplier.\n'..
				'Alt+click: Add units to front of queue. \n'..
				'Rightclick: remove units from queue.\n'..
				'Space+click: Show unit stats'
		else
			sc_caption = '(Hold Spacebar for help)'
		end
	else
		sc_caption = 'Space+click: Show details'
	end
	
	return sc_caption
end

----------------------------------------------------------------------------------------------------
local function MakeStack( ttName, ttStackData )
	local children = {}
	local height = 0
	
	for _, item in ipairs( ttStackData ) do
		local stack_children = {}
		local empty = false
		
		if item.directcontrol then
			local directitem = globalItems[item.directcontrol]
			stack_children[ #stack_children + 1 ] = directitem

		elseif item.text or item.icon then
			local curFontSize = ttFontSize + ( item.fontSize or 0 )
			local itemtext =  item.text or ''

			if item.icon then
				ttControlsIcons[ ttName ][ item.name ] = Image:New{ 
					file = item.icon,
					height = icon_size,
					width  = icon_size,
					fontSize = curFontSize,
				}
				stack_children[ #stack_children + 1 ] = ttControlsIcons[ttName][item.name]
			end
			
			if item.wrap then
				ttControls[ ttName ][ item.name ] = TextBox:New{
					name = item.name, 				
					autosize = false,
					text = itemtext , 
					width = '100%', 
					valign = "ascender", 
					font = { size = curFontSize }, 
					fontShadow = true,
				}
				stack_children[ #stack_children + 1 ] = ttControls[ttName][item.name]
			else
				local rightmargin = item.icon and icon_size or 0
				local width = (leftBar and 50 or 230) - rightmargin
				
				ttControls[ ttName ][ item.name ] = Label:New{
					fontShadow = true,
					defaultHeight = 0,
					autosize = false,
					name = item.name,
					caption = itemtext,
					fontSize = curFontSize,
					valign = 'center',
					height = icon_size,
					x = icon_size + 5, right = 1,
				}
				
				stack_children[ #stack_children + 1 ] = ttControls[ ttName ][ item.name ]
			end
			
			if ( not item.icon ) and itemtext == '' then
				ttControls[ ttName ][ item.name ]:Resize( '100%', 0 )
			end
		elseif item.row then
			local curFontSize = ttFontSize + ( item.fontSize or 0 )
		
			for i = 1, #item.row do
				local rowItem = item.row[ i ]
				local itemControl
				if rowItem.icon then
					itemControl = Image:New{ 
						file = rowItem.icon,
						height = icon_size,
						width  = icon_size,
						fontSize = curFontSize,
					}
				elseif rowItem.text then
					itemControl = Label:New{
					name = rowItem.name,
					fontShadow = true,
					defaultHeight = 0,
					autosize = false,
					caption = rowItem.text,
					fontSize = curFontSize,
					valign = 'center',
					height = icon_size,
					x = icon_size + 5, width = rowItem.width,
				}
				end
				
				stack_children[ #stack_children + 1 ] = itemControl
				if rowItem.name then
					ttControls[ ttName ][ rowItem.name ] = itemControl
				end
			end
		else
			empty = true
		end
		
		if not empty then
			children[ #children + 1 ] = StackPanel:New{
				centerItems = false,
				autoArrangeV = true,
				orientation='horizontal',
				resizeItems=false,
				width = '100%',
				autosize=true,
				padding = {1,1,1,1},
				itemPadding = {0,5,0,0},
				itemMargin = {4,1,0,1},
				children = stack_children,
			}
		end
	end
	return children
end

----------------------------------------------------------------------------------------------------
local function UpdateStack( ttName, stack )
	for _, item in ipairs( stack ) do
		local name = item.name
		
			--[[
			if item.directcontrol then
				--local directitem = (type( item.directcontrol ) == 'string') and globalItems[item.directcontrol] or item.directcontrol
				--local directitem = globalItems[item.directcontrol]
				--
				if hideitems[item.directcontrol] then
					directitem:Resize('100%',0)
				else
					directitem:Resize('100%',globalitemheights[item.directcontrol])
				end
				--
			end
			--]]
			if ttControls[ttName][name] then			
				if item.wrap then	
					ttControls[ttName][name]:SetText( item.text )
					ttControls[ttName][name]:Invalidate()
				else
					ttControls[ttName][name]:SetCaption( item.text )
				end
			elseif item.row then
				local row = item.row
				for i = 1, #row do
					local rowItem = row[ i ]
					if rowItem.name then
						local control = ttControls[ttName][rowItem.name]
						if control then
							control:SetCaption( rowItem.text )
						end
					end
				end
			end
			if ttControlsIcons[ttName][name] then
				if item.icon then
					ttControlsIcons[ttName][name].file = item.icon
					ttControlsIcons[ttName][name]:Invalidate()
				end
			end
		
	end
	
end

----------------------------------------------------------------------------------------------------
local function SetTooltip( tt_window )
	
	if not window_tooltip2 or window_tooltip2 ~= tt_window then
		KillTooltip(true)
		window_tooltip2 = tt_window
	end
	PlaceToolTipWindow2(mx+20,my-20)
end

----------------------------------------------------------------------------------------------------
local function BuildTooltip2( ttName, ttData )
	if not ttData.main then
		echo '<Cursortip> Missing ttData.main'
		return
	end
	
	if ttControls[ ttName ] then
		UpdateStack( ttName, ttData.main )
		if ttData.leftBar then
			UpdateStack( ttName, ttData.leftBar )
		end
	else
		ttControls[ ttName ] = {}
		ttControlsIcons[ ttName ] = {}
		
		local stack_leftbar_temp, stack_main_temp
		local children_main  = MakeStack( ttName, ttData.main )
		local leftside = false
		
		if ttData.leftBar then
			children_leftbar  = MakeStack( ttName, ttData.leftBar )
			
			stack_leftbar_temp = 
				StackPanel:New{
					name = 'leftBar',
					orientation='vertical',
					padding = {0,0,0,0},
					itemPadding = {1,0,0,0},
					itemMargin = {0,0,0,0},
					resizeItems=false,
					autosize=true,
					width = 90,
					children = children_leftbar,
				}
			leftside = true
		else
			stack_leftbar_temp = StackPanel:New{ width=10, }
		end
		
		stack_main_temp = StackPanel:New{
			name = 'main',
			autosize=true,
			x = leftside and 80 or 0,
			y = 0,
			orientation='vertical',
			centerItems = false,
			width = 200,
			padding = {0,0,0,0},
			itemPadding = {1,0,0,0},
			itemMargin = {0,0,0,0},
			resizeItems=false,
			children = children_main,
		}
		
		ttWindows[ ttName ] = Window:New{
			name = ttName,
			useDList = false,
			resizable = false,
			draggable = false,
			autosize  = true,
			padding = { 7, 7, 5, 5 },
			backgroundColor = color.tooltip_bg, 
			children = { 
				stack_leftbar_temp,
				stack_main_temp,
			}
		}
	end
	
	SetTooltip( ttWindows[ ttName ] )
end

----------------------------------------------------------------------------------------------------
local function GetUnitMapIcon( ud )
	if ( not ud ) or ( not icontypes ) then 
		return false 
	end
	
	local icon = icontypes[ ud.iconType or "default" ]
	
	return icon and icon.bitmap or 'icons/' .. ud.iconType .. iconFormat
end

----------------------------------------------------------------------------------------------------
local function MakeToolTip_Text(text)
	BuildTooltip2( 'tt_text', {
		main = {
			{ name = 'text', text = text, wrap = true },
		}
	} )
end
----------------------------------------------------------------------------------------------------
local function UpdateBuildpic( ud, globalitem_name )
	if not ud then 
		return 
	end
	
	local item = globalItems[ globalitem_name ]
	if not item then
		globalItems[ globalitem_name ] = Image:New{
			file = "#" .. ud.id,
			file2 = WG.GetBuildIconFrame and WG.GetBuildIconFrame( ud ),
			keepAspect = false,
			height  = 55*(4/5),
			width   = 55,
		}
		return
	end
	
	item.file = "#" .. ud.id
	item.file2 = WG.GetBuildIconFrame and WG.GetBuildIconFrame( ud )
	item:Invalidate()
end

----------------------------------------------------------------------------------------------------
local function GetExtraInfo( info )
	local extraInfo = ''
	
	local energyProduce = info.totalEnergyOut or 0
	if energyProduce > 1 then
		if info.windGenerator > 0 then
			extraInfo = extraInfo ..
				"\nProduces ammunition " .. green .. string_format( "%d - %d", Game.windMin, Game.windMax ) .. white
		elseif info.tidalGenerator > 0 then
			extraInfo = extraInfo ..
				"\nProduces ammunition " .. green .. formatThousands( Game.tidal ) .. white
		else
			extraInfo = extraInfo ..
				"\nProduces ammunition " .. green .. formatThousands( energyProduce ) .. white
		end
	elseif energyProduce < -1 then
		extraInfo = extraInfo ..
			"\nConsumes ammunition " .. red .. formatThousands( energyProduce ) .. white
	end
	
	if info.makesMetal > 0 then
		extraInfo = extraInfo ..
			"\nProduces command " .. green ..  string_format( "%.1f", info.makesMetal ) .. white
	end
	if info.extractsMetal > 0 then
		extraInfo = extraInfo ..
			"\nExtracts command depends on command source"
	end
	
	if info.metalStorage > 1 then
		extraInfo = extraInfo ..
			"\nProvides command storage " .. green .. formatThousands( info.metalStorage ) .. white
	end
	
	if info.energyStorage > 1 then
		extraInfo = extraInfo ..
			"\nProvides ammunition storage " .. green .. formatThousands( info.energyStorage ) .. white
	end
	
	if info.canCloak then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Can cloak"
	end
	
	if info.canKamikaze then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Kamikaze"
	end
	
	if info.stealth then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Radar stealth"
	end
	
	if info.radarRadius > 0 then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Radar"
	end
	
	if info.jammerRadius > 0 then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Radar jammer"
	end
	
	if info.sonarStealth then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Sonar stealth"
	end
	
	if info.sonarRadius > 0 then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Sonar"
	end
	
	if info.sonarJamRadius > 0 then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Sonar jammer"
	end
	
	if info.transportCapacity > 0 then
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Transport capacity " .. info.transportCapacity ..
			"\n" .. cyan .. "Transport size " .. info.transportSize
	end
	
	if (info.customParams ~= nil) and (info.customParams.storage_unit_custom_resource1 ~= nil) then -- hotfix storage_unit_custom_resource1, it can be any resource :)
		extraInfo = extraInfo ..
			"\n" .. cyan .. "Max fuel: " .. info.customParams.storage_unit_custom_resource1
	end
	
	return extraInfo
end

----------------------------------------------------------------------------------------------------
local function MakeToolTip_UD( buildTable )
	
	local info = UnitDefs[ buildTable.unitDefId ]
	if not info then
		return
	end
	
	local buildType = buildTable.isUnitBuilder and "buildunit" or "building"
	local morphData
	
	local helpText = GetHelpText( buildType )
	local iconPath = GetUnitMapIcon( info )
	
	-- extract unit definition from standard Spring unit tooltip. If tooltip non standard.
	-- extracting not work, so will be showed custom tooltip
	local tooltip = buildTable.text:match( 'Build:.+%-%s(.*)\nHealth' )

	if not tooltip then
		tooltip = buildTable.text
	end
	
	tooltip = tooltip .. "\n" .. GetExtraInfo( info )
	
	local unitStatsIconPrefix = ":a:" .. SS44_UI_DIRNAME .. "images/unitStats/"
	
	local buildPic = morphData 
		and { name= 'bp', directcontrol = 'buildpic_morph' } 
		or  { name= 'bp', directcontrol = 'buildpic_ud' }
		
	local morphStatus = morphData 
		and { name='morph', directcontrol = 'morphs' } 
		or  { }
	
	local rangeText = ( info.maxWeaponRange > 0 ) and formatThousands( info.maxWeaponRange ) or ""
	local speedText = ( info.speed > 0 ) and string_format( "%i", info.speed ) or ""
		
	local ttStructure = {
		leftBar = {
			buildPic,
			{ name = 'metalCost',  icon = SS44_UI_DIRNAME .. 'images/resources/metal.png',  text = metalTextColor  .. formatThousands( info.metalCost  ), },
			{ name = 'energyCost', icon = SS44_UI_DIRNAME .. 'images/resources/energy.png', text = energyTextColor .. formatThousands( info.energyCost ), },
			{ name = 'buildCost',  icon = SS44_UI_DIRNAME .. 'images/unitStats/build.png',  text = GetBuildTime( info ), },
		},
		main = {
			{ name = 'udname',	icon = iconPath, text = info.humanName, fontSize = 2 },
			{ name = 'tt',		text = tooltip, wrap = true },
			{ row = {
				{ icon = unitStatsIconPrefix .. 'dps.png' },	{ name = "dps", text = CalculateDPS( info ) },
				{ icon = unitStatsIconPrefix .. 'range.png' },	{ name = "range", text = rangeText },
			} },
			{ row = {
				{ icon = unitStatsIconPrefix .. 'speed.png' },  { name = "speed", text = speedText },
				{ icon = unitStatsIconPrefix .. 'health.png' }, { name = "health", text = formatThousands( info.health ), },
			} },
			--[[
			{ name = 'requires', text = ttTable.requires and ('REQUIRES' .. ttTable.requires) or '', },
			{ name = 'provides', text = ttTable.provides and ('PROVIDES' .. ttTable.provides) or '', },
			{ name = 'consumes', text = ttTable.consumes and ('CONSUMES' .. ttTable.consumes) or '', },
			--]]
			morphStatus,
			{ name='helpText', text = green .. helpText, wrap=true }
		},
	}
	
	if morphData then
		UpdateBuildpic( info, 'buildpic_morph' )
		UpdateMorphControl( morphData )
		
		BuildTooltip2( 'morph', ttStructure )
	else
		UpdateBuildpic( info, 'buildpic_ud' )
		BuildTooltip2( 'ud', ttStructure )
	end
	
end

----------------------------------------------------------------------------------------------------
local function MakeToolTip_Unit( data, tooltip )
	local unitID = data

	tt_unitID = unitID
	tt_ud = UnitDefs[ spGetUnitDefID( tt_unitID ) or -1]
		
	if not tt_ud then
		--fixme
		return false
	end
	
	--local alliance       = spGetUnitAllyTeam(tt_unitID)
	local team			= spGetUnitTeam( tt_unitID )
	local _, player		= spGetTeamInfo(team)
	local playerName	= player and spGetPlayerInfo( player ) or ''
	local teamColor		= NotAchili.color2incolor( spGetTeamColor( team ) )
	---local unittooltip	= tt_unitID and spGetUnitTooltip(tt_unitID) or (tt_ud and tt_ud.tooltip) or ""
	local unittooltip	= GetUnitDesc( tt_unitID, tt_ud )
	local iconPath		= GetUnitMapIcon( tt_ud )
	
	UpdateResourceStack( 'unit', unitID, tt_ud, tooltip, ttFontSize )
	
	local fullname = ( tt_ud and tt_ud.humanName ) or ''
	local ttStructure = {
		leftBar = {
			{ name= 'bp', directcontrol = 'buildpic_unit' },
			--{ name= 'cost', icon = 'LuaUI/images/resources/metal.png', text = cyan .. numformat((tt_ud and tt_ud.metalCost) or '0') },
		},
		main = {
			{ name='uname', icon = iconPath, text = fullname, fontSize = 2, },
			{ name='player_name', text = teamColor .. playerName, fontSize = 2, },
			{ name='utt', text = unittooltip, wrap=true },
			{ name='hp', directcontrol = 'hp_unit', },
			{ name='res', directcontrol = 'resources_unit' },
			{ name='help', text = green .. 'Space+click: Show unit stats', },
		},
	}
	
	UpdateBuildpic( tt_ud, 'buildpic_unit' )
	BuildTooltip2( 'unit', ttStructure )
end

----------------------------------------------------------------------------------------------------
local function MakeToolTip_Selection( data )
	
end

----------------------------------------------------------------------------------------------------
local function MakeToolTip_Feature(data, tooltip)
	local featureID = data
	local tt_fd
	local team, fullname
	
	tt_fid = featureID
	team = spGetFeatureTeam(featureID)
	local fdid = spGetFeatureDefID(featureID)
	tt_fd = fdid and FeatureDefs[fdid or -1]
	local feature_name = tt_fd and tt_fd.name

	local live_name
	if tt_fd and tt_fd.customParams and tt_fd.customParams.unit then
		live_name = tt_fd.customParams.unit
	else
		live_name = feature_name:gsub('([^_]*).*', '%1')
	end
	
	local desc = ''
	if feature_name:find('dead2') or feature_name:find('heap') then
		desc = ' (debris)'
	elseif feature_name:find('dead') then
		desc = ' (wreckage)'
	end
	tt_ud = UnitDefNames[live_name]
	
	fullname = ((tt_ud and tt_ud.humanName .. desc) or tt_fd.tooltip or "")
	
	if not (tt_fd) then
		--fixme
		return false
	end
	
	if options.hide_for_unreclaimable.value and not tt_fd.reclaimable then
		return false
	end
	
	--local alliance       = spGetUnitAllyTeam(tt_unitID)
	local _, player		= spGetTeamInfo(team)
	local playerName	= player and spGetPlayerInfo(player) or 'noname'
	local teamColor		= NotAchili.color2incolor(spGetTeamColor(team))
	---local unittooltip	= tt_unitID and spGetUnitTooltip(tt_unitID) or (tt_ud and tt_ud.tooltip) or ""
	local unittooltip	= GetUnitDesc(tt_unitID, tt_ud)
	local iconPath		= GetUnitMapIcon(tt_ud)
	
	UpdateResourceStack( tt_ud and 'corpse' or 'feature', featureID, tt_ud or tt_fd, tooltip, ttFontSize )
	
	local ttStructure = {
		leftBar =
			tt_ud and
			{
				{ name= 'bp', directcontrol = 'buildpic_feature' },
				{ name='cost', icon = SS44_UI_DIRNAME .. 'images/resources/metal.png', text = cyan .. numformat((tt_ud and tt_ud.metalCost) or '0'), },
			}
			or nil,
		main = {
			{ name='uname', icon = iconPath, text = fullname .. ' (' .. teamColor .. playerName .. white ..')', fontSize=2, },
			{ name='utt', text = unittooltip, wrap=true },
			(	options.featurehp.value
					and { name='hp', directcontrol = (tt_ud and 'hp_corpse' or 'hp_feature'), } 
					or {}),
			{ name='res', directcontrol = tt_ud and 'resources_corpse' or 'resources_feature' },
			{ name='help', text = green .. 'Space+click: Show details', },
		},
	}
	
	
	if tt_ud then
		UpdateBuildpic( tt_ud, 'buildpic_feature' )
		BuildTooltip2('corpse', ttStructure)
	else
		BuildTooltip2('feature', ttStructure)
	end
	return true
end


----------------------------------------------------------------------------------------------------
local function CreateHpBar( name )
	globalItems[ name ] = StackPanel:New{
		name = name,
		width = '100%', height = icon_size + 2,
		padding = { 0, 0, 0, 0 },
		itemMargin = { 5, 0, 0, 0 },
		centerItems = false,
		autoArrangeV = true,
		orientation='horizontal',
		resizeItems=false,
		width = '100%',
		autosize=true,
		children = {
			Image:New{
				file = SS44_UI_DIRNAME .. 'images/unitstats/health.png',
				x = 0, width = icon_size,
				y = 0, height = icon_size,
			},
			Progressbar:New {
				width = 160, height = icon_size,
				--padding = {0,0,0,0},
				color = {0,1,0,1},
				max = 1,
				caption = '',
			},
		}
	}
end

----------------------------------------------------------------------------------------------------
local function MakeMapDrawingToolTip()
	local ttStructure = {
		main = {
			{ name='lmb', 		icon = SS44_UI_DIRNAME .. 'images/drawingCursors/pencil.png', 	text = 'Left Mouse Button', },
			{ name='rmb', 		icon = SS44_UI_DIRNAME .. 'images/drawingCursors/eraser.png', 	text = 'Right Mouse Button', },
			{ name='mmb', 		icon = SS44_UI_DIRNAME .. 'images/drawingCursors/flag.png', 		text = 'Middle Mouse Button', },
			{ name='dblclick', 	icon = SS44_UI_DIRNAME .. 'images/drawingCursors/flagtext.png', 	text = 'Double Click', },
		},
	}
	BuildTooltip2('drawing', ttStructure)
end

local function IsEmpty( text )
	return ( text == '' ) or text:gsub( ' ','' ):len() <= 0
end

----------------------------------------------------------------------------------------------------
-- TOOLTIP BUILDER
----------------------------------------------------------------------------------------------------
local function MakeTooltip()

	local isMapDrawing = options.showdrawtooltip.value 
		and tildePressed 
		and not( drawing or erasing )
	
	if isMapDrawing then
		MakeMapDrawingToolTip()
		return
	end
	
	local currentTooltipData = screen0.currentTooltip or spGetCurrentTooltip()
	local dataType, data = spTraceScreenRay( mx, my )

	local noChanged = ( not changeNow ) 
		and currentTooltipData ~= '' 
		and oldTooltipData == currentTooltipData 
		and oldPointedData == data
		
	if noChanged then
		PlaceToolTipWindow2( mx + 20, my - 20 )
		return
	end
	
	oldPointedData = data
	oldTooltipData = currentTooltipData
	
	tt_unitID = nil
	tt_ud = nil

	-- notAchili control tooltip	
	if screen0.currentTooltip then
		local isCustomTooltip = type( screen0.currentTooltip ) == "table"
		if isCustomTooltip then
			if currentTooltipData.build then
				MakeToolTip_UD( currentTooltipData )
				return
			elseif currentTooltipData.selection then
				--MakeToolTip_Unit( currentTooltipData )
				KillTooltip()
				return
			end
			
			KillTooltip()
		else
			if IsEmpty( currentTooltipData ) then
				KillTooltip()
			else
				MakeToolTip_Text( currentTooltipData )
			end
		end
		
		return
	end
	
	-- standard spring tooltip or non notAchili widgets tooltip
	local ttTable = ParseTooltip( currentTooltipData )	
	
	local tooltip, unitDef = ttTable.tooltip, ttTable.unitDef
	if not tooltip then
		KillTooltip()
		return
	end
	
	-- unit tooltip
	--[[
	if unitDef then
		tt_ud = unitDef
		MakeToolTip_UD( ttTable )
		return
	end
	--]]
	
	-- empty tooltip
	if IsEmpty( tooltip ) then
		KillTooltip()
		return
	end	
	
	--unit(s) selected/pointed at 
	local isUnitOrFeature = 
		tooltip:find('Experience %d+.%d+ Cost ')--shows on your units, not enemy's
	--	or tooltip:find('TechLevel %d')			--shows on units
		or tooltip:find('Metal.*Energy')		--shows on features
	
	--unit(s) selected/pointed at
	if isUnitOrFeature then
		-- pointing at unit/feature
		if dataType == 'unit' and showExtendedTip then
			MakeToolTip_Unit( data, tooltip )
			return
			
		elseif dataType == 'feature' and showExtendedTip then -- shows tooltip feature only when meta pressed
			if MakeToolTip_Feature( data, tooltip ) then
				return
			end
		end
	
		--holding meta or static tip
		--[[
		if showExtendedTip then
			MakeToolTip_Text( tooltip )
		else
			KillTooltip()
		end
		--]]
		
		KillTooltip()
		return
	end
	
	-- default tooltip
	-- or tooltip that shows position
	local pos_tooltip = tooltip:sub( 1, 4 ) == 'Pos '
	if not pos_tooltip or showExtendedTip then
		MakeToolTip_Text( tooltip )
		return
	end
	
	KillTooltip()	
end --function MakeTooltip


----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLLINS                                        --
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function widget:Initialize()
	if not WG.NotAchili then
		widgetHandler:RemoveWidget( widget )
		return
	end
	
	local VFSMODE = VFS.RAW_FIRST
	_, iconFormat = VFS.Include( SS44_UI_DIRNAME .. "config/tip_conf.lua" , nil, VFSMODE )
	local confdata = VFS.Include( SS44_UI_DIRNAME .. "config/epicmenu_conf.lua", nil, VFSMODE )
	color = confdata.color

	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button = NotAchili.Button
	Label = NotAchili.Label
	Window = NotAchili.Window
	Panel = NotAchili.Panel
	StackPanel = NotAchili.StackPanel
	Grid = NotAchili.Grid
	TextBox = NotAchili.TextBox
	Image = NotAchili.Image
	Multiprogressbar = NotAchili.Multiprogressbar
	Progressbar = NotAchili.Progressbar
	screen0 = NotAchili.Screen0

	widget:ViewResize( Spring.GetViewGeometry() )

	CreateHpBar( 'hp_unit' )
	CreateHpBar( 'hp_feature' )
	CreateHpBar( 'hp_corpse' )
	
	stack_main = StackPanel:New{
		width=300, -- needed for initial tooltip
	}
	
	stack_leftbar = StackPanel:New{
		width=10, -- needed for initial tooltip
	}

	window_tooltip2 = Window:New{
		--skinName = 'default',
		useDList = false,
		resizable = false,
		draggable = false,
		autosize  = true,
		backgroundColor = color.tooltip_bg, 
		children = { stack_leftbar, stack_main, }
	}


	FontChanged()
	spSendCommands( { "tooltip 0" } )

end

----------------------------------------------------------------------------------------------------
function widget:Shutdown()
	spSendCommands( { "tooltip 1" } )
	if window_tooltip2 then
		window_tooltip2:Dispose()
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local timer = 0
local updateInterval = 0.3 -- in seconds

function widget:Update(dt)
	
	timer = timer + dt
	
	old_mx, old_my = mx,my
	mx, my = spGetMouseState()
	local mousemoved = mx ~= old_mx or my ~= old_my
	local show_cursortip = true
	alt,_,meta,_ = spGetModKeyState()
	
	local consoleWidget = WG.SS44_UI and WG.SS44_UI.consoleWidget
	local inputText = consoleWidget	and consoleWidget.inputText

	if meta and ( not inputText ) then
		if not showExtendedTip then 
			changeNow = true 
		end
		showExtendedTip = true
	
	else
		if options.tooltip_delay.value > 0 then
			if not mousemoved then
				stillCursorTime = stillCursorTime + dt
			else
				stillCursorTime = 0 
			end
			show_cursortip = stillCursorTime > options.tooltip_delay.value
		end
		
		if showExtendedTip then 
			changeNow = true 
		end
		showExtendedTip = false
	end

	if mousemoved or changeNow then
		if show_cursortip then
			MakeTooltip()
			changeNow = false
		else
			KillTooltip()
			return
		end
	end
	
	SetHealthbar()
	
	if timer > updateInterval then
		timer = 0
		changeNow = true
	end
	
end

----------------------------------------------------------------------------------------------------
function widget:ViewResize(vsx, vsy)
	scrW = vsx
	scrH = vsy
end

----------------------------------------------------------------------------------------------------
function widget:KeyPress(key, modifier, isRepeat)
	if key == KEYSYMS.BACKQUOTE then
		if not tildePressed then
			changeNow = true
		end	
		tildePressed = true
	end
end
function widget:KeyRelease(key)
	if key == KEYSYMS.BACKQUOTE then
		if tildePressed then
			changeNow = true
		end
		tildePressed = false
	end
end

----------------------------------------------------------------------------------------------------
function widget:DrawScreen()
	if not tildePressed then
		return
	end

	local x, y, lmb, mmb, rmb = spGetMouseState()
	drawing = lmb
	erasing = rmb
	
	local filefound
	if drawing then
		filefound = glTexture( SS44_UI_DIRNAME .. 'images/drawingCursors/pencil.png' )
	elseif erasing then
		filefound = glTexture( SS44_UI_DIRNAME .. 'images/drawingCursors/eraser.png' )
	end
	
	if filefound then
		--do teamcolor?
		--glColor(0,1,1,1) 
		if drawing or erasing then
			Spring.SetMouseCursor( 'none' )
		end
		glTexRect(x, y-cursor_size, x+cursor_size, y)
		glTexture(false)
		--glColor(1,1,1,1)
	end
end
