--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:GetInfo()
  return {
    name      = "Detection radius",
    desc      = "Gives every unit a distance from enemy units at which they become visible. ",
    author    = "B. Tyler",
    date      = "July 20th, 2009",
    license   = "LGPL v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  COMMON

if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()

if (modOptions.detectionradius == 1) then

--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
local GetUnitVelocity		=	Spring.GetUnitVelocity
local GetUnitNearestEnemy	=	Spring.GetUnitNearestEnemy

local SetUnitSensorRadius	=	Spring.SetUnitSensorRadius
local SetUnitAlwaysVisible	=	Spring.SetUnitAlwaysVisible

local sneaky			=	{}
local sneakyStill		=	100
local sneakyMoving		=	250

local infantry			= 	{}
local infantryStill		=	400
local infantryMoving		=	800

local vehicles			=	{}
local vehicleStill		=	500	
local vehicleMoving		=	1500

local tanks			=	{}
local tankStill			=	600
local tankMoving		=	2500

local buildings			=	{} --also small boats
local buildingRadius		=	2000

local planes			=	{}
local boats			=	{}

--------------------------------------------------------------------------------
function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	SetUnitSensorRadius(unitID, "los", 1)
	SetUnitSensorRadius(unitID, "airLos", 1)
	local ud = UnitDefs[unitDefID]
	local uc = ud.modCategories
	local find = table.find
	
	if find(uc, "INFANTRY") ~= nil then
		if ud.decloakDistance ~= nil then
			sneaky[unitID] = true
		else
			infantry[unitID] = true
		end
	end
	if (find(uc, "OPENVEH") ~= nil) or (find(unitCategories, "SOFTVEH" ~= nil)) then
		vehicles[unitID] = true
	end
	
	if find(uc, "HARDVEH") ~= nil then
		tanks[unitID] = true
	end
	
	if find(uc, "AIR") ~= nil then
		planes[unitID] = true
	end
	
	if (find(uc, "BUILDING") ~= nil) or (find(uc, "DEPLOYED") ~= nil) then
		buildings[unitID] = true
	end
	
	if find(uc, "SHIP") ~= nil then
		boats[unitID] = true
	end
end

function gadget:GameFrame(n)
	if n % (1*30) < 0.1 then
		for unitID, someThing in pairs(sneaky) do
			local x, y, z = GetUnitVelocity(unitID)
			if x > 0 or y > 0 or z > 0 then --unit is moving
				local visibleMoving = GetUnitNearestEnemy(unitID, sneakyMoving, 0)
				if visibleMoving == nil then
					SetUnitAlwaysVisible(unitID, false)
				else
					SetUnitAlwaysVisible(unitID, true)
				end
			else
				local visibleStill = GetUnitNearestEnemy(unitID, sneakyStill, 0)
				if visibleStill == nil then
					SetUnitAlwaysVisible(unitID, false)
				else
					SetUnitAlwaysVisible(unitID, true)
				end
			end
		end
			
	end
end


else
--  UNSYNCED
--------------------------------------------------------------------------------
end
end
end
