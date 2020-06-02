--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--auto_reload_ammo_v1.8.lua 20.09.11

function widget:GetInfo()
  return {
    name      = "1944 Auto Reload Ammo",
    desc      = "Does what it says on the tin",
    author    = "James. Thanks go to: FLOZi, Godde, Google Frog, Quantum and Seagull",
    version   = "v1.8",
    date      = "Sep 2011",
    license   = "Public Domain",
    layer     = 9999,
    enabled   = false                        --loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--change log

--20.09.11 Added Incoming() function which turns armoured units to face and engage the enemy if they come under fire
--         Added some simple error checking

--17.09.11 Improved unit AI in UNIT_SOPS and UNIT_RELOADING, now handles a supply that moves off as we're reloading
--         Made some minor efficiency improvements - added customParams.armour so artillery isn't processed
--         Made some minor efficiency improvements - added customParams.armour so artillery isn't processed
--         Added FindClosestSupply() to UNIT_RETURNING_TO_SUPPLY in case the supply unit moves off as we're travelling to it 

--12.09.11 Replaced timer and delay test in UNIT_BRAND_NEW
--         Added FindClosestSupply() function
--         Added UNIT_SOPS to handle orders given while returning for resupply

--09.09.11 Added closestSupply to ammoUsingUnit instead of using a separate array for storing supply range etc. Thanks Seagull. :) 

--08.09.11 Now supports returning a unit, after reload, to finish it's command queue if it has one

--08.09.11 Added Spring.AreTeamsAllied instead of Spring.GetLocalAllyTeamID and the callin Initialize() - Thanks Seagull. :)
--         Made some minor efficiency changes in the "elseif (v.unitSupplyState == v.UNIT_RESUPPLY_NEEDED) then" block

--07.09.11 Now supports going to an ally for reload if the ally is closest

--05.09.11 Using customParams.weaponswithammo amd customParams.ammosupplier instead of an array - Thanks Floz :)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--speedups

local GetMyTeamID               = Spring.GetMyTeamID
local GetUnitTeam               = Spring.GetUnitTeam
local AreTeamsAllied            = Spring.AreTeamsAllied
local GetUnitDefID              = Spring.GetUnitDefID
local GetUnitPosition           = Spring.GetUnitPosition
local GetUnitSeparation         = Spring.GetUnitSeparation
local GetUnitVelocity           = Spring.GetUnitVelocity 
local GetAllUnits               = Spring.GetAllUnits
local GetUnitRulesParam         = Spring.GetUnitRulesParam
local GiveOrderToUnit           = Spring.GiveOrderToUnit
local GetUnitCommands           = Spring.GetUnitCommands
local GetUnitLastAttacker       = Spring.GetUnitLastAttacker 
local GetUnitHealth				= Spring.GetUnitHealth
local GetTeamRulesParam			= Spring.GetTeamRulesParam

local Echo                      = Spring.Echo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--globals

local teamID            = GetMyTeamID()

local CMD_STOP          = CMD.STOP
local CMD_MOVE          = CMD.MOVE
local CMD_FIGHT         = CMD.FIGHT
local CMD_TURN          = 35521

local ammoUsingUnit     = {}
local supplyUnit        = {}

local teamSupplyRangeModifierParamName = 'supply_range_modifier'
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--functions
local function GetSupplyRangeModifier(teamID)
	return 1 + (GetTeamRulesParam(teamID, teamSupplyRangeModifierParamName) or 0)
end

function widget:Initialize()
    --if this widget is loaded mid game we need to initialize pre-existing units
    for i, unitID in ipairs(GetAllUnits()) do    
        widget:UnitCreated(unitID, GetUnitDefID(unitID), GetUnitTeam(unitID))        
    end    
end

--------------------------------------------------------------------------------
function widget:GameFrame(n) 
    if (n%50<1) then   
	    checkAmmo()	
    end  
end

