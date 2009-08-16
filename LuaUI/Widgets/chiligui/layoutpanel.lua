--//=============================================================================
--// This control is the base of any auto-layout panel, this includes:
--//   grid, stackpanel, tables, itemlistview, listbox, radiogroups, ...
--//
--// Internal all childrens/items are handled via cells, which can be
--// freely aligned (table-grid, free movable like in imagelistviews, ...).
--//
--// Also most subclasses should use an items table to create their child
--// objects, so the user just define the captions, filenames, ... instead
--// of creating checkboxes, images, ... directly.
--// This doesn't affect simple containers like grids & stackcontrols, which
--// don't create any controls themselves (instead they just align their children).

LayoutPanel = Control:Inherit{
  classname = "layoutpanel",

  itemMargin    = {5, 5, 5, 5},
  itemPadding   = {5, 5, 5, 5},
  minItemWidth  = 0,
  maxItemWidth  = 0,
  minItemHeight = 0,
  maxItemHeight = 0,

  autoSize = false,

  rows = nil,
  columns = nil,
  orientation   = "horizontal", --// "horizontal" or "vertical"
  autoArrangeH  = false, --FIXME rename
  autoArrangeV  = false, --FIXME rename
  grid          = false, --// if true, each row should have the same number of columns (table layout)
  resizeItems   = false,
  centerItems   = true,

  selectable    = false,
  multiSelect   = true,
  selectedItems = {},

  OnSelect = {}, --FIXME
  OnDrawItem = {}, --FIXME
  OnDblClick = {}, --FIXME (move to control?)

  _rows = nil,
  _columns = nil,
  _cells = nil,
}

local this = LayoutPanel

--//=============================================================================

function LayoutPanel:New(obj)
  obj = (this.inherited).New(self,obj)
  if (obj.selectable) then
    obj.selectedItems = {[1]=true}
  end
  return obj
end

--//=============================================================================

function LayoutPanel:SetOrientation(orientation)
  self.orientation = orientation
  this.inherited.UpdateClientArea(self)
end

--//=============================================================================

local tsort = table.sort

--//=============================================================================

local function compareSizes(a,b)
  return a[2] < b[2]
end

function LayoutPanel:_JustCenterItemsH(startCell,endCell,freeSpace)
  local _cells = self._cells
  local perItemHalfAlloc = (freeSpace/2) / ((endCell+1) - startCell)
  for i=startCell,endCell do
    local cell = _cells[i]
    if (self.orientation == "horizontal") then
      cell[1] = cell[1] + perItemHalfAlloc
    else
      cell[2] = cell[2] + perItemHalfAlloc
    end
  end
end

function LayoutPanel:_JustCenterItemsV(startCell,endCell,freeSpace)
--[[
  local _cells = self._cells
  local perItemHalfAlloc = (freeSpace/2) / ((endCell+1) - startCell)
  for i=startCell,endCell do
    local cell = _cells[i]
    if (self.orientation == "horizontal") then
      cell[2] = cell[2] + perItemHalfAlloc
    else
      cell[1] = cell[1] + perItemHalfAlloc
    end
  end
--]]
end

function LayoutPanel:_AutoArrangeAbscissa(startCell,endCell,freeSpace)
  if (startCell > endCell) then
    return
  end

  if (not self.autoArrangeH) then
    if (self.centerItems) then
      self:_JustCenterItemsH(startCell,endCell,freeSpace)
    end
    return
  end

  local _cells = self._cells

  if (startCell == endCell) then
    local cell = self._cells[startCell]
    if (self.orientation == "horizontal") then
      cell[1] = cell[1] + freeSpace/2
    else
      cell[2] = cell[2] + freeSpace/2
    end
    return
  end

  --// create a sorted table with the cell sizes
  local cellSizesCount = 0
  local cellSizes = {}
  for i=startCell,endCell do
    cellSizesCount = cellSizesCount + 1
    if (self.orientation == "horizontal") then
      cellSizes[cellSizesCount] = {i,_cells[i][3]}
    else
      cellSizes[cellSizesCount] = {i,_cells[i][4]}
    end
  end
  tsort(cellSizes,compareSizes)

  --// upto this index all cells have the same size (in the cellSizes table)
  local sameSizeIdx = 1
  local shortestCellSize = cellSizes[1][2]

  while (freeSpace>0)and(sameSizeIdx<cellSizesCount) do

    --// detect the cells, which have the same size
    for i=sameSizeIdx+1,cellSizesCount do
      if (cellSizes[i][2] ~= shortestCellSize) then
        break
      end
      sameSizeIdx = sameSizeIdx + 1
    end

    --// detect 2. shortest cellsize
    local nextCellSize = 0
    if (sameSizeIdx >= cellSizesCount) then
      nextCellSize = self.maxItemWidth --FIXME orientation
    else
      nextCellSize = cellSizes[sameSizeIdx+1][2]
    end


    --// try to fillup the shorest cells to the 2. shortest cellsize (so we can repeat the process on n+1 cells)
    --// (if all/multiple cells have the same size share the freespace between them)
    local spaceToAlloc = shortestCellSize - nextCellSize
    if (spaceToAlloc > freeSpace) then
      spaceToAlloc = freeSpace
      freeSpace    = 0
    else
      freeSpace    = freeSpace - spaceToAlloc
    end
    local perItemAlloc = (spaceToAlloc / sameSizeIdx)


    --// set the cellsizes/share the free space between cells
    for i=1,sameSizeIdx do
      local celli = cellSizes[i]
      celli[2] = celli[2] + perItemAlloc --FIXME orientation

      local cell = _cells[ celli[1] ]
      cell[3] = cell[3] + perItemAlloc --FIXME orientation

      --// adjust the top/left startcoord of all following cells (in the line)
      for j=celli[1]+1,endCell do
        local cell = _cells[j]
        cell[1] = cell[1] + perItemAlloc --FIXME orientation
      end
    end

    shortestCellSize = nextCellSize

  end
