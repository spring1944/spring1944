function gadget:GetInfo()
  return {
    name      = "Unstucker",
    desc      = "Attempts to unstuck stuck units",
    author    = "yuritch",
    date      = "1 May 2014",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = false  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local spAllUnits = Spring.GetAllUnits
local spUnitDead = Spring.GetUnitIsDead
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitStunned = Spring.GetUnitIsStunned
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitCommands = Spring.GetUnitCommands
local spGetUnitTransporter = Spring.GetUnitTransporter
local spGetUnitCOBVar = Spring.GetCOBUnitVar
local spTestMoveOrder = Spring.TestMoveOrder
local spGetGroundHeight = Spring.GetGroundHeight
local spSetUnitPosition = Spring.SetUnitPosition
local spEcho = Spring.Echo

local CMD_MOVE = CMD.MOVE
local COB_MAX_SPEED = COB.MAX_SPEED

-- all units which are potentially stuck have their positions stored here
local unitPositions = {}

-- units confirmed as stuck
local stuckUnits = {}

-- how often to do check, in frames
local FRAMES_PER_CHECK = 8

-- skip runs if no stuck units are found (map is very flat, etc.)
local frameSkip = 0
local skipCounter = 0

local function RemoveUnit(unitID)
	unitPositions[unitID] = nil
	stuckUnits[unitID] = nil
end

local function ProcessUnit(unitID)
	-- unit should be able to move (non-zero speed), should be completed and not paralyzed nor transported
	local includeUnit = true
	local stunned_or_inbuild, _, _ = spGetUnitStunned(unitID)

	if stunned_or_inbuild then
		includeUnit = false
	end

	if includeUnit then
		-- can this thing move at all?
		local ud = UnitDefs[spGetUnitDefID(unitID)]
		-- also exclude non-ground units
		if not (ud.canMove and ud.speed > 0) or not ud.IsGroundUnit then
			includeUnit = false
		end
	end

	if includeUnit then
		local posX, posY, posZ = spGetUnitPosition(unitID)
		if unitPositions[unitID] then
			includeUnit = false
			tmpPos = unitPositions[unitID]
			if (tmpPos.x ~= posX) or (tmpPos.z ~= posZ) then
				-- this unit is NOT stuck, it moves
				tmpPos.x = posX
				tmpPos.y = posY
				tmpPos.z = posZ
			else
				-- is it in a transport?
				if not spGetUnitTransporter(unitID) then
					-- does it have any move related orders?
					local commands = spGetUnitCommands(unitID, 1)
					-- we really only need first command
					if commands and #commands > 0 then
						local tmpCommand = commands[1]
						if tmpCommand then
							-- is this a move command?
							if tmpCommand.id == CMD_MOVE then
								-- this unit IS stuck: it has a move command, it has non-zero speed, but has not moved since last check
								stuckUnits[unitID] = true
								includeUnit = true
							end
						end
					end
				end
			end
		else
			tmpPos = {x = posX, y = posY, z = posZ}
			unitPositions[unitID] = tmpPos
		end
	end
	
	if not includeUnit then
		RemoveUnit(unitID)
	end
end

local function AttemptUnstuck()
	-- attempt to unstuck one unit from the stuck list
	for unitID, _ in pairs(stuckUnits) do
		--spEcho("Unstucking unit "..unitID)
		-- the position should still be in positions list, no need to get it again
		local position = unitPositions[unitID] or spGetUnitPosition(unitID)
		local uDefID = spGetUnitDefID(unitID)
		local ud = UnitDefs[uDefID]
		local moveDist = 64
		-- attempt nearby positions
		local dx, dz
		local x, y, z
		local unstuck = false
		for mult = 1, 4, 1 do
			for dx = -1, 1, 1 do
				for dz = -1, 1, 1 do
					if (dx ~= 0) and (dz ~= 0) then
						x = position.x + dx * moveDist * mult
						z = position.z + dz * moveDist * mult
						y = spGetGroundHeight(x, z)
						if spTestMoveOrder(uDefID, x, y, z) then
							-- move the unit to new position and unmark it
							spSetUnitPosition(unitID, x, z)
							RemoveUnit(unitID)
							--spEcho("Success")
							unstuck = true
						end
					end
					if unstuck then
						break
					end
				end
				if unstuck then
					break
				end
			end
			if unstuck then
				break
			end
		end
		if not unstuck then
			-- unit was not unstuck :(
			--spEcho("Fail")
		end
		RemoveUnit(unitID)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	RemoveUnit(unitID)
end

function gadget:GameFrame(n)
	AttemptUnstuck()
	if n % FRAMES_PER_CHECK ~= 0 then
		return
	end

	if skipCounter < frameSkip then
		skipCounter = skipCounter + 1
		return
	end

	skipCounter = 0

	-- check all units
	local allUnits = spAllUnits()
	for _, unitID in pairs(allUnits) do
		if not spUnitDead(unitID) then
			ProcessUnit(unitID)
		end
	end

	-- if nothing is stuck, increase delay
	if #stuckUnits == 0 then
		frameSkip = 4
	else
		frameSkip = 0
	end
end