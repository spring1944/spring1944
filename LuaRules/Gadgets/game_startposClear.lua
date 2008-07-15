--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: startpos_clear.lua
--  brief: Removes any features around the  Commanders start positions
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Startpos Clearer",
		desc      = "Blows shit up around the HQ units",
		author    = "Maelstrom",
		date      = "30th September 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then
	
		-- Removes this gadget if the game has started.
		-- Only needs to run once at game start
	function gadget:GameFrame(n)
		if n<1 then
			gadgetHandler:RemoveGadget()
		end
	end
	
	function gadget:UnitFinished(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitID]
		if ud.customParams.hq == '1' then
			
			local px, py, pz = Spring.GetUnitPosition(unitID)
			
			local xmin = px - (ud.xsize * 14) / 2
			local xmax = px + (ud.xsize * 14) / 2
			local zmin = pz - (ud.ysize * 14) / 2
			local zmax = pz + (ud.ysize * 14) / 2
			
			local features = Spring.GetFeaturesInRectangle(xmin, zmin, xmax, zmax)
			
			if features then
				for k,v in pairs(features) do
					if k ~= n then
						Spring.DestroyFeature(v)
					end
				end
			end			
		end
	end	
end
