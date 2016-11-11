
if addon.InGetInfo then
	return {
		name    = "Music",
		desc    = "plays music",
		author  = "jK, modified by yuritch for Spring:1944",
		date    = "2012,2013",
		license = "GPL2",
		layer   = 0,
		depend  = {"LoadProgress"},
		enabled = true,
	}
end

------------------------------------------

Spring.SetSoundStreamVolume(0)
local musicfiles = VFS.DirList(LUA_DIRNAME .. "Assets/music", "*.ogg")
Spring.Echo('Searching for loadscreen music...')
for i, fname in ipairs(musicfiles) do
	Spring.Echo('found: ' .. i .. '. ' .. fname)
end
if (#musicfiles > 0) then
	-- reset rng a bit, maybe it will be more random that way?
	local i = math.random(10)
	i = math.random(#musicfiles)
	local fname = musicfiles[i]
	Spring.Echo('playing: ' .. i .. '. ' .. fname)
	Spring.PlaySoundStream(fname, 1)
	Spring.SetSoundStreamVolume(0)
else
	Spring.Echo('No loasdscreen music found.')
end


function addon.DrawLoadScreen()
	local loadProgress = SG.GetLoadProgress()

	-- fade in & out music with progress
	if (loadProgress < 0.9) then
		Spring.SetSoundStreamVolume(loadProgress)
	else
		Spring.SetSoundStreamVolume(0.9 + ((0.9 - loadProgress) * 9))
	end
end


function addon.Shutdown()
	Spring.StopSoundStream()
	Spring.SetSoundStreamVolume(1)
end
