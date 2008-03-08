function widget:GetInfo()
  return {
    name      = "Spring 1944 Low Ammo Icon",
    desc      = "Draws no ammo icon when units run low on ammo",
    author    = "SH",
    date      = "Long, long ago",
    license   = "GPL",
    layer     = 10000,
    enabled   = true  --  loaded by default?
  }
end

function widget:DrawWorld()
	local size = 10
	local units = Spring.GetAllUnits()
	
	--for key, value in pairs(units) do
	--	local type = Spring.GetUnitDefID(value)
		
	--	if(type ~= nil) then
			
			local pieces = Spring.GetUnitPieceList(value)
			
	--		for key1, value1 in pairs(pieces) do
					gl.DepthTest(true)
					
					gl.PushMatrix()
					
					gl.UnitMultMatrix(value)
					gl.UnitPieceMultMatrix(value,key1)
					
					gl.Texture('bitmaps/prop.tga')	
					
					gl.BeginEnd(GL.QUADS, 
						function()
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

