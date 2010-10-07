--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "CustomFormations2",
		desc      = "Allows you to draw your own formation line.",
		author    = "Niobium", -- Based on 'Custom Formations v2.3' by jK and gunblob
		version   = "v2.9",
		date      = "Jan, 2008",
		license   = "GNU GPL, v2 or later",
		layer     = 10000,
		enabled   = true,
		handler   = true,
	}
end

--------------------------------------------------------------------------------
-- User Configurable
--------------------------------------------------------------------------------
-- Minimum spacing between commands (Squared) when drawing a path for single unit, must be >= 17*17 (Or orders overlap and cancel)
local minPathSpacingSq = 50 * 50

-- How long should algorithms take. (>0.1 gives visible stutter, default: 0.05)
local maxHngTime = 0.05 -- Desired maximum time for hungarian algorithm
local maxNoXTime = 0.05 -- Strict maximum time for nox algorithm

-- Need a baseline to start from when no config data saved
local defaultHungarianUnits	= 20

-- If we kept reducing maxUnits, it can get to a point where it can never increase
-- So we enforce minimums on the algorithms, if peoples CPUs cannot handle these minimums then the widget is not suited to them
local minHungarianUnits		= 10

-- We only increase maxUnits if the units are great enough for time to be meaningful
local unitIncreaseThresh	= 0.85

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------
-- These get changed when loading config, they don't technically need values here
local maxHungarianUnits         = defaultHungarianUnits
local maxOptimizationUnits      = defaultOptimizationUnits

local fNodes = {}
local fNodeCount = 0
local fLength = 0
local fDists = {}
local totaldxy = 0  --// moved mouse distance 

local dimmNodes = {}
local dimmNodeCount = 0
local alphaDimm = 1

local draggingPath = false
local lastPathPos = {}

local inMinimap = false

local endShift = false
local activeCmdIndex = -1
local cmdTag = CMD.MOVE
local inButtonEvent = false  --//if you click the command menu the move/fight command is handled with left click instead of right one

local invertQueueKey = (Spring.GetConfigInt("InvertQueueKey", 0) == 1)
local MiniMapFullProxy = (Spring.GetConfigInt("MiniMapFullProxy", 0) == 1)

--------------------------------------------------------------------------------
-- Speedups
--------------------------------------------------------------------------------
local osclock	= os.clock

local GL_LINE_STRIP		= GL.LINE_STRIP
local glVertex			= gl.Vertex
local glLineStipple 	= gl.LineStipple
local glLineWidth   	= gl.LineWidth
local glColor       	= gl.Color
local glBeginEnd    	= gl.BeginEnd
local glPushMatrix		= gl.PushMatrix
local glPopMatrix		= gl.PopMatrix
local glScale			= gl.Scale
local glTranslate		= gl.Translate
local glLoadIdentity	= gl.LoadIdentity

local spEcho				= Spring.Echo

local spGetActiveCommand 	= Spring.GetActiveCommand
local spSetActiveCommand	= Spring.SetActiveCommand
local spGetDefaultCommand	= Spring.GetDefaultCommand

local spGetModKeyState		= Spring.GetModKeyState
local spGetInvertQueueKey	= Spring.GetInvertQueueKey
local spGetMouseState		= Spring.GetMouseState

local spIsAboveMiniMap		= Spring.IsAboveMiniMap

local spGetSelUnitCount		= Spring.GetSelectedUnitsCount
local spGetSelUnits			= Spring.GetSelectedUnits
local spGetSelUnitsSorted	= Spring.GetSelectedUnitsSorted

local spGiveOrder			= Spring.GiveOrder
local spGetUnitDefID 		= Spring.GetUnitDefID
local spGetUnitIsTransporting = Spring.GetUnitIsTransporting
local spGetCommandQueue		= Spring.GetCommandQueue
local spGiveOrderToUnit   	= Spring.GiveOrderToUnit
local spGetUnitPosition		= Spring.GetUnitPosition

local spTraceScreenRay		= Spring.TraceScreenRay
local spGetGroundHeight		= Spring.GetGroundHeight
local spGetFeaturePosition	= Spring.GetFeaturePosition

local mapWidth, mapHeight 	= Game.mapSizeX, Game.mapSizeZ
local maxUnits				= Game.maxUnits

local uDefs = UnitDefs

local sfind = string.find

