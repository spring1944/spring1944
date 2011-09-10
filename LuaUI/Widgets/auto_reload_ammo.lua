--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--auto_reload_ammo_v1.5.lua 08.09.11

function widget:GetInfo()
  return {
    name      = "1944 Auto Reload Ammo",
    desc      = "Does what it says on the tin",
    author    = "James. Thanks go to: FLOZi, Godde, Google Frog, Quantum and Seagull",
    version   = "v1.5",
    date      = "Sep 2011",
    license   = "Public Domain",
    layer     = 9999,
    enabled   = true                        --loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--change log

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
local DiffTimers                = Spring.DiffTimers
local GetTimer                  = Spring.GetTimer
local Echo                      = Spring.Echo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--globals

local teamID            = GetMyTeamID()

local CMD_STOP          = CMD.STOP
local CMD_MOVE          = CMD.MOVE
local CMD_FIGHT         = CMD.FIGHT

local ammoUsingUnit     = {}
local supplyUnit        = {}

local delay             = 60

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--functions

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
    for unit, v in pairs(ammoUsingUnit) do                      
        --keep checking our ammo levels
        local ammoLevel = GetUnitRulesParam(v.uID, "ammo")                
        local temp
        local currentUnitSeparation 
        local targetSupplyUnit              
        local dist = 9999999999       
        local x, z 
        
        -----STATE MACHINE-----------------------------------------------------
        if (v.unitSupplyState == v.UNIT_BRAND_NEW) then              
            --timer 
            local now = GetTimer()                    
            --unit is brand new so let it get out the door before we start changing states   
            if ((DiffTimers(now, v.timer)) >= delay) then                    
                if (ammoLevel < v.maxAmmo) then                        
                    v.unitSupplyState   = v.UNIT_EMPTY              
                elseif (ammoLevel == v.maxAmmo) then
                    v.unitSupplyState   = v.UNIT_BACK_AT_POS                              
                end                             
            end            
        --ammo !!!
        elseif (v.unitSupplyState == v.UNIT_EMPTY) then                    
            --Echo("In EMPTY", v.uID)
            --save our location, we might need it later
            v.cx, _, v.cz = GetUnitPosition(v.uID)
            --save unit command queue, if it has one, so we can return to the queue after reload
            v.cmds = GetUnitCommands(v.uID)       
            --we need more ammo so change state to UNIT_RESUPPLY_NEEDED
            v.unitSupplyState = v.UNIT_RESUPPLY_NEEDED      
        --lets get back for resupply    
        elseif (v.unitSupplyState == v.UNIT_RESUPPLY_NEEDED) then
            --Echo("In RESUPPLY_NEEDED", v.uID)
            --sanity check - are we already in a supply area so don't need to move?
            if (ammoLevel > 0) then  
                v.unitSupplyState = v.UNIT_RELOADING 
            --get location of closest supply unit to our position and move to it 
            else                    
                --loop through each supply unit, checking each one         
                for sup, s in pairs(supplyUnit) do 
                    local vx, _, vz = GetUnitVelocity(s.uID)
                    --we don't really want any supply units that are moving
                    if ((vx == 0) and (vz == 0)) then            
                        --get the distance to supply unit
                        temp = GetUnitSeparation(v.uID, s.uID, true)                        
                        --work out the distance to the edge of the supply area
                        temp = temp - s.supplyArea 
                        --find the closest
                        if (temp < dist) then
                            dist = temp
                            x, _, z = GetUnitPosition(s.uID)
                            targetSupplyUnit = s
                        end                 
                    end                 
                end            
                --save this
                v.closestSupply = targetSupplyUnit 
                --move to the supply      
                GiveOrderToUnit(v.uID, CMD_MOVE, {x,_,z}, {""})          
                v.unitSupplyState = v.UNIT_RETURNING_TO_SUPPLY  
            end
        --on our way        
        elseif (v.unitSupplyState == v.UNIT_RETURNING_TO_SUPPLY) then
            --Echo("In RETURNING_TO_SUPPLY", v.uID)
            --keep checking our position relative to the supply unit that we're moving to
            currentUnitSeparation = GetUnitSeparation(v.uID, v.closestSupply.uID, true)
            --we must be in a supply area now coz our ammo is going up so STOP and change state
            if ((ammoLevel > 0) and (currentUnitSeparation < v.closestSupply.supplyArea)) then
                GiveOrderToUnit(v.uID, CMD_STOP, {_,_,_}, {""}) 
                v.unitSupplyState = v.UNIT_RELOADING
            end        
        elseif (v.unitSupplyState == v.UNIT_RELOADING) then 
            --Echo("In RELOADING", v.uID)
            --could get moved and have to fight before we're fully loaded, before 
            --we get a chance to change to UNIT_FULL state, so catch that   
            if (ammoLevel < 1) then            
                v.unitSupplyState = v.UNIT_EMPTY                
            end
            --looks like we're weapons hot
            if (ammoLevel == v.maxAmmo) then
                v.unitSupplyState = v.UNIT_FULL                
            end 
        --ready !!!    
        elseif (v.unitSupplyState == v.UNIT_FULL) then
            --Echo("In FULL", v.uID)
            if (v.cmds.n == 0) then
                --as there's no cmd queue use CMD_FIGHT to get back to our original position
                GiveOrderToUnit(v.uID, CMD_FIGHT, {v.cx ,_, v.cz}, {""}) 
            else                 
                --now that we're reloaded we can finish our command queue            
                for i = 1, v.cmds.n do  
                    local cmd = v.cmds[i]
                    GiveOrderToUnit(v.uID, cmd.id, cmd.params, cmd.options.coded)
                end
            end                        
            v.unitSupplyState = v.UNIT_BACK_AT_POS
        --at your target in front, go on  
        elseif (v.unitSupplyState == v.UNIT_BACK_AT_POS) then 
            --Echo("In BACK_AT_POS", v.uID)
            --empty magazine?
            if (ammoLevel < 1) then
                --good shoot'n tex
                v.unitSupplyState = v.UNIT_EMPTY
            end 
        end      
    end  
end

-------------------------------------------------------------------------------
function widget:UnitCreated(unitID, unitDefID, unitTeam) 
    if (AreTeamsAllied(teamID, unitTeam)) then
	    local ud = UnitDefs[unitDefID]        
        --define some extra attributes for each unit created 
        if ((ud ~= nil) and (tonumber(ud.customParams.weaponswithammo)) and (unitTeam == teamID)) then
        
	        ammoUsingUnit[unitID] = {
	            uID                         = unitID,	
	            cmds                        = nil,
	            closestSupply               = nil,            
	            maxAmmo                     = tonumber(ud.customParams.maxammo),	            
	            timer                       = GetTimer(),
	            cx                          = 0, 
	            cz                          = 0,
	            --unit states
	            UNIT_BACK_AT_POS            = 6,
	            UNIT_RELOADING              = 5,
	            UNIT_RETURNING_TO_SUPPLY    = 4,              
	            UNIT_RESUPPLY_NEEDED        = 3,
	            UNIT_FULL                   = 2,
	            UNIT_EMPTY                  = 1,
	            UNIT_BRAND_NEW              = 0,
	
	            unitSupplyState             = 0 
	        }  
	        
        elseif ((ud ~= nil) and (tonumber(ud.customParams.ammosupplier))) then 
         
            supplyUnit[unitID] = {
                uID                         = unitID,
                supplyArea                  = tonumber(ud.customParams.supplyrange)
	         }
        end  
          
    elseif (ammoUsingUnit[unitID]) then
        ammoUsingUnit[unitID] = nil 
    elseif (supplyUnit[unitID]) then  
        supplyUnit[unitID] = nil 
    end
end

-------------------------------------------------------------------------------
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

-------------------------------------------------------------------------------
function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
    if (ammoUsingUnit[unitID]) then
        ammoUsingUnit[unitID] = nil       
    elseif (supplyUnit[unitID]) then  
        supplyUnit[unitID] = nil 
    end
end

-------------------------------------------------------------------------------