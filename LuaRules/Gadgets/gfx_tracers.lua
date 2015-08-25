function gadget:GetInfo()
	return {
		name = "Tracers",
		desc = "Tracer Visual FX",
		author = "FLOZi (C. Lawrence)",
		date = "03 February 2015",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end


local fxs = include("LuaRules/Configs/lups_projectile_fxs.lua")
local weapons = {}

for id, wd in pairs(WeaponDefs) do
	if wd.customParams and wd.customParams.projectilelups then
		local data
		local func, err = loadstring("return " .. (wd.customParams.projectilelups or ""))
		if func then
			effects = func()
		elseif err then
			Spring.Log(gadget:GetInfo().name, LOG.WARNING, "malformed projectile Lups definition for weapon " .. wd.name .. "\n" .. err  )
		end
		if effects then
			local fxList = {}
			for i, effect in pairs(effects) do
				fxList[i] = fxs[effect]
			end
			weapons[id] = fxList
		end
	end
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

-- Localisations
local DelayCall 			= GG.Delay.DelayCall
-- MoveCtrl
local mcDisable				= Spring.MoveCtrl.Disable
local mcEnable				= Spring.MoveCtrl.Enable
local mcSetCollideStop		= Spring.MoveCtrl.SetCollideStop
local mcSetTrackGround		= Spring.MoveCtrl.SetTrackGround
local mcSetVelocity			= Spring.MoveCtrl.SetVelocity
-- Synced Read
local GetGroundHeight		= Spring.GetGroundHeight
local GetUnitBasePosition	= Spring.GetUnitBasePosition
-- Synced Ctrl
local CallCOBScript			= Spring.CallCOBScript
local EditUnitCmdDesc		= Spring.EditUnitCmdDesc
local FindUnitCmdDesc		= Spring.FindUnitCmdDesc
local InsertUnitCmdDesc		= Spring.InsertUnitCmdDesc
local SetUnitArmored		= Spring.SetUnitArmored
local SetUnitWeaponState	= Spring.SetUnitWeaponState
-- Unsynced Ctrl
local SendMessageToTeam		= Spring.SendMessageToTeam

-- Constants


-- Variables
local unitWeaponRounds = {}


function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
  if weapons[weaponDefID] then
    if not unitWeaponRounds[proOwnerID] then
      unitWeaponRounds[proOwnerID] = {}
    end
	unitWeaponRounds[proOwnerID][weaponDefID] = (unitWeaponRounds[proOwnerID][weaponDefID] or 0) + 1
    if unitWeaponRounds[proOwnerID][weaponDefID] == (tonumber(WeaponDefs[weaponDefID].customParams.tracerfreq or 5)) then --customparam this later too
	  unitWeaponRounds[proOwnerID][weaponDefID] = 0
	  --TODO: batch sending if required
      SendToUnsynced("lupsProjectiles_AddProjectile", proID, proOwnerID, weaponDefID)
    end
  end
end

else
--UNSYNCED
local Lups
local LupsAddParticles 
local SYNCED = SYNCED

local projectiles = {}

local function AddProjectile(_, proID, proOwnerID, weaponID)
  if (not Lups) then Lups = GG['Lups']; LupsAddParticles = Lups.AddParticles end
  projectiles[proID] = {}
  local def = weapons[weaponID]
  for i=1,#def do
    local fxTable = projectiles[proID]
    local fx = def[i]
    local options = {}
	table.copy(fx.options, options)
    --options.unit = proOwnerID
    options.projectile = proID
    options.weapon = weaponID
    --options.worldspace = true
    local fxID = LupsAddParticles(fx.class, options)
    if fxID ~= -1 then
      fxTable[#fxTable+1] = fxID
    end
  end
end

local function RemoveProjectile(_, proID)
  if projectiles[proID] then
    for i=1,#projectiles[proID] do
      local fxID = projectiles[proID][i]
      local fx = Lups.GetParticles(fxID)
      if fx and fx.persistAfterDeath then
        fx.isvalid = nil
      else
        Lups.RemoveParticles(fxID)
      end
    end
    projectiles[proID] = nil
  end
end



function gadget:Initialize()
  gadgetHandler:AddSyncAction("lupsProjectiles_AddProjectile", AddProjectile)
  gadgetHandler:AddSyncAction("lupsProjectiles_RemoveProjectile", RemoveProjectile)
end


function gadget:Shutdown()
  gadgetHandler:RemoveSyncAction("lupsProjectiles_AddProjectile")
  gadgetHandler:RemoveSyncAction("lupsProjectiles_RemoveProjectile")
end
end