end


function LayoutPanel:_AutoArrangeOrdinate(freeSpace)
  if (not self.autoArrangeV) then
    if (self.centerItems) then
      self:_JustCenterItemsV(freeSpace)
    end
    return
  end

  local _lines = self._lines
  local _cells = self._cells

  --// create a sorted table with the line sizes
  local lineSizes = {}
  for i=1,#_lines do
    local first_cell_in_line = _cells[ _lines[i] ]
    if (self.orientation == "horizontal") then --FIXME
      lineSizes[i] = {i,first_cell_in_line[4]}
    else
      lineSizes[i] = {i,first_cell_in_line[3]}
    end
  end
  tsort(lineSizes,compareSizes)
  local lineSizesCount = #lineSizes

  --// upto this index all cells have the same size (in the cellSizes table)
  local sameSizeIdx = 1
  local shortestLineSize = lineSizes[1][2]

  while (freeSpace>0)and(sameSizeIdx<lineSizesCount) do

    --// detect the lines, which have the same size
    for i=sameSizeIdx+1,lineSizesCount do
      if (lineSizes[i][2] ~= shortestLineSize) then
        break
      end
      sameSizeIdx = sameSizeIdx + 1
    end

    --// detect 2. shortest linesize
    local nextLineSize = 0
    if (sameSizeIdx >= lineSizesCount) then
      nextLineSize = self.maxItemHeight --FIXME orientation
    else
      nextLineSize = lineSizes[sameSizeIdx+1][2]
    end


    --// try to fillup the shorest lines to the 2. shortest linesize (so we can repeat the process on n+1 lines)
    --// (if all/multiple have the same size share the freespace between them)
    local spaceToAlloc = shortestLineSize - nextLineSize
    if (spaceToAlloc > freeSpace) then
      spaceToAlloc = freeSpace
      freeSpace    = 0
    else
      freeSpace    = freeSpace - spaceToAlloc
    end
    local perItemAlloc = (spaceToAlloc / sameSizeIdx)


    --// set the linesizes
    for i=1,sameSizeIdx do
      local linei = lineSizes[i]
      linei[2] = linei[2] + perItemAlloc --FIXME orientation

      --// adjust the top/left startcoord of all following lines (in the line)
      local nextLineIdx = linei[1]+1
      local nextLine = ((nextLineIdx <= #_lines) and _lines[ nextLineIdx ]) or #_cells+1
      for j=_lines[ linei[1] ],nextLine-1 do
        local cell = _cells[j]
        cell[4] = cell[4] + perItemAlloc --FIXME orientation
      end
      for j=nextLine,#_cells do
        local cell = _cells[j]
        cell[2] = cell[2] + perItemAlloc --FIXME orientation
      end
    end

    shortestLineSize = nextLineSize

  end
end

--//=============================================================================

function LayoutPanel:UpdateLayout()
  local cn = self.children
  local cn_count = #cn

  if (cn_count==0) then
    return
  end

  --FIXME add check if any item.width > maxItemWidth (+Height)

  if (self.resizeItems) then
    local max_ix = math.floor(self.clientArea[3]/self.minItemWidth)
    local max_iy = math.floor(self.clientArea[4]/self.minItemHeight)

    if (max_ix*max_iy < cn_count)or
       (max_ix<(self.columns or 0))or
       (max_iy<(self.rows or 0))
    then
      --FIXME add autoEnlarge/autoAdjustSize?
      error"LayoutPanel: not enough space"
    end

    --FIXME take minWidth/height maxWidth/Height into account! (and try to reach a 1:1 pixel ratio)
    if self.columns and self.rows then
      self._columns = self.columns
      self._rows    = self.rows
    elseif (not self.columns) and self.rows then
      self._columns = math.ceil(cn_count/self.rows)
      self._rows    = self.rows
    elseif (not self.rows) and self.columns then
      self._columns = self.columns
      self._rows    = math.ceil(cn_count/self.columns)
    else
      local size    = math.ceil(cn_count^0.5)
      self._columns = size
      self._rows    = size
    end

    local childWidth  = self.clientArea[3]/self._columns
    local childHeight = self.clientArea[4]/self._rows

    self._cells  = {}
    local _cells = self._cells

    local dir1,dir2
    if (self.orientation == "vertical") then
      dir1,dir2 = self._columns,self._rows
    else
      dir1,dir2 = self._rows,self._columns
    end

    local n,x,y=1
    for i=1, dir1 do
      for j=1, dir2 do
        local child = cn[n]
        if not child then break end
        local margin = child.margin or self.itemMargin

        if (self.orientation == "vertical") then
          x,y = i,j
        else
          x,y = j,i
        end

        child:SetPos(
          childWidth * (x-1) + margin[1],
          childHeight * (y-1) + margin[2],
          childWidth - margin[1] - margin[3],
          childHeight - margin[2] - margin[4]
        )
	_cells[n] = {
          childWidth * (x-1) + margin[1],
          childHeight * (y-1) + margin[2],
          childWidth - margin[1] - margin[3],
          childHeight - margin[2] - margin[4]
        }

        n = n+1
      end
    end

  else

    local clientAreaWidth,clientAreaHeight = self.clientArea[3],self.clientArea[4]

    self._lines  = {1}
    local _lines = self._lines
    self._cells  = {}
    local _cells = self._cells

    local itemMargin  = self.itemMargin
    local itemPadding = self.itemPadding

    local x,y = 0,0
    local curLine, curLineSize = 1,self.minItemHeight
    local totalChildWidth,totalChildHeight = 0
    local cell_left,cell_top,cell_width,cell_height = 0,0,0,0

    for i=1, #cn do
      --FIXME use orientation!

      local child = cn[i]
      if not child then break end
      local margin = child.margin or itemMargin

      local childWidth  = math.max(child.width,self.minItemWidth)
      local childHeight = math.max(child.height,self.minItemHeight)

      totalChildWidth  = margin[1] + itemPadding[1] + childWidth  + itemPadding[3] + margin[3]
      totalChildHeight = margin[2] + itemPadding[2] + childHeight + itemPadding[4] + margin[4]

      cell_top    = y + margin[2] + itemPadding[2]
      cell_left   = x + margin[1] + itemPadding[1]
      cell_width  = childWidth
      cell_height = childHeight

      x = x + totalChildWidth

      --FIXME check if the child is too large for the client area

      if (x > clientAreaWidth)
       --or(y+child.height+margin[4] > clientAreaHeight) --FIXME
      then
        self:_AutoArrangeAbscissa(_lines[curLine], i-1, clientAreaWidth - (x - totalChildWidth))

        x = totalChildWidth
        y = y + curLineSize

        curLine,curLineSize = curLine+1,self.minItemHeight
        _lines[curLine] = i
        cell_top  = y + margin[2] + itemPadding[2]
        cell_left = margin[1] + itemPadding[1]
      end

      _cells[i] = {cell_left,cell_top,cell_width,cell_height}


      if (totalChildHeight > curLineSize) then
        curLineSize = totalChildHeight
      end
    end

    self:_AutoArrangeAbscissa(_lines[curLine], #cn, clientAreaWidth - x)
    self:_AutoArrangeOrdinate(clientAreaHeight - (y + curLineSize))

    if (y+curLineSize > clientAreaHeight) then
      if (self.autoSize) then
        clientAreaHeight = y+curLineSize
        self.clientArea[4] = clientAreaHeight
        self.height = self.padding[2] + clientAreaHeight +  self.padding[4]
        --self.parent.UpdateClientArea(self.parent)
      else
        Spring.Echo(debug.traceback())
        error(self.classname .. ": not enough vertical space")
      end
    end

    local curLine = 1

    for i=1, #cn do
      local child = cn[i]
      if not child then break end

      local cell = _cells[i]

      local cposx,cposy = cell[1],cell[2]
      if (self.centerItems) then
        cposx = cposx + (cell[3] - child.width) * 0.5
        cposy = cposy + (cell[4] - child.height) * 0.5
      end

      child:SetPos(cposx,cposy)
    end

    if (self.autoSize) then
      clientAreaHeight = y+curLineSize
      self.clientArea[4] = clientAreaHeight
      self.height = self.padding[2] + clientAreaHeight +  self.padding[4]
    end

  end

  self:RealignChildren()
end

--//=============================================================================

function LayoutPanel:DrawBackground()
end

function LayoutPanel:DrawItemBkGnd(index)
end

function LayoutPanel:DrawControl()
  self:DrawBackground(self)
end


function LayoutPanel:DrawChildren()
  local cn = self.children
  if (#cn==0) then return end

  local cells = self._cells
  local selectedItems = self.selectedItems
  local itemPadding = self.itemPadding

  gl.PushMatrix()
  gl.Translate(self.x + self.clientArea[1],self.y + self.clientArea[2],0)

  for i=1,#cn do
    local child = cn[i]
    self:DrawItemBkGnd(i)
    child:Draw()
  end

  if (self.debug) then
    gl.Color(1,0,0,0.6)
    for i=1,#self._cells do
      local cell = self._cells[i]
      gl.Rect(cell[1],cell[2],cell[1]+cell[3],cell[2]+cell[4])
    end
    gl.Color(1,1,1,1)
  end

  gl.PopMatrix()
end

function LayoutPanel:DrawChildrenForList()
  local cn = self.children
  if (#cn==0) then return end

  local cells = self._cells
  local selectedItems = self.selectedItems
  local itemPadding = self.itemPadding

  gl.PushMatrix()
  gl.Translate(self.x + self.clientArea[1],self.y + self.clientArea[2],0)

  for i=1,#cn do
    local child = cn[i]
    self:DrawItemBkGnd(i)
    child:DrawForList(true)
  end

  if (self.debug) then
    gl.Color(1,0,0,0.6)
    for i=1,#self._cells do
      local cell = self._cells[i]
      gl.Rect(cell[1],cell[2],cell[1]+cell[3],cell[2]+cell[4])
    end
    gl.Color(1,1,1,1)
  end

  gl.PopMatrix()
end

--//=============================================================================

function LayoutPanel:GetItemIndexAt(cx,cy)
  local cells = self._cells
  local itemPadding = self.itemPadding
  for i=1,#cells do
    local cell  = cells[i]
    local cellbox = ExpandRect(cell,itemPadding)
    if (InRect(cellbox, cx,cy)) then
      return i
    end
  end
  return -1
end


function LayoutPanel:_MultiRectSelect(item1,item2)
  --// select all items in the convex hull of those 2 items
  local cells = self._cells
  local itemPadding = self.itemPadding

  local cell1,cell2 = cells[item1],cells[item2]

  local convexHull = {
    math.min(cell1[1],cell2[1]),
    math.min(cell1[2],cell2[2]),
  }
  convexHull[3] = math.max(cell1[1]+cell1[3],cell2[1]+cell2[3]) - convexHull[1]
  convexHull[4] = math.max(cell1[2]+cell1[4],cell2[2]+cell2[4]) - convexHull[2]

  for i=1,#cells do
    local cell  = cells[i]
    local cellbox = ExpandRect(cell,itemPadding)
    if (AreRectsOverlapping(convexHull,cellbox)) then
      self.selectedItems[i] = true
    end
  end
end


function LayoutPanel:MouseDown(x,y,button,mods)
  local clickedChild = this.inherited.MouseDown(self,x,y,button,mods)
  if (clickedChild) then
    return clickedChild
  end

  if (not self.selectable) then return end

  local cx,cy = self:LocalToClient(x,y)
  local itemIdx = self:GetItemIndexAt(cx,cy)

  --FIXME write and use SelectItem(),ToggleItem() functions!

  if (itemIdx>0) then
    if (self.multiSelect) then
      if (mods.shift and mods.ctrl) then
        self:_MultiRectSelect(itemIdx,self._lastSelected or 1)
        --//note: don't update self._lastSelected!!!
      elseif (mods.shift) then
        self.selectedItems = {}
        self:_MultiRectSelect(itemIdx,self._lastSelected or 1)
        --//note: don't update self._lastSelected!!!
      elseif (mods.ctrl) then
        self.selectedItems[itemIdx] = not self.selectedItems[itemIdx]
        self._lastSelected = itemIdx
      else
        self.selectedItems = {[itemIdx]=true}
        self._lastSelected = itemIdx
      end
    else
      self.selectedItems = {[itemIdx]=true}
      self._lastSelected = itemIdx
    end

    self:Invalidate()

    return self
  end
end

--//=============================================================================