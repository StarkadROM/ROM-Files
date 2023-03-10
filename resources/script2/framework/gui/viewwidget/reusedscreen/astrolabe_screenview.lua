autoImport("EventDispatcher")
Astrolabe_ScreenView = class("Astrolabe_ScreenView", EventDispatcher)
autoImport("Astrolabe_ScreenCell")
Astrolabe_ScreenView_Event = {
  PanelMove = "Astrolabe_ScreenView_Event_PanelMove",
  RefreshDraw = "Astrolabe_ScreenView_Event_RefreshDraw"
}
local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3()
function Astrolabe_ScreenView:ctor(scrollView, mapBord, blockSize_row, blockSize_col)
  self.drawPointMap = {}
  self.drawBgMap = {}
  self.scrollView = scrollView
  self.mPanel = self.scrollView.panel
  function self.mPanel.onClipMove()
    self:PassEvent(Astrolabe_ScreenView_Event.PanelMove)
    self:RefreshDraw()
  end
  local panel_worldCorners = self.mPanel.worldCorners
  local worldCenterV3 = (panel_worldCorners[1] + panel_worldCorners[3]) * 0.5
  self.worldCenter = LuaVector3(worldCenterV3[1], worldCenterV3[2], worldCenterV3[3])
  self.localCenter = LuaVector3()
  self.mapBord = mapBord
  self.scrollBound = Game.GameObjectUtil:DeepFindChild(self.mapBord, "ScrollBound")
  self.centerTarget = Game.GameObjectUtil:DeepFindChild(self.mapBord, "CenterTarget")
  self.centerTarget = self.centerTarget.transform
  self.mapScale = 1
  local viewsize = self.mPanel:GetViewSize()
  self.origin_viewsize = {
    viewsize[1],
    viewsize[2]
  }
  self:SetViewSize(self.origin_viewsize[1], self.origin_viewsize[2])
end
local cellScale = 3
function Astrolabe_ScreenView:SetViewSize(viewWidth, viewHeight)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.mapBord.transform)
  local size_x, size_y = bound.size[1], bound.size[2]
  viewWidth = viewWidth / cellScale
  viewHeight = viewHeight / cellScale
  self.max_index_row = math.ceil(size_x / viewHeight)
  self.max_index_col = math.ceil(size_y / viewWidth)
  self.mapSize = {
    viewWidth * self.max_index_col,
    viewHeight * self.max_index_row
  }
  self.cellSize = {
    viewWidth * 1.1,
    viewHeight * 1.1
  }
  self.centerSize = {
    self.cellSize[1] * 2,
    self.cellSize[2] * 2
  }
  self.screenCellMap = {}
  for i = 1, self.max_index_row do
    for j = 1, self.max_index_col do
      if self.screenCellMap[i] == nil then
        self.screenCellMap[i] = {}
      end
      local center_x = viewWidth * (j - 0.5) - self.mapSize[1] / 2
      local center_y = self.mapSize[2] / 2 - viewHeight * (i - 0.5)
      local center = {center_x, center_y}
      self.screenCellMap[i][j] = Astrolabe_ScreenCell.new(center, self.cellSize, i, j)
    end
  end
end
function Astrolabe_ScreenView:GetScreenCell(row, col)
  if row == nil or col == nil then
    return nil
  end
  local rowMap = self.screenCellMap[row]
  if rowMap then
    return rowMap[col]
  end
end
local param = {}
function Astrolabe_ScreenView:RefreshDraw(forceUpdate)
  if not forceUpdate and not self:NeedRefresh() then
    return
  end
  local w = math.floor((cellScale - 1) / self.mapScale)
  TableUtility.TableClear(self.drawPointMap)
  TableUtility.TableClear(self.drawBgMap)
  local row, col = self.centerScreen.row, self.centerScreen.col
  for i = row - w, row + w do
    for j = col - w, col + w do
      local cell = self:GetScreenCell(i, j)
      if cell then
        local pointDataMap = cell:GetPointDataMap()
        for id, data in pairs(pointDataMap) do
          self.drawPointMap[id] = data
        end
        local bgMap = cell:GetBgDataMap()
        for id, data in pairs(bgMap) do
          self.drawBgMap[id] = data
        end
      end
    end
  end
  param[1] = self.drawPointMap
  param[2] = self.drawBgMap
  self:PassEvent(Astrolabe_ScreenView_Event.RefreshDraw, param)
