----------------------------------------------------------------------------------------------------
--                                       UNIT CONTROL TOOLS                                       --
--                          Helper functions to build unit commands menu                          --
----------------------------------------------------------------------------------------------------

local SpGetSelectedUnitsCount = Spring.GetSelectedUnitsCount

local table_sort = table.sort

----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local CMD_SCATTER		= 33658
local ORDER_COMMANDS_LIST = {
	[CMD.MOVE] = true,
	[CMD.FIGHT] = true,
	[CMD.PATROL] = true,
	[CMD.ATTACK] = true,
	[CMD.GUARD] = true,
	[CMD.STOP]  = true,
	[CMD.WAIT]  = true,
	[CMD_SCATTER] = true
}

local HIDDEN_COMMANDS_LIST = {
	[76] = true,	--load units clone
	[65] = true,	--selfd
	[9] = true,		--gatherwait
	[8] = true,		--squadwait
	[7] = true,		--deathwait
	[6] = true,		--timewait
	--[CMD.REPAIR] = true,	--repair
}

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local commandsById = {}

local orderCommands = {} -- attack, stop, move, patrol
local buildCommands = {} -- build units
local stateCommands = {} -- repeat on/off, on/off, trajectory low/high, production 25/50/75/100, etc
local otherCommands = {} -- stockpile, load, unload, etc

local currentCommands = {}

local function CompareByCommandId( lhs, rhs ) end
local function CompareByBuildCommandId( lhs, rhs ) end

----------------------------------------------------------------------------------------------------
--                                         Implementation                                         --
----------------------------------------------------------------------------------------------------
local function RefreshCommands( commands )
	
	local orderCommandsCount = 0
	orderCommands = {}
	local buildCommandsCount = 0
	buildCommands = {}
	local stateCommandsCount = 0
	stateCommands = {}
	local otherCommandsCount = 0
	otherCommands = {}
	
	-- hide 'scatter' command if only one unit selected
	HIDDEN_COMMANDS_LIST[ CMD_SCATTER ] = ( SpGetSelectedUnitsCount() == 1 )
	
	for index = 1, #commands do
		local cmd = commands[ index ]
		
		local isHidden = ( cmd.action == nil ) -- ??
				or ( cmd.type == 18 ) -- previous cmd page
				or ( cmd.type == 17 ) -- next cmd page
				or ( cmd.type == 21 ) -- page button
				or ( HIDDEN_COMMANDS_LIST[ cmd.id ] )
				or cmd.hidden
		
		if not isHidden then
			if(	cmd.id < 0 ) then --build building
				buildCommandsCount = buildCommandsCount + 1
				buildCommands[ buildCommandsCount ] = cmd
				
			elseif( cmd.type == 5 and #cmd.params > 1 ) then
				--Spring.Echo( "toggle cmd:" .. cmd.name )
				stateCommandsCount = stateCommandsCount + 1
				stateCommands[ stateCommandsCount ] = cmd
				
			elseif( ORDER_COMMANDS_LIST[ cmd.id ] ) then
				orderCommandsCount = orderCommandsCount + 1
				orderCommands[ orderCommandsCount ] = cmd
				
			else
				--Spring.Echo( "other cmd:" .. cmd.name )
				otherCommandsCount = otherCommandsCount + 1
				otherCommands[ otherCommandsCount ] = cmd
			end
		end
	end
	
	table_sort( orderCommands, CompareByCommandId )
	--table_sort( buildCommands, CompareByBuildCommandId )
	table_sort( stateCommands, CompareByCommandId )
	table_sort( otherCommands, CompareByCommandId )
	
	currentCommands.orders = orderCommands
	currentCommands.builds = buildCommands
	currentCommands.states = stateCommands
	currentCommands.others = otherCommands
end

function CompareByCommandId( lhs, rhs )
	return lhs.id < rhs.id;
end

function CompareByBuildCommandId( lhs, rhs )
	return lhs.id > rhs.id;
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
UNIT_CONTROL_TOOLS = {
	currentCommands	= currentCommands,
	RefreshCommands	= RefreshCommands
}
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------