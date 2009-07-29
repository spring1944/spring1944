--[[
  format:
  sortie_unitname = {
    plane_unitname,
    plane_unitname,
    ...
    
    delay = number, -- number of frames before sortie arrives
    cursor = string, (default "Attack"), --cursor when ordering sortie
  }
]]

local sortieDefs = {
  gbr_sortie_recon = {
    "gbrauster",
    
    delay = 15,
  }
}

return sortieDefs
