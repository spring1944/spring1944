function gadget:GetInfo()
  return {
    name      = "No reclaiming trees",
    desc      = "Prevents default trees from being reclaimed",
    author    = "Tobi and Nemo, based on a bit by lurker",
    date      = "December, 2008",
    license   = "public domain, except for line 17 and 18, because those were GPL'd by lurker. o_O",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if gadgetHandler:IsSyncedCode() then
-- SYNCED
	local GetFeatureDefID = Spring.GetFeatureDefID

	function gadget:Initialize()
	    for _,feature in ipairs(Spring.GetAllFeatures()) do
	        local name = FeatureDefs[GetFeatureDefID(feature)].name
	        if name and string.find(name, "treetype") ~= nil then
	            Spring.SetFeatureNoSelect(feature, true)
	        end
	    end
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
