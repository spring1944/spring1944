function widget:GetInfo()
  return {
    name      = "1944 Aircraft Sounds",
    desc      = "Advanced doppler-sound fx for aircraft",
    author    = "Zpock",
    date      = "19th january, 2008",
    license   = "free 4 all",
    layer     = 10000,
    enabled   = true  --  loaded by default?
  }
end

local timer2 = Spring.GetTimer()

function widget:DrawWorld()

	local timer1 = Spring.GetTimer()
	if(Spring.DiffTimers(timer1, timer2) > .25)then
		--Spring.Echo(Spring.DiffTimers(timer1, timer2))
		timer2 = timer1
	
		local units = Spring.GetAllUnits()
	
	
		for key, value in pairs(units) do
			local type = Spring.GetUnitDefID(value)
		
			if(type ~= nil) then
				if (UnitDefs[type]["customParams"]["enginesound"] ~= nil) then
        			local xp, yp, zp = Spring.GetUnitPosition(value)
        			local xv, yv, zv = Spring.GetUnitVelocity(value)
        			local xc, yc, zc = Spring.GetCameraPosition()
        			local xd = xp - xc
        			local yd = yp - yc
        			local zd = zp - zc
        			local range = math.sqrt(xd^2+yd^2+zd^2)
        			local speed = math.sqrt(xv^2+yv^2+zv^2)
        			local xr = xd/range
           			local yr = yd/range
           			local zr = zd/range
           			local dotp = xr*xv + yr*yv + zr*zv

        			--local sound = 'sounds/'..UnitDefs[type]["customParams"]["enginesound"]..math.floor(UnitDefs[type]["customParams"]["enginesoundnr"]/2*(30*dotp+UnitDefs[type]["speed"])/UnitDefs[type]["speed"])..".wav"
        			if(math.floor((UnitDefs[type]["customParams"]["enginesoundnr"]-2)/2*(1-2*math.random()+dotp+speed)/speed+2) > 0 and
					math.floor((UnitDefs[type]["customParams"]["enginesoundnr"]-2)/2*(1-2*math.random()+dotp+speed)/speed+2) <= UnitDefs[type]["customParams"]["enginesoundnr"]+0) then
						local sound = 'sounds/engine/'..UnitDefs[type]["customParams"]["enginesound"]..math.floor((UnitDefs[type]["customParams"]["enginesoundnr"]-2)/2*(1-2*math.random()+dotp+speed)/speed+2)..".wav"
						Spring.PlaySoundFile(sound,3,xp,yp,zp)
						--Spring.Echo(sound)
					end
				end
			end
		end
	end
end

