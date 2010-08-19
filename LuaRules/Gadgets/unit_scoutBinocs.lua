function gadget:GetInfo()
	return {
		name      = "Binocs for Scouts",
		desc      = "Lets scouts see far away",
		author    = "Nemo",
		date      = "17 Aug 2010",
		license   = "LGPL v2",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:Explosion(weaponId, px, py, pz, ownerID)
	local weapDef = WeaponDefs[weaponId]
	if not weapDef.customParams.binocs or weapDef.customParams.binocs ~= "1" then
		--Spring.Echo("not binocs :(")
		return false
	else
		local team = Spring.GetUnitTeam(ownerID)
		--Spring.Echo("Made a binocspot!")
		Spring.CreateUnit("binocspot", px, py, pz, 0, team)
	end
	Spring.Echo("nothing happened?")
	
end

function gadget:UnitCreated(unitID, unitDefID)
	local ud = UnitDefs[unitDefID]
	if ud.name == "binocspot" then
		Spring.SetUnitNoSelect(unitID, true)
	end
end

function gadget:Initialize()
	for weaponId, weaponDef in pairs (WeaponDefs) do
		if weaponDef.customParams.binocs then
			Script.SetWatchWeapon(weaponId, true)
		end
	end
end

end