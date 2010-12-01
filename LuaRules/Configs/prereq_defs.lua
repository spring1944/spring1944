--[[
format:
{
  buildoptionUnitname = {
    prereqUnitname,
    prereqUnitname,
  },
  ...
}
]]

local anyBarracks = {
  "gbrbarracks",
  "gerbarracks",
  "gerbarracksbunker",
  "rusbarracks",
  "usbarracks",
}

local result = {
  gbrgunyard = anyBarracks,
  gbrvehicleyard = anyBarracks,
  gbrtankyard = anyBarracks,
  gbrradar = anyBarracks,
  gergunyard = anyBarracks,
  gervehicleyard = anyBarracks,
  gertankyard = anyBarracks,
  gerradar = anyBarracks,
  rusvehicleyard = anyBarracks,
  rustankyard = anyBarracks,
  rusradar = anyBarracks,
  usgunyard = anyBarracks,
  usvehicleyard = anyBarracks,
  ustankyard = anyBarracks,
  usradar = anyBarracks,
}

return result
