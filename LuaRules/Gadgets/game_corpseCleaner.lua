function gadget:GetInfo()
	return {
		name      = "Corpse cleaner",
		desc      = "Removes infantry corpses over time",
		author    = "Gnome, tweaked by Nemo",
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
			local fdid = Spring.GetFeatureDefID(fid)
			local fname = FeatureDefs[fdid].name
			local fmetal = FeatureDefs[fdid].metal
			if fname and (string.find(fname, "soldier") or string.find(fname, "shoulder")) ~= nil then
				local fhp, fmaxhp = Spring.GetFeatureHealth(fid)
				local subtract = fmaxhp * 0.01 --always make it take about 90 seconds regardless of the feature
				local fhp = fhp - subtract
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