-------------------------------------------------------------------------------
function checkAmmo() 
	local rangeModifier = GetSupplyRangeModifier(teamID)
    for unit, v in pairs(ammoUsingUnit) do                      
        --keep checking our ammo levels
        local ammoLevel = GetUnitRulesParam(v.uID, "ammo")
        local commands
        
        -----STATE MACHINE-----------------------------------------------------
        if (v.unitSupplyState == v.UNIT_BRAND_NEW) then
            --Echo("in UNIT_BRAND_NEW", v.uID)
            v.cmds = GetUnitCommands(v.uID, -1)
            if ((v.cmds ~= nil) and (ammoLevel ~= nil)) then
			    local _,_,_,_,buildProgress = GetUnitHealth(v.uID)
				-- nothing to do until we're finished building
				if buildProgress < 1 then
					v.unitSupplyState   = v.UNIT_BRAND_NEW
				else
					if (#v.cmds < 1) then
						v.unitSupplyState   = v.UNIT_READY 
						--there's a chance we could leave the factory empty 
					elseif (ammoLevel < 1) then 
						v.unitSupplyState = v.UNIT_EMPTY        
					end
				end
            end
        --ammo !!!
        elseif (v.unitSupplyState == v.UNIT_EMPTY) then
            --Echo("in UNIT_EMPTY", v.uID)
			-- check if we're really empty, because we might have gotten some supply since last check
			if ammoLevel < 1 then
				--save our location, we might need it later
				v.unit_cx, _, v.unit_cz = GetUnitPosition(v.uID)
				--save unit command queue, if it has one, so we can return to the queue after reload
				v.cmds = GetUnitCommands(v.uID, -1) 
				if ((v.cmds ~= nil) and (v.unit_cx ~= nil) and (v.unit_cz ~= nil)) then  
					--we need more ammo so change state to UNIT_RESUPPLY_NEEDED
					v.unitSupplyState = v.UNIT_RESUPPLY_NEEDED      
				end
			else
				v.unitSupplyState = v.UNIT_READY
			end
        --lets get back for resupply    
        elseif (v.unitSupplyState == v.UNIT_RESUPPLY_NEEDED) then
            --Echo("in UNIT_RESUPPLY_NEEDED", v.uID)
            FindClosestSupply(v)   
        --on our way        
        elseif (v.unitSupplyState == v.UNIT_RETURNING_TO_SUPPLY) then
            --Echo("in UNIT_RETURNING_TO_SUPPLY", v.uID) 
            --while in the process of returning for resupply we could be ordered to do something else so keep checking
            --the order queue then get back for resupply   
            commands = GetUnitCommands(v.uID, 0)
            if (commands ~= nil) then  
                if (commands >=2) then            
                    v.unitSupplyState = v.UNIT_SOPS            
                else                
                    --keep checking our position relative to the supply unit that we're moving to
                    local currentUnitSeparation = GetUnitSeparation(v.uID, v.closestSupply.uID, true)
                    if ((currentUnitSeparation ~= nil) and (ammoLevel ~= nil)) then
                        --its possible the supply unit may have been destroyed or moved off so keep checking
                        FindClosestSupply(v)
                        if (currentUnitSeparation < v.closestSupply.supplyArea * rangeModifier) then
                            GiveOrderToUnit(v.uID, CMD_STOP, {_,_,_}, {""})                    
                            if ((ammoLevel > 0) and (currentUnitSeparation < v.closestSupply.supplyArea * rangeModifier)) then
                                v.inSupplyArea = true
                                v.gate = v.open
                                v.unitSupplyState = v.UNIT_RELOADING
                            end
                        end 
                    end
                end 
            end
        --we may get ordered to do something else as we're returning for resupply so handle that         
        elseif (v.unitSupplyState == v.UNIT_SOPS) then
            --Echo("in UNIT_SOPS", v.uID)
            --we've been ordered to do something else so over write and save the command queue     
            v.cmds = GetUnitCommands(v.uID, -1)
            if ((v.cmds ~= nil) and (ammoLevel ~= nil)) then 
                --when we've finished our order queue we can return for resupply
                if ((#v.cmds <= 1) and (ammoLevel < 3)) then
                    --save our location so we can return after resupply
                    v.unit_cx, _, v.unit_cz = GetUnitPosition(v.uID)
                    FindClosestSupply(v)
                --there's been a stand-to so we need to move with an emergency load out    
                elseif (ammoLevel >= 3) then
                    v.unitSupplyState = v.UNIT_READY  
                end 
            end
        --reload            
        elseif (v.unitSupplyState == v.UNIT_RELOADING) then
            --Echo("in UNIT_RELOADING", v.uID)
            --are we under attack?
            commands = GetUnitCommands(v.uID, 1)
            local attacker = GetUnitLastAttacker(v.uID)
            if ((attacker ~= nil) and (commands[1] ~= nil)) then
                local cmds = commands[1]
                if (cmds.id ~= CMD_MOVE) then 
                    Incoming(v.uID)
                else
                    v.unitSupplyState = v.UNIT_READY
                end              
            end
            --create a constant while we're in UNIT_RELOADING state
            if (v.gate == v.open) then
                --save our location only once
                v.unit_inSupply_cx, _, v.unit_inSupply_cz = GetUnitPosition(v.uID)
                v.gate = v.closed  
            end   
            --again its possible that either we or the supply unit could be ordered to move during reload
            currentUnitSeparation = GetUnitSeparation(v.uID, v.closestSupply.uID, true)
            if (currentUnitSeparation ~= nil) then
                if (currentUnitSeparation > v.closestSupply.supplyArea * rangeModifier) then
                    v.inSupplyArea = false
                    local ux, _, uz = GetUnitPosition(v.uID)
                    if ((ux ~= nil) and (uz ~= nil) and (v.unit_inSupply_cx ~= nil) and (v.unit_inSupply_cz ~= nil)) then
                        --find out which one of us has moved off and change state accordingly  
                        if ((v.unit_inSupply_cx == ux) and (v.unit_inSupply_cz == uz)) then
                            v.unitSupplyState = v.UNIT_RESUPPLY_NEEDED
                        else
                            v.unitSupplyState = v.UNIT_SOPS
                        end 
                    end                        
                end
            end  
            if (ammoLevel ~= nil) then     
                --looks like we're weapons hot
                if (ammoLevel == v.maxAmmo) then
                    v.unitSupplyState = v.UNIT_FULL                
                end 
            end           
        --ready !!!    
        elseif (v.unitSupplyState == v.UNIT_FULL) then
            --Echo("in UNIT_FULL", v.uID) 
            if ((#v.cmds ~= nil) and (v.unit_cx ~= nil) and (v.unit_cz ~= nil)) then           
                if (#v.cmds <= 2) then                            
                    --use CMD_FIGHT to get back to our original position
                    GiveOrderToUnit(v.uID, CMD_FIGHT, {v.unit_cx, _, v.unit_cz}, {""})           
                else               
                    --now that we're reloaded we can finish our command queue            
                    for i = 1, #v.cmds do  
                        local cmd = v.cmds[i]
                        GiveOrderToUnit(v.uID, cmd.id, cmd.params, cmd.options.coded)
                    end
                end 
            end                     
            v.unitSupplyState = v.UNIT_READY
        --at your target in front, go on  
        elseif (v.unitSupplyState == v.UNIT_READY) then
            --Echo("in UNIT_READY", v.uID) 
            --are we under attack? 
            commands = GetUnitCommands(v.uID, 1)
            local attacker = GetUnitLastAttacker(v.uID)
            if ((attacker ~= nil) and (commands[1] ~= nil)) then
                local cmds = commands[1]
                if (cmds.id ~= CMD_MOVE) then 
                    Incoming(v.uID)
                else
                    v.unitSupplyState = v.UNIT_READY
                end               
            end
            if (ammoLevel ~= nil) then
                --looks like we're out
                if (ammoLevel < 1) then
                    --good shoot'n tex
                    v.unitSupplyState = v.UNIT_EMPTY 
                end 
            end          
        end     
    end  
end
-------------------------------------------------------------------------------
function Incoming(uID)
    --turn and face our last armoured attacker 
    local lastAttacker = GetUnitLastAttacker(uID)
    local udid = GetUnitDefID(lastAttacker)
    local ud = UnitDefs[udid]
    if (lastAttacker == nil) then
        return 
    elseif (ud.customParams.armour) then
        --Echo("in else CMD_TURN", uID)
        local ex, _, ez  = GetUnitPosition(lastAttacker)
        if ((ex ~= nil) and (ez ~= nil)) then
            --turn and face our foe      
            GiveOrderToUnit(uID, CMD_TURN, {ex, _, ez}, {""})
        end
    end
end

-------------------------------------------------------------------------------
function FindClosestSupply(v)
    local dist = 9999999999
    local targetSupplyUnit
    local x, z
	local rangeModifier = GetSupplyRangeModifier(teamID)
    --loop through each supply unit, checking each one to find the closest        
    for sup, s in pairs(supplyUnit) do 
        local vx, _, vz = GetUnitVelocity(s.uID)
        if ((vx ~= nil) and (vz ~= nil)) then
            --we don't really want any supply units that are moving
            if ((vx == 0) and (vz == 0)) then            
                --get the distance to supply unit
                local temp = GetUnitSeparation(v.uID, s.uID, true) 
                if (temp ~= nil) then                       
                    --work out the distance to the edge of the supply area
                    temp = temp - s.supplyArea * rangeModifier
                end
                --find the closest
                if (temp < dist) then
                    dist = temp
                    x, _, z = GetUnitPosition(s.uID)
                    targetSupplyUnit = s
                end                 
            end 
        end                
    end 
    --save these
    v.closestSupply = targetSupplyUnit
	-- what if we didn't find any supply sources?
	if v.closestSupply == nil then
		return
	end

	-- what if we're already in supply radius?
	if dist < 0 then
		return
	end
    --get separation between unit and supply
    local currentUnitSeparation = GetUnitSeparation(v.uID, v.closestSupply.uID, true)

    -- hack: there's a bug where units drive all the way to the supplier and
    -- freeze there. I couldn't determine the cause of that, but this ought to
    -- prevent that from happening as often
    local offset = math.random(-3, 3) * 50
    if offset == 0 then
        offset = 100
    end

    if ((currentUnitSeparation ~= nil) and (x ~= nil)  and (z ~= nil)) then
        --are we already in a supply area so don't need to move?
        if (currentUnitSeparation < v.closestSupply.supplyArea * rangeModifier) then
            v.inSupplyArea = true
            v.unitSupplyState = v.UNIT_RELOADING
        else
            v.inSupplyArea = false
            --move to the supply      
            GiveOrderToUnit(v.uID, CMD_MOVE, {x + offset,_,z + offset}, {""})          
            v.unitSupplyState = v.UNIT_RETURNING_TO_SUPPLY 
        end 
    end         
end

function RemoveUnitFromLists(unitID)
	if (ammoUsingUnit[unitID]) then
		ammoUsingUnit[unitID] = nil
	end
	if (supplyUnit[unitID]) then
		supplyUnit[unitID] = nil
	end
end

-------------------------------------------------------------------------------
function widget:UnitCreated(unitID, unitDefID, unitTeam) 
    if (AreTeamsAllied(teamID, unitTeam)) then
	    local ud = UnitDefs[unitDefID] 
        --define some extra attributes for each armoured unit created and let mortars auto reload too
        if (((ud ~= nil) and (tonumber(ud.customParams.weaponswithammo)) and (unitTeam == teamID)
            and (ud.customParams.armour)) or ((ud ~= nil) and (ud.iconType == "mortar"))) then
            --Echo("Unit created", unitID)
	        ammoUsingUnit[unitID] = {
	            uID                         = unitID,	
	            cmds                        = nil,
	            closestSupply               = nil,            
	            maxAmmo                     = tonumber(ud.customParams.maxammo),	            
	            unit_cx                     = 0, 
	            unit_cz                     = 0,
	            unit_inSupply_cx            = 0,
	            unit_inSupply_cz            = 0,
	            gate                        = true,
	            open                        = true,
	            closed                      = false,
	            inSupplyArea                = true,
	            --unit states
	            UNIT_SOPS                   = 7,
	            UNIT_READY                  = 6,
	            UNIT_RELOADING              = 5,
	            UNIT_RETURNING_TO_SUPPLY    = 4,              
	            UNIT_RESUPPLY_NEEDED        = 3,
	            UNIT_FULL                   = 2,
	            UNIT_EMPTY                  = 1,
	            UNIT_BRAND_NEW              = 0,
	
	            unitSupplyState             = 0 
	        }  
	        
        elseif ((ud ~= nil) and (tonumber(ud.customParams.supplyrange))) then 
         
            supplyUnit[unitID] = {
                uID                         = unitID,
                supplyArea                  = tonumber(ud.customParams.supplyrange)
	        }
        end  
    else
		RemoveUnitFromLists(unitID)
    end
end

-------------------------------------------------------------------------------
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

-------------------------------------------------------------------------------
function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	RemoveUnitFromLists(unitID)
end

-------------------------------------------------------------------------------
