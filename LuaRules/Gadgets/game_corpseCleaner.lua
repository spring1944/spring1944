function gadget:GetInfo()
	return {
		name      = "Corpse cleaner",
		desc      = "Removes infantry corpses over time",
		author    = "Gnome",
		date      = "June 2008",
		license   = "CC by-nc, version 3.0",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

function gadget:GameFrame(n)
	if(n % 30 < 1) then
		local features = Spring.GetAllFeatures()
		for _,fid in ipairs(features) do
			fdid = Spring.GetFeatureDefID(fid)
			fname = FeatureDefs[fdid].name
			fmetal = FeatureDefs[fdid].metal
			if(fmetal == 1) then --don't get rid of corpses that can change gameplay
				fhp, fmaxhp = Spring.GetFeatureHealth(fid)
				subtract = fmaxhp * 0.033 --always make it take about 30 seconds regardless of the feature
				fhp = fhp - subtract
				if(fhp ~= nil) then
					if(fhp <= 0) then
						Spring.DestroyFeature(fid)
					else
						Spring.SetFeatureHealth(fid,fhp)
					end
				end
			end
		end
	end
end

end