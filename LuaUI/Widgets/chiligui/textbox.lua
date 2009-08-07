TextBox = Control:Inherit{
  classname = "textbox",
  align     = "centered",
  valign    = "bottom",
  text      = "line1\nline2",
  lineSpacing = 3,
  autoHeight  = true, -- sets height to text size, useful for embedding in scrollboxes
  fontSize = 12,
}

local fontHandler = fh

local this = TextBox
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function Split(s, separator)
  local results = {}
  for part in s:gmatch("[^"..separator.."]+") do
    results[#results + 1] = part
  end
  return results
end

-- remove first n elemets from t, return them
local function Take(t, n)
  local removed = {}
  for i=1, n do
    removed[#removed+1] = table.remove(t, 1)
  end
  return removed
end

-- appends t1 to t2 in-place
local function Append(t1, t2)
  local l = #t1
  for i = 1, #t2 do
    t1[i + l] = t2[i]
  end
end

local function WordWrap(text, font, maxWidth, size)
  fontHandler.UseFont(font)
  text = text:gsub("\r\n", "\n")
  local spaceWidth = fontHandler.GetTextWidth(" ", size)
  local allLines = {}
  local paragraphs = Split(text, "\n")
  for _, paragraph in ipairs(paragraphs) do
    lines = {}
    local words = Split(paragraph, "%s")
    local widths = {}
    for i, word in ipairs(words) do
      -- todo: when we use the real fonthandler, strip colors
      widths[i] = fontHandler.GetTextWidth(word, size)
    end
    repeat
      local width = 0
      local i = 1
      for j=1, #words do
        newWidth = width + widths[j]
        if (newWidth > maxWidth) then
          break
        else
          width = newWidth + spaceWidth
        end
        i = j
      end
      Take(widths, i)
      lines[#lines+1] = table.concat(Take(words, i), " ")
    until (i > #words)
    if (#words > 0) then
      lines[#lines+1] = table.concat(words, " ")
    end
    Append(allLines, lines)
  end
  return allLines
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function TextBox:UpdateLayout()
  if #self.children > 0 then 
    error"textbox does not support children"
  end
  if self.autoHeight then
    local padding = self.padding
    local width = self.width - padding[1] - padding[3]
    self.lines = WordWrap(self.text, self.font, width, self.fontSize)
    local textHeight = self.fontSize*#self.lines + self.lineSpacing*(#self.lines - 1)
    self:Resize(self.width, textHeight + padding[2] + padding[4])
  end
end

function TextBox:Draw()
  fontHandler.UseFont(self.font)
  local x, y, width, height = unpack4(self.clientArea)
  x,y = self.x + x,self.y + y
  gl.Color(self.textColor)
  for i=1, #self.lines do
    local textY = (self.fontSize + self.lineSpacing) * (i-1) + self.padding[1]
    fontHandler.Draw(self.lines[i], x, textY, self.fontSize)
  end
end