end
function Astrolabe_ScreenView:NeedRefresh()
  local x, y, z = LuaGameObject.InverseTransformPointByVector3(self.mapBord.transform, self.worldCenter)
  LuaVector3.Better_Set(self.localCenter, x, y, z)
  if self.centerScreen == nil then
    local centerCell = self:FindCellByPos(self.localCenter)
    self.centerScreen = Astrolabe_ScreenCell.new(self.localCenter, self.centerSize, centerCell.row, centerCell.col)
    return true
  end
  if not self.centerScreen:Contains(self.localCenter) then
    self.centerScreen:ResetCenter(self.localCenter[1], self.localCenter[2], self.localCenter[3])
    local centerCell = self:FindCellByPos(self.localCenter)
    if centerCell then
      self.centerScreen:ResetScreenPos(centerCell.row, centerCell.col)
      return true
    end
  end
  return false
end
function Astrolabe_ScreenView:FindCellByPos(pos)
  local row = math.ceil((self.mapSize[2] * 0.5 - pos[2]) / self.cellSize[2])
  local col = math.ceil((pos[1] + self.mapSize[1] * 0.5) / self.cellSize[1])
  return self:GetScreenCell(row, col)
end
local RIGHT, UP, LEFT, DOWN = {1, 0}, {0, 1}, {-1, 0}, {0, -1}
function Astrolabe_ScreenView:SprialFindCell(center_row, center_col, searchFunc)
  if nil == center_row or nil == center_col or nil == searchFunc then
    return nil
  end
  local curPos_row = center_row
  local curPos_col = center_col
  local curDir = RIGHT
  local curW = 0
  while curW <= self.max_index_row do
    curDir = curDir or RIGHT
    if curDir == RIGHT then
      if curPos_row == center_row + curW then
        curDir = UP
        curW = curW + 1
      end
    elseif curDir == UP then
      if curPos_col == center_col + curW then
        curDir = LEFT
      end
    elseif curDir == LEFT then
      if curPos_row == center_row - curW then
        curDir = DOWN
      end
    elseif curDir == DOWN and curPos_col == center_col - curW then
      curDir = RIGHT
    end
    curPos_row = curPos_row + curDir[1]
    curPos_col = curPos_col + curDir[2]
    local cell = self:GetScreenCell(curPos_row, curPos_col)
    if cell and searchFunc(cell) then
      return cell
    end
  end
  return nil
end
function Astrolabe_ScreenView:InitPlateDatas(plateDatas)
  for plateid, plateData in pairs(plateDatas) do
    LuaVector3.Better_Set(tempV3_1, plateData:GetPos_XYZ())
    local cell = self:FindCellByPos(tempV3_1)
    if cell then
      cell:AddPointData(plateData.id, plateData)
    end
  end
end
function Astrolabe_ScreenView:InitBgDatas(bgDatas)
  for cid, bgData in pairs(bgDatas) do
    LuaVector3.Better_Set(tempV3_1, bgData[1], bgData[2], bgData[3])
    local cell = self:FindCellByPos(tempV3_1)
    if cell then
      cell:AddBgData(cid, bgData)
    end
  end
