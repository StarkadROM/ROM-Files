autoImport("MiniROItemCell")
MiniRORewardView = class("MiniRORewardView", BaseView)
MiniRORewardView.ViewType = UIViewType.PopUpLayer
function MiniRORewardView:Init()
  self:FindObjs()
end
function MiniRORewardView:OnEnter()
  MiniRORewardView.super.OnEnter(self)
  self:UpdateShow()
end
function MiniRORewardView:OnExit()
  MiniRORewardView.super.OnExit(self)
end
function MiniRORewardView:FindObjs()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  self.tipStick = self:FindComponent("tipStick", UISprite)
  local turnCount = #activityData.featureData.circleRewards
  local container = self:FindGO("ItemContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = turnCount,
    cellName = "MiniROItemCell",
    control = MiniROItemCell,
    dir = 1
  }
  self.listItem = WrapCellHelper.new(wrapConfig)
  self.listItem:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
end
function MiniRORewardView:ClickItemCell(cell, forceUpdate)
  local data = cell and cell.data
  if data then
  end
end
function MiniRORewardView:UpdateShow()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  if self.listData == nil then
    self.listData = {}
  else
    TableUtility.TableClear(self.listData)
  end
  local turnCount = #activityData.featureData.circleRewards
  for i = 1, turnCount do
    local listRewardId = activityData.featureData.circleRewards[i]
    local data = {}
    data.index = i
    data.tipStick = self.tipStick
    data.title = string.format(ZhString.MiniRORewardCellTitle, i)
    data.listRewardId = listRewardId
    table.insert(self.listData, data)
  end
  self.listItem:UpdateInfo(self.listData)
  if self.listItemCell == nil then
    self.listItemCell = self.listItem:GetCellCtls()
  end
  for i = 1, #self.listItemCell do
    self.listItemCell[i]:SetView(self)
  end
  local startIndex = turnCount > MiniROProxy.Instance:GetCurCompleteTurns() and MiniROProxy.Instance:GetCurCompleteTurns() + 1 or turnCount
  self.listItem:SetStartPositionByIndex(startIndex)
end