local tsort = table.sort
local tinsert = table.insert

local ceil = math.ceil
local sqrt	= math.sqrt
local huge	= math.huge

local CMD_INSERT = CMD.INSERT
local CMD_MOVE = CMD.MOVE
local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_ATTACK = CMD.ATTACK
local CMD_UNLOADUNIT = CMD.UNLOAD_UNIT
local CMD_UNLOADUNITS = CMD.UNLOAD_UNITS
local CMD_JUMP = 38521

local keyShift = 304

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------
local function GetModKeys()

	--// Create modkeystate list
	local alt, ctrl, meta, shift = spGetModKeyState()
	
	-- Shift inversion
	if spGetInvertQueueKey() then
		
		shift = not shift
		
		-- check for immediate mode mouse 'rocker' gestures
		--[[
		local x, y, b1, b2, b3 = spGetMouseState()
		if (((button == 1) and b3) or
			((button == 3) and b1)) then
			shift = false
		end
		]]--
	end
	
	return alt, ctrl, meta, shift
end

local moveCmds = {
	[CMD_MOVE]=true,	[CMD_ATTACK]=true,	[CMD.RECLAIM]=true,	[CMD.RESTORE]=true,	[CMD.RESURRECT]=true,
	[CMD_PATROL]=true,	[CMD.CAPTURE]=true,	[CMD_FIGHT]=true,	[CMD.DGUN]=true,	[CMD_JUMP]=true, 
	[CMD_UNLOADUNIT]=true,	[CMD_UNLOADUNITS]=true,	[CMD.LOAD_UNITS]=true,
} -- Only used by GetUnitPosition

