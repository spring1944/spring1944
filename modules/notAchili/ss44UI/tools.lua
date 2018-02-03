----------------------------------------------------------------------------------------------------
--                                             TOOLS                                              --
--                    Helper functions, that can be used in different modules                     --
----------------------------------------------------------------------------------------------------

local math_floor = math.floor
local string_format = string.format

----------------------------------------------------------------------------------------------------
local CheckBounds = function( value, minValue, maxValue )
	return ( value < minValue ) and minValue or 
			( ( value > maxValue ) and maxValue or value )
end

----------------------------------------------------------------------------------------------------
function CalculateDPS( info )
	local weapons = info.weapons
	
	if #weapons == 0 then
		return "-"
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
	
	return string_format( "%i", totalDps )
end

----------------------------------------------------------------------------------------------------
local function GetShortNumber( n )	
	if( n < 10000 ) then
		return string_format( "%.1f", n )
	elseif( n < 1000000 ) then
		return string_format( "%.1fk", n / 1000 )
	else
		return string_format( "%.1fm", n / 1000000 )
	end
end

----------------------------------------------------------------------------------------------------
-- function GetTimeString() taken from trepan's clock widget
local function GetTimeString()
	local secs = math.floor(Spring.GetGameSeconds())
	if (timeSecs ~= secs) then
		timeSecs = secs
		local h = math.floor(secs / 3600)
		local m = math.floor((secs % 3600) / 60)
		local s = math.floor(secs % 60)
		if h > 0 then
			timeString = string.format( '%02i:%02i:%02i', h, m, s )
		else
			timeString = string.format( '%02i:%02i', m, s )
		end
	end
	return timeString
end

----------------------------------------------------------------------------------------------------
local function BoolToInt( bool )
	return bool and 1 or 0
end

----------------------------------------------------------------------------------------------------
local function IntToBool( int )
	return int ~= 0
end

----------------------------------------------------------------------------------------------------
--May not be needed with new notAchili functionality
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
end

----------------------------------------------------------------------------------------------------
local function SplitStringToArray( div, str )
	if div == '' then
		return false
	end

	local pos, result = 0, {}
	
	local function FindDivider()
		return string.find( str, div, pos, true )
	end
	
	-- for each divider found
	for st, sp in FindDivider do
		-- Attach chars left of current divider
		result[ #result + 1 ] = string.sub( str, pos, st - 1 )
		-- Jump past current divider
		pos = sp + 1
	end

	-- Attach chars right of last divider
	table.insert( result, string.sub( str, pos ) )

	return result
end

----------------------------------------------------------------------------------------------------
local function DeepCopyArray( dst, src )
	for i,v in pairs( src ) do 
		if type( v ) == 'table' then
			if type( dst[ i ] ) ~= 'table' then
				dst[ i ] = {}
			end
			-- Attention: cycle available
			DeepCopyArray( dst[ i ], v )
		else
			dst[ i ] = v
		end
	end
end

----------------------------------------------------------------------------------------------------
local function SetColorTransparency( color, transparency )
	color[ 4 ] = transparency
end

----------------------------------------------------------------------------------------------------
local iconType = ".tga"
local iconByNameCache = {}

local function GetUnitIconByHumanName( name )
	local icon = iconByNameCache[ name ]
	if icon then
		return icon
	end
	
	icon = "default"
	
	for _, unitDef in pairs( UnitDefs ) do
		if unitDef.humanName == name then
			icon = unitDef.iconType
			break
		end
	end

	icon = "icons/" .. icon .. iconType
	
	if not VFS.FileExists( icon ) then
		icon = "LuaUI/Widgets/notAchili/ss44UI/images/console/warning.png"
	end
	
	iconByNameCache[ name ] = icon
	
	return icon
end

----------------------------------------------------------------------------------------------------
local iconSideCache = {}
local function GetSideIconByName( side )
	local icon = iconSideCache[ side ]
	if icon then
		return icon
	end
	
	icon = "LuaUI/Widgets/notAchili/ss44UI/images/console/" .. side .. ".png"
	if not VFS.FileExists( icon ) then
		icon = "LuaUI/Widgets/notAchili/ss44UI/images/console/player.png"
	end
	
	iconSideCache[ side ] = icon
	
	return icon
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
TOOLS = {
	CheckBounds				= CheckBounds,
	GetShortNumber			= GetShortNumber,
	CalculateDPS			= CalculateDPS,
	
	GetTimeString			= GetTimeString,
	BoolToInt				= BoolToInt,
	IntToBool				= IntToBool,
	AdjustWindow			= AdjustWindow,
	
	SplitStringToArray		= SplitStringToArray,
	DeepCopyArray			= DeepCopyArray,
	
	SetColorTransparency	= SetColorTransparency,
	
	GetUnitIconByHumanName	= GetUnitIconByHumanName,
	GetSideIconByName		= GetSideIconByName,
}
----------------------------------------------------------------------------------------------------