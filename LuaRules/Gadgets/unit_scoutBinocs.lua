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
-- function localisations
-- Synced Read
local GetUnitTeam				= Spring.GetUnitTeam
local GetProjectilePosition		= Spring.GetProjectilePosition
local GetProjectileTarget		= Spring.GetProjectileTarget
local GetUnitCOBValue			= Spring.GetUnitCOBValue

-- Synced Ctrl
local CreateUnit				= Spring.CreateUnit
local SetUnitNoSelect			= Spring.SetUnitNoSelect
local SetProjectilePosition		= Spring.SetProjectilePosition
local SetProjectileCollision	= Spring.SetProjectileCollision
local InsertUnitCmdDesc			= Spring.InsertUnitCmdDesc
local SetUnitTarget				= Spring.SetUnitTarget
-- variables
local activeBinocs = {} -- activeBinocs[ownerID] = {origin={x,y,z},target,teleportTo={x,y,z}}

local CMD_LOOK = GG.CustomCommands.GetCmdID("CMD_LOOK")
local COBSCALE = 65536

local lookCmdDesc = {
	id = CMD_LOOK,
	type = CMDTYPE.ICON_MAP,
	name = "Look",
	action = "look",
	tooltip = "Use Binoculars to look at a point",
	cursor = "Patrol",
}

function CheckForBinocsWeapon(weapon)
	local retVal = false
	if (WeaponDefs[weapon.weaponDef].customParams.binocs) and (WeaponDefs[weapon.weaponDef].customParams.binocs == "1") then
		retVal = true
	end
	return retVal
end

function Look(unitID, weaponNumber, x, y, z)
	--[[
	local SET_WEAPON_GROUND_TARGET = COB.SET_WEAPON_GROUND_TARGET
	-- command parameters: unit's weapon number (0-based), packed XZ, y
	local XZ = x * COBSCALE + z
	Spring.Echo("Looking with weapon "..weaponNumber.." at: "..XZ.." "..y)
	local tmp = GetUnitCOBValue(unitID, SET_WEAPON_GROUND_TARGET, weaponNumber, XZ, y * COBSCALE)
	Spring.Echo("Result: "..tmp)
	]]--
	Spring.SetUnitTarget(unitID, x, y, z)
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	local weapDef = WeaponDefs[weaponID]
	if weapDef and (not weapDef.customParams.binocs or weapDef.customParams.binocs ~= "1" or ownerID == nil) then
		--Spring.Echo("not binocs :(")
		return false
	else
		local team = GetUnitTeam(ownerID)
		--Spring.Echo("Made a binocspot!")
		CreateUnit("binocspot", px, py, pz, 0, team)
		local binocInfo = activeBinocs[ownerID]
		if binocInfo == nil then
			Spring.Echo("Binoc error, shouldn't occur!")
			return false
		end
		if binocInfo.teleportTo == nil then
			binocInfo.teleportTo = {px, py, pz}
		end
	end
	
end

function gadget:ProjectileCreated(projID, ownerID, weaponID)
	local weapDef = WeaponDefs[weaponID]
	if weapDef and (not weapDef.customParams.binocs or weapDef.customParams.binocs ~= "1" or ownerID == nil) then
		--Spring.Echo("not binocs :(")
		return
	else
		local binocInfo = activeBinocs[ownerID]
		local px, py, pz = GetProjectilePosition(projID)
		local targetTypeInt, target = GetProjectileTarget(projID)
		if type(target) == "table" then
			if (binocInfo == nil) then
				activeBinocs[ownerID] = {origin={px, py, pz}, target=target}
			else
				local currentOrigin = binocInfo.origin
				local currentTarget = binocInfo.target
				if currentOrigin[1] ~= px or currentOrigin[2] ~= py or currentOrigin[3] ~= pz or
							currentTarget[1] ~= target[1] or target[2] ~= target[2] or target[3] ~= target[3] then
					binocInfo.origin = {px, py, pz}
					binocInfo.target = target
					binocInfo.teleportTo = nil
				elseif binocInfo.teleportTo ~= nil then
					SetProjectilePosition(projID, binocInfo.teleportTo[1], binocInfo.teleportTo[2], binocInfo.teleportTo[3])
					SetProjectileCollision(projID)
				end
			end
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID)
	local ud = UnitDefs[unitDefID]
	if ud.name == "binocspot" then
		SetUnitNoSelect(unitID, true)
	end
	-- should we add the Look command?
	local weapons = UnitDefs[unitDefID].weapons
	if weapons and #weapons > 0 then
		for i = 1, #weapons do
			if CheckForBinocsWeapon(weapons[i]) then
				InsertUnitCmdDesc(unitID, lookCmdDesc)
				break
			end
		end
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_LOOK then
		-- let's find the weapon number again
		local weapons = UnitDefs[unitDefID].weapons
		if weapons and #weapons > 0 then
			for i = 1, #weapons do
				if CheckForBinocsWeapon(weapons[i]) then
					Look(unitID, i, cmdParams[1], cmdParams[2], cmdParams[3])
					break
				end
			end
		end
	end
	return true
end

function gadget:Initialize()
	for weaponId, weaponDef in pairs (WeaponDefs) do
		if weaponDef.customParams.binocs then
			Script.SetWatchWeapon(weaponId, true)
		end
	end
end

end