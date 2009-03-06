--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    download_builds.lua
--  brief:   downloaded unit buildOptions insertion, modified to load monolith builddefs.lua
--  author:  Dave Rodgers, Craig Lawrence
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local dlBuilds

if VFS.FileExists('gamedata/builddefs.lua') then
	dlBuilds = VFS.Include('gamedata/builddefs.lua')
end


--------------------------------------------------------------------------------


local function Execute(unitDefs)
  if (dlBuilds == nil) then
    Load()
  end

  for name, ud in pairs(unitDefs) do
    local dlMenu = dlBuilds[name]
    if (dlMenu) then
      ud.buildoptions = ud.buildoptions or {}
      for _, entry in ipairs(dlMenu) do
				Spring.Echo(entry)
        local buildOptions = ud.buildoptions
        table.insert(buildOptions, entry)
      end
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return {
  Execute = Execute,
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
                                                                                                      