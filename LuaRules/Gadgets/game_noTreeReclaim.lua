function gadget:GetInfo()
  return {
    name      = "Command Controller",
    desc      = "Prevents certain commands being issued",
    author    = "Tobi, Nemo (B. Tyler), FLOZi (C. Lawrence) based on a bit by lurker",
    date      = "December, 2008",
    license   = "GNU GPL v2",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if gadgetHandler:IsSyncedCode() then
-- SYNCED
	local GetFeatureDefID	= Spring.GetFeatureDefID
	local GetUnitDefID		= Spring.GetUnitDefID
	local CMD_ATTACK		= CMD.ATTACK
	local CMD_RECLAIM		= CMD.RECLAIM

	function gadget:Initialize()
		for _,feature in ipairs(Spring.GetAllFeatures()) do
			local name = FeatureDefs[GetFeatureDefID(feature)].name
			if name and string.find(name, "treetype") ~= nil then
				Spring.SetFeatureNoSelect(feature, true)
			end
		end
	end

	function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
		--Only even consider blocking the command if it's a reclaim command on a (single) unit.
		if (cmdID == CMD_RECLAIM and #cmdParams == 1 and cmdParams[1] < Game.maxUnits) then
			local udid = GetUnitDefID(cmdParams[1])
			if (udid ~= nil) then
				--Allow reclaiming big buildings, block reclaim for mobile units and deployed guns etc.
				--Now using heuristic based on footprintx >= 4 or footprintz >= 4 for this.
				--Note that xsize/zsize value in unitDef is twice the footprint value!
				local ud = UnitDefs[udid]
				return ud.xsize >= 8 or ud.zsize >= 8
			end
		elseif (cmdID == CMD_ATTACK and #cmdParams == 1) then
			local unitID = cmdParams[1]
			local ud = UnitDefs[GetUnitDefID(unitID)]
			if ud.name == "flag" then
				return false 
			end
		end
		return true
	end

	-- The code below mimics Spring's internal reclaiming code, with the major
	-- difference that no resources are ever added to anyone's storage.
	-- Author: Tobi Vollebregt

	local reclaimLeft = {}

	function gadget:AllowFeatureBuildStep(builderID, builderTeam, featureID, featureDefID, part)
		-- 2009/09/01: 10x faster reclaim (hence 0.1), 110 sec for standard tree seems tad bit much
		reclaimLeft[featureID] = (reclaimLeft[featureID] or 0.1) + part
		if (reclaimLeft[featureID] <= 0) then
			Spring.DestroyFeature(featureID)
		end
		return false
	end

	function gadget:FeatureDestroyed(featureID, allyTeam)
		reclaimLeft[featureID] = nil
	end
end
