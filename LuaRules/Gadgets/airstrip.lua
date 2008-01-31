function gadget:GetInfo()
	return {
		name      = "Airstrip",
		desc      = "Controls takeoff/landing",
		author    = "Zpock",
		date      = "2008",
		license   = "free4all",
		layer     = 555,
		enabled   = true  --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then

local airstrips = {}
local planes = {}
local vel = 1
local rot = 0.02

	function gadget:Initialize()

	end


	function gadget:GameFrame(n)
		for key, value in pairs(airstrips) do
		 	local xc, yc, zc = Spring.GetUnitPosition(value.id)
			if(xc == nil)then
			--table.remove(airstrips,key)
				airstrips[key] = nil
			end
			
		end
		for key, value in pairs(planes) do
		
		local xg, yg, zg = Spring.GetUnitPosition(value.home)
		local xb,yb,zb = Spring.GetUnitPosition(value.id)
		if(xb == nil)then
			airstrips[value.home].tax[value.locy][value.locx] = 0
			--table.remove(planes,key)
			planes[key] = nil
		end
		if(xg == nil)then
			Spring.DestroyUnit(value.id)
			--table.remove(planes,key)
			planes[key] = nil
		end
		
		--Spring.Echo(key,value.id)
		
		if(xg ~= nil and xb ~= nil) then	
		if(value.flying == 1) then		
			local state = Spring.GetUnitStates(value.id)
			if(state.autoland == true) then
				local cq = Spring.GetUnitCommands(value.id)
				if(cq[1] == nil) then
					local x, y, z = Spring.GetUnitPosition(value.home)
					local xp,yp,zp = Spring.GetUnitPosition(value.id)
					local range = (x-xp)^2 + (z-zp)^2
					if(range > 100) then
						Spring.GiveOrderToUnit(value.id, CMD.MOVE,{x,y,z},{})
					else
						if(airstrips[value.home].tax[1][1] == 0) then
							Spring.MoveCtrl.Enable(value.id)
							value.wantfly = 0
							value.flying = 0
							value.task = 20
							airstrips[value.home].tax[1][1] = 1
							value.locy = 1
     		        		value.locx = 1
						else
							Spring.GiveOrderToUnit(value.id, CMD.MOVE,{x+math.random()*1000-500,y,z+math.random()*1000-500},{})
						end
					end
				else 
					if(cq[1]["id"] == CMD.MOVE) then
						local x, y, z = Spring.GetUnitPosition(value.home)
						if(cq[1]["params"][1] == x) then
						if(cq[1]["params"][2] == y) then
						if(cq[1]["params"][3] == z) then
							
							local xp,yp,zp = Spring.GetUnitPosition(value.id)
							local range = (x-xp)^2 + (z-zp)^2
							if(range < 100) then
								Spring.GiveOrderToUnit(value.id, CMD.STOP,{},{})															
							end
							
						end
						end
						end
					end					
				end
			end
		else
			if(value.task == 20) then
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
				
				Spring.MoveCtrl.SetVelocity(value.id,10*xh,10*yh,10*zh)
				
				Spring.MoveCtrl.SetRotationVelocity(value.id,0,0.04,0)
				Spring.CallCOBScript(value.id,"bankleft", 0)
				if(Spring.GetUnitHeading(value.id)>16000 and Spring.GetUnitHeading(value.id) <16500) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    value.task = 21
				end
					
			end
			
			if(value.task == 21) then
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
				local x,y,z = Spring.GetUnitPosition(value.home)
				Spring.MoveCtrl.SetVelocity(value.id,10*xh,10*yh,10*zh)
				
				if(xp - x > 3000) then
				    value.task = 22
				end
					
			end
			
			if(value.task == 22) then
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
				local x,y,z = Spring.GetUnitPosition(value.home)

				Spring.MoveCtrl.SetVelocity(value.id,10*xh,10*yh,10*zh)
				
				Spring.MoveCtrl.SetRotationVelocity(value.id,0,0.04,0)
				Spring.CallCOBScript(value.id,"bankleft", 0)
				if(Spring.GetUnitHeading(value.id)<-16000 and Spring.GetUnitHeading(value.id) >-16500) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    value.task = 23
				    value.altitude = yp-y
				    value.distance = xp-x-400
				    Spring.CallCOBScript(value.id,"gearsdown", 0)
				end
					
			end
			
			if(value.task == 23) then
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
				local x,y,z = Spring.GetUnitPosition(value.home)
				Spring.MoveCtrl.SetVelocity(value.id,-10,-10*value.altitude/value.distance,0)
				
				if(xp - x < 2000) then
				if((zp-z +100)^2>10) then
				if(zp-z >-100) then
					Spring.MoveCtrl.SetVelocity(value.id,-10,-10*value.altitude/value.distance, -3)
				else
					Spring.MoveCtrl.SetVelocity(value.id,-10,-10*value.altitude/value.distance, 3)
				end
				end
				end
				
				if(yp - y < value.clearance+3) then
					Spring.PlaySoundFile('sounds/land.wav',3,xp,yp,zp)
					
				    Spring.MoveCtrl.SetRotation(value.id,-math.pi/16,-math.pi/2,0)
				    Spring.MoveCtrl.SetPosition(value.id,xp,y+value.clearance,zp)
				    Spring.MoveCtrl.SetVelocity(value.id,-10,0,0)
					value.task = 24
				end
					
			end
			
			if(value.task == 24) then
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
				local x,y,z = Spring.GetUnitPosition(value.home)
				Spring.MoveCtrl.SetVelocity(value.id,-1-(xp-x+400)/80,0,0)
				
				if(xp - x < -400) then
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 25
				end
					
			end
			
			if(value.task == 25) then
				local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)>0) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 26
				end
     		end
			
			if(value.task == 26) then
				if(airstrips[value.home].tax[1][2] == 0) then
					value.task = 27
					airstrips[value.home].tax[1][2] = 1
					airstrips[value.home].tax[1][1] = 0
					value.locy = 1
     		        value.locx = 2					
				end
     		end
     		
     		if(value.task == 27) then
     			Spring.MoveCtrl.SetVelocity(value.id,0,0,1)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(zp-z > 400) then
					value.task = 28
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 28) then
     			local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)>16000) then
					Spring.Echo(Spring.GetUnitHeading(value.id))
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 29
				end
     		end
     		
     		if(value.task == 29) then
				if(airstrips[value.home].tax[4][1] == 0) then
					value.task = 2
					airstrips[value.home].tax[4][1] = 1
					airstrips[value.home].tax[1][2] = 0
					value.locy = 4
     		        value.locx = 1
				end
     		end
		
			if(value.task == 1) then
				if(airstrips[value.home].tax[4][1] == 0) then
				    local x,y,z = Spring.GetUnitPosition(value.home)
					local xp,yp,zp = Spring.GetUnitPosition(value.id)
					value.task = 2
					airstrips[value.home].tax[4][1] = 1
					value.locy = 4
     		        value.locx = 1
				end
     		end
     		
     		if(value.task == 2) then
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
     			Spring.MoveCtrl.SetVelocity(value.id,1,0,0)
				if(x-xp - 300 < 0) then
					value.task = 3
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 3) then
     		    if(airstrips[value.home].tax[3][value.locx] == 0) then
                     airstrips[value.home].tax[3][value.locx] = 1
                     airstrips[value.home].tax[4][value.locx] = 0
					 value.locy = 3
     		         value.task = 4
     		    else
     		    	if(airstrips[value.home].tax[4][value.locx+1] == 0) then
     		    	 airstrips[value.home].tax[4][value.locx+1] = 1
                     airstrips[value.home].tax[4][value.locx] = 0
					 value.locx = value.locx+1
     		         value.task = 7
     		    	
     		    	end
     		    end
     		end
     		
     		if(value.task == 4) then
     			local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)<0) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 5
				end
     		end
     		
     		if(value.task == 5) then
     			Spring.MoveCtrl.SetVelocity(value.id,0,0,-1)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(z-zp > -300) then
					value.task = 6
					Spring.CallCOBScript(value.id,"stopengine",0)
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 6) then
     		    if(value.wantfly == 1) then
     		        if(airstrips[value.home].tax[2][value.locx] == 0) then
     		        	airstrips[value.home].tax[2][value.locx] = 1
                    	airstrips[value.home].tax[3][value.locx] = 0
                    	value.locy = 2
                    	value.task = 8
                    	local xp,yp,zp = Spring.GetUnitPosition(value.id)
                    	Spring.PlaySoundFile('sounds/bomberstart.wav',3,xp,yp,zp)
                    	Spring.CallCOBScript(value.id,"startengine",0)
     		        end
     		    end
     		end
     		
     		if(value.task == 7) then
     			Spring.MoveCtrl.SetVelocity(value.id,1,0,0)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(x-xp - 400 + value.locx*100 < 0) then
					value.task = 3
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 8) then
     			Spring.MoveCtrl.SetVelocity(value.id,0,0,-1)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(z-zp > -200) then
					value.task = 9
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 9) then
     			local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)>-16000) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 10
				end
     		end
     		
     		if(value.task == 10) then
     			if(value.locx == 1) then
     			    value.task = 12
     			else
     		    	if(airstrips[value.home].tax[2][value.locx-1] == 0) then
     		    			airstrips[value.home].tax[2][value.locx-1] = 1
                     		airstrips[value.home].tax[2][value.locx] = 0
					 		value.locx = value.locx-1
     		         		value.task = 11
            		end
     		    end
     		end
     		
     		if(value.task == 11) then
     			Spring.MoveCtrl.SetVelocity(value.id,-1,0,0)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(x-xp - 400 + value.locx*100 > 0) then
					value.task = 10
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 12) then
     		    local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,-rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)>0) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 13
				end
     		end
     		
     		if(value.task == 13) then
     		    if(airstrips[value.home].tax[1][1] == 0) then
     		        airstrips[value.home].tax[1][1] = 1
                    airstrips[value.home].tax[2][1] = 0
                    value.locy = 1
                    value.locx = 1
                    value.task = 14
     		    end
     		end
     		
     		if(value.task == 14) then
     			Spring.MoveCtrl.SetVelocity(value.id,0,0,-1)
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				if(z-zp > 100) then
					value.task = 15
					Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				end
     		end
     		
     		if(value.task == 15) then
     			local xh, yh, zh = Spring.GetUnitDirection(value.id)
           Spring.MoveCtrl.SetRotationVelocity(value.id,0,-rot,0)
           Spring.MoveCtrl.SetVelocity(value.id,vel*xh,0,vel*zh)
				if(Spring.GetUnitHeading(value.id)<16000) then
				    Spring.MoveCtrl.SetRotationVelocity(value.id,0,0,0)
				    Spring.MoveCtrl.SetVelocity(value.id,0,0,0)
				    value.task = 16
				end
     		end
     		
            if(value.task == 16) then
     			local x,y,z = Spring.GetUnitPosition(value.home)
				local xp,yp,zp = Spring.GetUnitPosition(value.id)
				Spring.MoveCtrl.SetVelocity(value.id,(600+xp-x)/100,0,0)
				if(xp-x - 300 > 0) then
     				Spring.MoveCtrl.Disable(value.id)
     				airstrips[value.home].tax[1][1] = 0
     				value.locy = 1
                    value.locx = 3
     				
     				value.flying = 1
     				Spring.CallCOBScript(value.id,"gearsup", 0)
				end
     		end
     		
     	end	
   		end
   		end
	end

	function gadget:UnitFinished(unitID, unitDefID, teamID)
		if(UnitDefs[unitDefID]["customParams"]["airfield"] == '1') then
			table.insert(airstrips,unitID,{
				id=unitID,
				strip=0,
				tax={{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}})
		end
	end

	function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)

		if(UnitDefs[factDefID]["customParams"]["airfield"] == '1') then

		    local x,y,z = Spring.GetUnitPosition(factID)
			table.insert(planes,unitID,{
				id=unitID,
				flying=0,
				clearance = 3,
				locy=4,
				locx=1,
				task=1,
				wantfly=0,
    			timer=0,
    			altitude = 0,
    			distance = 0,
				home=factID})

            Spring.MoveCtrl.Enable(unitID)
            Spring.MoveCtrl.SetNoBlocking(unitID,true)
            Spring.MoveCtrl.SetCollideStop(unitID,false)
            Spring.MoveCtrl.SetPosition(unitID,x-450,y+3,z+400)
            Spring.MoveCtrl.SetRotation(unitID,-math.pi/16,math.pi/2,0)
            Spring.CallCOBScript(unitID,"gearsdown", 0)
            
--            Spring.MoveCtrl.SetVelocity(unitID,0,0,0)
		end
	end



	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		if(planes[unitID]~=nil) then
			planes[unitID].wantfly = 1
		end
	return true
	end
	
--	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
--	
--		if(UnitDefs[unitDefID]["customParams"]["airfield"] == '1') then
--		
--			for key, value in pairs(planes) do
--				if(planes[value.id].home == unitID) then
--					Spring.DestroyUnit(value.id)
--				end
--			end
--		
--		    table.remove(airstrips, unitID)
--		end
--		
--		for key1, value1 in pairs(planes) do
--			if(value1.id == unitID) then
--				if(value1.flying == 0) then
--					airstrips[value1.home].tax[value1.locy][value1.locx] = 0
--					Spring.Echo(value1.locy,value1.locx)
--				end
--				table.remove(planes, value1.id)
--			end
--		end
--	end




end
