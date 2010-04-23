--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: progress_bar.lua
--  brief: Shows a generic progress bar for what ever you need
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Progress Bar",
		desc      = "Displays a progress bar",
		author    = "Maelstrom",
		date      = "4th December 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then
	return
end

local ADD_BAR = "AddBar"
local SET_BAR = "SetBar"
local REMOVE_BAR = "RemoveBar"

local BAR_WIDTH = 40 / 2 -- 100
local BAR_HEIGHT = 4 / 2 -- 14

local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetSpectatingState  = Spring.GetSpectatingState

local glColor      = gl.Color
local glPushMatrix = gl.PushMatrix
local glTranslate  = gl.Translate
local glPopMatrix  = gl.PopMatrix

local barUnits = { }

local function DrawBar(unitID, barData, localTeamID)
	
	local unitTeam = GetUnitTeam(unitID)
	
	local px,py,pz = GetUnitBasePosition(unitID)
	if (not px) then
		return
	end
	
	local unitHeight = UnitDefs[barData.unitDefID].height

	-- Draw a progress indicator if its on our team
	if (localTeamID) and (unitTeam == localTeamID) then
		
		local progress = barData.progress
		
			-- Move matrix to unit position
		glPushMatrix()
		glTranslate(px, py + 20, pz)
		gl.Billboard()
		local progStr = "\255\255\255\1" .. barData.title .. "\255\255\255\255:" .. string.format("\255\1\255\1%.1f", 100 * progress) .. "%"
		
			-- Drawing Progress bar
		gl.Color({0.0, 0.0, 0.0, 0.7})
		gl.Rect(-(BAR_WIDTH + 1), -(BAR_HEIGHT + 1), BAR_WIDTH + 1, BAR_HEIGHT + 1)
		gl.Color({2 * (1-progress), 2.0 * progress, 0.0, 0.7})
		gl.Rect(-BAR_WIDTH, -BAR_HEIGHT, (BAR_WIDTH * 2 * progress) - BAR_WIDTH, BAR_HEIGHT)
			-- Drawing text
		gl.Color({1.0, 1.0, 1.0, 0.7})
		gl.Text(progStr, 0, BAR_HEIGHT * 2, 10, "cnd")
		glPopMatrix()
	end
end


function gadget:DrawWorld()

	if not barUnits then
		return -- no bars to draw
	end
	
	gl.Blending(false)
	gl.DepthTest(false)
	gl.Fog(false)

	local spec, specFullView = GetSpectatingState()
	local readTeam
	if (specFullView) then
		readTeam = Script.ALL_ACCESS_TEAM
	else
		readTeam = Spring.GetLocalTeamID()
	end

	CallAsTeam({ ['read'] = readTeam }, function()
		for unitID, barData in pairs(barUnits) do
			if (unitID and barData) then  -- FIXME: huh?
				DrawBar(unitID, barData, readTeam)
			end
		end
	end)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

function SetBar(command, unitID, progress)
	if (barUnits[unitID] ~= nil) then
		barUnits[unitID].progress = progress
	end
end

function RemoveBar(command, unitID)
	barUnits[unitID] = nil
end

function AddBar(command, unitID, title)
	local unitDefID = Spring.GetUnitDefID(unitID)
	local ud = UnitDefs[unitDefID]
	if ud.height == nil then
		ud.height = Spring.GetUnitDefDimensions(unitDefID).height
	end
	
	barUnits[unitID] = { }
	barUnits[unitID].progress = 0
	barUnits[unitID].unitDefID = unitDefID
	barUnits[unitID].title = title .. " "
end

function gadget:Initialize()
	barUnits = { }
	gadgetHandler:AddSyncAction(ADD_BAR, AddBar)
	gadgetHandler:AddSyncAction(SET_BAR, SetBar)
	gadgetHandler:AddSyncAction(REMOVE_BAR, RemoveBar)
end
