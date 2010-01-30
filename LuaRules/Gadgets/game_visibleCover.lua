function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Visible Cover Areas",
		desc      = "Reads a map config file to generate areas where infantry are hidden from sight.",
		author    = "Nemo",
		date      = "26 Jan 2010",
		license   = "LGPL 2.0",
		layer     = 1,
		enabled   = true  --  loaded by default?
	}
end

--[[
TODO
restrict hiding to unit types - DONE, fearTarget units (guns and inf)
create config format, load from that
set a limit for number of units each section can hold 
reduce efficiency as features are destroyed in the area (fewer guys hidden)
dynamically create zones as features are created (vehicle corpses) based on some required density param (# of features in whatever radius)
modify tobi's waypoint widget so it can generate config files for maps
]]--

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local SetUnitCloak			=	Spring.SetUnitCloak 
--Arguments to SetUnitCloak: unitID, boolean cloaked | number scriptCloak, [number decloakDistance | boolean decloakAbs]
--[[
  If the 2nd argument is a number, the value works like this:
  1:=normal cloak
  2:=for free cloak (cost no E)
  3:=for free + no decloaking (except the unit is stunned)
  4>=ultimate cloak (no ecost, no decloaking, no stunned decloak)

 The decloak distance is only changed if the 3th argument is a number or a boolean.
  If the boolean is false it takes the default decloak distance for that unitdef,
  if the boolean is true it takes the absolute value of it.
]]--

local GetUnitDefID				=	Spring.GetUnitDefID
local GetUnitsInRectangle		=	Spring.GetUnitsInRectangle
local GetUnitsInCylinder		=	Spring.GetUnitsInCylinder
local GetFeaturePosition		=	Spring.GetFeaturePosition
local GetFeaturesInRectangle	=	Spring.GetFeaturesInRectangle
local GetFeatureDefID			=	Spring.GetFeatureDefID
--Arguments to GetUnitsInCylinder: world coord x, world coord z, radius

--Tables!
local sneakyUnits		=	{}
local cloakAreas		=	{} --table of areas that provide cover
local savedAreaUnits	=	{}	-- table 

--Constants!
local newFieldRadiusCheck	=	200 --the area that is checked when a new feature is created to see if a new cloaking field is in order
local sneakyFactor			=	2.5 --the normal cloak radius of sneaky units is divided by this when they're in cover
--the config file
local PROFILE_PATH			=	"maps/hideZoneConfig/" .. string.sub(Game.mapName, 1, string.len(Game.mapName) - 4) .. ".lua" --<3 floz
if VFS.FileExists(PROFILE_PATH) then
function gadget:Initialize()
	local zones = VFS.Include(PROFILE_PATH)
	for areaID, someThing in pairs(zones) do
		if zones[areaID].px1 ~= nil then -- rectangle
			cloakAreas[areaID] = {
				px1 = zones[areaID].px1,
				pz1 = zones[areaID].pz1,
				px2 = zones[areaID].px2,
				pz2 = zones[areaID].pz2,
				unitsToHide = {},
				decloakRadius = zones[areaID].decloakRadius,
				}
		--Spring.Echo("rectangular zone!", areaID)
		else 
			cloakAreas[areaID] = {
				px = zones[areaID].px,
				pz = zones[areaID].pz,
				radius = zones[areaID].radius,
				unitsToHide = {},
				decloakRadius = zones[areaID].decloakRadius,
				}
		end
		--Spring.Echo("circular zone!", areaID)
	end
end

--[[function gadget:FeatureCreated(featureID)
	local featureDefID = GetFeatureDefID(featureID)
	if featureDefID.reclaimable == true then
		local x, _, z = GetFeaturePosition(featureID)
		
end]]--

function gadget:FeatureDestroyed(featureID)

end

function gadget:GameFrame(n)
	if n == 5 then
		for areaID, someThing in pairs(cloakAreas) do
		local count = 0
		if cloakAreas[areaID].radius ~= nil then --circular zone, need to transform it into a rectangle because there is no GetFeaturesInCircle
			local radius = cloakAreas[areaID].radius
			local px = cloakAreas[areaID].px
			local pz = cloakAreas[areaID].pz
			local px1 = px + radius
			local pz1 = pz + radius
			local px2 = px - radius
			local pz2 = pz - radius
			for i=1, #GetFeaturesInRectangle(px1, pz1, px2, pz2) do
				count = count + 1
			end
		else --rectangular zone
			for i=1, #GetFeaturesInRectangle(cloakAreas[areaID].px1, cloakAreas[areaID].pz1, cloakAreas[areaID].px2, cloakAreas[areaID].pz2) do
				count = count + 1
			end
		end
		cloakAreas[areaID].initFeatures = count
		--Spring.Echo("Area: ",areaID,"has",cloakAreas[areaID].initFeatures,"features.")
	end

	end
	if (n % (3*30)) < 0.1 then
		for areaID, something in pairs(cloakAreas) do
				savedAreaUnits[areaID] = cloakAreas[areaID].unitsToHide
				for unitID, someThing in pairs(savedAreaUnits[areaID]) do
					if Spring.GetUnitIsDead(unitID) == true then
						savedAreaUnits[areaID][unitID] = nil
					end
				end
				cloakAreas[areaID].unitsToHide = {}
				
				if cloakAreas[areaID].radius ~= nil then --circular zone
					for _, unitID in ipairs(GetUnitsInCylinder(cloakAreas[areaID].px, cloakAreas[areaID].pz, cloakAreas[areaID].radius)) do
						local unitDefID = GetUnitDefID(unitID)
						local ud = UnitDefs[unitDefID]
						if ud.customParams.feartarget == "1" then
							cloakAreas[areaID].unitsToHide[unitID] = true
						end
					end
				else --rectangular zone
					for _, unitID in ipairs(GetUnitsInRectangle(cloakAreas[areaID].px1, cloakAreas[areaID].pz1, cloakAreas[areaID].px2, cloakAreas[areaID].pz2)) do
						local unitDefID = GetUnitDefID(unitID)
						local ud = UnitDefs[unitDefID]
						if ud.customParams.feartarget == "1" then
							cloakAreas[areaID].unitsToHide[unitID] = true
						end
					end
				end		
				
			for unitID, someThing in pairs(savedAreaUnits[areaID]) do
				local unitDefID = GetUnitDefID(unitID)
				local ud = UnitDefs[unitDefID]
				if ud ~= nil then
					if ud.startCloaked then		
						if cloakAreas[areaID].unitsToHide[unitID] == nil then
							SetUnitCloak(unitID, true, ud.decloakDistance)
						else
							SetUnitCloak(unitID, true, (ud.decloakDistance/sneakyFactor))
						end
					else	
						if cloakAreas[areaID].unitsToHide[unitID] == nil then
							SetUnitCloak(unitID, false)
						else
							SetUnitCloak(unitID, true, cloakAreas[areaID].decloakRadius)
						end
					end
				end
			end
		end
	end
end
else
Spring.Echo("No hide zone config found for map:", PROFILE_PATH)
end
