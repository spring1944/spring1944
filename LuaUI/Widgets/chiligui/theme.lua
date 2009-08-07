--//=============================================================================
--// Theme

theme = {}

theme.defaultFont     = "LuaUI/Fonts/FreeSansBold_14"
theme.defaultFontSize = 11
theme.defaultTextColor= {0,0,0,1}

theme.padding         = {5, 5, 5, 5} -- padding: left, top, right, bottom
theme.borderThickness = 1.5
theme.borderColor1    = {1,1,1,0.6}
theme.borderColor2    = {0,0,0,0.8}
theme.backgroundColor = {0.8, 0.8, 1, 0.3}

theme.imageplaceholder = "luaui/images/placeholder.png"
theme.imageFolder      = "luaui/images/folder.png"
theme.imageFolderUp    = "luaui/images/folder_up.png"

local glColor  = gl.Color
local glVertex = gl.Vertex

function theme.DrawBorder_(x,y,w,h,bt,color1,color2)
  glColor(color1)
  glVertex(x,     y+h)
  glVertex(x+bt,  y+h-bt)
  glVertex(x,     y)
  glVertex(x+bt,  y)
  glVertex(x+bt,  y)
  glVertex(x+bt,  y+bt)
  glVertex(x+w,   y)
  glVertex(x+w-bt,y+bt)

  glColor(color2)
  glVertex(x+w-bt,y+bt)
  glVertex(x+w,   y)
  glVertex(x+w-bt,y+h)
  glVertex(x+w,   y+h)
  glVertex(x+w-bt,y+h-bt)
  glVertex(x+w-bt,y+h)
  glVertex(x+bt,  y+h-bt)
  glVertex(x+bt,  y+h)
  glVertex(x,     y+h)
end


function theme.DrawBorder(obj,state)
  local x,y = obj.x, obj.y
  local w,h = obj.width, obj.height
  local bt = obj.borderThickness

  glColor((state=='pressed' and obj.borderColor2) or obj.borderColor1)
  glVertex(x,     y+h)
  glVertex(x+bt,  y+h-bt)
  glVertex(x,     y)
  glVertex(x+bt,  y)
  glVertex(x+bt,  y)
  glVertex(x+bt,  y+bt)
  glVertex(x+w,   y)
  glVertex(x+w-bt,y+bt)

  glColor((state=='pressed' and obj.borderColor1) or obj.borderColor2)
  glVertex(x+w-bt,y+bt)
  glVertex(x+w,   y)
  glVertex(x+w-bt,y+h)
  glVertex(x+w,   y+h)
  glVertex(x+w-bt,y+h-bt)
  glVertex(x+w-bt,y+h)
  glVertex(x+bt,  y+h-bt)
  glVertex(x+bt,  y+h)
  glVertex(x,     y+h)
end


function theme.DrawBackground(obj)
  local x,y = obj.x, obj.y
  local w,h = obj.width, obj.height

  glColor(obj.backgroundColor)
  glVertex(x,   y)
  glVertex(x,   y+h)
  glVertex(x+w, y)
  glVertex(x+w, y+h)
end


local function DrawCheck(rect)
  local x,y,w,h = rect[1],rect[2],rect[3],rect[4]
  glVertex(x+w*0.25, y+h*0.5)
  glVertex(x+w*0.125,y+h*0.625)
  glVertex(x+w*0.375,y+h*0.625)
  glVertex(x+w*0.375,y+h*0.875)
  glVertex(x+w*0.75, y+h*0.25)
  glVertex(x+w*0.875,y+h*0.375)
end


function theme.DrawCheckbox(obj, rect, state)
  glColor(obj.backgroundColor)
  gl.Rect(rect[1]+1,rect[2]+1,rect[1]+1+rect[3]-2,rect[2]+1+rect[4]-2)

  gl.BeginEnd(GL.TRIANGLE_STRIP, theme.DrawBorder_, rect[1],rect[2],rect[3],rect[4], 1, obj.borderColor1, obj.borderColor2)

  if (obj.checked) then
    gl.BeginEnd(GL.TRIANGLE_STRIP,DrawCheck,rect)
  end
end


function theme.DrawTrackbar(x,y,w,h,percent,state,color)
  glColor(color)
  gl.Rect(x,y+h*0.5,x+w,y+h*0.5+1)

  local vc = y+h*0.5 --//verticale center
  local pos = x+percent*w

  glColor(color)
  gl.Rect(pos-2,vc-h*0.5,pos+2,vc+h*0.5)
end


function theme.DrawScrollbar(type, x,y,w,h, pos, visiblePercent, state)
  glColor(theme.backgroundColor)
  gl.Rect(x,y,x+w,y+h)

  if (type=='horizontal') then
    local gripx,gripw = x+w*pos, w*visiblePercent
    gl.BeginEnd(GL.TRIANGLE_STRIP, theme.DrawBorder_, gripx,y,gripw,h, 1, theme.borderColor1, theme.borderColor2)
  else
    local gripy,griph = y+h*pos, h*visiblePercent
    gl.BeginEnd(GL.TRIANGLE_STRIP, theme.DrawBorder_, x,gripy,w,griph, 1, theme.borderColor1, theme.borderColor2)
  end
end


function theme.DrawSelectionItemBkGnd(x,y,w,h,state)
  if (state=="selected") then
    glColor(0.15,0.15,0.9,1)   
  else
    glColor({0.8, 0.8, 1, 0.45})
  end
  gl.Rect(x,y,x+w,y+h)

  gl.BeginEnd(GL.TRIANGLE_STRIP, theme.DrawBorder_, x,y,w,h, 1, theme.borderColor1, theme.borderColor2)
end