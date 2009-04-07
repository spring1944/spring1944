function gadget:GetInfo()
  return {
    name      = "No reclaiming trees",
    desc      = "Prevents default trees from being reclaimed",
    author    = "Tobi and Nemo, based on a bit by lurker",
    date      = "December, 2008",
    license   = "public domain, except for line 20 and 21, because those were GPL'd by lurker. o_O",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if gadgetHandler:IsSyncedCode() then
-- SYNCED
	local GetFeatureDefID = Spring.GetFeatureDefID
	local GetUnitDefID = Spring.GetUnitDefID
	local CMD_RECLAIM = CMD.RECLAIM

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
		end
		return true
	end

	-- The code below mimics Spring's internal reclaiming code, with the major
	-- difference that no resources are ever added to anyone's storage.
	-- Author: Tobi Vollebregt

	local reclaimLeft = {}

	function gadget:AllowFeatureBuildStep(builderID, builderTeam, featureID, featureDefID, part)
		reclaimLeft[featureID] = (reclaimLeft[featureID] or 1) - part
		if (reclaimLeft[featureID] <= 0) then
			Spring.DestroyFeature(featureID)
		end
		return false
	end

	function gadget:FeatureDestroyed(featureID, allyTeam)
		reclaimLeft[featureID] = nil
	end
end
