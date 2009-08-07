--//=============================================================================
--// FontSystem

fh = {}

function fh.UseFont(fontname)
end

function fh.GetTextWidth(text, size) 
  return gl.GetTextWidth(text) * size
end

fh.StripColors = fontHandler.StripColors

function fh.Draw(text, x, y, size)
  gl.PushMatrix()
  gl.Translate(x,y+size,0)
  gl.Scale(1,-1,1)
  gl.Text(text,0,0,size,'n')
  gl.PopMatrix()
end

function fh.DrawRight(text, x, y, size)
  gl.PushMatrix()
  gl.Translate(x,y+size,0)
  gl.Scale(1,-1,1)
  gl.Text(text,0,0,size,'nr')
  gl.PopMatrix()
end

function fh.DrawCentered(text, x, y, size)
  gl.PushMatrix()
  gl.Translate(x,y+size,0)
  gl.Scale(1,-1,1)
  gl.Text(text,0,0,size,'nc')
  gl.PopMatrix()
end