local function GetUnitPosition(uID)
	
	local x, y, z = spGetUnitPosition(uID)
	
	local cmds = spGetCommandQueue(uID) ; if not cmds then return x, y, z end
	
	for i = #cmds, 1, -1 do
		
		local cmd = cmds[i]
		
		if (cmd.id < 0) or moveCmds[cmd.id] then
			
			local params = cmd.params
			
			if (#params >= 3) then
				
				return params[1], params[2], params[3]
				
			else
				if (#params == 1) then
					
					local pID = params[1]
					local px, py, pz
					
					if pID > maxUnits then
						px, py, pz = spGetFeaturePosition(pID - maxUnits)
					else
						px, py, pz = spGetUnitPosition(pID)
					end
					
					if px then
						return px, py, pz
					end
				end
			end
		end
	end
	
	return x, y, z
end

local function setColor(cmdID, alpha)
	if (cmdID == CMD_MOVE) then glColor(0.5, 1.0, 0.5, alpha) -- Green
	elseif (cmdID == CMD_ATTACK) then glColor(1.0, 0.2, 0.2, alpha) -- Red
	elseif (cmdID == CMD_UNLOADUNIT) then glColor(1.0, 1.0, 0.0, alpha) -- Yellow
	else glColor(0.5, 0.5, 1.0, alpha) -- Blue
	end
end

local function commandApplies(uID, uDefID, cmdID)
	
	if (cmdID == CMD_UNLOADUNIT) then
		local transporting = spGetUnitIsTransporting(uID)
		return (transporting and #transporting > 0)
	end
	
	return (((cmdID == CMD_MOVE) or (cmdID == CMD_FIGHT) or (cmdID == CMD_PATROL)) and uDefs[uDefID].canMove) or
			((cmdID == CMD_ATTACK) and (uDefs[uDefID].weapons.n > 0)) or
			(cmdID == CMD_JUMP) -- TODO: How to tell if a unit can jump or not
end

local function AddFNode(pos)
	
	if (fNodeCount > 0) then
		
		local prevNode = fNodes[fNodeCount]
		local dx, dz = pos[1] - prevNode[1], pos[3] - prevNode[3]
		local dist = sqrt(dx*dx + dz*dz)
		
		if (dist == 0.0) then
			-- Duplicate node. Don't add
			return
		end
		
		fLength = fLength + dist
		
	--else fLength = 0 -- This is done at ClearFNodes instead
	end
	
	fNodeCount = fNodeCount + 1
	fNodes[fNodeCount] = pos
	fDists[fNodeCount] = fLength
	
	totaldxy = 0
end

local function ClearFNodes()
	
	fNodes = {}
	fNodeCount = 0
	fLength = 0
end

local function GetInterpNodes(number)
	
	local spacing = fLength / (number - 1)
	
	local interpNodes = {}
	
	local sPos = fNodes[1]
	local sX = sPos[1]
	local sZ = sPos[3]
	local sDist = 0
	
	local eIdx = 2
	local ePos = fNodes[2]
	local eX = ePos[1]
	local eZ = ePos[3]
	local eDist = fDists[2]
	
	interpNodes[1] = {sX, spGetGroundHeight(sX, sZ), sZ}
	
	for n=1, (number - 2) do
		
		local reqDist = n * spacing
		
		while (reqDist > eDist) do
			
			sX = eX
			sZ = eZ
			sDist = eDist
			
			eIdx = eIdx + 1
			ePos = fNodes[eIdx]
			eX = ePos[1]
			eZ = ePos[3]
			eDist = fDists[eIdx]
		end
		
		local nFrac = (reqDist - sDist) / (eDist - sDist)
		
		local nX = sX * (1 - nFrac) + eX * nFrac
		local nZ = sZ * (1 - nFrac) + eZ * nFrac
		
		interpNodes[n + 1] = {nX, spGetGroundHeight(nX, nZ), nZ}
	end
	
	ePos = fNodes[fNodeCount]
	eX = ePos[1]
	eZ = ePos[3]
	
	interpNodes[number] = {eX, spGetGroundHeight(eX, eZ), eZ}
	
	return interpNodes
end

local function GiveNotifyingOrder(cmdID, cmdParams, cmdOpts)
	
	-- Because we have ONE order for ALL selected units, there are no conflicts
	-- If something wants to handle it, then it is allowed to and we exit
	
	-- Loop through all widgets with :CommandNotify
	for _, w in ipairs(widgetHandler.CommandNotifyList) do
		
		-- Don't look at command insert widget (It conflicts due to the way it is written)
		-- Else get return value, if true then return
		if not sfind(w:GetInfo().name, "CommandInsert") and w:CommandNotify(cmdID, cmdParams, cmdOpts) then
			return
		end
	end
	
	-- Give order
	spGiveOrder(cmdID, cmdParams, cmdOpts)
end

--------------------------------------------------------------------------------
-- Mouse/keyboard Callins
--------------------------------------------------------------------------------
function widget:MousePress(mx, my, button)
	
	local activeid
	endShift = false
	activeCmdIndex, activeid = spGetActiveCommand()
	
	if (activeid == CMD_UNLOADUNITS) then
		activeid = CMD_UNLOADUNIT -- Without this, the unloads issued will use the area of the last area unload
	end
	
	local alt, ctrl, meta, shift = GetModKeys()
	
	inButtonEvent = (activeid) and (button == 1) and ((activeid == CMD_PATROL) or 
													(activeid == CMD_FIGHT) or 
													(activeid == CMD_MOVE) or 
													(activeid == CMD_JUMP) or 
													(alt and ((activeid == CMD_ATTACK) or (activeid == CMD_UNLOADUNIT)))
													)
	
	if not (inButtonEvent or ((activeid == nil) and (button == 3))) then return false end
	
	local _,defid    = spGetDefaultCommand()
	cmdTag = activeid or defid   --// CMD.MOVE or CMD.FIGHT
	
	if not (inButtonEvent or (defid == CMD_MOVE)) then return false end
	
	inMinimap = spIsAboveMiniMap(mx, my)
	
	if inMinimap and not MiniMapFullProxy then return false end
	
	local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
	
	if pos then
		widgetHandler:UpdateWidgetCallIn("DrawInMiniMap", self)
		widgetHandler:UpdateWidgetCallIn("DrawWorld", self)
		
		AddFNode(pos)
		
		if ((spGetSelUnitCount() == 1) or (alt and (activeid ~= CMD_ATTACK) and (activeid ~= CMD_UNLOADUNIT))) then
			
			-- Start ordering unit immediately
			-- Need keyState
			local keyState = {}
			-- if alt   then tinsert(keyState, "alt") end -- A move order with "alt" in keystate does a box formation - we want a normal move
			if ctrl  then tinsert(keyState, "ctrl") end
			if meta  then tinsert(keyState, "meta") end
			if shift then tinsert(keyState, "shift") end
			
			-- Issue order (Insert if meta)
			if meta then
				GiveNotifyingOrder(CMD_INSERT, {0, cmdTag, 0, pos[1], pos[2], pos[3]}, {"alt"})
			else
				GiveNotifyingOrder(cmdTag, pos, keyState)
			end
			
			lastPathPos = pos
			
			draggingPath = true
		end
		
		return true
	end
	
	return false
end

function widget:MouseMove(mx, my, dx, dy, button)
	
	if (inButtonEvent and (button == 3)) or
		(not inButtonEvent and (button ~= 3)) then
		
		return false
	end
	
	if (fNodeCount > 0) then
		
		if not inMinimap or (totaldxy > 5) then
			
			if not inMinimap or spIsAboveMiniMap(mx, my) then
				
				local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
				
				if pos then
					
					AddFNode(pos)
					
					-- We may be giving path to a single unit, check
					if draggingPath then
						
						local dx, dz = pos[1] - lastPathPos[1], pos[3] - lastPathPos[3]
						
						if ((dx*dx + dz*dz) > minPathSpacingSq) then
							
							local alt, ctrl, meta, shift = GetModKeys()
							if meta then
								GiveNotifyingOrder(CMD_INSERT, {0, cmdTag, 0, pos[1], pos[2], pos[3]}, {"alt"})
							else
								GiveNotifyingOrder(cmdTag, pos, {"shift"})
							end
							
							lastPathPos = pos
						end
					end
				end
			end
		end
		
		totaldxy = totaldxy + dx*dx + dy*dy
	end
	
	return false
end

function widget:MouseRelease(mx, my, button)
	
	-- Check for no nodes...
	if (fNodeCount == 0) then 
		return -1
	end
	
	-- Modkeys
	local alt, ctrl, meta, shift = GetModKeys()
	
	-- MouseRelease -> Reset command if not shifting commands
	if (inButtonEvent and not shift) then
		spSetActiveCommand(-1)
	end
	
	-- Order issued -> Releasing shift will reset command
	if shift and (activeCmdIndex > -1) then
		endShift = true
	end
	
	-- Unit Path
	if draggingPath then
		
		-- Nothing to do here but end / cleanup
		draggingPath = false
		
		dimmNodes = fNodes
		dimmNodeCount = fNodeCount
		
		alphaDimm = 1.0
		
		ClearFNodes()
		
		return -1
	end
	
	-- Work out keystates (keyState is for GiveOrder and keyState2 is for CommandNotify)
	local keyState, keyState2 = {}, {coded=0, alt=false, ctrl=false, shift=false, right=false}    
	if alt   then tinsert(keyState,"alt");   keyState2.alt =true;  end
	if ctrl  then tinsert(keyState,"ctrl");  keyState2.ctrl=true;  end
	if meta  then tinsert(keyState,"meta");                        end
	if shift then tinsert(keyState,"shift"); keyState2.shift=true; end
	if not inButtonEvent then                keyState2.right=true; end
	
	-- Calculate coded of keyState2
	if keyState2.alt   then keyState2.coded = keyState2.coded + CMD.OPT_ALT   end
	if keyState2.ctrl  then keyState2.coded = keyState2.coded + CMD.OPT_CTRL  end
	if keyState2.shift then keyState2.coded = keyState2.coded + CMD.OPT_SHIFT end
	if keyState2.right then keyState2.coded = keyState2.coded + CMD.OPT_RIGHT end
	
	-- Single click? (no line drawn)
	if (fNodeCount == 1) then
		
		local pos = fNodes[1]
		
		if meta then
			GiveNotifyingOrder(CMD_INSERT, {0, cmdTag, 0, pos[1], pos[2], pos[3]}, {"alt"})
		else
			GiveNotifyingOrder(cmdTag, pos, keyState)
		end
		
		ClearFNodes()
		
		return -1
	end
	
	-- Loop over widgets with CommandNotify callin, calling it
	for _, w in ipairs(widgetHandler.CommandNotifyList) do
		
		-- Exclude CommandInsert (Note: We have other code which causes meta to insert the line at front of queues)
		local wName = w:GetInfo().name
		if not sfind(wName, "CommandInsert") and w:CommandNotify(cmdTag, fNodes[1], keyState2) then
			
			spEcho("<CustomFormations2> Conflict detected with " .. wName .. " widget on " .. CMD[cmdTag] .. " command, expect anomalies")
		end
	end
	
	-- Add final position
	if not inMinimap or spIsAboveMiniMap(mx, my) then
		
		local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
		
		if pos then
			AddFNode(pos)
		end
	end
	
	-- Get sorted units
    local units  = spGetSelUnitsSorted()
    units.n = nil

    -- Get units command applies to
    local mUnits = {}
    local mUnitsCount = 0
	
	-- Unloading is unit-specific, else unitdef-specific
	if cmdTag == CMD_UNLOADUNIT then
		for uDefID, uIDs in pairs(units) do
			if uDefs[uDefID].isTransport then
				for ui=1, #uIDs do
					local uID = uIDs[ui]
					if commandApplies(uID, uDefID, cmdTag) then
						mUnitsCount = mUnitsCount + 1
						mUnits[mUnitsCount] = uID
					end
				end
			end
		end
	else
		for uDefID, uIDs in pairs(units) do
			if commandApplies(0, uDefID, cmdTag) then
				for ui=1, #uIDs do
					mUnitsCount = mUnitsCount + 1
					mUnits[mUnitsCount] = uIDs[ui]
				end
			end
		end
	end
	
	-- Any units?
    if (mUnitsCount > 0) then
		
		-- Get interpolated nodes, one for each unit
		local interNodes = GetInterpNodes(mUnitsCount)
		local orders
		
		-- Get orders
		if (mUnitsCount <= maxHungarianUnits) then
			orders = GetOrdersHungarian(interNodes, mUnits, mUnitsCount, shift and not meta)
		else
			orders = GetOrdersNoX(interNodes, mUnits, mUnitsCount, shift and not meta)
		end
		
		-- Issue the orders
		for i=1, #orders do
			
			local oPair = orders[i]
			
			if meta then
				local cPos = oPair[1]
				spGiveOrderToUnit(oPair[2], CMD_INSERT, {0, cmdTag, keyState2.coded, cPos[1], cPos[2], cPos[3]}, {"alt"})
			else
				spGiveOrderToUnit(oPair[2], cmdTag, oPair[1], keyState)
			end
		end
    end
	
    dimmNodes = fNodes
	dimmNodeCount = fNodeCount
	
	alphaDimm = 1.0
    
	ClearFNodes()
	
	return -1
end

function widget:KeyRelease(key)
	if (key == keyShift) and endShift then
		endShift = false
		spSetActiveCommand(-1)
		return true
	end
end

--------------------------------------------------------------------------------
-- Drawing
--------------------------------------------------------------------------------
local function DrawFormationLine(dimmNodes)
	for _, v in pairs(dimmNodes) do
		glVertex(v[1],v[2],v[3])
	end
end

local function DrawMinimapFormationLine(dimmNodes)
	for _, v in pairs(dimmNodes) do
		glVertex(v[1], v[3], 1)
	end
end

function widget:DrawWorld()
	
	if (fNodeCount < 1) and (dimmNodeCount < 1) then
		widgetHandler:RemoveWidgetCallIn("DrawWorld", self)
		return
	end
	
	--// draw the lines
	glLineStipple(2, 4095)
	glLineWidth(2.0)
	
	setColor(cmdTag, 1.0)
	glBeginEnd(GL_LINE_STRIP, DrawFormationLine, fNodes)
	
	if (dimmNodeCount > 1) then
		
		setColor(cmdTag, alphaDimm)
		glBeginEnd(GL_LINE_STRIP, DrawFormationLine, dimmNodes)
		
		alphaDimm = alphaDimm - 0.03
		if (alphaDimm <= 0) then
			dimmNodes = {}
			dimmNodeCount = 0
		end
	end

	glColor(1, 1, 1, 1)
	glLineWidth(1.0)
	glLineStipple(false)
end

function widget:DrawInMiniMap()
	
	if (fNodeCount < 1) and (dimmNodeCount < 1) then
		widgetHandler:RemoveWidgetCallIn("DrawInMiniMap", self)
		return
	end
	
	--// draw the lines
	glLineStipple(1, 4095)
	glLineWidth(2.0)
	
	setColor(cmdTag, 1.0)
	
	glPushMatrix()
	glLoadIdentity()
	glTranslate(0,1,0)
	glScale(1/mapWidth, -1/mapHeight, 1)
	
	glBeginEnd(GL_LINE_STRIP, DrawMinimapFormationLine, fNodes)
	
	if (dimmNodeCount > 1) then
		
		setColor(cmdTag, alphaDimm)
		glBeginEnd(GL_LINE_STRIP, DrawMinimapFormationLine, dimmNodes)
		
		alphaDimm = alphaDimm - 0.03
		if (alphaDimm <= 0) then 
			dimmNodes = {}
			dimmNodeCount = 0
		end
	end
	
	glPopMatrix()
	
	glColor(1, 1, 1, 1)
	glLineWidth(1.0)
	glLineStipple(false)
end

---------------------------------------------------------------------------------------------------------
-- Configuration
---------------------------------------------------------------------------------------------------------
function widget:GetConfigData() -- Saving
	local data = {}
	data["maxHungarianUnits"] = maxHungarianUnits
	return data
end

function widget:SetConfigData(data) -- Loading
	maxHungarianUnits = data["maxHungarianUnits"] or defaultHungarianUnits
end

---------------------------------------------------------------------------------------------------------
-- Matching Algorithms
---------------------------------------------------------------------------------------------------------
function GetOrdersNoX(nodes, units, unitCount, shifted)
	
	-- Remember when  we start
	-- This is for capping total time
	-- Note: We at least complete initial assignment
	local startTime = osclock()
	
	---------------------------------------------------------------------------------------------------------
	-- Find initial assignments
	---------------------------------------------------------------------------------------------------------
	local unitSet = {}
	local fdist = -1
	local fm
	
	for u = 1, unitCount do
		
		-- Get unit position
		local ux, uz
		if shifted then
			ux, _, uz = GetUnitPosition(units[u])
		else
			ux, _, uz = spGetUnitPosition(units[u])
		end
		unitSet[u] = {ux, units[u], uz, -1} -- Such that x/z are in same place as in nodes (So we can use same sort function)
		
		-- Work on finding furthest points (As we have ux/uz already)
		for i = u - 1, 1, -1 do
			
			local up = unitSet[i]
			local vx, vz = up[1], up[3]
			local dx, dz = vx - ux, vz - uz
			local dist = dx*dx + dz*dz
			
			if (dist > fdist) then
				fdist = dist
				fm = (vz - uz) / (vx - ux)
			end
		end
	end
	
	-- Maybe nodes are further apart than the units
	for i = 1, unitCount - 1 do
		
		local np = nodes[i]
		local nx, nz = np[1], np[3]
		
		for j = i + 1, unitCount do
			
			local mp = nodes[j]
			local mx, mz = mp[1], mp[3]
			local dx, dz = mx - nx, mz - nz
			local dist = dx*dx + dz*dz
			
			if (dist > fdist) then
				fdist = dist
				fm = (mz - nz) / (mx - nx)
			end
		end
	end
	
	local function sortFunc(a, b)
		-- y = mx + c
		-- c = y - mx
		-- c = y + x / m (For perp line)
		return (a[3] + a[1] / fm) < (b[3] + b[1] / fm)
	end
	
	tsort(unitSet, sortFunc)
	tsort(nodes, sortFunc)
	
	for u = 1, unitCount do
		unitSet[u][4] = nodes[u]
	end
	
	---------------------------------------------------------------------------------------------------------
	-- Main part of algorithm
	---------------------------------------------------------------------------------------------------------
	
	-- M/C for each finished matching
	local Ms = {}
	local Cs = {}
	
	-- Stacks to hold finished and still-to-check units
	local stFin = {}
	local stFinCnt = 0
	local stChk = {}
	local stChkCnt = 0
	
	-- Add all units to check stack
	for u = 1, unitCount do
		stChk[u] = u
	end
	stChkCnt = unitCount
	
	-- Begin algorithm
	while ((stChkCnt > 0) and (osclock() - startTime < maxNoXTime)) do
		
		-- Get unit, extract position and matching node position
		local u = stChk[stChkCnt]
		local ud = unitSet[u]
		local ux, uz = ud[1], ud[3]
		local mn = ud[4]
		local nx, nz = mn[1], mn[3]
		
		-- Calculate M/C
		local Mu = (nz - uz) / (nx - ux)
		local Cu = uz - Mu * ux
		
		-- Check for clashes against finished matches
		local clashes = false
		
		for i = 1, stFinCnt do
			
			-- Get opposing unit and matching node position
			local f = stFin[i]
			local fd = unitSet[f]
			local tn = fd[4]
			
			-- Get collision point
			local ix = (Cs[f] - Cu) / (Mu - Ms[f])
			local iz = Mu * ix + Cu
			
			-- Check bounds
			if ((ux - ix) * (ix - nx) >= 0) and
			   ((uz - iz) * (iz - nz) >= 0) and
			   ((fd[1] - ix) * (ix - tn[1]) >= 0) and
			   ((fd[3] - iz) * (iz - tn[3]) >= 0) then
				
				-- Lines cross
				
				-- Swap matches, note this retains solution integrity
				ud[4] = tn
				fd[4] = mn
				
				-- Remove clashee from finished
				stFin[i] = stFin[stFinCnt]
				stFinCnt = stFinCnt - 1
				
				-- Add clashee to top of check stack
				stChkCnt = stChkCnt + 1
				stChk[stChkCnt] = f
				
				-- No need to check further
				clashes = true
				break
			end
		end
		
		if not clashes then
			
			-- Add checked unit to finished
			stFinCnt = stFinCnt + 1
			stFin[stFinCnt] = u
			
			-- Remove from to-check stack (Easily done, we know it was one on top)
			stChkCnt = stChkCnt - 1
			
			-- We can set the M/C now
			Ms[u] = Mu
			Cs[u] = Cu
		end
	end
	
	---------------------------------------------------------------------------------------------------------
	-- Return orders
	---------------------------------------------------------------------------------------------------------
	local orders = {}
	for u = 1, unitCount do
		local unit = unitSet[u]
		orders[u] = {unit[4], unit[2]}
	end
	return orders
end

function GetOrdersHungarian(nodes, units, unitCount, shifted)
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-- (the following code is written by gunblob)
	--   this code finds the optimal solution (slow, but effective!)
	--   it uses the hungarian algorithm from http://www.public.iastate.edu/~ddoty/HungarianAlgorithm.html
	--   if this violates gpl license please let gunblob and me know
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	local t = osclock()
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- cache node<->unit distances
	
	local distances = {}
	for n=1, unitCount do distances[n] = {} end
	
	for i=1, unitCount do
		
		local uID = units[i]
		local ux, uz 
		
		if shifted then
			ux, _, uz = GetUnitPosition(uID)
		else
			ux, _, uz = spGetUnitPosition(uID)
		end
		
		for n=1, unitCount do
			
			local nodePos   = nodes[n]
			local dx,dz     = nodePos[1] - ux, nodePos[3] - uz
			distances[n][i] = ceil(sqrt(dx*dx + dz*dz) + 0.5)
			 -- Integer distances = greatly improved algorithm speed
			 -- multiplying all distances by a constant does not affect optimality
			 -- but gives us some decimal place accuracy (Not required)
		end
	end
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- find optimal solution and send orders
	
	local result = findHungarian(distances, unitCount)
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- determine needed time and optimize the maxUnits limit
	
	local delay = osclock() - t
	
	if (delay > maxHngTime) and (maxHungarianUnits > minHungarianUnits) then
		
		-- Delay is greater than desired, we have to reduce units
		maxHungarianUnits = maxHungarianUnits - 1
	else
		local nUnits = #units
		
		-- Delay is less than desired, so thats OK
		-- To make judgements we need number of units to be close to max
		-- Because we are making predictions of time and we want them to be accurate
		if (nUnits > maxHungarianUnits*unitIncreaseThresh) then
			
			-- This implementation of Hungarian algorithm is O(n3)
			-- Because we have less than maxUnits, but are altering maxUnits...
			-- We alter the time, to 'predict' time we would be getting at maxUnits
			-- We then recheck that against maxHngTime
			
			local nMult = maxHungarianUnits / nUnits
			
			if ((delay*nMult*nMult*nMult) < maxHngTime) then
				maxHungarianUnits = maxHungarianUnits + 1
			else
				if (maxHungarianUnits > minHungarianUnits) then
					maxHungarianUnits = maxHungarianUnits - 1
				end
			end
		end
	end
	
	-- Return orders
	local orders = {}
	
	for j=1, unitCount do
		local rPair = result[j]
		orders[j] = {nodes[rPair[1]], units[rPair[2]]}
	end
	
	return orders
end

function findHungarian(array, n)
	
	-- Vars
	local starmask = {}
	local colcover = {}
	local rowcover = {}
	local starscol = {}
	
	-- Initialization
	for i = 1, n do
		
		rowcover[i] = false
		colcover[i] = false
		starscol[i] = false
		
		starmask[i] = {}
		local starRow = starmask[i]
		for j = 1, n do
			starRow[j] = 0
		end
	end
	
	-- Subtract minimum from rows
	for i = 1, n do
		
		local aRow = array[i]
		local starRow = starmask[i]
		local minVal = aRow[1]
		
		-- Find minimum
		for j = 2, n do
			if aRow[j] < minVal then
				minVal = aRow[j]
			end
		end
		
		-- Subtract minimum
		for j = 1, n do
			aRow[j] = aRow[j] - minVal
		end
		
		-- Star zeroes
		for j = 1, n do
			if (aRow[j] == 0) and not colcover[j] then
				starRow[j] = 1
				colcover[j] = true
				starscol[i] = j
				break
			end
		end
	end
	
	return stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
end

function stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
	
	-- Are we done? (All columns covered)
	for i = 1, n do
		if not colcover[i] then
			return stepPrimeZeroes(array, starmask, colcover, rowcover, n, starscol)
		end
	end
	
	-- All columns were covered
	-- Return the solution
	local pairings = {}
	for i = 1, n do
		pairings[i] = {i, starscol[i]}
	end
	
	return pairings
end

function stepPrimeZeroes(array, starmask, colcover, rowcover, n, starscol)
	
	-- Infinite loop
	while true do
		
		for i = 1, n do
			
			if not rowcover[i] then
				
				local aRow = array[i]
				local starRow = starmask[i]
				
				for j = 1, n do
					
					if (aRow[j] == 0) and not colcover[j] then
						
						starRow[j] = 2
						
						local starpos = starscol[i]
						if starpos then
							
							rowcover[i] = true
							colcover[starpos] = false
							break -- This row is now covered
						else
							return stepFiveStar(array, starmask, colcover, rowcover, i, j, n, starscol)
						end
					end
				end
			end
		end
		
		-- Find minimum uncovered
		local minVal = huge
		for i = 1, n do
			
			if not rowcover[i] then
				
				local aRow = array[i]
				
				for j = 1, n do
					if (aRow[j] < minVal) and not colcover[j] then
						minVal = aRow[j]
					end
				end
				
				-- Lowest we can go is zero, break early if so
				if minVal == 0 then
					break
				end
			end
		end
		
		-- Only update if things will change
		if minVal ~= 0 then
			
			-- Covered rows = +
			-- Uncovered cols = -
			for i = 1, n do
				local aRow = array[i]
				if rowcover[i] then
					for j = 1, n do
						if colcover[j] then
							aRow[j] = aRow[j] + minVal
						end
					end
				else
					for j = 1, n do
						if not colcover[j] then
							aRow[j] = aRow[j] - minVal
						end
					end
				end
			end
		end
	end
end

function stepFiveStar(array, starmask, colcover, rowcover, row, col, n, starscol)
	
	local stars = {}
	local primes = {}
	local orow, ocol = row, col
	
	local nStars = 0
	local nPrimes = 0
	
	repeat
		local noFind = true
		
		for i = 1, n do
			
			local starRow = starmask[i]
			if starRow[col] == 1 then
				
				noFind = false
				
				nStars = nStars + 1
				stars[nStars] = {i, col}
				
				for j = 1, n do
					
					if starRow[j] == 2 then
						
						nPrimes = nPrimes + 1
						primes[nPrimes] = {i, j}
						
						col = j
						break
					end
				end
				
				break
			end
		end
	until noFind
	
	for s = 1, nStars do
		local star = stars[s]
		local r, c = star[1], star[2]
		starmask[r][c] = 0
		starscol[r] = false
	end
	
	-- Apply initial prime
	starmask[orow][ocol] = 1
	starscol[orow] = ocol
	
	for p = 1, nPrimes do
		local prime = primes[p]
		local r, c = prime[1], prime[2]
		starmask[r][c] = 1
		starscol[r] = c
	end
	
	for i = 1, n do
		colcover[i] = false
	end
	
	for i = 1, n do
		
		rowcover[i] = false
		
		local starRow = starmask[i]
		for j = 1, n do
			if starRow[j] == 2 then
				starRow[j] = 0
				break
			end
		end
		
		local scol = starscol[i]
		if scol then
			colcover[scol] = true
		end
	end
	
	return stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
end
