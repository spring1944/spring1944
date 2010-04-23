function gadget:GetInfo()
   return {
      name = "Control Victory",
      desc = "Enables a victory through capture and hold",
      author = "KDR_11k (David Becker)",
      date = "2008-03-22",
      license = "Public Domain",
      layer = 1,
      enabled = true
   }
end

local captureRadius = 230 --Radius around a point in which to capture it
local captureTime = 30 --Time to capture a point
local captureBonus = .5 --speedup from adding more units
local decapSpeed = 3 --speed multiplier for neutralizing an enemy point

local startTime = tonumber(Spring.GetModOptions().starttime) or 5 --The time when capturing can start

local dominationScoreTime = 30 --Time needed holding all points to score in multi domination

local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
--Spring.Echo("+++++++++++++++++++++++++++++++++++++++++++++++++++++++ "..(Spring.GetModOptions().scoremode or "nil!"))
if Spring.GetModOptions().scoremode == "disabled" or Spring.GetModOptions().scoremode == nil then return false end

local limitScore = tonumber(Spring.GetModOptions().limitscore) or 200
local initFrame
local scoreModes = {
   disabled = 0, --none (duh)
   countdown = 1, --A point decreases all opponents' scores, zero means defeat
   tugowar = 2, --A point steals enemy score, zero means defeat
   multidomination = 3, --Holding all points will grant 100 score, first to reach the score limit wins
}
local scoreMode = scoreModes[Spring.GetModOptions().scoremode or "countdown"]

local _,_,_,_,_,gaia = Spring.GetTeamInfo(Spring.GetGaiaTeamID())

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local points={}
local score={}

local dom = {
   dominator=nil,
   dominationTime=nil,
}

local function Loser(team)
   if team == gaia then
      return
   end
   for _,u in ipairs(Spring.GetAllUnits()) do
      if team == Spring.GetUnitAllyTeam(u) then
         Spring.TransferUnit(u, GAIA_TEAM_ID, false)
      end
   end
end

local function Winner(team)
   for _,a in ipairs(Spring.GetAllyTeamList()) do
      if a ~= team and a ~= gaia then
         Loser(a)
      end
   end
end

function gadget:Initialize()
   for _,a in ipairs(Spring.GetAllyTeamList()) do
      if scoreMode ~= 3 then
         score[a] = limitScore
      else
         score[a] = 0
      end
   end
   initFrame = Spring.GetGameFrame()
   score[gaia]=0
   _G.points = points
   _G.score = score
   _G.dom = dom
end

function gadget:GameFrame(f)
	if (f == (initFrame + 10)) then
      for _,u in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(u)
		local ud = UnitDefs[unitDefID]
         if ud.name == "flag" then
            local x,y,z = Spring.GetUnitPosition(u)
            table.insert(points, {
               x=x, y=y, z=z,
               owner=nil,
               capturer=nil,
               capture=0,
            })
         end
      end
	end
	  
   if f % 30 < .1 and f / 1800 > startTime then
      local owned = {}
      for _,a in ipairs(Spring.GetAllyTeamList()) do
         owned[a]=0
      end
      for _,p in pairs(points) do
         local target = nil
         local owner = p.owner
         local count = 0
         for _,u in ipairs(Spring.GetUnitsInCylinder(p.x, p.z, captureRadius)) do
            local unitOwner = Spring.GetUnitAllyTeam(u)
			local unitDefID = Spring.GetUnitDefID(u)
			local ud = UnitDefs[unitDefID]
		   if (ud.customParams.flagcaprate ~= nil) or ((ud.customParams.flag == 1) and (unitOwner ~= GAIA_TEAM_ID)) then
	            if owner then
	               if owner == unitOwner then
	                  count = 0
	                  break
	               else
	                  count = count + 1
	               end
	            else
	               if target then
	                  if target == unitOwner then
	                     count = count + 1
	                  else
	                     target = nil
	                     break
	                  end
	               else
	                  target = unitOwner
	                  count = count + 1
	               end
	            end
			end
         end
         if owner and count > 0 then
            p.capturer = nil
            p.capture = p.capture + (1 + captureBonus*(count-1))*decapSpeed
         elseif target then
            if p.capturer == target then
               p.capture = p.capture + 1 + captureBonus*(count-1)
            else
               p.capturer = target
               p.capture = 1 + captureBonus*(count-1)
            end
         end
         if p.capture > captureTime then
            p.owner = p.capturer
            p.capture = 0
         end
         if p.owner then
            owned[p.owner]=owned[p.owner]+1
         end
      end
      if scoreMode == 1 then --Countdown
         for owner, count in pairs(owned) do
            for _,a in ipairs(Spring.GetAllyTeamList()) do
               if a ~= owner and score[a] > 0 then
                  score[a] = score[a] - count
               end
            end
         end
         for a,s in pairs(score) do
            --Spring.Echo("Team "..a..": "..s)
            if s <= 0 then
               Loser(a)
            end
         end
      elseif scoreMode ==2 then --Tug o'War
         for owner, count in pairs(owned) do
            for _,a in ipairs(Spring.GetAllyTeamList()) do
               if a ~= owner and score[a] > 0 then
                  score[a] = score[a] - count
                  score[owner] = score[owner] + count
               end
            end
         end
         for a,s in pairs(score) do
            --Spring.Echo("Team "..a..": "..s)
            if s <= 0 then
               Loser(a)
            end
         end
      elseif scoreMode ==3 then --Multi Domination
         local prevDominator=dom.dominator
         dom.dominator=nil
         for owner, count in pairs(owned) do
            if count == #points then
               dom.dominator = owner
               if prevDominator ~= owner or not dom.dominationTime then
                  dom.dominationTime = f + 30*dominationScoreTime
               end
               break
            end
         end
         if dom.dominator then
            if dom.dominationTime <= f then
               for _,p in pairs(points) do
                  p.owner = nil
                  p.capture = 0
               end
               score[dom.dominator] = score[dom.dominator] + 100
               if score[dom.dominator] >= limitScore then
                  Winner(dom.dominator)
               end
            end
         end
      end
   end
