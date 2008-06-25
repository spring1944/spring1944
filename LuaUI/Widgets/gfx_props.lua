function widget:GetInfo()
  return {
    name      = "1944 Propeller FX",
    desc      = "Draws motion-blurred propellers on aircraft",
    author    = "Zpock",
    date      = "19th january, 2008",
    license   = "free 4 all",
    layer     = 10000,
    enabled   = true  --  loaded by default?
  }
end

function widget:DrawWorld()
	local size = 10
	local units = Spring.GetAllUnits()
	
	for key, value in pairs(units) do
		local type = Spring.GetUnitDefID(value)
		
		if(type ~= nil) then
			if (UnitDefs[type]["canFly"] == true) then
			
			local pieces = Spring.GetUnitPieceList(value)
			
			for key1, value1 in pairs(pieces) do
				if(string.sub(value1,1,9) == 'propeller') then
					if(Spring.GetCOBUnitVar(value, 0) == 1) then
						gl.DepthTest(true)
					
						gl.PushMatrix()
					
						gl.UnitMultMatrix(value)
						gl.UnitPieceMultMatrix(value,key1)
					
							if(UnitDefs[type]["customParams"]["proptexture"] == nil) then							
								gl.Texture('bitmaps/prop.tga')
							else
								gl.Texture(UnitDefs[type]["customParams"]["proptexture"])	
							end
					
						    gl.BeginEnd(GL.QUADS, function()
    						gl.TexCoord(0,0)
							gl.Vertex(size,size,0)
    						gl.TexCoord(1,0)
							gl.Vertex(-size,size,0)
    						gl.TexCoord(1,1)
							gl.Vertex(-size,-size,0)
    						gl.TexCoord(0,1)
							gl.Vertex(size,-size,0)
  							end)
  						gl.PopMatrix()
					end
				end
			end
				
			end
		end			
	end
end