end
local tempV3_3 = LuaVector3()
local tempV2_1 = LuaVector2()
local tempV2_2 = LuaVector2()
function Astrolabe_ScreenView:ZoomScrollView(endScale, time, onfinish)
  time = time or 1
  LuaVector3.Better_Set(tempV3_1, self.mapScale, self.mapScale, self.mapScale)
  LuaVector3.Better_Set(tempV3_3, endScale, endScale, 1)
  self.centerTarget.transform.localPosition = self.localCenter
  LuaVector3.Better_Set(tempV3_2, LuaGameObject.GetPosition(self.centerTarget))
  local mTrans = self.scrollView.transform
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateTickFromTo(0, 0, 1, time * 1000, function(owner, deltaTime, curValue)
    self.mapBord.transform.localScale = LuaVector3.Lerp(tempV3_1, tempV3_3, curValue)
    local before = self.centerTarget.transform.position
    local after = LuaVector3.Lerp(tempV3_2, self.worldCenter, curValue)
    local offset = after - before
    local mlPosition = mTrans.localPosition
    mTrans.position = mTrans.position + offset
    self.mPanel.clipOffset = self.mPanel.clipOffset - (mTrans.localPosition - mlPosition)
    local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.scrollBound.transform)
    local calOffset = self.mPanel:CalculateConstrainOffset(b.min, b.max)
    if calOffset.magnitude >= 0.01 then
      mTrans.localPosition = mTrans.localPosition + calOffset
      LuaVector2.Better_Set(tempV2_1, calOffset.x, calOffset.y)
      LuaVector2.Better_Sub(self.mPanel.clipOffset, tempV2_1, tempV2_2)
      self.mPanel.clipOffset = tempV2_2
    end
  end, self):SetCompleteFunc(function(owner, id)
    if onfinish then
      onfinish()
    end
    self.mapScale = endScale
    self:RefreshDraw()
  end)
end
function Astrolabe_ScreenView:CenterOnLocalPos(x, y, z, time, onfinish)
  if time and time > 0 then
    local mTrans = self.scrollView.transform
    LuaVector3.Better_Set(tempV3_1, x, y, z)
    self.centerTarget.transform.localPosition = tempV3_1
    LuaVector3.Better_Set(tempV3_2, LuaGameObject.GetPosition(self.centerTarget))
    if self.centerPosLt then
      self.centerPosLt:cancel()
      self.centerPosLt = nil
    end
    TimeTickManager.Me():ClearTick(self)
    TimeTickManager.Me():CreateTickFromTo(0, 0, 1, time * 1000, function(owner, deltaTime, curValue)
      local before = self.centerTarget.transform.position
      local after = LuaVector3.Lerp(tempV3_2, self.worldCenter, curValue)
      local offset = after - before
      local mlPosition = mTrans.localPosition
      mTrans.position = mTrans.position + offset
      self.mPanel.clipOffset = self.mPanel.clipOffset - (mTrans.localPosition - mlPosition)
      local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.scrollBound.transform)
      local calOffset = self.mPanel:CalculateConstrainOffset(b.min, b.max)
      if calOffset.magnitude >= 0.01 then
        mTrans.localPosition = mTrans.localPosition + calOffset
        LuaVector2.Better_Set(tempV2_1, calOffset.x, calOffset.y)
        LuaVector2.Better_Sub(self.mPanel.clipOffset, tempV2_1, tempV2_2)
        self.mPanel.clipOffset = tempV2_2
      end
    end, self):SetCompleteFunc(function(owner, id)
      if onfinish then
        onfinish()
      end
      self.centerPosLt = nil
    end)
    break
  else
    LuaVector3.Better_Set(tempV3_1, x, y, z)
    self.centerTarget.transform.localPosition = tempV3_1
    local mTrans = self.scrollView.transform
    local x, y, z = LuaGameObject.GetPosition(self.centerTarget.transform)
    LuaVector3.Better_Set(tempV3_1, self.worldCenter[1] - x, self.worldCenter[2] - y, self.worldCenter[3] - z)
    local mlPosition = mTrans.localPosition
    mTrans.position = mTrans.position + tempV3_1
    self.mPanel.clipOffset = self.mPanel.clipOffset - (mTrans.localPosition - mlPosition)
    local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.scrollBound.transform)
    local calOffset = self.mPanel:CalculateConstrainOffset(b.min, b.max)
    if calOffset.magnitude >= 0.01 then
      mTrans.localPosition = mTrans.localPosition + calOffset
      LuaVector2.Better_Set(tempV2_1, calOffset.x, calOffset.y)
      LuaVector2.Better_Sub(self.mPanel.clipOffset, tempV2_1, tempV2_2)
      self.mPanel.clipOffset = tempV2_2
    end
  end
end