end

else

--UNSYNCED

local Text = gl.Text
local Color = gl.Color
local DrawGroundCircle = gl.DrawGroundCircle
local PushMatrix = gl.PushMatrix
local PopMatrix = gl.PopMatrix
local Translate = gl.Translate
local Scale = gl.Scale
local Rotate = gl.Rotate
local Rect = gl.Rect
local Billboard = gl.Billboard

local function DrawPoints()
   local me = Spring.GetLocalAllyTeamID()
   for _,p in spairs(SYNCED.points) do
      local r,g,b = .5,.5,.5
      if p.owner then
         --Spring.Echo(p.owner, me)
         if p.owner == me then
            r,g,b = 0,1,0
         else
            r,g,b = 1,0,0
         end
      end
      Color(r,g,b,1)
      DrawGroundCircle(p.x,p.y,p.z,captureRadius,30)
      if p.capture > 0 then
         PushMatrix()
         Translate(p.x,p.y + 100,p.z)
         Billboard()
         Color(0,0,0,1)
         Rect(-26, 6, 26, -6)
         Color(1,1,0,1)
         Rect(-25, 5, -25 + 50*(p.capture / captureTime), -5)
         PopMatrix()
      end
   end
   Color(1,1,1,1)
end

function gadget:DrawWorld()
   gl.DepthTest(GL.LEQUAL)
   gl.PolygonOffset(-10,-10)
   DrawPoints()
   gl.DepthTest(false)
   gl.PolygonOffset(false)
end

function gadget:DrawInMiniMap(mmx, mmy)
   PushMatrix()
   gl.LoadIdentity()
   Translate(0,1,0)
   Scale(1/Game.mapSizeX, 1/Game.mapSizeZ, 1)
   Rotate(90,1,0,0)
   DrawPoints()
   PopMatrix()
end

local name={}

function gadget:DrawScreen(vsx, vsy)
   local frame = Spring.GetGameFrame()
   if frame / 1800 > startTime then
      local me = Spring.GetLocalAllyTeamID()
      Text("Your Score: "..SYNCED.score[me], vsx - 280, vsy * .58, 16, "lo")
      local n = 1
      for a,s in spairs(SYNCED.score) do
         if not name[a] then
            for _,p in ipairs(Spring.GetPlayerList()) do
               local pn,_,_,_,at = Spring.GetPlayerInfo(p)
               if at == a then
                  name[a] = pn
               end
               break
            end
            if not name[a] or name[a]=="Opponent" then
               name[a] = "Opponent"
            end
         end
         if a ~= me and a ~= gaia then
            Text("<"..name[a].."> "..s, vsx - 240, vsy * .58 - 20 * n, 12, "l")
            n = n + 1
         end
      end
      if SYNCED.dom.dominator and SYNCED.dom.dominationTime > Spring.GetGameFrame() then
         Text("<"..name[SYNCED.dom.dominator].."> will score a Domination in "..math.floor((SYNCED.dom.dominationTime - Spring.GetGameFrame())/30).." seconds!", vsx*.5, vsy *.7, 24, "oc")
      end
   else
      Text("Capturing points begins in:", vsx - 280, vsy * .58, 16, "lo")
     local timeleft = startTime * 60 - frame / 30
     timeleft = timeleft - timeleft % 1
     Text(timeleft .. " seconds", vsx - 280, vsy * .58 - 25, 16, "lo")
   end
end

end
