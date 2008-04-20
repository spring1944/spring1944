--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Ammo Limiter",
    desc      = "Gives each unit a personal 'ammo' storage that it draws from to fire, when empty it fires much more slowly",
    author    = "quantum",
    date      = "Feb 01, 2007",
    license   = "CC attribution-noncommerical 3.0 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
	
  if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------


--[[
a note on the customParams (custom FBI tags) used by this script:

maxammo=the total ammo capacity of this unit;
ammosupplier=boolean; //is this a ammo supplying unit?
supplyrange=x; //how far this supply unit can supply (at this distance ammoRegen is default)
lowAmmoLevel=x; the level when this unit displays some kind of "low ammo" graphic. example would be lowammolevel=5 for the panther.
weaponcost= the cost to reload the weaopns with ammo per tick.
weaponswithammo; // Number of weapons that use ammo. Must be the first ones. Default is 2.

------
TODO:
implement trucks and halftracks and such somehow
visuals (low ammo graphic, supply range graphic, ect)
make more customizable/flexible (custom params for ammoPenalty, multi-weapon support, 
]]--

--and here we go
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local SetUnitWeaponState = Spring.SetUnitWeaponState
local GetUnitWeaponState = Spring.GetUnitWeaponState
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitPosition    = Spring.GetUnitPosition
local GetUnitSeparation  = Spring.GetUnitSeparation
local GetUnitDefID       = Spring.GetUnitDefID


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local vehicles      = {}
local ammoSuppliers = {}
local savedFrames 	= {}

--what reload time is multiplied by when the unit runs out of ammo
local ammoPenalty = 1.5 --not used anymore


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AmmoRegen(defaultRegen, supplyRange, nearestDepotDistance)
  local regen = ((0-1)*(defaultRegen/supplyRange)*nearestDepotDistance + (2*defaultRegen))
  if (regen >= 0) then
  return regen
  else 
  return 0
  end
end


local function DefaultRegen(unitDefID)
  local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
  local reload = WeaponDefs[weaponID].reload
  return reload
end


local function CheckReload(unitID, reloadFrame, weaponNum)
  local oldReloadFrame
  if (vehicles[unitID].reloadFrame) then
    oldReloadFrame = vehicles[unitID].reloadFrame[weaponNum]
  end
  if (oldReloadFrame == reloadFrame or
      not reloadFrame)              then
    return false
  else
    vehicles[unitID].reloadFrame[weaponNum] = reloadFrame
    return true
  end
end

local function CalcReload(ammoLevel, lowAmmoLevel, newReload, defaultReload)
	newReload = ((((0-1)*lowAmmoLevel)/defaultReload)*ammoLevel+(2*defaultReload))
	print("lowAmmoLevel:", lowAmmoLevel)
	print("defaultReload:", defaultReload)
	print("ammoLevel:", ammoLevel)
	print("newReload:", newReload)
	return newReload
end
	
local function ProcessWeapon(unitID, weaponNum)
  local unitDefID = GetUnitDefID(unitID)
  local _, _, reloadFrame = GetUnitWeaponState(unitID, weaponNum)
  local ammoLevel = tonumber(vehicles[unitID].ammoLevel)
  local lowAmmoLevel = tonumber(UnitDefs[unitDefID].customParams.lowammolevel)
  local weaponID = UnitDefs[unitDefID].weapons[weaponNum+1].weaponDef
  local reload = WeaponDefs[weaponID].reload
  if (CheckReload(unitID, reloadFrame, weaponNum)) then
    print("fire!", weaponNum, reloadFrame)
		if (ammoLevel == 1) then
			savedFrames[unitID] = reloadFrame
			SetUnitWeaponState(unitID, weaponNum, {reloadtime = 99999})
		end
    if (ammoLevel > 0) then
      vehicles[unitID].ammoLevel = ammoLevel - 1
    end
    print("ammo", vehicles[unitID].ammoLevel)
  end	
  if (ammoLevel < lowAmmoLevel) and (ammoLevel > 1) then
	local defaultReload = reload
	local newReload = reload
		--CalcReload(ammoLevel, lowAmmoLevel, newReload, defaultReload)
    SetUnitWeaponState(unitID, weaponNum, {reloadtime = newReload, reloadstate = reloadFrame + (32*newReload)})
    vehicles[unitID].conserveAmmo = true
  end
  if (ammoLevel > lowAmmoLevel) then
		if (reloadFrame > 0 and savedFrames[unitID]) then
			SetUnitWeaponState(unitID, weaponNum, {reloadtime = reload, reloadstate = savedFrames[unitID] + (32*reload)})
		end
    vehicles[unitID].conserveAmmo = nil
  end
end


local function FindSupplier(vehicleID)
  local closestSupplier
  local closestDistance = math.huge
  
  for supplierID in pairs(ammoSuppliers) do
    local separation  = GetUnitSeparation(vehicleID, supplierID, true)
    if (separation < closestDistance) then
      closestSupplier = supplierID
      closestDistance = separation
    end
  end
  
  return closestSupplier, closestDistance
end


local function Resupply(unitID)
  local unitDefID = GetUnitDefID(unitID)
  local supplierID, distanceFromSupplier = FindSupplier(unitID)
   if (supplierID) then
    local teamID = Spring.GetUnitTeam(supplierID)
    local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
	if (logisticsLevel < 50) then
	 return
	end
    --print("logisticsLevel", logisticsLevel)
   end
  --print("supplierID", supplierID, "distanceFromSupplier", distanceFromSupplier)
  if (not supplierID) then
    return
  end
  local supplierDefID = GetUnitDefID(supplierID)
  local weaponCost = tonumber(UnitDefs[unitDefID].customParams.weaponcost)
  local supplyRange = tonumber(UnitDefs[supplierDefID].customParams.supplyrange)
  if (supplyRange < distanceFromSupplier) then
    return
  end
  local maxAmmo = tonumber(UnitDefs[unitDefID].customParams.maxammo)
  local defaultRegen = DefaultRegen(unitDefID)
  local ammoRegen = defaultRegen --AmmoRegen(defaultRegen, supplyRange, distanceFromSupplier)
  local oldAmmo = vehicles[unitID].ammoLevel
  
  
  local newAmmo = oldAmmo + ammoRegen
  if (newAmmo > maxAmmo) then
    newAmmo = maxAmmo
  end
  print("Resupply ammo", oldAmmo, newAmmo)
  if (newAmmo < maxAmmo) then
  Spring.UseUnitResource(supplierID, "e", weaponCost)
  end
  vehicles[unitID].ammoLevel = newAmmo
  
end
    
    
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local ud = UnitDefs[unitDefID]
  if (ud.customParams.maxammo)               then
  --  print("add vehicle", ud.customParams.maxammo)
    vehicles[unitID] = {
      ammoLevel = ud.customParams.maxammo,
      reloadFrame = {},
    }
    for weaponNum=0, ud.customParams.weaponswithammo do
      vehicles[unitID].reloadFrame[weaponNum] = 0
    end
  end
  if (ud.customParams.ammosupplier == '1') then
    --print"add ammo supplier"
    ammoSuppliers[unitID] = true
  end
end


function gadget:UnitDestroyed(unitID) -- you can omit unneeded arguments if they
  vehicles[unitID] = nil              -- are at the end
  ammoSuppliers[unitID] = nil
end


function gadget:GameFrame(n)
   if (n % (3*30) < 0.1) then
  
  --for supplierID in pairs(ammoSuppliers) do
 --  local supplierDefID = GetUnitDefID(supplierID)
  -- local supplyRange = UnitDefs[supplierDefID].customParams.supplyrange
   --SendToUnsynced("supplyinfo", supplierID, supplyRange)
 -- end
    for unitID in pairs(vehicles) do
	  local unitDefID = GetUnitDefID(unitID)
	  local ammoLevel = vehicles[unitID].ammoLevel
	  local lowAmmoLevel = tonumber(UnitDefs[unitDefID].customParams.lowammolevel)
	  --local maxAmmo = UnitDefs[unitDefID].customParams.maxAmmo
	
    
      local weaponsWithAmmo = UnitDefs[unitDefID].customParams.weaponswithammo or 2
      for weaponNum=0, weaponsWithAmmo-1 do
        ProcessWeapon(unitID, weaponNum)
      end
      Resupply(unitID)
      SendToUnsynced("ammo", unitID, ammoLevel, lowAmmoLevel)
    end
    

  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
else
--	UNSYNCED?
---------------------------------------------------------------------------------
local WhiteStr   = "\255\255\255\255"
local RedStr     = "\255\255\001\001"


local fontSize = 20

local units = {}
local suppliers = {}
local remove = {}

local function Rounding (Num)
  	local Num2 = Num
	while Num2 >= 1 do
	    Num2 = Num2 - 1
  	end
  	if Num2 <= 0.4 and Num2 > 0 then
    	return math.floor (Num)
  	elseif Num2 >= 0.5 and Num2 < 1 then
    	return math.ceil (Num)
  	elseif Num2 == 0 then
    	return Num
	end
end

function gadget:DrawScreen(dt)
  local readTeam
  local spec, specFullView = Spring.GetSpectatingState()

    if (specFullView) then
    readTeam = Script.ALL_ACCESS_TEAM
    else
    readTeam = Spring.GetLocalTeamID()
    end
  CallAsTeam({ ['read'] = readTeam }, function()
    local n = Spring.GetGameFrame()
    for unitID, ammoLevel in pairs(units) do
	--local ammoLevel = units[unitID].ammoLevel
	--local lowAmmoLevel = units[unitID].lowAmmoLevel
        -- if (not Spring.GetUnitViewPosition(unitID)) then
          -- break
        -- end

	  if (ammoLevel ~= -1) then
        ammoLevel = Rounding(ammoLevel)
        local wx, wy, wz = Spring.GetUnitPosition(unitID)
        if (not wx) then
           remove[unitID] = true
           break
	    end
        local sx, sy, sz = Spring.WorldToScreenCoords(wx, wy, wz)
       if (ammoLevel ~= nil) then
		  if (ammoLevel <= 5) then
           gl.Text(RedStr..ammoLevel, sx, sy, 20, "c")
           elseif (ammoLevel > 5) then
           gl.Text(WhiteStr..ammoLevel, sx, sy, 10, "c")
           --else
          -- gl.Text(WhiteStr.."x", sx, sy, 10, "c")
		  end
        end
      end
	

    --[[ for supplierID, supplyRange in pairs(suppliers) do
	   local teamID=Spring.GetUnitTeam(supplierID)
       --local r,g,b,_=Spring.GetTeamColor(teamID)
	   local x,y,z=Spring.GetUnitBasePosition(supplierID)
	   print(x,y,z)
	   --local a = (((0-1)*supplyRange) + 1)
	   if (supplyRange ~= nil) then	 
	   gl.Color(0,0,1,1)
	   gl.DrawGroundCircle(x,y,z,supplyRange, 20)
	   gl.Color(0,0,1,1)
	   end
	 end]]--
	end
 end
 )
 
  for unitID in pairs(remove) do
    units[unitID] = nil
  end
 end


  function RecvFromSynced(...)
    if (arg[2] == "ammo") then
	 units[arg[3]] = tonumber(arg[4])
	 --units[arg[3]].lowAmmoLevel = tonumber(arg[5])
    end
	--if (arg[2] == "supplyinfo") then
    -- suppliers[arg[3]] = tonumber(arg[4]) 
	--end	
  end
	
end 
