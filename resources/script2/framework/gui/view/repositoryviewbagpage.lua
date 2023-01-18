RepositoryViewBagPage = class("RepositoryViewBagPage", SubView)
autoImport("ItemNormalList")
autoImport("RepositoryBagCombineItemCell")
function RepositoryViewBagPage:Init()
  self:InitUI()
end
function RepositoryViewBagPage:InitUI()
  self.normalStick = self.container.normalStick
  self.rightBord = self:FindGO("rightBord")
  local listObj = self:FindGO("ItemNormalList", self.rightBord)
  self.itemlist = ItemNormalList.new(listObj, RepositoryBagCombineItemCell, nil, PullStopScrollView, true)
  self.itemlist.GetTabDatas = RepositoryViewBagPage.GetTabDatas
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemCells = self.itemlist:GetItemCells()
  self.refreshSymbolGrid = self:FindComponent("RefreshSymbol", UIGrid, self.rightBord)
  self.storeBtn = self:FindGO("StoreButton")
  self:AddClickEvent(self.storeBtn, function()
    self.container:CallOneClickPutStore(self.nowItemTabIndex)
  end)
  self:AddButtonEvent("RearrayButton", function()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
  end)
  self.itemlist:ChooseTab(1)
  self:UpdateList()
  self.tip = string.format(ZhString.Repository_storeLv, GameConfig.Item.store_baselv_req)
end
local viewTabFuncConfigMap = {
  [1] = 32,
  [2] = 30,
  [3] = 62
}
function RepositoryViewBagPage:InitShow()
  self.viewTab = self.container.viewTab
  self.funcConfigId = viewTabFuncConfigMap[self.viewTab]
  self:SetCellsLock()
  self.lock = RepositoryViewProxy.Instance:CheckLockByLevel()
end
function RepositoryViewBagPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  local go = cellCtl and cellCtl.gameObject
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowRepositoryItemTip(data, {go})
  else
    self.chooseId = 0
    self:ShowRepositoryItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end
function RepositoryViewBagPage:DoubleClickItem(cellCtl)
  local data = cellCtl.data
  if data then
    self.chooseId = 0
    self:ShowRepositoryItemTip()
    if RepositoryViewProxy.Instance:CheckLockByStrength(data) then
      MsgManager.ShowMsgByID(2001)
      return
    end
    if self.viewTab == RepositoryView.Tab.CommonTab then
      FunctionItemFunc.DepositRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.RepositoryTab then
      FunctionItemFunc.PersonalDepositRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.HomeTab and self.lock == false then
      FunctionItemFunc.HomeStoreIn(data)
    end
  end
end
function RepositoryViewBagPage:ClickItemTab(cell)
  self.nowItemTabIndex = cell.data and cell.data.index or 0
  self.storeBtn:SetActive(self.nowItemTabIndex > 0)
  self.refreshSymbolGrid:Reposition()
end
function RepositoryViewBagPage:ShowRepositoryItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local callback = function()
    local itemdata = BagProxy.Instance:GetItemByGuid(self.chooseId)
    if itemdata and RepositoryViewProxy.Instance:CheckLockByStrength(itemdata) then
      MsgManager.ShowMsgByID(2001)
      return
    end
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = ReusableTable.CreateTable()
  sdata.itemdata = data
  sdata.funcConfig = {
    self.funcConfigId
  }
  sdata.ignoreBounds = ignoreBounds
  sdata.callback = callback
  if self.lock then
    sdata.tip = self.tip
  end
  self:ShowItemTip(sdata, self.normalStick, nil, {-180, 0})
  ReusableTable.DestroyAndClearTable(sdata)
end
function RepositoryViewBagPage:ShowPrompt()
  local data = self.container.repositoryViewItemPage.itemlist.chooseItemData
  if data then
    local index = 1
    for i = 1, #GameConfig.ItemPage do
      for j = 1, #GameConfig.ItemPage[i].types do
        if data.staticData.Type == GameConfig.ItemPage[i].types[j] then
          index = index + i
          break
        end
      end
    end
    MsgManager.ShowEightTypeMsgByIDTable(820, {
      self.container.repositoryViewItemPage.itemlist.chooseItemData.num
    }, self.itemlist.ItemTabLst[index].transform.position, {0, 10})
  end
end
function RepositoryViewBagPage:UpdateList(note)
  self.itemlist:UpdateList(true)
end
function RepositoryViewBagPage:HandleItemUpdate(note)
  self:UpdateList(note)
  self:SetCellsLock()
end
function RepositoryViewBagPage:HandleItemReArrage(note)
  self:PlayUISound(AudioMap.UI.ReArrage)
  self:UpdateList()
  self.itemlist:ScrollViewRevert()
  self:SetCellsLock()
end
function RepositoryViewBagPage:HandleLevelUp(note)
  self:SetCellsLock()
  self.lock = RepositoryViewProxy.Instance:CheckLockByLevel()
end
function RepositoryViewBagPage:SetCellsLock()
  for i = 1, #self.itemCells do
    self.itemCells[i]:SetCellLock()
  end
end
local tabDatas = {}
function RepositoryViewBagPage.GetTabDatas(itemTabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local datas = tabData.index ~= -1 and BagProxy.Instance.bagData:GetItems(itemTabConfig) or BagProxy.Instance:GetFavoriteItemDatas()
  if datas and #datas == 0 then
    return false
  end
  for i = 1, #datas do
    table.insert(tabDatas, datas[i])
  end
  return tabDatas
end
