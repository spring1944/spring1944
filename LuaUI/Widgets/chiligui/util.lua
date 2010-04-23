--//=============================================================================

function unpack4(t)
  return t[1], t[2], t[3], t[4]
end

function clamp(min,max,num)
  if (num<min) then
    return min
  elseif (num>max) then
    return max
  end
  return num
end

function ExpandRect(rect,margin)
  return {
    rect[1] - margin[1],              --//left
    rect[2] - margin[2],              --//top
    rect[3] + margin[1] + margin[3], --//width
    rect[4] + margin[2] + margin[4], --//height
  }
end

function InRect(rect,x,y)
  return x>=rect[1]         and y>=rect[2] and
         x<=rect[1]+rect[3] and y<=rect[2]+rect[4]
end

--//=============================================================================

function AreRectsOverlapping(rect1,rect2)
  return (rect1[2]+rect1[4] >= rect2[2]) and
   (rect1[2] <= rect2[2]+rect2[4]) and
   (rect1[1]+rect1[3] >= rect2[1]) and
   (rect1[1] <= rect2[1]+rect2[3]) 
end

--//=============================================================================

local oldPrint = print
function print(...)
  oldPrint(...)
  io.flush()
end


function InvertColor(c)
  return {1 - c[1], 1 - c[2], 1 - c[3], c[4]}
end

--//=============================================================================

function table:map(fun)
  local newTable = {}
  for key, value in pairs(self) do
    newTable[key] = fun(key, value)
  end
  return newTable
end

function table:shallowcopy()
  local newTable = {}
  for k, v in pairs(self) do
    newTable[k] = v
  end
  return newTable
end

function table:arrayshallowcopy()
  local newArray = {}
  for i=1, #self do
    newArray[i] = self[i]
  end
end

function table:arraymap(fun)
  for i=1, #self do
    newTable[i] = fun(self[i])
  end
end

function table:fold(fun, state)
  for key, value in pairs(self) do
    fun(state, key, value)
  end
end

function table:arrayreduce(fun)
  local state = self[1]
  for i=2, #self do
    state = fun(state , self[i])
  end
  return state
end

-- removes and returns element from array
-- array, T element -> T element
function table:arrayremovefirst(element)
  for i=1, #self do
    if self[i] == element then
      return self:remove(i)
    end
  end
end

--//=============================================================================
