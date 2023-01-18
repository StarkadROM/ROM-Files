autoImport("RedPacketCombineCell")
RedPacketPage = class("RedPacketPage", SubView)
local redPacketType = 4208
local numPerRow = 11
function RedPacketPage:Init()
  self.contentScrollView = self:FindGO("RedPacketScrollView", self.container.PopUpWindow):GetComponent(UIScrollView)
  self.emptyHint = self:FindGO("emptyHint", self.contentScrollView.gameObject)
end
function RedPacketPage:OnEnter()
end
function RedPacketPage:OnExit()
end
function RedPacketPage:TryInit()
  if not self.inited then
    self:InitView()
    self.inited = true
  else
    self:RefreshView()
  end
end
function RedPacketPage:InitView()
  local data = ReusableTable.CreateTable()
  local container = self:FindGO("RedPacket_Container", self.container.PopUpWindow)
  data.wrapObj = container
  data.pfbNum = 4
  data.cellName = "RedPacketCombineCell"
  data.control = RedPacketCombineCell
  data.dir = 1
  self.itemWrapHelper = WrapCellHelper.new(data)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  ReusableTable.DestroyTable(data)
  self:RefreshView()
end
function RedPacketPage:RefreshView()
  if self.itemWrapHelper then
    local bagTypes = GameConfig.PackageMaterialCheck.redpacket
    local items = ReusableTable.CreateArray()
    local sortFunc = function(val, insertVal)
      local itemId = val.staticData.id
      local insertItemId = insertVal.staticData.id
      local config = Table_RedPacket[itemId]
      local insertConfig = Table_RedPacket[insertItemId]
      if config and insertConfig then
        local curChannel = ChatRoomProxy.Instance:GetChatRoomChannel()
        local channelMatch = TableUtility.ArrayFindIndex(config.channel, curChannel) > 0
        local insertChannelMatch = TableUtility.ArrayFindIndex(insertConfig.channel, curChannel) > 0
        if channelMatch and insertChannelMatch or not channelMatch and not insertChannelMatch then
          return itemId > insertItemId
        end
        return insertChannelMatch
      end
    end
    if bagTypes and #bagTypes > 0 then
      for i = 1, #bagTypes do
        local bagType = bagTypes[i]
        local temp = BagProxy.Instance:GetBagItemsByType(redPacketType, bagType)
        for j = 1, #temp do
          TableUtility.InsertSort(items, temp[j], sortFunc)
        end
      end
    else
      local temp = BagProxy.Instance:GetBagItemsByType(redPacketType)
      for i = 1, #temp do
        TableUtility.InsertSort(items, temp[i], sortFunc)
      end
    end
    if #items > 0 then
      self.emptyHint:SetActive(false)
    else
      self.emptyHint:SetActive(true)
    end
    local info = self:ReUniteCellData(items, numPerRow)
    self.itemWrapHelper:ResetDatas(info)
    ReusableTable.DestroyAndClearArray(items)
  end
end
function RedPacketPage:HandleClickItem(cellCtrl)
  local itemData = cellCtrl.data
  if itemData and not cellCtrl:CheckIfItemInvalid(itemData) then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RedPacketSendView,
      viewdata = itemData.staticData.id
    })
  end
end
function RedPacketPage:ReUniteCellData(datas, perRowNum)
  local list = {}
  if datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      list[i1] = list[i1] or {}
      list[i1][i2] = datas[i]
    end
  end
  return list
end
