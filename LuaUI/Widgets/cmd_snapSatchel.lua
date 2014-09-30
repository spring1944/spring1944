function widget:GetInfo()
  return {
    name      = "Snap Satchel to building",
    desc      = "Help satchels usability by snapping them to closest place when hovering over building",
    author    = "ashdnazg",
    date      = "29 Sep 2014",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


--Unsynced Read
local GetActiveCommand       = Spring.GetActiveCommand
local GetMouseState          = Spring.GetMouseState
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local TraceScreenRay         = Spring.TraceScreenRay
local WarpMouse              = Spring.WarpMouse
local WorldToScreenCoords    = Spring.WorldToScreenCoords

--Unsynceed Ctrl
local GiveOrder        = Spring.GiveOrder
local GiveOrderToUnit  = Spring.GiveOrderToUnit 
local SetActiveCommand = Spring.SetActiveCommand

--Synced Read
local GetUnitBuildFacing = Spring.GetUnitBuildFacing
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitPosition    = Spring.GetUnitPosition
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local TestBuildOrder     = Spring.TestBuildOrder

--misc
local min = math.min
local max = math.max
local push = table.insert

--Constants
local BLOCKED = 0
local OPEN = 2

--variables
local satchelIDs = {} -- [-satchelID] = {unitDefIDs that can build it}
local buildingID
local satchelID
local satchelx, satchelz
local xmin, zmin, xmax, zmax, buildingy
local openSpots

local function GetNextCW(x, z)
	local nextx, nextz
	if x == xmin then
		nextz = max(z - satchelz, zmin)
	elseif x == xmax then
		nextz = min(z + satchelz, zmax)
	else
		nextz = z
	end
	if z == zmin then
		nextx = min(x + satchelx, xmax)
	elseif z == zmax then
		nextx = max(x - satchelx, xmin)
	else
		nextx = x
	end
	return nextx, nextz
end

local function GetNextCCW(x, z)
	local nextx, nextz
	if x == xmin then
		nextz = min(z + satchelz, zmax)
	elseif x == xmax then
		nextz = max(z - satchelz, zmin)
	else
		nextz = z
	end
	if z == zmin then
		nextx = max(x - satchelx, xmin)
	elseif z == zmax then
		nextx = min(x + satchelx, xmax)
	else
		nextx = x
	end
	return nextx, nextz
end


function widget:MousePress(mx, my, button)
	local cmdID, cmdDescID, cmdDescType, cmdDescName = GetActiveCommand()
	if cmdDescID and satchelIDs[cmdDescID] and button == 1 then
		local what, unitID = TraceScreenRay(mx, my, false)
		if what == "unit" then
			local _, coords = TraceScreenRay(mx, my, true)
			local blocking = TestBuildOrder(-cmdDescID, coords[1], coords[2], coords[3], 0)
			if blocking == BLOCKED then
				local unitDefID = GetUnitDefID(unitID)
				local unitDef = UnitDefs[unitDefID]		
				if unitDef.isBuilding then
					buildingID = unitID
					local ux, uy, uz = GetUnitPosition(unitID)
					buildingy = uy
					satchelID = -cmdDescID
					local facing = GetUnitBuildFacing(unitID)
					local xsize = unitDef.xsize * 4
					local zsize = unitDef.zsize * 4
					
					if facing == 0 then
						xmin, xmax = ux - xsize, ux + xsize
						zmin, zmax = uz - zsize, uz + zsize
					elseif facing == 1 then
						xmin, xmax = ux - zsize, ux + zsize
						zmin, zmax = uz - xsize, uz + xsize
					elseif facing == 2 then
						xmin, xmax = ux - xsize, ux + xsize
						zmin, zmax = uz - zsize, uz + zsize
					else
						xmin, xmax = ux - zsize, ux + zsize
						zmin, zmax = uz - xsize, uz + xsize
					end
					
					local satchelDef = UnitDefs[satchelID]
					satchelx = satchelDef.xsize * 4
					satchelz = satchelDef.zsize * 4
					xmin = xmin - satchelx
					zmin = zmin - satchelz
					return true
				end
			end
		end
	end
	return false
end

local function SendToClosestSpot(unitID)
	local ux, uy, uz = GetUnitPosition(unitID)
	local cwtargetx, cwtargetz, ccwtargetx, ccwtargetz
	if ux < xmin then
		cwtargetx = xmin
	elseif ux > xmax then
		cwtargetx = xmax
	else
		cwtargetx = ux - ux % satchelx
	end
	
	if uz < zmin then
		cwtargetz = zmin
	elseif uz > zmax then
		cwtargetz = zmax
	else
		cwtargetz = uz - uz % satchelz
	end
	
	ccwtargetx, ccwtargetz = cwtargetx, cwtargetz
	
	repeat
		local blocking = TestBuildOrder(satchelID, cwtargetx, buildingy, cwtargetz, 0)
		if blocking == OPEN then
			GiveOrderToUnit(unitID, -satchelID, {cwtargetx, buildingy, cwtargetz}, {})
			return
		end
		ccwtargetx, ccwtargetz = GetNextCCW(ccwtargetx, ccwtargetz)
		blocking = TestBuildOrder(satchelID, ccwtargetx, buildingy, ccwtargetz, 0)
		if blocking == OPEN then
			GiveOrderToUnit(unitID, -satchelID, {ccwtargetx, buildingy, ccwtargetz}, {})
			return
		end
		cwtargetx, cwtargetz = GetNextCW(cwtargetx, cwtargetz)
	until ccwtargetx == cwtargetx and ccwtargetz == cwtargetz
end


function widget:MouseRelease(mx, my, button)
	local what, target = TraceScreenRay(mx, my, false)
	if what == "unit" and target == buildingID then
		local selected = GetSelectedUnitsSorted()
		for _, unitDefID in pairs(satchelIDs[-satchelID]) do
			local units = selected[unitDefID]
			if units then
				for _, unitID in pairs(units) do
					SendToClosestSpot(unitID)
				end
			end
		end
	elseif what == "ground" then
		GiveOrder(-satchelID, target, {})
	end
	buildingID = nil
	satchelID = nil
	SetActiveCommand(0)
end


function widget:Initialize()
	totaldx = 0
	totaldy = 0
	for unitDefID, unitDef in pairs (UnitDefs) do
		if unitDef.customParams and unitDef.customParams.candetonate then
			satchelIDs[-unitDefID] = {}
		end
	end
	for unitDefID, unitDef in pairs (UnitDefs) do
		if unitDef.buildOptions then
			for _, id in pairs(unitDef.buildOptions) do
				if satchelIDs[-id] then
					push(satchelIDs[-id], unitDefID)
				end
			end
		end
	end
end