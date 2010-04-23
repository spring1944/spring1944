function gadget:GetInfo()
   return {
      name      = "HQ Heading",
      desc      = "Sets the heading of building HQs based on nearest map edge",
      author    = "Gnome, FLOZi",
      date      = "October 2008",
      license   = "PD",
      layer     = -5,
      enabled   = true  --  loaded by default?
   }
end

if (gadgetHandler:IsSyncedCode()) then

function gadget:GameFrame(n)
   if(n == 1) then
      local mapx = Game.mapX * 512
      local mapz = Game.mapY * 512
      for _,uid in ipairs(Spring.GetAllUnits()) do
         local udid = Spring.GetUnitDefID(uid)
				 local name = UnitDefs[udid].name
         if name == "gerhqbunker" or name == "gbrhq" or name == "ushq"  then
            local x,y,z = Spring.GetUnitBasePosition(uid)
            local team = Spring.GetUnitTeam(uid)
            local heading = "south"

            if(x > mapx / 2) then                  --unit is in the east side
               if(z > mapz / 2) then               --unit is in the south east
                  if(mapx - x < mapz - z) then heading = "west"
                  else heading = "north" end
               else                     --unit is in the north east
                  if(mapx - x < z) then heading = "west"
                  else heading = "south" end
               end
            else                        --unit is in the west side
               if(z > mapz / 2) then               --unit is in the south west
                  if(x < mapz - z) then heading = "east"
                  else heading = "north" end
               else                     --unit is in the north west
                  if(x < z) then heading = "east"
                  else heading = "south" end
               end
            end

            Spring.CreateUnit(name,x,y,z,heading,team)
            Spring.DestroyUnit(uid,false,true)
         end
      end
      gadgetHandler:RemoveGadget()
   end
end

end