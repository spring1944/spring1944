function gadget:GetInfo()
	return {
		name      = "Corpse cleaner",
		desc      = "Removes infantry corpses over time",
		author    = "Rewritten by FLOZi (C.Lawrence)",
		date      = "27/05/2014",
		license   = "GNU GPL v2",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

local CLEAR_TIME = 90 * 30 -- 90sec
local DelayCall = GG.Delay.DelayCall

function gadget:FeatureCreated(featureID, featureAllyID)
	local featureDefID = Spring.GetFeatureDefID(featureID)
	local fName = FeatureDefs[featureDefID].name
    -- "blocking" corpses still mess with aiming, so fix that.
    if not FeatureDefs[featureDefID].blocking then
        Spring.SetFeatureBlocking(featureID, false, false, false, false, false, false, false)
    end
	if fName:find("soldier") then
		DelayCall(Spring.DestroyFeature, {featureID}, CLEAR_TIME)
	end
end

end
