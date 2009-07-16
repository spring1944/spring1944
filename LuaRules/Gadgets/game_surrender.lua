--TODO:
function gadget:GetInfo()
    return {
        name      = "Surrender",
        desc      = "Allows units to 'surrender' rather than just die.",
        author    = "Ben Tyler (Nemo)",
        date      = "July 9th, 2009",
        license   = "LGPL v2.1 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
local CMD_FIRESTATE = CMD.FIRE_STATE
local CMD_MOVESTATE = CMD.MOVE_STATE

local GetGameSeconds        =    Spring.GetGameSeconds
local GetUnitNearestEnemy	=    Spring.GetUnitNearestEnemy
local GetUnitSeparation		=    Spring.GetUnitSeparation
local GetUnitTeam			=	Spring.GetUnitTeam
local GAIA_TEAM_ID			=	Spring.GetGaiaTeamID()

local AddTeamResource		= 	Spring.AddTeamResource
local SetUnitSensorRadius        =    Spring.SetUnitSensorRadius
local TransferUnit			= 	Spring.TransferUnit
local GiveOrderToUnit		=	Spring.GiveOrderToUnit
local SetUnitNeutral		=	Spring.SetUnitNeutral
local surrenderedUnits		= 	{}
local escapeRadius			=	4000

if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

--escapeTime is seconds until unit escapes if unattended. 0 is unlimited
function GG.surrender(unitID, esTime)
	currentTeam = GetUnitTeam(unitID)
	if (currentTeam ~= GAIA_TEAM_ID) and (surrenderedUnits[unitID] == nil) then 
		surrenderedUnits[unitID] = {
			originalTeam = GetUnitTeam(unitID),
			surrenderTime = GetGameSeconds(),
			escapeTime = esTime,
		}
		TransferUnit(unitID, GAIA_TEAM_ID)
		GG.GiveOrderToUnitDisregardingNoSelect(unitID, CMD_FIRESTATE, { 0 }, 0)
		GG.GiveOrderToUnitDisregardingNoSelect(unitID, CMD_MOVESTATE, { 0 }, 0)    
	end
end

function gadget:GameFrame(n)
	if n == 5 then
		local GAIATeam	=	GAIA_TEAM_ID
		SendToUnsynced('allytogaia', GAIATeam)
	end
    if n % (1*30) < 0.1 then
        for unitID, someThing in pairs(surrenderedUnits) do
            local nearestGuard = GetUnitNearestEnemy(unitID, _, 0)
            if nearestGuard ~= nil then
				local oldTeam = surrenderedUnits[unitID].originalTeam
				local separation = GetUnitSeparation(unitID, nearestGuard)
				local guardTeam = GetUnitTeam(nearestGuard)
					if separation > escapeRadius or guardTeam == oldTeam then
						local currentTime = GetGameSeconds()
						local captureTime = surrenderedUnits[unitID].surrenderTime or 0
						local escapeTime = surrenderedUnits[unitID].escapeTime						
						if (currentTime - captureTime) > escapeTime and GG.fear[unitID] == 0 then
							TransferUnit(unitID, oldTeam)
							surrenderedUnits[unitID] = nil
						end             
					else
						surrenderedUnits[unitID].surrenderTime = currentTime
					end
					if (modOptions.prisoner_income ~= 0) and guardTeam ~= oldTeam then
							AddTeamResource(guardTeam, "m", modOptions.prisoner_income or 1)
					end
					--end  
			end
		end
    end
end

-----------------------
else --Unsynced
----------------------
local sendCommands            =	Spring.SendCommands

local function allytogaia(GAIATeam)
	sendCommands({'ally '.. GAIATeam .. ' 1'})
	print("Allied!")
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction("allytogaia", allytogaia)
end




end
