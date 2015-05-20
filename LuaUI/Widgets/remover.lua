function widget:GetInfo()
  return {
    name      = "Gadget/Widget remover",
    desc      = "Safely remove gadgets/widgets",
    author    = "ashdnazg",
    date      = "21 May 2015",
    license   = "GNU GPL, v2 or later",
    layer     = -20000,
    enabled   = true,  --  loaded by default?
	handler   = true,
  }
end


local function retTrue()
	return true
end

local function retFalse()
	return false
end

local function retNil()
end

local dummy = {}

dummy.Save = retNil
dummy.Load = retNil

dummy.Shutdown = retNil

function dummy:GameSetup(state, ready)
	return false, ready
end

dummy.GamePreload = retNil
dummy.GameStart   = retNil
dummy.GameOver    = retNil
dummy.GameFrame   = retNil
dummy.GameID      = retNil

dummy.PlayerChanged = retNil
dummy.PlayerAdded   = retNil
dummy.PlayerRemoved = retNil

dummy.TeamDied    = retNil
dummy.TeamChanged = retNil  

dummy.UnitCreated      = retNil
dummy.UnitFinished     = retNil
dummy.UnitFromFactory  = retNil
dummy.UnitDestroyed    = retNil
dummy.UnitExperience   = retNil
dummy.UnitIdle         = retNil
dummy.UnitCmdDone      = retNil
dummy.UnitPreDamaged   = retNil

dummy.UnitPreDamaged       = retNil
dummy.UnitDamaged          = retNil
dummy.UnitStunned          = retNil
dummy.UnitTaken            = retNil
dummy.UnitGiven            = retNil
dummy.UnitEnteredRadar     = retNil
dummy.UnitEnteredLos       = retNil
dummy.UnitLeftRadar        = retNil
dummy.UnitLeftLos          = retNil
dummy.UnitSeismicPing      = retNil
dummy.UnitLoaded           = retNil
dummy.UnitUnloaded         = retNil
dummy.UnitCloaked          = retNil
dummy.UnitDecloaked        = retNil
dummy.UnitUnitCollision    = retNil
dummy.UnitFeatureCollision = retNil

dummy.StockpileChanged = retNil

dummy.FeatureCreated    = retNil
dummy.FeatureDestroyed  = retNil
dummy.FeatureDamaged    = retNil
dummy.FeaturePreDamaged = retNil
dummy.ProjectileCreated = retNil
dummy.ProjectileDestroyed = retNil

dummy.ShieldPreDamaged = retFalse

dummy.AllowCommand               = retTrue
dummy.AllowStartPosition         = retTrue
dummy.AllowUnitCreation          = retTrue
dummy.AllowUnitTransfer          = retTrue
dummy.AllowUnitBuildStep         = retTrue
dummy.AllowFeatureBuildStep      = retTrue
dummy.AllowFeatureCreation       = retTrue
dummy.AllowResourceLevel         = retTrue
dummy.AllowResourceTransfer      = retTrue
dummy.AllowDirectUnitControl     = retTrue
dummy.AllowBuilderHoldFire       = retTrue
dummy.AllowWeaponTargetCheck     = retTrue
dummy.AllowWeaponTarget          = retTrue
dummy.AllowWeaponInterceptTarget = retTrue

dummy.Explosion              = retFalse
dummy.CommandFallback        = retFalse
dummy.MoveCtrlNotify         = retFalse
dummy.TerraformComplete      = retFalse

dummy.GotChatMsg = retFalse
dummy.RecvLuaMsg = retFalse

--Unsynced

dummy.Update              = retNil

dummy.DrawGenesis         = retNil
dummy.DrawWorld           = retNil
dummy.DrawWorldPreUnit    = retNil
dummy.DrawWorldShadow     = retNil
dummy.DrawWorldReflection = retNil
dummy.DrawWorldRefraction = retNil
dummy.DrawScreenEffects   = retNil
dummy.DrawScreen          = retNil
dummy.DrawInMiniMap       = retNil

dummy.DrawUnit       = retFalse
dummy.DrawFeature    = retFalse
dummy.DrawShield     = retFalse
dummy.DrawProjectile = retFalse

dummy.RecvFromSynced        = retFalse
dummy.RecvSkirmishAIMessage = retFalse

dummy.DefaultCommand = retFalse
dummy.CommandNotify  = retFalse

dummy.ViewResize = retNil

dummy.KeyPress      = retFalse
dummy.KeyRelease    = retFalse
dummy.MousePress    = retFalse

function dummy:MouseRelease()
	return -1
end

dummy.MouseMove     = retNil
dummy.MouseWheel    = retFalse

dummy.IsAbove = retFalse

function dummy:GetTooltip()
	return ''
end

dummy.MapDrawCmd = retFalse

local removeList = {}
local removeCallinList = {}

local function Remove(dget)
	removeList[#removeList + 1] = dget
	if dget.Shutdown then
		dget:Shutdown()
	end
	for k, _ in pairs(dget) do
		if dummy[k] then
			dget[k] = dummy[k]
		end
	end
end

local function RemoveCallIn(name, dget)
	removeCallinList[#removeCallinList + 1] = {name, dget}
	dget[name] = dummy[name]
end

WG.RemoveWidget = Remove
WG.RemoveWidgetCallIn = RemoveCallIn

function widget:Update()
	if #removeList > 0 then
		for _, w in pairs(removeList) do
			widgetHandler:RemoveWidget(w)
			Spring.Echo("Widget Remover: removed " .. w.whInfo.name)
		end
		removeList = {}
	end
	
	if #removeCallinList > 0 then 
		for _, data in pairs(removeCallinList) do
			widgetHandler:RemoveWidgetCallIn(unpack(data))
			Spring.Echo("Widget Remover: removed callin " ..  data[1] .. " from " .. data[2].whInfo.name)
		end
		removeCallinList = {}
	end
end
