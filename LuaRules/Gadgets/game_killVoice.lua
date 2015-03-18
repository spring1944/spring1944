local versionNumber = "v1.0"

function gadget:GetInfo()
	return {
		name    = "1944 Unit Kill Voice",
		desc    = versionNumber .. " Makes certain units say things when they kill something",
		author  = "yuritch",
		date    = "18 March 2015",
		license = "Public domain",
		layer   = 10000,
		enabled = true  --  loaded by default?
	}
end

-- Unsynced only
if gadgetHandler:IsSyncedCode() then
	return
end

local DEFAULT_VOLUME = 4

local SOUND_DIR = "sounds/"
local SOUND_EXT = ".wav"

-- minimum delay between voices from a single unit to prevent voice spam on killy things
local KillVoiceDelay = 2

local GetUnitPosition = Spring.GetUnitPosition
local PlaySoundFile = Spring.PlaySoundFile

local AreTeamsAllied = Spring.AreTeamsAllied

-- isn't going to change during game, might as well store the value
local myTeam = Spring.GetMyTeamID()

-- stores phrases
local KillVoiceData = {}

-- stores info on killing units, such as last phrase number and when it last happened
local KillVoiceUnitPhraseNumber = {}
local KillVoiceUnitVoiceDelay = {}

function KillVoice(killerID, killedDefID, victimDefID, x, y, z)
	local phraseNum = KillVoiceUnitPhraseNumber[killerID] or 1
	local killVoiceCategory = KillVoiceData[killedDefID].VoiceCategory
	local killVoicePhraseCount = KillVoiceData[killedDefID].PhraseCount

	-- pick a phrase to say
	local soundFileName = SOUND_DIR..killVoiceCategory..phraseNum..SOUND_EXT

	-- say it
	PlaySoundFile(soundFileName, DEFAULT_VOLUME, x, y, z)
	
	phraseNum = phraseNum + 1
	if phraseNum > killVoicePhraseCount then
		phraseNum = 1
	end
	KillVoiceUnitPhraseNumber[killerID] = phraseNum
end

function gadget:Initialize()
	if (Game.modShortName ~= "S44") then
		widgetHandler:RemoveWidget()
		return
	end

	-- preload kill voice data
	for unitDefID=1, #UnitDefs do
		local unitDef = UnitDefs[unitDefID]
		local cp = unitDef.customParams
		if cp then
			if cp.killvoicecategory then
				local newData = {
					VoiceCategory = cp.killvoicecategory,
					PhraseCount = tonumber(cp.killvoicephasecount or 1),
				}
				KillVoiceData[unitDefID] = newData
			end
		end
	end
end

function gadget:GameFrame(f)
	if f % 30 ~= 0 then
		return
	end

	local removalList = {}

	for unitID, delay in pairs(KillVoiceUnitVoiceDelay) do
		if delay then
			delay = delay - 1
			if delay <= 0 then
				removalList[unitID] = unitID
			end
			KillVoiceUnitVoiceDelay[unitID] = delay
		end
	end
	-- post-removal
	for _, unitID in pairs(removalList) do
		KillVoiceUnitVoiceDelay[unitID] = nil
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	-- this one isn't going to say much more anyway
	KillVoiceUnitVoiceDelay[unitID] = nil
	KillVoiceUnitPhraseNumber[unitID] = nil

	if attackerID and attackerDefID then
		if AreTeamsAllied(attackerTeam, myTeam) then
			if not KillVoiceUnitVoiceDelay[attackerID] then
				local x, y, z = GetUnitPosition(attackerID)
				KillVoiceUnitVoiceDelay[attackerID] = KillVoiceDelay
				KillVoice(attackerID, attackerDefID, unitDefID, x, y, z)
			end
		end
	end
end