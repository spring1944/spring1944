--//=============================================================================

ImageListView = LayoutPanel:Inherit{
  classname = "imagelistview",

  centerItems = true,
  autoSize = true,

  autoArrangeH = false,
  autoArrangeV = false,
  centerItems  = false,

  iconX     = 64,
  iconY     = 64,

  selectable  = true,
  multiSelect = true,

  items = nil,

  dir = '',
  selectedIdx = 1,
  selectedFile = '',
}

local this = ImageListView

--//=============================================================================

function ImageListView:New(obj)
  obj = (this.inherited).New(self,obj)
  obj:SetDir(obj.dir)
  return obj
end

--//=============================================================================

local function GetParent(dir)
  dir = dir:gsub("\\", "/")
  local lastChar = dir:sub(-1)
  if (lastChar == "/") then
    dir = dir:sub(1,-2)
  end
  local pos,b,e,match,init,n = 1,1,1,1,0,0
  repeat
    pos,init,n = b,init+1,n+1
    b,init,match = dir:find("/",init,true)
  until (not b)
  if (n==1) then
    return dir
  else
    return dir:sub(1,pos)
  end
end


local function ExtractFileName(filename)
  filename = filename:gsub("\\", "/")
  local lastChar = filename:sub(-1)
  if (lastChar == "/") then
    filename = filename:sub(1,-2)
  end
  local pos,b,e,match,init,n = 1,1,1,1,0,0
  repeat
    pos,init,n = b,init+1,n+1
    b,init,match = filename:find("/",init,true)
  until (not b)
  if (n==1) then
    return dir
  else
    return filename:sub(pos+1)
  end
end

--//=============================================================================

function ImageListView:_AddFile(name,imagefile)
  self:AddChild( LayoutPanel:New{
    width  = self.iconX+10,
    height = self.iconY+20,
    padding = {0,0,0,0},
    itemPadding = {0,0,0,0},
    itemMargin = {0,0,0,0},
    rows = 2,
    columns = 1,

    children = {
      Image:New{
        width  = self.iconX,
        height = self.iconY,
        file = ':cn:'..imagefile,
      },
      Label:New{
        width = self.iconX+10,
        height = 20,
        align = 'center',
        autosize = false,
        caption = name,
      },
    },
  })
end


function ImageListView:ScanDir()
  local files = VFS.DirList(self.dir)
  local dirs  = VFS.SubDirs(self.dir)
  local imageFiles = {}
  for i=1,#files do
    local f = files[i]:lower()
    if (f:find('.jpg') or f:find('.bmp') or f:find('.png') or f:find('.tga') or f:find('.dds')) then
      imageFiles[#imageFiles+1]=f
    end
  end

  self._dirsNum = #dirs
  self._dirList = dirs

  local n    = 1
  local items = self.items or {}
  for i=1,#dirs do
    items[n],n=dirs[i],n+1
  end
  for i=1,#imageFiles do
    items[n],n=imageFiles[i],n+1
  end
  if (#items>n-1) then
    for i=n,#items do
      items[i] = nil
    end
  end

  self:DisableRealign()
    --// clear old
    for i=#self.children,1,-1 do
      self:RemoveChild(self.children[i])
    end

    --// add ".."
    self:_AddFile('..',theme.imageFolderUp)

    --// add dirs at top
    for i=1,#dirs do
      self:_AddFile(ExtractFileName(dirs[i]),theme.imageFolder)
    end

    --// add files
    for i=1,#imageFiles do
      self:_AddFile(ExtractFileName(imageFiles[i]),imageFiles[i])
    end
  self:EnableRealign()
end


function ImageListView:SetDir(directory)
  self.dir = directory
  self:ScanDir()
  self.selectedIdx  = 1
  --self.selectedFile = self._dirList[self.selectedIdx]

  if (self.parent) then
    self.parent:RequestRealign()
  else
    self:UpdateLayout()
    self:Invalidate()
  end
end

--//=============================================================================

function ImageListView:DrawItemBkGnd(index)
  local cell = self._cells[index]
  local itemPadding = self.itemPadding

  if (self.selectedItems[index]) then
    theme.DrawSelectionItemBkGnd(cell[1] - itemPadding[1],cell[2] - itemPadding[2],cell[3] + itemPadding[1] + itemPadding[3],cell[4] + itemPadding[2] + itemPadding[4],"selected")
  else
    theme.DrawSelectionItemBkGnd(cell[1] - itemPadding[1],cell[2] - itemPadding[2],cell[3] + itemPadding[1] + itemPadding[3],cell[4] + itemPadding[2] + itemPadding[4],"normal")
  end
end

--//=============================================================================

function ImageListView:HitTest(x,y)
  local cx,cy = self:LocalToClient(x,y)
  local obj = this.inherited.HitTest(self,cx,cy)
  if (obj) then return obj end
  local itemIdx = self:GetItemIndexAt(cx,cy)
  return (itemIdx>0) and self
end


function ImageListView:MouseDblClick(x,y)
  local cx,cy = self:LocalToClient(x,y)
  local itemIdx = self:GetItemIndexAt(cx,cy)

  if (itemIdx<0) then return end

  if (itemIdx==1) then
    self:SetDir(GetParent(self.dir))
    return true
  end

  if (itemIdx-1<=self._dirsNum) then
    self:SetDir(self._dirList[itemIdx-1])
    return true
  else
    --self:OnSelect(self.selectedFile)
    return true
  end
end

--//=============================================================================