function gadget:GetInfo()
  return {
    name      = "No reclaiming trees",
    desc      = "Prevents default trees from being relcaimed",
    author    = "Nemo, based on a bit by lurker",
    date      = "December, 2008",
    license   = "public domain, except for line 17 and 18, because those were GPL'd by lurker. o_O",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
if gadgetHandler:IsSyncedCode() then
--	SYNCED
	local GetFeatureDefID = Spring.GetFeatureDefID

	function gadget:Initialize()
	    for _,feature in ipairs(Spring.GetAllFeatures()) do
	        local name = FeatureDefs[GetFeatureDefID(feature)].name
	        if name and string.find(name, "treetype") ~= nil then
	            Spring.SetFeatureNoSelect(feature, true)
	        end
	    end
	end
	
	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		if cmdID ~= CMD.RECLAIM then
			return true
		end
		if cmdID == CMD.RECLAIM then
			local IDs = cmdParams
			if (IDs[1] > Game.maxUnits) then
				local featureID = IDs[1] - Game.maxUnits
				local FeatureDefID = GetFeatureDefID(featureID)
				local name = FeatureDefs[FeatureDefID].name
				if name and string.find(name, "treetype") ~= nil then
					return false
				else
					return true
				end
			end
		end		
	end
end
